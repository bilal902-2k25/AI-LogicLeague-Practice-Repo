# ============================================================
#   Sample Release Creator
#   Application : BHEFTS | ITAM/CI ID : 50274
#   Author      : muhammad.bilal@avanzasolutions.com
#
#   PURPOSE: Creates a sample folder structure and zips it
#            as Gen_Release.zip, ready to be used as input
#            for BHEFTS_Release_Automation.ps1
# ============================================================

param(
    [string]$ReleaseVersion  = "",
    [string]$BaseOutputPath  = "C:\Releases"
)

# ============================================================
#   HELPERS
# ============================================================

function Write-Header {
    param([string]$Title)
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
}

function Write-Step {
    param([string]$Message)
    Write-Host "  --> $Message" -ForegroundColor Yellow
}

function Write-Success {
    param([string]$Message)
    Write-Host "  [OK] $Message" -ForegroundColor Green
}

function Write-Fail {
    param([string]$Message)
    Write-Host "  [FAILED] $Message" -ForegroundColor Red
}

# ============================================================
#   INPUT COLLECTION
# ============================================================

Write-Header "Create Sample Release - BHEFTS"

if (-not $ReleaseVersion) {
    $ReleaseVersion = Read-Host "  Enter release version (e.g. v0.9)"
}

$ReleaseFolderPath = Join-Path $BaseOutputPath $ReleaseVersion
$ZipOutputPath     = Join-Path $ReleaseFolderPath "Gen_Release.zip"
$SourceFolderPath  = Join-Path $ReleaseFolderPath "Gen_Release"

Write-Host ""
Write-Host "  Release folder : $ReleaseFolderPath"  -ForegroundColor Gray
Write-Host "  Source content : $SourceFolderPath"   -ForegroundColor Gray
Write-Host "  Output zip     : $ZipOutputPath"      -ForegroundColor Gray

# ============================================================
#   CREATE FOLDER STRUCTURE
# ============================================================

Write-Header "Creating Folder Structure"

$subFolders = @(
    "bin",
    "config",
    "lib",
    "docs",
    "scripts"
)

try {
    if (Test-Path $SourceFolderPath) {
        Write-Step "Removing existing source folder..."
        Remove-Item $SourceFolderPath -Recurse -Force
    }

    New-Item -ItemType Directory -Path $SourceFolderPath -Force | Out-Null
    Write-Success "Created: $SourceFolderPath"

    foreach ($folder in $subFolders) {
        $fullPath = Join-Path $SourceFolderPath $folder
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
        Write-Success "Created subfolder: $folder"
    }
} catch {
    Write-Fail "Failed to create folder structure: $_"
    exit 1
}

# ============================================================
#   ADD DUMMY FILES
# ============================================================

Write-Header "Adding Dummy Files"

$dummyFiles = @{
    "bin\bhefts_app.exe"          = "[BHEFTS] Application binary - Version $ReleaseVersion`nVendor: Adroit Technology`nGTS ID: GTS-0012707"
    "bin\bhefts_service.exe"      = "[BHEFTS] Service binary - Version $ReleaseVersion"
    "config\app.config"           = "[config]`nversion=$ReleaseVersion`nenv=production`napp_name=BHEFTS`nitam_id=50274"
    "config\database.config"      = "[database]`nhost=db.internal`nport=5432`nname=bhefts_db"
    "lib\bhefts_core.dll"         = "[BHEFTS] Core library - Version $ReleaseVersion"
    "lib\bhefts_utils.dll"        = "[BHEFTS] Utilities library - Version $ReleaseVersion"
    "docs\Release_Notes.txt"      = "BHEFTS Release Notes - $ReleaseVersion`nDate: $(Get-Date -Format 'yyyy-MM-dd')`nVendor: Adroit Technology`nChanges: Initial release package for pipeline deployment."
    "docs\Deployment_Guide.txt"   = "BHEFTS Deployment Guide - $ReleaseVersion`nApplication: BHEFTS`nITAM/CI ID: 50274`nVendor: Adroit Technology`nGTS ID: GTS-0012707"
    "scripts\install.ps1"         = "# BHEFTS Installation Script - $ReleaseVersion`nWrite-Host 'Installing BHEFTS $ReleaseVersion...'"
    "scripts\uninstall.ps1"       = "# BHEFTS Uninstall Script - $ReleaseVersion`nWrite-Host 'Uninstalling BHEFTS...'"
    "README.txt"                  = "BHEFTS Release Package - $ReleaseVersion`nApplication Name : BHEFTS`nITAM/CI ID       : 50274`nVendor           : Adroit Technology`nGTS ID           : GTS-0012707`nProduct Owner    : nemazie, sameer`nPSIDs            : 1618688, 1228108`nBuild Date       : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    "MANIFEST.txt"                = "BHEFTS Package Manifest - $ReleaseVersion`nFiles:`nbin/bhefts_app.exe`nbin/bhefts_service.exe`nconfig/app.config`nconfig/database.config`nlib/bhefts_core.dll`nlib/bhefts_utils.dll"
}

foreach ($entry in $dummyFiles.GetEnumerator()) {
    $filePath = Join-Path $SourceFolderPath $entry.Key
    try {
        $entry.Value | Out-File -FilePath $filePath -Encoding UTF8
        Write-Success "Created: $($entry.Key)"
    } catch {
        Write-Fail "Could not create $($entry.Key): $_"
    }
}

# ============================================================
#   ZIP THE FOLDER
# ============================================================

Write-Header "Creating Gen_Release.zip"

if (Test-Path $ZipOutputPath) {
    Write-Step "Removing existing zip..."
    Remove-Item $ZipOutputPath -Force
}

try {
    Compress-Archive -Path "$SourceFolderPath\*" -DestinationPath $ZipOutputPath -Force
    $zipInfo = Get-Item $ZipOutputPath
    Write-Success "Created: $ZipOutputPath  (Size: $([Math]::Round($zipInfo.Length / 1KB, 2)) KB)"
} catch {
    Write-Fail "Failed to create zip: $_"
    exit 1
}

# ============================================================
#   SUMMARY
# ============================================================

Write-Header "Sample Release Created - Summary"

Write-Host ""
Write-Host "  Release Version : $ReleaseVersion"                -ForegroundColor White
Write-Host "  Release Folder  : $ReleaseFolderPath"             -ForegroundColor White
Write-Host "  Zip File        : $ZipOutputPath"                 -ForegroundColor Cyan
Write-Host ""
Write-Host "  To upload this release, run:" -ForegroundColor Yellow
Write-Host "  .\BHEFTS_Release_Automation.ps1 -ReleaseFolderPath '$ReleaseFolderPath' -ReleaseVersion '$ReleaseVersion'" -ForegroundColor Cyan
Write-Host ""
Write-Success "Sample release package ready!"
Write-Host ""
