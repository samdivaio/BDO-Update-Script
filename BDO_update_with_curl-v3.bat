@ECHO OFF
SET "root=%~dp0"
CD /D "%root%"

TITLE Black Desert Manual Downloader

ECHO Run Black Desert client once and start downloading pap files a lil before using this script.
ECHO.
pause

if exist "BlackDesertLauncher.exe" (
	ECHO.[101;30m
	ECHO  We are in the Game folder. Proceeding... 
	ECHO.[0m
	) ELSE (
	ECHO.[91m
	ECHO We are in the wrong folder. Ending script...
	ECHO.[0m
	pause >nul
	exit
	)

for /F "tokens=7" %%a in ('findstr /I "client version=" update.log') do set "clientver=%%a"
ECHO Client version is: %clientver%
ECHO.
for /F "tokens=7" %%b in ('findstr /I "latest version=" update.log') do set "latestver=%%b"
ECHO Latest version is: %latestver%

if %clientver%==%latestver% (
ECHO.[91m
ECHO Game is already up to date.
ECHO.
ECHO If not, run the BDO client once and wait for it to start downloading PAP files.
ECHO When it does, close the BDO client and run this script again.
ECHO.[0m
pause >nul
exit
)

:patchfolder
ECHO.
if exist "%root%patch_temp1" (
	ECHO "%root%patch_temp1" folder already exists. Delete it?
	del "%root%patch_temp1"
	RMDIR "%root%Log" /S /Q >nul 2>&1
	del "%root%console.log"
	ECHO.
	ECHO "%root%patch_temp1" folder has been deleted.
	) ELSE (
	mkdir "%root%patch_temp1"
	ECHO "%root%patch_temp1" folder created.
	)

ECHO.
set /a updt0=%clientver%+1
set /a updt1=%latestver%
for /l %%c in (%updt0%;1;%updt1%) do (
   ECHO.[7m
   ECHO  Downloading "http://naeu-o-dn.playblackdesert.com/UploadData/patch/%%c.PAP" 
   ECHO.[0m
   REM idman /n /a /d "http://naeu-o-dn.playblackdesert.com/UploadData/patch/%%c.PAP" /p "%root%patch_temp1"
   curl -f "http://naeu-o-dn.playblackdesert.com/UploadData/patch/%%c.PAP" -o "%root%patch_temp1\%%c.PAP"
   )

:movefolder
if exist "%root%patch_temp" (
	ECHO.
	ECHO ---------------------------
	ECHO "%root%patch_temp" folder exists.
	RMDIR "%root%patch_temp" /S /Q >nul 2>&1
	ECHO "%root%patch_temp" folder has been deleted.
	ECHO ---------------------------
	) ELSE (
	REM cls
	mkdir "%root%patch_temp"
	ECHO.
	ECHO ---------------------------
	ECHO New "%root%patch_temp" folder created.
	ECHO.
	ROBOCOPY %root%patch_temp1 %root%patch_temp\ /E /COPY:DAT
	ECHO.[93m
	ECHO Patches copied to "%root%patch_temp"
	ECHO.[0m
	ECHO ---------------------------
	)
GOTO end

:end
ECHO.[92m
ECHO Press any key to check and move patch_temp folder again...
ECHO.[0m
pause >nul
GOTO movefolder
