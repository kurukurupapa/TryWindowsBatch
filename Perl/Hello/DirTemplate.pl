# Perl�X�N���v�g�̃e���v���[�g�ł��B
# �t�@�C���E�f�B���N�g������T���v���t���B

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
  print "Usage: perl $scriptname [-h] path1 ...\n";
  print "path - �t�@�C���A�܂��̓f�B���N�g���̃p�X�B\n";
  exit(1);
}

# �又��
printlog("START");
printlog("basename=$basename");
printlog("scriptname=$scriptname");
printlog("scriptdir=$scriptdir");
printlog("currentdir=$currentdir");
printlog("timestampstr=$timestampstr");

my $dircount = 0;
my $filecount = 0;
my $unknowncount = 0;
foreach my $path (@ARGV) {
  proc($path);
}

print "�f�B���N�g����: $dircount\n";
print "�t�@�C����:     $filecount\n";
print "�s����:         $unknowncount\n";

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

# 1�̃f�B���N�g��/�t�@�C���̏���
sub proc {
  my ($path) = @_;
  if (-d $path) {
    proc_dir($path);
    proc_nest($path);
  } elsif (-f $path) {
    proc_file($path);
  } else {
    proc_unknown($path);
  }
}

# �f�B���N�g���ċA
sub proc_nest {
  my ($dirpath) = @_;

  my @arr = ();
  opendir(DIR, "$dirpath");
  while (my $sub = readdir(DIR)) {
    if ($sub !~ /^\.\.?$/) {
      push(@arr, $dirpath . "\\" . $sub);
    }
  }
  closedir(DIR);

  foreach my $e (@arr) {
    proc($e);
  }
}

# 1�̃f�B���N�g���̏���
sub proc_dir {
  my ($path) = @_;
  my ($dev, $ino, $mode, $nlink, $uid, $gid, $rdev, $size,
    $atime, $mtime, $ctime, $blksize, $blocks) = stat($path);
  my $timestr = make_timestr($mtime);
  print "$path Dir $timestr\n";
  $dircount++;
}

# 1�̃t�@�C���̏���
sub proc_file {
  my ($path) = @_;
  my ($dev, $ino, $mode, $nlink, $uid, $gid, $rdev, $size,
    $atime, $mtime, $ctime, $blksize, $blocks) = stat($path);
  my $timestr = make_timestr($mtime);
  print "$path File $size $timestr\n";
  $filecount++;
}

# 1�̕s���p�X�̏���
sub proc_unknown {
  my ($path) = @_;
  print "$path Unknown\n";
  $unknowncount++;
}

# ����������̑g�ݗ���
sub make_timestr {
  my ($time) = @_;
  my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($time);
  return sprintf("%04d/%02d/%02d %02d:%02d:%02d", $year + 1900, $mon + 1, $mday, $hour, $min, $sec);
}
