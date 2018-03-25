# Perlでディレクトリ操作するスクリプトのテンプレートです。
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
# GetOptionsの型指定：s=文字列型, i=整数型, f=実数型, @=同optionを複数回指定可, 型なし=boolean
GetOptions(\%opts,
  "help|h",
  "debug"
) or $opts{help} = 1;
if ($#ARGV + 1 < 1 || $opts{help}) {
  print "Usage: perl $scriptname [OPTIONS] path1 ...\n";
  print "--help, -h     - 当ヘルプを表示する。\n";
  print "--debug        - デバッグ用\n";
  print "path           - ファイル、またはディレクトリのパス。\n";
  exit(1);
}

# 主処理
printlog("START");
printlog("\%opts " . Dumper(\%opts));
printlog("\@ARGV " . Dumper(\@ARGV));

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
