# Perlスクリプトのテンプレートです。
# Windows環境で動作させることを前提にしています。
# モダンPerlはUTF8で作成するらしいので、スクリプトをUTF8にして、標準入出力をシフトJISにしています。

use strict;
use warnings;
use utf8;
use Cwd;
use Encode;
use File::Basename;
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
if ($#ARGV + 1 != 1 || $ARGV[0] eq '-h') {
  print "Usage: perl $scriptname [-h] arg1\n";
  exit(1);
}
my ($arg1) = @ARGV;
$arg1 = decode('cp932', $arg1);

# 主処理
printlog("START");
printlog("basename=$basename");
printlog("scriptname=$scriptname");
printlog("scriptdir=$scriptdir");
printlog("currentdir=$currentdir");
printlog("timestampstr=$timestampstr");
printlog("\$arg1=$arg1");

# ▼▼▼ここに処理を書きます

# 配列
my @arr = ('a', 'b', 'c');
push(@arr, '1');
@arr = sort(@arr);
foreach my $e (@arr) {
  print "配列操作 $e\n";
}

# 連想配列
my %hash = ();
$hash{key1} = 'value1';
$hash{key2} = 'value2';
while (my ($k, $v) = each(%hash)) {
  print "連想配列操作 $k=$v\n";
}
foreach my $k (keys(%hash)) {
  print "連想配列操作 $k\n";
}

# 連想配列の配列
# ※無名リファレンスを使う方式は省略。
my %person1 = (name => 'Ken',  country => 'Japan', age => 19);
my %person2 = (name => 'Taro', country => 'USA',   age => 45);
my @persons2 = (\%person1, \%person2);
for my $person (@persons2) {
  for my $key (sort(keys(%$person))) {
    my $value = $person->{$key};
    print "連想配列の配列 $key=$value\n";
  }
}

# 制御構文
my $state = 3;
if ($state == 1) {
  print "if文 処理1\n";
} elsif ($state == 2) {
  print "if文 処理2\n";
} else {
  print "if文 処理3\n";
}

for (my $i = 0; $i < 3; $i++) {
  print "for文 $i\n";
}

foreach my $e ('a', 'b', 'c') {
  print "foreach文 $e\n";
}

my $flag = 1;
while ($flag) {
  print "while文 $flag\n";
  $flag = 0;
}

# 文字列操作
$_ = "abc,123,456";
my $str = $_;
print "length " . length($_) . "\n"; #length(expr)
print "substr " . substr($_, 1, 2) . "\n"; #substr(expr, offset, length)
@arr = split(/,/, $_); print "split $arr[0]\n"; #split(/pattern/, expr)
$str =~ s/,(.*),/$1/g; print "置換 $str\n"; #s/pattern/replacement/gieo
if ($_ =~ /,(.*),/) { print "マッチング $1\n"; }

# ▲▲▲ここに処理を書きます

# 後処理
printlog("END");
exit(0);

# ----------------------------------------------------------------------
# 関数定義

sub printlog {
  my ($msg) = @_;
  my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time());
  my $timestamp = sprintf("%04d/%02d/%02d %02d:%02d:%02d", $year + 1900, $mon + 1, $mday, $hour, $min, $sec);
  print STDERR "${timestamp} ${scriptname} ${msg}\n";
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
