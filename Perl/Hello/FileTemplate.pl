# Perl�X�N���v�g�̃e���v���[�g�ł��B
# �e�L�X�g�t�@�C���ǂݏ����T���v���t���B

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
if ($#ARGV + 1 < 2 || $ARGV[0] eq "-h") {
  print "Usage: perl $scriptname [-h] inpath outpath\n";
  print "inpath - ���̓t�@�C���p�X�B\n";
  print "outpath - �o�̓t�@�C���p�X�B\n";
  exit(1);
}
our ($inpath, $outpath) = @ARGV;

# �又��
printlog("START");
printlog("basename=$basename");
printlog("scriptname=$scriptname");
printlog("scriptdir=$scriptdir");
printlog("currentdir=$currentdir");
printlog("timestampstr=$timestampstr");

open(IN, "< $inpath") || die "Can't open $inpath.\n";
open(OUT, "> $outpath") || die "Can't open $outpath.\n";

# ���s�R�[�h�𐧌䂵�����Ƃ��̓o�C�i�����[�h�ɂ���B
binmode(OUT);

my $count = 0;
while (<IN>) {
  $count++;
  print OUT "$count: $_";
}

close OUT;
close IN;

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
