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
::
:: Enable EWF on the next boot up.
ewfmgr -all | findstr /i "DISABLED"
if %errorlevel% == 0 @Echo Enhanced Write Filter state is now DISABLED. & @Echo all changes is now permanent. & @Echo It is recommented to restart computer now. & Echo. & ewfmgr -all -enable & @Echo After next restart Enhanced Write Filter protects volume(s). 
pause
