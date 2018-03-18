# Perl�X�N���v�g�̃e���v���[�g�ł��B

use strict;
use warnings;
use Cwd;
use File::Basename;

# �O����
our $basename;
our $scriptname;
our $scriptdir;
our $currentdir;
our $datestr;
our $timestr;
our $timestampstr;
init();

# �����`�F�b�N
if ($#ARGV < 0 || $ARGV[0] eq "-h") {
  print "Usage: perl $scriptname [-h] arg1 ...\n";
  exit(1);
}

# �又��
printlog("START");

# �����������ɏ����������܂�
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

# �㏈��
printlog("END");
exit(0);

# --------------------------------------------------
# �֐���`
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
