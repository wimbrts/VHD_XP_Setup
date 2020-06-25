:: Write changes to the protected volume and Immediately dsiable EWF
ewfmgr -all -commitanddisable -live
::
:: Disable XP recovery options
:: When Windows XP Professional starts, it reads status information from the file systemroot\Bootstat.dat.
:: If Windows XP detects that the last startup attempt was unsuccessful,
:: it automatically displays Automatic Recovery screen, which contains:
::
:: We apologize for the inconvenience, but Windows did not start successfully.
:: A recent hardware or software change might have caused this.
::
:: The Windows Advanced Options menu includes the following troubleshooting modes:
:: Safe Mode
:: Safe Mode with Networking
:: Safe Mode with Command Prompt
:: Last Known Good Configuration
:: Start Windows Normally
if exist %SystemRoot%\bootstat.dat attrib -r -s -h %SystemRoot%\bootstat.dat & del %SystemRoot%\bootstat.dat
::
pause
