# ============================================================
#   Create Sample Release Zip
#   Helper script for BHEFTS Release Automation demo
#   Application  : BHEFTS | ITAM/CI ID: 50274
#   Author       : muhammad.bilal@avanzasolutions.com
# ============================================================

# ---- CONFIGURATION ----
$ReleaseVersion    = ""          # e.g. v0.9  (prompted if blank)
$BaseReleasePath   = "C:\Releases"
$ZipName           = "Gen_Release.zip"

# ============================================================
#   HELPER FUNCTIONS
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
    Write-Host ""
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

Write-Header "Create Sample Release Zip - BHEFTS 50274"

if (-not $ReleaseVersion) {
    $ReleaseVersion = Read-Host "  Enter release version (e.g. v0.9)"
}

$ReleaseFolderPath = Join-Path $BaseReleasePath $ReleaseVersion
$ContentFolder     = Join-Path $ReleaseFolderPath "content"
$ZipOutputPath     = Join-Path $ReleaseFolderPath $ZipName

Write-Host ""
Write-Host "  Release Path : $ReleaseFolderPath" -ForegroundColor Gray
Write-Host "  Zip Output   : $ZipOutputPath"     -ForegroundColor Gray

# ============================================================
#   CREATE FOLDER STRUCTURE
# ============================================================

Write-Header "Creating Folder Structure"
Write-Step "Creating directories..."

$dirs = @(
    $ReleaseFolderPath,
    $ContentFolder,
    (Join-Path $ContentFolder "bin"),
    (Join-Path $ContentFolder "config"),
    (Join-Path $ContentFolder "scripts"),
    (Join-Path $ContentFolder "docs")
)

foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  Created: $dir" -ForegroundColor Gray
    } else {
        Write-Host "  Exists : $dir" -ForegroundColor DarkGray
    }
}

Write-Success "Folder structure created."

# ============================================================
#   CREATE DUMMY FILES
# ============================================================

Write-Header "Creating Dummy Release Files"
Write-Step "Generating sample files..."

$files = @{
    "$ContentFolder\bin\bhefts_service.exe"              = "BHEFTS Service Binary v$ReleaseVersion - DUMMY"
    "$ContentFolder\bin\bhefts_agent.dll"                = "BHEFTS Agent Library v$ReleaseVersion - DUMMY"
    "$ContentFolder\config\app.config"                   = @"
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <appSettings>
    <add key="AppName" value="BHEFTS" />
    <add key="Version" value="$ReleaseVersion" />
    <add key="ITAMID"  value="50274" />
    <add key="Vendor"  value="Adroit Technology" />
  </appSettings>
</configuration>
"@
    "$ContentFolder\config\deployment.yml"               = @"
application: BHEFTS
version: $ReleaseVersion
itam_id: 50274
vendor: Adroit Technology
gts_id: GTS-0012707
ado_repo: 50274-REPO-BHEFTS
pipeline_branch: Catalyst/Main
nodes:
  test: hki4ympy8hl0l00
  production:
    - sg5qbxm2eh43z00
    - hkiqbxm2eh43z00
"@
    "$ContentFolder\scripts\install.ps1"                 = "# BHEFTS Install Script v$ReleaseVersion`nWrite-Host 'Installing BHEFTS $ReleaseVersion...'"
    "$ContentFolder\scripts\uninstall.ps1"               = "# BHEFTS Uninstall Script v$ReleaseVersion`nWrite-Host 'Uninstalling BHEFTS...'"
    "$ContentFolder\docs\release_notes.txt"              = @"
BHEFTS Release Notes - $ReleaseVersion
======================================
Date       : $(Get-Date -Format 'yyyy-MM-dd')
Vendor     : Adroit Technology
ITAM/CI ID : 50274
GTS ID     : GTS-0012707

Changes in this release:
- Performance improvements
- Security patches applied
- Bug fixes

Product Owner: nemazie, sameer
"@
    "$ContentFolder\docs\checksums.txt"                  = "SHA256 checksums for BHEFTS $ReleaseVersion - PLACEHOLDER"
    "$ReleaseFolderPath\README.txt"                      = @"
BHEFTS Release Package - $ReleaseVersion
=========================================
Vendor     : Adroit Technology
ITAM/CI ID : 50274
GTS ID     : GTS-0012707
ADO Repo   : 50274-REPO-BHEFTS

Contents:
  bin/      - Application binaries
  config/   - Configuration files
  scripts/  - Install/uninstall scripts
  docs/     - Release notes and checksums

JFrog Upload Destination:
https://artifactory.global.standardchartered.com/artifactory/restricted-generic-artifactingestion/50274-BHEFTS/package/Gen_Release.zip
"@
}

foreach ($filePath in $files.Keys) {
    Set-Content -Path $filePath -Value $files[$filePath] -Encoding UTF8
    Write-Host "  Created: $filePath" -ForegroundColor Gray
}

Write-Success "All dummy files created."

# ============================================================
#   CREATE ZIP
# ============================================================

Write-Header "Creating Gen_Release.zip"
Write-Step "Compressing content folder..."

if (Test-Path $ZipOutputPath) {
    Remove-Item $ZipOutputPath -Force
    Write-Host "  Removed existing zip." -ForegroundColor DarkGray
}

try {
    Compress-Archive -Path "$ContentFolder\*", "$ReleaseFolderPath\README.txt" -DestinationPath $ZipOutputPath -Force
    $zipSize = (Get-Item $ZipOutputPath).Length
    Write-Success "Zip created: $ZipOutputPath ($([math]::Round($zipSize/1KB, 2)) KB)"
} catch {
    Write-Fail "Failed to create zip: $_"
    exit 1
}

# ============================================================
#   SUMMARY
# ============================================================

Write-Header "Sample Release Created - Summary"

Write-Host ""
Write-Host "  Release Version : $ReleaseVersion"    -ForegroundColor White
Write-Host "  Release Folder  : $ReleaseFolderPath" -ForegroundColor White
Write-Host "  Zip File        : $ZipOutputPath"     -ForegroundColor Cyan
Write-Host ""
Write-Host "  Next Step:" -ForegroundColor Yellow
Write-Host "  Run BHEFTS_Release_Automation.ps1 and enter:" -ForegroundColor White
Write-Host "    Release Folder : $ReleaseFolderPath" -ForegroundColor Cyan
Write-Host "    Release Version: $ReleaseVersion"    -ForegroundColor Cyan
Write-Host ""
Write-Host "  [OK] Sample release zip is ready for demo upload!" -ForegroundColor Green
Write-Host ""
