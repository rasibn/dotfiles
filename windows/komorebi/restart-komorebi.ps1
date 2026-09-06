$ErrorActionPreference = 'Continue'

$komorebiConfig = 'C:\Users\rasib\dotfiles\komorebi\komorebi.json'
$komorebiAhk = 'C:\Users\rasib\OneDrive\Startup\komorebi.ahk'
$autoHotkey = 'C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe'

# Stop only the AutoHotkey process running the Komorebi script.
Get-CimInstance Win32_Process -Filter "Name = 'AutoHotkey64.exe'" |
    Where-Object { $_.CommandLine -like '*komorebi.ahk*' } |
    ForEach-Object { Stop-Process -Id $_.ProcessId -Force }

# Ask Komorebi to stop cleanly, then ensure leftover processes are closed.
komorebic.exe stop --bar 2>$null
Stop-Process -Name komorebi -Force -ErrorAction SilentlyContinue
Stop-Process -Name komorebi-bar -Force -ErrorAction SilentlyContinue
Stop-Process -Name komorebi-bar -Force -ErrorAction SilentlyContinue

# Start Komorebi with the current home-directory config symlink and its bar.
komorebic.exe start --bar

# Start the matching AutoHotkey bindings.
Start-Process -FilePath $autoHotkey -ArgumentList '/restart', '/script', $komorebiAhk

Write-Host 'Komorebi and its AutoHotkey bindings have been restarted.'
