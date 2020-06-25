TITLE PURGE DLL CACHE with SFC /PURGECACHE 
@echo off
CLS
ECHO.
ECHO PURGE DLL CACHE with SFC /PURGECACHE - Reduce WINDOWS by 350 MB
ECHO.
pause

ECHO.
start /wait sfc /purgecache

pause
EXIT
