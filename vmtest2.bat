:: Minidemo VMware mit cmd-Spagetticode

@echo off
cls

set VMcmd="%ProgramFiles(x86)%\VMware\VMware Workstation"\vmrun -T ws
setlocal enabledelayedexpansion

for /f "delims=" %%i in ('echo prompt $E^| cmd') do set "ESC=%%i"	:: ESC definieren fuer ANSI-Farben

set VMname=%~1
if "%VMname%"=="" goto VMbrowser
if NOT EXIST "%VMname%" (
	echo Kann Datei: %ESC%[36m%VMname%%ESC%[0m nicht finden.
	goto VMbrowser
)
	
if "%VMname:~-4%"==".vmx" (
    	goto menue

) else (
    	echo %ESC%[36m%VMname%%ESC%[0m ist keine VMware-VM.
    	goto VMbrowser
)

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


:menue
cls
echo.
echo VM: %ESC%[36m%VMname%%ESC%[0m
echo.
echo 1: VM starten
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
set /p Key= Waehle (0-9):
if %Key% GEQ 10 (goto menue) else (goto %Key%)

:1
echo VM starten ...
%VMcmd% start "%VMname%"
goto fertig

:2
echo VM runterfahren ...
%VMcmd% stop "%VMname%" soft
goto fertig

:3
echo VM ausschalten ...
%VMcmd% stop "%VMname%" hard
goto fertig

:4
echo VM neustarten ...
%VMcmd% reset "%VMname%" soft
goto fertig

:5
echo Resettaste druecken ...
%VMcmd% reset "%VMname%" hard
goto fertig

:6
echo VM suspendieren ...
%VMcmd% suspend "%VMname%"
goto fertig

:7
echo Erzeuge Snapshot, bitte warten...
%VMcmd% snapshot "%VMname%" "%VMname%".snapshot
goto fertig

:8
echo Loesche Snapshot ...
%VMcmd% deleteSnapshot "%VMname%" "%VMname%".snapshot
goto fertig

:9
echo Loesche Snapshot ...
%VMcmd% revertToSnapshot "%VMname%" "%VMname%".snapshot
goto fertig

:fertig
if %ERRORLEVEL% NEQ 0 (echo Ups da hat was nicht geklappt.) else ( echo erledigt.)
pause
goto menue

:0
:ende
