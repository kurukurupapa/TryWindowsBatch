# Perlスクリプトのテンプレートです。

use strict;
use warnings;
use Cwd;
use File::Basename;

# 前処理
our $basename;
our $scriptname;
our $scriptdir;
our $currentdir;
our $datestr;
our $timestr;
our $timestampstr;
init();

# 引数チェック
if ($#ARGV < 0 || $ARGV[0] eq "-h") {
  print "Usage: perl $scriptname [-h] arg1 ...\n";
  exit(1);
}

# 主処理
printlog("START");

# ▼▼▼ここに処理を書きます
print "basename=$basename\n";
print "scriptname=$scriptname\n";
print "scriptdir=$scriptdir\n";
print "currentdir=$currentdir\n";
print "timestampstr=$timestampstr\n";

for (my $i = 0; $i < 3; $i++) {
  print "$i,";
  # next, last, redo
}
print "\n";

my @arr = ('a', 'b', 'c');
foreach my $arg (@arr) {
  print "${arg},";
  # next, last, redo
}
print "\n";

my $flag = 1;
while ($flag) {
  print "$flag,";
  $flag = 0;
  # next, last, redo
}
print "\n";

# 後処理
printlog("END");
exit(0);

# --------------------------------------------------
# 関数定義
sub printlog {
  my ($msg) = @_;
  my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time());
  my $timestamp = sprintf("%04d/%02d/%02d %02d:%02d:%02d", $year + 1900, $mon + 1, $mday, $hour, $min, $sec);
  print STDERR "${timestamp} ${scriptname} ${msg}\n";
}

sub abort {
  my ($msg) = @_;
  printlog $msg;
  die("Abort!")
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
