@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$startup = [Environment]::GetFolderPath('Startup');" ^
  "$path = Join-Path $startup 'swap.ahk';" ^
  "Set-Content -LiteralPath $path -Value @('CapsLock::Esc','Esc::CapsLock') -Encoding UTF8;" ^
  "Write-Host ('Created: ' + $path)"
if %errorlevel% neq 0 (
    echo Failed to create script.
    exit /b 1
)
echo Done. The script will run at your next logon.
endlocal
