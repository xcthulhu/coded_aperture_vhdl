@ECHO OFF
REM --- _djgpp.bat ------------------------------------------------------------
REM function: Setup environment for bash shell.  Call bash.exe
REM args:	  - 1..9: bash shell arguments

REM Set DjGpp home directory (~)
SET  HOME=.
REM  Set DjGpp environment file
REM  SET DJGPP=%HOME%\djGpp.env
REM  Set path to DjGpp
copy bin\dos2pwd1.bat bin\dos2pwd2.bat
cd   >>bin\dos2pwd2.bat
call bin\dos2pwd2.bat
SET  PATH=.;%DOS2PWD2%\bin;%PATH%
IF   "--%1"=="----bash" goto bash
bash setup.bash --msdos %1 %2 %3 %4 %5 %6 %7 %8 %9
exit
:bash
bash %2 %3 %4 %5 %6 %7 %8 %9
