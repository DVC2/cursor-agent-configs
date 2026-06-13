#Requires -Version 5.1
<#
.SYNOPSIS
    Install Cursor/agent configs from this repo into the current project (Windows).
.DESCRIPTION
    Copies the .cursor primitives you choose, plus an AGENTS.md starter template.
    Backs up anything it would overwrite. No Node/npm required.
#>

$ErrorActionPreference = 'Stop'
$Src   = Split-Path -Parent $PSScriptRoot   # repo root (source)
$Dest  = (Get-Location).Path                # target project
$Stamp = Get-Date -Format 'yyyyMMdd_HHmmss'

function Ask([string]$Prompt, [string]$Default = 'y') {
    $r = Read-Host "  $Prompt"
    if ([string]::IsNullOrWhiteSpace($r)) { $r = $Default }
    return $r -match '^[Yy]$'
}

function Backup-Then-Copy([string]$S, [string]$D) {
    if (Test-Path $D) {
        $b = "$D.backup_$Stamp"
        Copy-Item $D $b -Recurse
        Write-Host "  backed up $(Split-Path $D -Leaf) -> $b"
    }
    $parent = Split-Path $D -Parent
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    Copy-Item $S $D -Recurse -Force
    Write-Host "  installed $D"
}

Write-Host "Installing Cursor configs into: $Dest"
if ($Src -eq $Dest) { Write-Error "Refusing to install into the source repo itself."; exit 1 }

if (Ask 'Copy rules (.cursor/rules)? [Y/n]')     { Backup-Then-Copy "$Src\.cursor\rules"  "$Dest\.cursor\rules" }
if (Ask 'Copy subagents (.cursor/agents)? [Y/n]') { Backup-Then-Copy "$Src\.cursor\agents" "$Dest\.cursor\agents" }
if (Ask 'Copy skills (.cursor/skills)? [Y/n]')   { Backup-Then-Copy "$Src\.cursor\skills" "$Dest\.cursor\skills" }

Write-Host ""
Write-Host "  Hooks run shell scripts on agent events. Review them first: $Src\.cursor\hooks\"
if (Ask 'Copy hooks (.cursor/hooks.json + scripts)? [y/N]' 'n') {
    Backup-Then-Copy "$Src\.cursor\hooks.json" "$Dest\.cursor\hooks.json"
    Backup-Then-Copy "$Src\.cursor\hooks"      "$Dest\.cursor\hooks"
    Write-Host "  note: the example hooks are bash + jq; on Windows run them via WSL/Git Bash."
}

if ((-not (Test-Path "$Dest\AGENTS.md")) -and (Ask 'Add an AGENTS.md from the template? [Y/n]')) {
    Copy-Item "$Src\templates\AGENTS.md" "$Dest\AGENTS.md"
    Write-Host "  created AGENTS.md — open it and fill in the bracketed sections."
} elseif (Test-Path "$Dest\AGENTS.md") {
    Write-Host "  AGENTS.md already exists — left untouched."
}

Write-Host ""
Write-Host "Done. Restart Cursor to load the new configs."
