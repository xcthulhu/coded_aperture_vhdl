echo ; ./bin/setup.bash; exit; #Dual batch script: Unix & msdos
@ECHO OFF
REM function: Shell command.com in order to start bash
REM
REM see http://home.wanadoo.nl/fvu/Projects/Bash/Web/bash.htm
REM
REM Shell command.com with enough environment space and start dos2bash.bat
REM
command.com /e:1024 /k bin\dos2bash.bat %1 %2 %3 %4 %5 %6 %7 %8 %9
