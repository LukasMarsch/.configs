Set-Alias vim nvim
Set-Alias dn dotnet
Set-Alias stop Measure-Command
Set-Alias rmrf Remove-ItemRecureForce
Set-Alias weather Get-Weather
Write-Host $(Get-Date -Format 'dddd HH:mm:ss tt')
Import-Module posh-sshell
Import-Module 'C:\Users\lmarsch\Repositories\.configs\Get-FileMetaDataReturnObject.ps1'
Import-Module 'C:\Users\lmarsch\Repositories\.configs\Get-FileMetadata.psm1'
Start-SshAgent -Quiet

function prompt {
    $cw = Get-ColorWheel 
    $host.ui.RawUI.WindowTitle = "$pwd"
    $CmdPromptCurrentFolder = Split-Path -Path $pwd -Leaf
    #$CmdPromptUser = [Security.Principal.WindowsIdentity]::GetCurrent();
    $IsAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

    $ColorChanger = switch ($IsAdmin) {
        $true { "Orange" }
        $false { "DarkBlue" }
    }
    if ($IsWindows) { $os = "  " }
    elseif ($IsLinux) { $os = "  "}
    elseif ($IsMac) { $os = "  " }

    $defaultForeground = (get-host).ui.rawui.ForegroundColor
    $defaultBackground = (get-host).ui.rawui.BackgroundColor
    Write-Host $os -ForegroundColor $defaultBackground -BackgroundColor $ColorChanger -NoNewline

    Write-Host ""-ForegroundColor $ColorChanger -BackgroundColor $defaultForeground -NoNewline
    Write-Host " /$CmdPromptCurrentFolder "  -ForegroundColor $defaultBackground -BackgroundColor $defaultForeground -NoNewline
    Write-Host "" -ForegroundColor $defaultForeground -BackgroundColor $defaultBackground -NoNewline
    $branch = get-gitbranch
    if($branch) {
            Write-Host "[$branch]" -ForegroundColor "cyan" -BackgroundColor $defaultBackground -NoNewLine
        }

    return " "
}

function time {
    $date = Get-Date -Format "HH:mm:ss"
    Write-Output $date
}

function elevate {
    Start-Process alacritty -Verb RunAs
}

function cd.. {
        cd ..
    }

function google ([String][Parameter(Position=0)] $sTerm) {
    if($sTerm) { $sTerm = "/search?q=" + $sTerm}
    else { $sTerm = $null }
    Start-Process microsoft-edge:"https://www.google.com$sTerm"
}

function ld {
    Get-ChildItem -Directory
}

function lf { 
    Get-ChildItem -File
}

function la {
    Get-ChildItem -Force 
}

function gitignore([String][Parameter(Position=0)] $lang) {
    switch($lang) {
        "c#" {Invoke-WebRequest -Uri "https://raw.githubusercontent.com/dotnet/core/main/.gitignore" | New-Item .\.gitignore}
        default {Write-Host "No idea dude"}
    }
}

function repo {
    param ( [Parameter(Mandatory, Position=0)][Int] $in )

    if($in -eq "1") { cd -Path "C:\Users\lmarsch\Repositories" }
    elseif($in -eq "2") { cd -Path "C:\Users\lmarsch\OneDrive - Vater Unternehmensgruppe\Ausbildung\Repositories" }
    elseif($in -eq "3") { cd -Path "H:\Projekte"}
}

function edge ([String][Parameter(Position=0)] $path) {
    Start-Process microsoft-edge:$path
}

function Get-GitBranch () {
        return git branch --show-current
    }

function Start-Timer ([Double][Parameter(Position=0)] $minutes) {
    $seconds = $minutes * 60.0d;
    Start-Sleep -Seconds $seconds;
    [System.Media.SystemSounds]::Asterisk.Play()
    Write-Host "Timer over";
}

function Get-Weather {
    param(
        [String][Parameter(Position=0)] $days,
        [String][Parameter(Position=1)] $city,
        [Switch] $n,
        [Switch] $q,
        [Switch] $qq,
        [Switch] $Help,
        [Switch] $h
    )
    if($h -or $Help) {
        Write-Host "\t [String][Position=1] days \t\tTage vorraus zu sehen"
        Write-Host "\t [String][Position=0] city \t\tZielstadt"
        return;
    }
    $request = "https://de.wttr.in/" + $city
    if($days) {
        if($days -ge 0 -or $days -le 2) {
            $request += "?" + $days
        }
    }
    if($n) {
        $request += "?n"
    }
    if($q) {
        $request += "?q"
    }
    if($qq) {
        $request += "?Q"
    }

        $response = Invoke-RestMethod -Uri $request
        Write-Host $response
    }

function Get-PathVariable {
    return [System.Environment]::GetEnvironmentVariable("PATH") -split ";"
}

function Set-PathVariable {
    param (
        [String] $AddPath,
        [String] $RemovePath,
        [ValidateSet('Process','User','Machine')] [String] $Scope = 'Process'
    )
    $regexPaths = @()
    if($PSBoundParameters.Keys -contains 'AddPath') {
        $regexPaths += [regex]::Escape($AddPath)
    }
    if($PSBoundParameters.Keys -contains 'RemovePath') {
        $regexPaths += [regex]::Escape($RemovePath)
    }
    $arrPath = Get-PathVariable
    foreach($path in $regexPaths) {
        $arrPath = $arrPath | Where-Object { $_ -notMatch "^$path\\?" }
    }
    $value = ($arrPath + $addPath) -join ";"
    [System.Environment]::SetEnvironmentVariable("PATH", $value, $Scope)
}

function Remove-ItemRecurseForce {
        param(
            [Parameter(Mandatory,Position=0)][String] $Path
        )
        Remove-Item $Path -Recurse -Force
    }
