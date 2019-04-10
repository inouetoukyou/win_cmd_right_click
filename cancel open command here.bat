@echo off
rem 管理员方式运行
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "cmd.exe", "/s /c " ^& """"%0"""" ^& " ", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
pushd "%cd%"
set NetPath=%~dp0

REM cd /d %~dp0

rem route为cmd目录 
set route=HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\background\shell\cmd

rem route2为Powershell目录
set route2=HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\background\shell\Powershell

rem 更改用户
%NetPath%\SetACL -on %route% -ot reg -actn setowner -ownr "n:Users" -rec yes -silent
echo %cd%

rem 更改权限
%NetPath%\SetACL -on %route% -ot reg -actn ace -ace "n:Users;p:full;i:sc,so" -rec yes -silent

rem 修改键值
for /f "tokens=2 delims=x" %%a in ('reg query %route2% /v ShowBasedOnVelocityId') do (
    set s=0x%%a
	setlocal enabledelayedexpansion
    REM set /a s += 1
	echo !s!
    reg add %route% /v HideBasedOnVelocityId /d !s! /t REG_DWORD /f
	reg add %route% /v Extended /t REG_SZ /f
)

rem 权限改回来
%NetPath%\SetACL -on %route% -ot reg -actn ace -ace "n:Users;p:read;i:sc,so" -rec yes -silent

rem 用户改回来
%NetPath%\SetACL -on %route% -ot reg -actn setowner -ownr "n:nt service\trustedinstaller" -rec yes -silent
popd