# Perlスクリプトのテンプレートです。
# ファイル・ディレクトリ操作サンプル付き。

use strict;
use warnings;
use Cwd;
use File::Basename;

# 前処理
my $basename;
my $scriptname;
my $scriptdir;
my $currentdir;
my $datestr;
my $timestr;
my $timestampstr;
init();

# 引数チェック
if ($#ARGV < 0 || $ARGV[0] eq "-h") {
  print "Usage: perl $scriptname [-h] path1 ...\n";
  print "path - ファイル、またはディレクトリのパス。\n";
  exit(1);
}

# 主処理
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

print "ディレクトリ数: $dircount\n";
print "ファイル数:     $filecount\n";
print "不明数:         $unknowncount\n";

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

# 1つのディレクトリ/ファイルの処理
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

# ディレクトリ再帰
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

# 1つのディレクトリの処理
sub proc_dir {
  my ($path) = @_;
  my ($dev, $ino, $mode, $nlink, $uid, $gid, $rdev, $size,
    $atime, $mtime, $ctime, $blksize, $blocks) = stat($path);
  my $timestr = make_timestr($mtime);
  print "$path Dir $timestr\n";
  $dircount++;
}

# 1つのファイルの処理
sub proc_file {
  my ($path) = @_;
  my ($dev, $ino, $mode, $nlink, $uid, $gid, $rdev, $size,
    $atime, $mtime, $ctime, $blksize, $blocks) = stat($path);
  my $timestr = make_timestr($mtime);
  print "$path File $size $timestr\n";
  $filecount++;
}

# 1つの不明パスの処理
sub proc_unknown {
  my ($path) = @_;
  print "$path Unknown\n";
  $unknowncount++;
}

# 日時文字列の組み立て
sub make_timestr {
  my ($time) = @_;
  my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($time);
  return sprintf("%04d/%02d/%02d %02d:%02d:%02d", $year + 1900, $mon + 1, $mday, $hour, $min, $sec);
}
