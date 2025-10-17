:: Minidemo VMware mit cmd-Spagetticode

@echo off
set VMrun="%ProgramFiles(x86)%\VMware\VMware Workstation"\vmrun -T ws
setlocal enabledelayedexpansion
call .\.include\ANSI-Farben.bat main :: Bunt machen
cls

:: 				=== Kommandozeilenparameter auswerten und checken ===
set VMname=%~1
if "%VMname%"=="" goto VMbrowser
if NOT EXIST "%VMname%" (
	echo Kann Datei: %CYAN%%VMname%%RESET% nicht finden.
	goto VMbrowser
)
	
if "%VMname:~-4%"==".vmx" (
    	goto menue

) else (
    	echo %CYAN%%VMname%%RESET% ist keine VMware-VM.
    	goto VMbrowser
)


:: 				=== Nach VMs suchen und eine auswaehlen ===
:VMbrowser
echo.
echo Suche nach virtuellen Maschinen (VMware)...
echo.

set i=0
for /f "delims=" %%A in ('dir /b /s %USERPROFILE%\*.vmx ^| findstr /E "\.vmx"') do (
    	set /a i+=1
    	set "item[!i!]=%%A"
    	echo !i!: %%A
)

echo.
set /p Key=VM auswaehlen oder beliebige Taste zum Abbrechen: 
set "VMname=!item[%Key%]!"


if defined VMname (
	goto menue
) else (
    	echo Auswahl abgebrochen.
    	goto ende
)

:: 				=== Funktionsmenue ===
:menue
cls
echo.
echo VM: %CYAN%%VMname%%RESET%
echo.
echo 1: VM starten / 10: Im Hintergrund starten
echo 2: VM sanft runterfahren
echo 3: Stecker ziehen
echo 4: Softreboot
echo 5: Harter Reset
echo 6: VM pausieren
echo.
echo 7: Snapshot erstellen
echo 8: Snapshot loeschen
echo 9: Auf Snapshot zuruecksetzen
echo.
echo 0: Beenden
echo.

set Key=255
set /p Key= Waehle (0-10):
if %Key%==0 goto ende
if %Key% LEQ 10 (call :%Key%) else (goto menue)
call :fertig
goto menue


:: 				=== Die einzelnen Funktionen ===
:1
echo VM starten ...
set CommandStr= start "%VMname%"
exit /b

:10
echo VM starten ...
set CommandStr= start "%VMname%" nogui
exit /b

:2
echo VM runterfahren ...
set CommandStr= stop "%VMname%" soft
exit /b

:3
echo VM ausschalten ...
set CommandStr= stop "%VMname%" hard
exit /b

:4
echo VM neustarten ...
set CommandStr= reset "%VMname%" soft
exit /b

:5
echo Resettaste druecken ...
set CommandStr= reset "%VMname%" hard
exit /b

:6
echo VM suspendieren ...
set CommandStr= suspend "%VMname%" hard
exit /b

:7
echo Erzeuge Snapshot, bitte warten...
set CommandStr= snapshot "%VMname%" "%VMname%".snapshot
exit /b

:8
echo Loesche Snapshot ...
set CommandStr= deleteSnapshot "%VMname%" "%VMname%".snapshot
exit /b

:9
echo Setze VM auf Snapshot zurueck ...
set CommandStr= revertToSnapshot "%VMname%" "%VMname%".snapshot
exit /b

:fertig
%VMrun% %CommandStr%
if %ERRORLEVEL% NEQ 0 (echo Ups da hat was nicht geklappt.) else ( echo erledigt.)
timeout /t 5
exit /b

:ende
