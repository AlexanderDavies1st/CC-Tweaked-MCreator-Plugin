# CC:Tweaked MCreator Plugin - Windows build script
# Requires Git and JDK 25. Run from PowerShell: .\\BUILD-WINDOWS.ps1
$ErrorActionPreference = 'Stop'
$Root = $PSScriptRoot
$Version = if ($env:MCREATOR_VERSION) { $env:MCREATOR_VERSION } else { '2026.2.33518' }
$Deps = Join-Path $Root '.build-deps'
$Mcreator = if ($env:MCREATOR_SOURCE_DIR) { $env:MCREATOR_SOURCE_DIR } else { Join-Path $Deps 'MCreator' }

if (-not (Get-Command java -ErrorAction SilentlyContinue)) { throw 'Java was not found. Install JDK 25.' }
$JavaOutput = (& java -version 2>&1 | Select-Object -First 1).ToString()
if ($JavaOutput -notmatch '"25(?:\.|"|-)') { throw "JDK 25 is required. Detected: $JavaOutput" }
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'Git was not found. Install Git.' }

if (-not (Test-Path (Join-Path $Mcreator 'gradlew.bat'))) {
    New-Item -ItemType Directory -Force -Path $Deps | Out-Null
    if (Test-Path $Mcreator) { throw "$Mcreator exists but is not an MCreator source checkout." }
    Write-Host "Downloading MCreator source $Version (first build only)..."
    git clone --depth 1 --branch $Version https://github.com/MCreator/MCreator.git $Mcreator
    if ($LASTEXITCODE -ne 0) { throw 'Could not clone the MCreator source repository.' }
}

& (Join-Path $Mcreator 'gradlew.bat') -p $Mcreator downloadJDKWin64 --no-daemon
if ($LASTEXITCODE -ne 0) { throw 'Could not download the MCreator JCEF toolchain.' }

Push-Location $Root
try {
    & (Join-Path $Mcreator 'gradlew.bat') -p $Root "-Pmcreator_path=$Mcreator" --no-daemon clean jar
    if ($LASTEXITCODE -ne 0) { throw 'Gradle build failed.' }
} finally {
    Pop-Location
}

$Artifact = Join-Path $Root 'build\\libs\\cc-tweaked-mcreator-plugin.zip'
if (-not (Test-Path $Artifact)) { throw "Expected plugin archive was not created: $Artifact" }
Write-Host "BUILD SUCCESSFUL: $Artifact" -ForegroundColor Green
