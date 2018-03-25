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
$opts{delimiter} = ",";
my $inpath = "";
# GetOptionsの型指定：s=文字列型, i=整数型, f=実数型, @=同optionを複数回指定可, 型なし=boolean
GetOptions(\%opts,
  "rowstring=s",
  "rowfile=s",
  "delimiter=s",
  "out=s",
  "help|h",
  "debug"
) or $opts{help} = 1;
if ($#ARGV + 1 < 0 || 1 < $#ARGV + 1 || $opts{help}) {
  print "Usage: perl $scriptname [OPTIONS] [--rowstring col=str][--rowfile col=path] [inpath]\n";
  print "--help, -h          - 当ヘルプを表示する。\n";
  print "--debug             - デバッグ用\n";
  print "--rowstring col=str - カラムcolが文字列strに一致する行を抽出する。colは1始まり。\n";
  print "--rowfile col=path  - カラムcolがファイルpath内のいずれかの文字列に一致する行を抽出する。colは1始まり。\n";
  print "--delimiter delim   - 入力ファイルの区切り文字。デフォルト：カンマ（,）。\n";
  print "--out, -o outpath   - 出力ファイルパス。デフォルト：標準出力。\n";
  print "inpath              - 入力ファイルパス。デフォルト：標準入力。\n";
  exit(1);
}
# rowstringオプション事前準備
my %rshash = ();
if ($opts{rowstring}) {
  my @arr = split(/,/, decode('cp932', $opts{rowstring}));
  foreach my $e (@arr) {
    my ($column, $value) = split(/=/, $e);
    $rshash{$column} = $value;
  }
}
# rowfileオプション事前準備
my $rfcolumn = "";
my @rfvalues = ();
if ($opts{rowfile}) {
  my ($column, $path) = split(/=/, $opts{rowfile});
  $rfcolumn = $column;
  @rfvalues = read_file($path);
}
# その他オプション
if ($#ARGV + 1 >= 1) {
  ($inpath) = @ARGV;
}

# 主処理
printlog("START");
printlog("\%opts " . Dumper(\%opts));
# printlog("\@ARGV " . Dumper(\@ARGV));
printlog("\%rshash " . Dumper(\%rshash));
printlog("\$rfcolumn " . Dumper($rfcolumn));
printlog("\@rfvalues " . Dumper(\@rfvalues));

# ファイルオープン
if ($inpath) {
  open(STDIN, "<", $inpath) or die "ERROR: Can't open $inpath. $!\n";
}
if ($opts{out}) {
  open(STDOUT, ">", $opts{out}) or die "ERROR: Can't open $opts{out}. $!\n";
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
  my $flag = 1;
  # rowstringオプション処理
  if (%rshash) {
    foreach my $k (keys(%rshash)) {
      if ($k < 1 || $#columns + 1 < $k) {
        die("ERROR: line=$count, \$#columns=$#columns, rowstring option column=$k\n");
      }
      my $v = $rshash{$k};
      if ($columns[$k - 1] ne $v) {
        $flag = 0;
        last;
      }
    }
  }
  # rowfileオプション処理
  if ($flag && $rfcolumn) {
    if ($rfcolumn < 1 || $#columns + 1 < $rfcolumn) {
      die("ERROR: line=$count, \$#columns=$#columns, rowfile option column=$rfcolumn\n");
    }
    my $invalue = $columns[$rfcolumn - 1];
    $flag = 0;
    foreach my $e (@rfvalues) {
      if ($invalue eq $e) {
        $flag = 1;
        last;
      }
    }
  }

  # 行の出力
  print "$line\n" if ($flag);
}

# ファイルクローズ
if ($inpath) {
  close(STDIN);
}
if ($opts{out}) {
  close(STDOUT);
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
  my @arr = ();
  open(IN, '<', $path) or die("ERROR: Can't open $path. $!\n");
  while (<IN>) {
    chomp($_);
    push(@arr, $_);
  }
  close(IN);
  return @arr;
}
