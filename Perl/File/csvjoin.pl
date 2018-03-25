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
  print "--help, -h          - 当ヘルプを表示する。\n";
  print "--debug             - デバッグ用\n";
  print "--file1key col1,col2,... - ファイル1のキーカラム番号。1始まり。\n";
  print "--file2key col1,col2,... - 上記同様。ファイル1のキーと結合する。\n";
  print "--out, -o outpath   - 出力ファイルパス。デフォルト：標準出力。\n";
  print "inpath              - 入力ファイルパス。\n";
  exit(1);
}
my @inpatharr = @ARGV;
my @keynumarr = ('1', '1');
$keynumarr[0] = $opts{file1key} if $opts{file1key};
$keynumarr[1] = $opts{file2key} if $opts{file2key};

# 主処理
printlog("START");
printlog("\%opts " . Dumper(\%opts));
printlog("\@inpatharr " . Dumper(\@inpatharr));

# 入力ファイル読み込み
my %inhash = ();
my %allkeys = ();
for (my $i = 0; $i <= $#inpatharr; $i++) {
  # 実行時引数で指定されたキーカラム番号を取得
  my $keynum = $keynumarr[$i];
  my @arr = split(/,/, $keynum);

  # ファイル読み込み
  my $inpath = $inpatharr[$i];
  my %hash = read_file($inpath, @arr);
  $inhash{$inpath} = \%hash;

  # キー値の一覧を保持する
  foreach my $e (keys(%hash)) {
    $allkeys{$e} = 1;
  }
}

# 出力ファイルオープン
if ($opts{out}) {
  open(STDOUT, '>', $opts{out}) or die "ERROR: Can't open $opts{out}. $!\n";
}

# キー項目で結合してデータ出力
foreach my $key (sort(keys(%allkeys))) {
  my $line = $key;

  # 各入力ファイルをキー項目で結合する
  foreach my $inpath (@inpatharr) {
    my $row = $inhash{$inpath}->{$key};
    $line .= ';';
    $line .= $row if $row;
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
  my ($path, @keys) = @_;
  my %hash = ();
  open(IN, '<:encoding(cp932)', $path) or die("ERROR: Can't open $path. $!\n");
  while (<IN>) {
    chomp($_);
    my @columns = split(/,/, $_);
    my $keystr = "";
    foreach my $e (@keys) {
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
  }
  close(IN);
  return %hash;
}
