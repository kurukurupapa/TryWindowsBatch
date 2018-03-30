@echo off

set prjdir=%basedir%\..\..\..
set mainname=csvgrep
set mainpath=%basedir%\..\%mainname%.pl
set indir=%basedir%\Input
set expdir=%basedir%\Expectation
set workdir=%basedir%\Work
set performancedir=%TMP%\TryWindowsBatch\Perl\File\CsvGrepTest
set tmplog=%workdir%\tmp.log
if not exist %workdir% ( mkdir %workdir% )
if not exist %performancedir% ( mkdir %performancedir% )

exit /b 0
