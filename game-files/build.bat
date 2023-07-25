@echo off

setlocal
set PATH=bin;%PATH%

if exist game.z? del game.z?
if exist game*.*zap del game*.*zap
zilf game.zil -ip ..\zillib -ip ..\zillib\parser
zapf -ab game.zap > game_freq.xzap
del game_freq.zap

zapf game.zap

pause
