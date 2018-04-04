# CSVファイルを比較します。
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
use Text::Diff;
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
# GetOptionsの型指定：s=文字列型, i=整数型, f=実数型, @=同optionを複数回指定可, 型なし=boolean
GetOptions(\%opts,
  "delimiter=s",
  "key=s",
  "out=s",
  "help|h",
  "debug"
) or $opts{help} = 1;
if ($#ARGV + 1 != 2 || $opts{help}) {
  print "Usage: perl $scriptname [OPTIONS] inpath1 inpath2\n";
  print "--debug             - デバッグ用\n";
  print "--delimiter delim   - 入力ファイルの区切り文字。デフォルト：カンマ（,）。\n";
  print "--help, -h          - 当ヘルプを表示する。\n";
  print "--key col1,col2,... - キーとなるカラムを指定する。1始まり。\n";
  print "--out, -o outpath   - 出力ファイルパス。デフォルト：標準出力。\n";
  print "inpath              - 入力ファイルパス。\n";
  exit(1);
}
my @inpatharr = @ARGV;

# 主処理
printlog("START");
printlog("opts " . Dumper(\%opts));
printlog("inpatharr " . Dumper(\@inpatharr));

# 出力ファイルオープン
if ($opts{out}) {
  open(STDOUT, '>:encoding(cp932)', $opts{out}) or die "ERROR: Can't open $opts{out}. $!\n";
}

# ファイルを比較
if (not $opts{key}) {
  my $in1ref = read_file($inpatharr[0]);
  my $in2ref = read_file($inpatharr[1]);
  # my $diff = diff($in1ref, $in2ref);
  # print $diff;
  diff($in1ref, $in2ref, { STYLE=>'OldStyle', OUTPUT=>\*STDOUT });
} else {
  my @inrefarr = ();
  foreach my $inpath (@inpatharr) {
    my $inref = read_file2($inpath, $opts{key});
    push(@inrefarr, $inref);
  }
  # キー値の一覧を取得
  my %allkeys = ();
  foreach my $inref (@inrefarr) {
    foreach my $key (keys(%$inref)) {
      $allkeys{$key} = 1;
    }
  }
  # 比較
  foreach my $key (sort(keys(%allkeys))) {
    my $row1 = $inrefarr[0]->{$key};
    my $row2 = $inrefarr[1]->{$key};
    if (not defined($row1)) {
      print "$key\n";
      print "> $row2";
    } elsif (not defined($row2)) {
      print "$key\n";
      print "< $row1";
    } elsif ($row1 ne $row2) {
      print "$key\n";
      print "< $row1";
      print "---\n";
      print "> $row2";
    }
  }
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
  my ($path) = @_;
  my @rows = ();
  open(IN, '<:encoding(cp932)', $path) or die("ERROR: Can't open $path. $!\n");
  while (<IN>) {
    chomp($_);
    push(@rows, "$_\n");
  }
  close(IN);
  return \@rows;
}

sub read_file2 {
  my ($path, $keycolumns) = @_;
  my @keycolumnarr = split(/,/, $keycolumns);
  my %hash = ();
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
      die("ERROR: キー重複発生。path=$path キー=$keystr\n");
    }
    $hash{$keystr} = "$_\n";
  }
  close(IN);
  return \%hash;
}
