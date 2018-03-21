# Perl�X�N���v�g�̃e���v���[�g�ł��B

use strict;
use warnings;
use Cwd;
use File::Basename;

# �O����
my $basename;
my $scriptname;
my $scriptdir;
my $currentdir;
my $datestr;
my $timestr;
my $timestampstr;
init();

# �����`�F�b�N
if ($#ARGV < 0 || $ARGV[0] eq "-h") {
  print "Usage: perl $scriptname [-h] arg1 ...\n";
  exit(1);
}

# �又��
printlog("START");
printlog("basename=$basename");
printlog("scriptname=$scriptname");
printlog("scriptdir=$scriptdir");
printlog("currentdir=$currentdir");
printlog("timestampstr=$timestampstr");

# �����������ɏ����������܂�

# ����\��
my $state = 3;
if ($state == 1) {
  print "if�� ����1\n";
} elsif ($state == 2) {
  print "if�� ����2\n";
} else {
  print "if�� ����3\n";
}

for (my $i = 0; $i < 3; $i++) {
  print "for�� $i\n";
}

my @arr = ('a', 'b', 'c');
foreach my $e (@arr) {
  print "foreach�� $e\n";
}

my $flag = 1;
while ($flag) {
  print "while�� $flag\n";
  $flag = 0;
}

# �����񑀍�
$_ = "abc,123,456";
my $str = $_;
print "length " . length($_) . "\n"; #length(expr)
print "substr " . substr($_, 1, 2) . "\n"; #substr(expr, offset, length)
@arr = split(/,/, $_); print "split $arr[0]\n"; #split(/pattern/, expr)
$str =~ s/,(.*),/$1/g; print "�u�� $str\n"; #s/pattern/replacement/gieo
if ($_ =~ /,(.*),/) { print "�}�b�`���O $1\n"; }

# �����������ɏ����������܂�

# �㏈��
printlog("END");
exit(0);

# ----------------------------------------------------------------------
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
