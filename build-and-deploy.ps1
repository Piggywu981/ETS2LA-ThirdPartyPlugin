param(
    [string]$Configuration = "Release",
    [string]$Ets2laRoot = (Join-Path (Get-Item $PSScriptRoot).Parent.FullName "ETS2LA-win-release-Portable")
)

$ErrorActionPreference = "Stop"
$RepoRoot = $PSScriptRoot
$PluginsDir = Join-Path (Join-Path $Ets2laRoot "current") "Plugins"

Write-Host "=== Third-Party Plugin Builder ===" -ForegroundColor Cyan
Write-Host "Repository: $RepoRoot"
Write-Host "ETS2LA root: $Ets2laRoot"
Write-Host "Target dir:  $PluginsDir"
Write-Host ""

# Verify ETS2LA root exists
if (-not (Test-Path $Ets2laRoot)) {
    Write-Error "ETS2LA directory not found at: $Ets2laRoot"
    exit 1
}

# Isolated dotnet environment (avoids polluting the real APPDATA)
$isolatedDir = Join-Path $RepoRoot ".dotnet-cache"
$env:APPDATA = Join-Path $isolatedDir "appdata"
$env:DOTNET_CLI_HOME = Join-Path $isolatedDir "dotnet-home"
$env:NUGET_PACKAGES = Join-Path $isolatedDir "nuget-packages"
New-Item -ItemType Directory -Force -Path $env:APPDATA, $env:DOTNET_CLI_HOME, $env:NUGET_PACKAGES | Out-Null

# Plugins to build: name → project sub-path
$plugins = @(
    @{ Name = "AutoParking";         Project = "AutoParking\AutoParking.csproj";             Config = "AutoParking\NuGet.Config" }
    @{ Name = "OvertakeAssistant";   Project = "OvertakeAssistant\OvertakeAssistant.csproj";     Config = "OvertakeAssistant\NuGet.config" }
    @{ Name = "SequentialAutoShift"; Project = "SequentialAutoShift\SequentialAutoShift.csproj"; Config = "SequentialAutoShift\NuGet.Config" }
    @{ Name = "SpeedLimitUnlocker";  Project = "SpeedLimitUnlocker\SpeedLimitUnlocker.csproj";   Config = "SpeedLimitUnlocker\NuGet.Config" }
)

foreach ($plugin in $plugins) {
    $projPath = Join-Path $RepoRoot $plugin.Project
    $configPath = Join-Path $RepoRoot $plugin.Config
    $name = $plugin.Name

    Write-Host "`n--- Building $name ---" -ForegroundColor Yellow

    # Restore
    Write-Host "Restoring $name..." -ForegroundColor Gray
    dotnet restore $projPath --configfile $configPath
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Restore failed for $name"
        exit 1
    }

    # Build
    Write-Host "Building $name ($Configuration)..." -ForegroundColor Gray
    dotnet build $projPath -c $Configuration --no-restore /p:Ets2laRoot=$Ets2laRoot
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Build failed for $name"
        exit 1
    }

    # Locate output DLL
    # Read csproj to check if AppendTargetFrameworkToOutputPath is explicitly false
    $csprojXml = [xml](Get-Content $projPath)
    $appendTfm = $csprojXml.Project.PropertyGroup.AppendTargetFrameworkToOutputPath
    $tfm = $csprojXml.Project.PropertyGroup.TargetFramework

    if ($appendTfm -ceq "false") {
        $outDir = Join-Path (Join-Path (Split-Path $projPath -Parent) "bin") $Configuration
    } else {
        $outDir = Join-Path (Join-Path (Join-Path (Split-Path $projPath -Parent) "bin") $Configuration) $tfm
    }

    $dllName = "$name.dll"
    $dllPath = Join-Path $outDir $dllName

    if (-not (Test-Path $dllPath)) {
        Write-Error "Output DLL not found at: $dllPath"
        exit 1
    }

    # Copy to Plugins directory
    $targetPath = Join-Path $PluginsDir $dllName
    Write-Host "Copying $dllName → $targetPath" -ForegroundColor Gray
    Copy-Item -Path $dllPath -Destination $targetPath -Force

    Write-Host "$name deployed successfully." -ForegroundColor Green
}

Write-Host "`n=== All plugins built and deployed ===" -ForegroundColor Cyan
