# install.ps1 — installs all BA skills into ~\.claude\skills\

$skillsDir = Join-Path $env:USERPROFILE ".claude\skills"
$repoDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "Installing Claude BA Skills..."
Write-Host "Target: $skillsDir"
Write-Host ""

New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null

Get-ChildItem -Path (Join-Path $repoDir "skills") -Filter "ba-*" -Directory | ForEach-Object {
    $skillName = $_.Name
    $destPath = Join-Path $skillsDir $skillName
    New-Item -ItemType Directory -Path $destPath -Force | Out-Null
    Copy-Item -Path (Join-Path $_.FullName "SKILL.md") -Destination (Join-Path $destPath "SKILL.md") -Force
    Write-Host "  OK $skillName"
}

Write-Host ""
Write-Host "All 9 BA skills installed."
Write-Host "Open Claude Code in any project and run /ba-nav to get started."
