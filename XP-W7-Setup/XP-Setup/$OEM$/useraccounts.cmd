net user "UserXP" /add
net localgroup Administrators "UserXP" /add
net accounts /maxpwage:unlimited
REM REGEDIT /S autologon.reg
EXIT
