# CSVファイルを結合します。
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
  "file1key=s",
  "file2key=s",
  "out=s",
  "help|h",
  "debug"
) or $opts{help} = 1;
if ($#ARGV + 1 < 2 || 2 < $#ARGV + 1 || $opts{help}) {
  print "Usage: perl $scriptname [OPTIONS] inpath1 inpath2\n";
  print "--debug             - デバッグ用\n";
  print "--file1key col1,col2,... - ファイル1のキーカラム番号。1始まり。\n";
  print "--file2key col1,col2,... - 上記同様、ファイル2のキーカラム番号。ファイル1のキーと結合する。\n";
  print "--help, -h          - 当ヘルプを表示する。\n";
  print "--out, -o path      - 出力ファイルパス。デフォルト：標準出力。\n";
  print "inpath              - 入力ファイルパス。\n";
  exit(1);
}
my @infilearr = ();
foreach my $e (@ARGV) {
  my %infile = ();
  $infile{path} = $e;
  $infile{keycolumns} = '1';
  push(@infilearr, \%infile);
}
$infilearr[0]->{keycolumns} = $opts{file1key} if $opts{file1key};
$infilearr[1]->{keycolumns} = $opts{file2key} if $opts{file2key};

# 主処理
printlog("START");
printlog("opts " . Dumper(\%opts));
printlog("infilearr " . Dumper(\@infilearr));

my %allkeys = ();
foreach my $infile (@infilearr) {
  # ファイル読み込み
  my ($rowhash, $numcolumns) = read_file($infile->{path}, $infile->{keycolumns});
  $infile->{rowhash} = $rowhash;
  $infile->{numcolumns} = $numcolumns;

  # キー値の一覧を保持する
  foreach my $e (keys(%$rowhash)) {
    $allkeys{$e} = 1;
  }
}

# 出力ファイルオープン
if ($opts{out}) {
  open(STDOUT, '>', $opts{out}) or die "ERROR: Can't open $opts{out}. $!\n";
}

# キー項目で結合してデータ出力
foreach my $key (sort(keys(%allkeys))) {
  my $line = '';

  # 各入力ファイルをキー項目で結合する
  foreach my $infile (@infilearr) {
    # 入力ファイルの該当行を取得
    # 該当なしの場合、区切り文字のみの空行を作成
    my $row = $infile->{rowhash}->{$key};
    if (not defined($row)) {
      my $numcolumns = $infile->{numcolumns};
      $row = "," x ($numcolumns - 1);
    }

    # 出力行の組み立て
    $line .= ',' if length($line) > 0;
    $line .= $row;
  }

  # 行の出力
  print "$line\n";
}

# 出力ファイルクローズ
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
  my ($path, $keycolumns) = @_;
  my @keycolumnarr = split(/,/, $keycolumns);
  my %hash = ();
  my $numcolumns = -1;
  open(IN, '<:encoding(cp932)', $path) or die("ERROR: Can't open $path. $!\n");
  while (<IN>) {
    chomp($_);
    my @columns = split(/,/, $_);

    # キー値ごとに行を保持する
    my $keystr = "";
    foreach my $e (@keycolumnarr) {
      if ($e < 1 || $#columns + 1 < $e) {
        die("ERROR: キーカラム範囲外。path=$path カラム番号=$e\n");
      }
      $keystr .= ',' if length($keystr) > 0;
      $keystr .= $columns[$e - 1];
    }
    if ($hash{$keystr}) {
      die("ERROR: キー重複発生。path=$inpath キー=$keystr\n")
    }
    $hash{$keystr} = $_;

    # カラム数を保持する
    if ($numcolumns == -1) {
      $numcolumns = $#columns + 1;
    }
  }
  close(IN);
  return (\%hash, $numcolumns);
}
