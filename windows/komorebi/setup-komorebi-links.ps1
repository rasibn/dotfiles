# Run this script from an elevated PowerShell, unless Windows Developer Mode
# allows the current user to create symbolic links.
$dotfiles = $PSScriptRoot
$home = $env:USERPROFILE
$startup = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Startup'
$oneDriveStartup = Join-Path $home 'OneDrive\Startup'

function Set-SymbolicLink($link, $target) {
    if (Test-Path -LiteralPath $link) {
        Remove-Item -LiteralPath $link -Force
    }

    New-Item -ItemType SymbolicLink -Path $link -Target $target | Out-Null
}

New-Item -ItemType Directory -Force -Path (Join-Path $home '.config') | Out-Null
New-Item -ItemType Directory -Force -Path $startup, $oneDriveStartup | Out-Null

Set-SymbolicLink (Join-Path $home 'komorebi.json') (Join-Path $dotfiles 'komorebi.json')
Set-SymbolicLink (Join-Path $home 'komorebi.bar.json') (Join-Path $dotfiles 'komorebi.bar.json')
Set-SymbolicLink (Join-Path $home 'applications.json') (Join-Path $dotfiles 'applications.json')
Set-SymbolicLink (Join-Path $home '.config\whkdrc') (Join-Path $dotfiles 'whkdrc')
Set-SymbolicLink (Join-Path $oneDriveStartup 'komorebi.ahk') (Join-Path $dotfiles 'komorebi.ahk')
Set-SymbolicLink (Join-Path $oneDriveStartup 'swap.ahk') (Join-Path $dotfiles 'swap.ahk')
Set-SymbolicLink (Join-Path $home 'restart-komorebi.ps1') (Join-Path $dotfiles 'restart-komorebi.ps1')

$restartScript = Join-Path $home 'restart-komorebi.ps1'
$shortcutPath = Join-Path $startup 'komorebi-restart.lnk'
$powershell = (Get-Command powershell.exe -ErrorAction Stop).Source
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $powershell
$shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$restartScript`""
$shortcut.WorkingDirectory = $home
$shortcut.Save()

Write-Host "Windows Komorebi and AutoHotkey links configured."
