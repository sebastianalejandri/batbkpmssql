@echo off
:: criacao pasta
For /f "tokens=1-4 delims=/ " %%a in ('date /t') do (set date=%%b%%c%%d)
For /f "tokens=1* delims=: " %%a in ('time /t') do (set time=%%a%%b) 

ECHO hoje eh %date%_%time% dia e hora!
set nomepasta=%date%_%time%
:: md e:\BKP_DB_AUTO\%nomepasta%
md E:\BKP_DB_AUTO\%nomepasta%

:: PARAR PROCESSO MSSQL
:: MSSQLSERVER
:: net stop mssql$sqlexpress
net stop MSSQLSERVER

:: COPIA ARQUIVOS .MDF .LDF DE C:\ PARA E:\
:: copy C:\MSSQL\Incorp\IncorpSaf_Data E:\BKP_DB_AUTO\%nomepasta%\IncorpSaf_Data
copy "C:\MSSQL\Incorp\IncorpSaf_Data.mdf" E:\BKP_DB_AUTO\%nomepasta%\IncorpSaf_Data.mdf
copy "C:\MSSQL\Incorp\IncorpSaf_Log.ldf" E:\BKP_DB_AUTO\%nomepasta%\IncorpSaf_Log.ldf

copy "C:\MSSQL\GpbTxt_Data.mdf" E:\BKP_DB_AUTO\%nomepasta%\GpbTxt_Data.mdf
copy "C:\MSSQL\Gpbtxt_Log.ldf" E:\BKP_DB_AUTO\%nomepasta%\Gpbtxt_Log.ldf

copy "C:\MSSQL\Incorp\Incorp_Data.mdf" E:\BKP_DB_AUTO\%nomepasta%\Incorp_Data.mdf
copy "C:\MSSQL\Incorp\Incorp_Log.ldf" E:\BKP_DB_AUTO\%nomepasta%\Incorp_Log.ldf

:: INICIA O PROCESSO MSSQL
:: MSSQLSERVER
:: net start mssql$sqlexpress
net start MSSQLSERVER

::APAGAR BACKUPS ANTIGOS COM MAIS 15 DIAS
echo APAGAR BACKUPS ANTIGOS COM MAIS 15 DIAS
::APAGA ARQUIVOS .MDF E .LDF
forfiles -p "E:\BKP_DB_AUTO" -s -m *.mdf /D -15 /C "cmd /c del @path"
forfiles -p "E:\BKP_DB_AUTO" -s -m *.ldf /D -15 /C "cmd /c del @path"

::APAGA PASTAS VAZIAS REMANECENTES
::forfiles -p "E:\BKP_DB_AUTO" /D -15 /C "cmd /c rd /q @path"
FORFILES /p "E:\BKP_DB_AUTO" /S /C "cmd /c IF @isdir == TRUE RMDIR @path"


rem net start MSSQLSERVER
rem 7z.exe -t D:\BKP_DB_AUTO\%nomepasta%\IncorpSaf.mdf"
rem 7z a -tzip doc.zip doc.txt