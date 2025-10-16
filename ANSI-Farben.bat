:: Aktiviert ANSI-Unterstützung in neueren Windows-Terminals (funktioniert ab Windows 10, Build 16257)

if "%~0" NEQ "%~f0" (
	@echo off
	cls
	echo Dies ist ein reines Support-Script und nicht zum direkten Ausfuehren gedacht.
	echo Um ANSI-Farben und die vordefinierten Bezeichner zu verwenden
	echo dieses Script mit "call %~0" in eigene Batchdatei einbinden. 
	timeout /t 5
	exit /b 1
)

:: === "ESC" umstaendlich definieren ===
for /f "delims=" %%i in ('echo prompt $E^| cmd') do set "ESC=%%i"

:: === Standardfarben ===
set "BLACK=%ESC%[30m"
set "RED=%ESC%[31m"
set "GREEN=%ESC%[32m"
set "YELLOW=%ESC%[33m"
set "BLUE=%ESC%[34m"
set "MAGENTA=%ESC%[35m"
set "CYAN=%ESC%[36m"
set "WHITE=%ESC%[37m"

:: === Helle Farben ===
set "BRIGHT_BLACK=%ESC%[90m"
set "BRIGHT_RED=%ESC%[91m"
set "BRIGHT_GREEN=%ESC%[92m"
set "BRIGHT_YELLOW=%ESC%[93m"
set "BRIGHT_BLUE=%ESC%[94m"
set "BRIGHT_MAGENTA=%ESC%[95m"
set "BRIGHT_CYAN=%ESC%[96m"
set "BRIGHT_WHITE=%ESC%[97m"

:: === Stile ===
set "BOLD=%ESC%[1m"
set "DIM=%ESC%[2m"
set "ITALIC=%ESC%[3m"
set "UNDERLINE=%ESC%[4m"
set "INVERT=%ESC%[7m"

:: === Setzt Farbe auf Standard zurueck ===
set "RESET=%ESC%[0m"
