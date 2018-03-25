# Perlでテキストファイルを入出力するスクリプトのテンプレートです。
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
  "string=s",
  "integer=i",
  "help|h",
  "debug"
) or $opts{help} = 1;
if ($#ARGV + 1 != 2 || $opts{help}) {
  print "Usage: perl $scriptname [OPTIONS] inpath outpath\n";
  print "--string str   - 文字列引数\n";
  print "--integer int  - 整数引数\n";
  print "--help, -h     - 当ヘルプを表示する。\n";
  print "--debug        - デバッグ用\n";
  print "inpath         - 入力ファイルパス。\n";
  print "outpath        - 出力ファイルパス。\n";
  exit(1);
}
my ($inpath, $outpath) = @ARGV;
$opts{string} = decode('cp932', $opts{string});

# 主処理
printlog("START");
printlog("\%opts " . Dumper(\%opts));
printlog("\@ARGV " . Dumper(\@ARGV));
printlog("\$opts{string}=$opts{string}") if $opts{string};
printlog("\$opts{integer}=$opts{integer}") if $opts{integer};
printlog("\$inpath=$inpath");
printlog("\$outpath=$outpath");

open(IN, '<', $inpath) || die("Can't open $inpath. $!\n");
open(OUT, '>', $outpath) || die("Can't open $outpath. $!\n");

# 改行コードを制御したいときはバイナリモードにする。
binmode(OUT);

my $count = 0;
while (<IN>) {
  $count++;
  chomp($_);
  print OUT "$count: $_\n";
}

close OUT;
close IN;

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
