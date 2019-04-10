@echo off
reg add HKEY_CURRENT_USER\Console\\"%%SystemRoot%%_system32_cmd.exe" /f
reg add HKEY_CURRENT_USER\Console\\"%%SystemRoot%%_system32_cmd.exe" /v CodePage /d 65001 /t REG_DWORD /f
