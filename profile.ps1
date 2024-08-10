Set-Alias vim nvim
Set-Alias dn dotnet
Set-Alias stop Measure-Command
Write-Host $(Get-Date -Format 'dddd HH:mm:ss tt')
Import-Module posh-sshell
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

    Write-Host $os -ForegroundColor Black -BackgroundColor $ColorChanger -NoNewline

    Write-Host ""-ForegroundColor $ColorChanger -BackgroundColor "#45475A" -NoNewline
    Write-Host " \$CmdPromptCurrentFolder "  -ForegroundColor White -BackgroundColor "#45475A" -NoNewline
    Write-Host "" -ForegroundColor "#45475A" -BackgroundColor "#1E222A" -NoNewline
    $branch = get-gitbranch
    if($branch) {
            Write-Host "[$branch]" -ForegroundColor "cyan" -BackgroundColor "#1E222A" -NoNewLine
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

function Set-Timer ([String][Parameter(Position=0)] $time) {
        $timer = $time.Split(':');
        $sets = $timer.Length;

#        switch($sets) {
#                1: //second
#                2: //minutes-seconds
#                3: //hours-minutes-seconds
#            }
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
