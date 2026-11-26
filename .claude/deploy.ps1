# Publish website/ to GitHub Pages (sweettreatsbychar.shop).
# Usage: powershell -File .claude\deploy.ps1 "Commit message"
# 1) stamps style.css / bookings.js / main.js links with a fresh ?v= so browsers
#    never mix an old script with a new page, 2) commits, 3) pushes the source
#    repo, 4) pushes only website/ to the public Pages repo (no force push).
param([Parameter(Mandatory = $true)][string]$Message)
$ErrorActionPreference = "Stop"
$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + $env:Path
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$index = Join-Path $root "website\index.html"
$v = Get-Date -Format "yyyyMMddHHmm"
$html = [IO.File]::ReadAllText($index)
$html = [regex]::Replace($html, '(href|src)="(style\.css|bookings\.js|main\.js)(\?v=\d+)?"', ('$1="$2?v=' + $v + '"'))
[IO.File]::WriteAllText($index, $html, (New-Object Text.UTF8Encoding($false)))

git add -A website
git commit -q -m "$Message`n`nCo-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"
git push -q origin main
if ($LASTEXITCODE -ne 0) { throw "push to origin failed" }
git subtree split --prefix website -b site-new -q | Out-Null
git checkout -q site
git merge -q --no-edit site-new
git push -q pages site:main
$code = $LASTEXITCODE
git checkout -q main
git branch -D site-new -q
if ($code -ne 0) { throw "push to pages failed" }
"deployed v=$v"
