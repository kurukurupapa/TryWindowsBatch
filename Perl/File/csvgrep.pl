# CSVファイルから行を抽出します。
# Windows環境で動作させることを前提にしています。
# モダンPerlはUTF8で作成するらしいので、スクリプトをUTF8にして、標準入出力をシフトJISにしています。

use strict;
use warnings;
use utf8;
use Cwd;
use Data::Dumper;
use Encode;
use File::Basename;
use Getopt::Long;
binmode STDIN, ':encoding(cp932)';
binmode STDOUT, ':encoding(cp932)';
binmode STDERR, ':encoding(cp932)';

# 前処理
my $basename;
my $scriptname;
my $scriptdir;
my $currentdir;
my $datestr;
my $timestr;
my $timestampstr;
init();

# 実行時引数解析
my %opts = ();
$opts{column} = 1;
$opts{delimiter} = ",";
# GetOptionsの型指定：s=文字列型, i=整数型, f=実数型, @=同optionを複数回指定可, 型なし=boolean
GetOptions(\%opts,
  "column=i",
  "string=s",
  "file=s",
  # オプション引数（優先度低）
  "delimiter=s",
  "invert",
  "out=s",
  "unmatch=s",
  # 共通引数
  "help|h",
  "debug"
) or $opts{help} = 1;
if ($#ARGV + 1 < 0 || 1 < $#ARGV + 1 || $opts{help}) {
  print "Usage: perl $scriptname [OPTIONS] --column col --string str1,str2,... [inpath]\n";
  print "       perl $scriptname [OPTIONS] --column col --file path [inpath]\n";
  print "--column col        - カラムcolを対象に条件判定する。colは1始まり。\n";
  print "--string str1,str2,...\n";
  print "                    - 文字列strのいずれかに一致する行を抽出する。\n";
  print "--file path         - ファイルpath内のいずれかの文字列に一致する行を抽出する。\n";
  # オプション引数（優先度低）
  print "--debug             - デバッグ用\n";
  print "--delimiter delim   - 入力ファイルの区切り文字。デフォルト：カンマ（,）。\n";
  print "--help, -h          - 当ヘルプを表示する。\n";
  print "--invert            - 抽出条件を反転する。\n";
  print "--out, -o path      - 出力ファイルパス。デフォルト：標準出力。\n";
  print "--unmatch path      - 条件に一致しない行の出力ファイルパス。デフォルトでは出力なし。\n";
  # ほぼ必須引数
  print "inpath              - 入力ファイルパス。デフォルト：標準入力。\n";
  exit(1);
}
# stringオプション準備
my %stringhash = ();
if ($opts{string}) {
  my @arr = split(/,/, decode('cp932', $opts{string}));
  foreach my $e (@arr) {
    $stringhash{$e} = 1;
  }
}
# fileオプション準備
my %filehash = ();
if ($opts{file}) {
  %filehash = read_file($opts{file});
}
# その他オプション
my $inpath = "";
if ($#ARGV + 1 >= 1) {
  ($inpath) = @ARGV;
}

# 主処理
printlog("START");
printlog("opts " . Dumper(\%opts));
# printlog("\@ARGV " . Dumper(\@ARGV));
printlog("stringhash " . Dumper(\%stringhash));
printlog("filehash " . Dumper(\%filehash));
printlog("inpath=$inpath");

# ファイルオープン
if ($inpath) {
  open(STDIN, "<:encoding(cp932)", $inpath) or die "ERROR: Can't open $inpath. $!\n";
}
if ($opts{out}) {
  open(STDOUT, ">:encoding(cp932)", $opts{out}) or die "ERROR: Can't open $opts{out}. $!\n";
}
if ($opts{unmatch}) {
  open(UNMATCHOUT, ">:encoding(cp932)", $opts{unmatch}) or die "ERROR: Can't open $opts{unmatch}. $!\n";
}
# 改行コードを制御したいときはバイナリモードにする。
#binmode(STDOUT);

# ファイル読み書き
my $count = 0;
while (<STDIN>) {
  $count++;
  chomp($_);
  my $line = $_;
  my @columns = split(/$opts{delimiter}/, $line);

  # 行の抽出
  if ($opts{column} < 1 || $#columns + 1 < $opts{column}) {
    die("ERROR: line=$count, num columns=" . ($#columns + 1) . ", key column=$opts{column}\n");
  }
  my $key = $columns[$opts{column} - 1];
  my $flag = 0;
  # stringオプション処理
  if (%stringhash) {
    $flag = defined($stringhash{$key});
  }
  # fileオプション処理
  if ((not $flag) && %filehash) {
    $flag = defined($filehash{$key});
  }
  # オプションなし時動作
  if (!$opts{string} && !$opts{file}) {
    $flag = 1;
  }

  # invertオプション処理
  $flag = not $flag if $opts{invert};

  # 行の出力
  if ($flag) {
    print "$line\n" ;
  } elsif ($opts{unmatch}) {
    print UNMATCHOUT "$line\n" ;
  }
}

# ファイルクローズ
if ($inpath) {
  close(STDIN);
}
if ($opts{out}) {
  close(STDOUT);
}
if ($opts{unmatch}) {
  close(UNMATCHOUT);
}

# 後処理
printlog("END");
exit(0);

# ----------------------------------------------------------------------
# 関数定義

sub printlog {
  if ($opts{debug}) {
    my ($msg) = @_;
    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time());
    my $timestamp = sprintf("%04d/%02d/%02d %02d:%02d:%02d", $year + 1900, $mon + 1, $mday, $hour, $min, $sec);
    chomp($msg);
    print STDERR "${timestamp} ${scriptname} ${msg}\n";
  }
}

sub abort {
  my ($msg) = @_;
  die("ERROR: $msg\n");
}

sub init {
  $basename = basename($0, '.pl');
  ($scriptname, $scriptdir) = fileparse($0);
  $currentdir = Cwd::getcwd();
  my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time());
  $datestr = sprintf("%04d%02d%02d", $year + 1900, $mon + 1, $mday);
  $timestr = sprintf("%02d%02d%02d", $hour, $min, $sec);
  $timestampstr = $datestr . "-" . $timestr;
}

sub read_file {
  my ($path) = @_;
  my %hash = ();
  open(IN, '<:encoding(cp932)', $path) or die("ERROR: Can't open $path. $!\n");
  while (<IN>) {
    chomp($_);
    $hash{$_} = 1;
  }
  close(IN);
  return %hash;
}
