@echo off
setlocal

REM Set the source and destination file paths
set "sourceFile=serverDZTemplate.cfg"
set "sourceFileBat=serverTemplate.bat"
set "defaultPath=C:\Program Files (x86)\Steam\steamapps\common\DayZServer"

REM Ask the user for a name to append to the copied file
set /p appendName=Enter name of map: 
set "destinationFile=%defaultPath%\serverDZ_%appendName%.cfg"
set "destinationFileBat=%defaultPath%\%appendName%.bat"

REM Copy the source file to the destination
copy "%sourceFile%" "%destinationFile%" /Y
copy "%sourceFileBat%" "%destinationFileBat%" /Y

REM Ask the user for a mission name to replace in the copied file
set /p missionName=Enter the mission file name found in mpmissions folder: 
set "findText=MISSIONFILENAME"
set "replaceText=%missionName%"

set "findTextBat1=serverDZTEMPLATE"
set "replaceTextBat1=serverDZ_%appendName%"

set "findTextBat2=profileTEMPLATE"
set "replaceTextBat2=profile_%appendName%"

REM Perform the find-and-replace operation using PowerShell
powershell -Command "(Get-Content '%destinationFile%') | ForEach-Object { $_ -replace '%findText%', '%replaceText%' } | Set-Content '%destinationFile%'"

powershell -Command "(Get-Content '%destinationFileBat%') | ForEach-Object { $_ -replace '%findTextBat1%', '%replaceTextBat1%' } | Set-Content '%destinationFileBat%'"

powershell -Command "(Get-Content '%destinationFileBat%') | ForEach-Object { $_ -replace '%findTextBat2%', '%replaceTextBat2%' } | Set-Content '%destinationFileBat%'"

REM Call the function to create a folder with "profile_" and the appendName
call :CreateProfileFolder "%appendName%"

echo "File copied, modified, and renamed successfully."
echo "Profile folder created."

pause
endlocal

:CreateProfileFolder
REM Function to create a folder with "profile_" appended to the beginning
set "folderName=profile_%~1"
mkdir "%defaultPath%\%folderName%"
exit /b
