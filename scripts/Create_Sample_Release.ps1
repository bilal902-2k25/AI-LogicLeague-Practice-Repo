# =============================================================================
#  Create_Sample_Release.ps1
#  Creates a sample folder structure and Gen_Release.zip for demo/testing
#  Application : BHEFTS | ITAM/CI ID : 50274
# =============================================================================

param(
    [string]$Version = "v0.9",
    [string]$BaseDir = "C:\Releases"
)

function Write-Banner {
    param([string]$Title)
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
}

function Write-OK   { param([string]$Msg) Write-Host "  [OK] $Msg"  -ForegroundColor Green  }
function Write-Info { param([string]$Msg) Write-Host "  --> $Msg"   -ForegroundColor Yellow }
function Write-Fail { param([string]$Msg) Write-Host "  [FAIL] $Msg" -ForegroundColor Red   }

Write-Banner "Create Sample Release - BHEFTS $Version"

# ── Paths ────────────────────────────────────────────────────────────────────
$ReleaseDir = Join-Path $BaseDir $Version
$ZipPath    = Join-Path $ReleaseDir "Gen_Release.zip"
$TempDir    = Join-Path $ReleaseDir "_contents"

Write-Info "Release directory : $ReleaseDir"
Write-Info "Zip output        : $ZipPath"
Write-Host ""

# ── Create directories ───────────────────────────────────────────────────────
Write-Info "Creating folder structure..."

$Folders = @(
    "$TempDir\bin",
    "$TempDir\config",
    "$TempDir\lib",
    "$TempDir\docs"
)

foreach ($f in $Folders) {
    New-Item -ItemType Directory -Path $f -Force | Out-Null
    Write-OK "Created: $f"
}

# ── Create dummy files ───────────────────────────────────────────────────────
Write-Host ""
Write-Info "Creating sample files..."

$Files = @{
    "$TempDir\bin\BHEFTS.exe"              = "BHEFTS Binary Placeholder - Version $Version"
    "$TempDir\bin\BHEFTS_Service.exe"      = "BHEFTS Service Binary Placeholder - Version $Version"
    "$TempDir\config\app.config"           = "[BHEFTS Config]`nVersion=$Version`nEnvironment=PROD`nVendor=Adroit Technology`nGTS_ID=GTS-0012707"
    "$TempDir\config\release.properties"   = "release.version=$Version`nrelease.date=$(Get-Date -Format 'yyyy-MM-dd')`nrelease.ci_id=50274"
    "$TempDir\lib\bhefts-core.jar"         = "BHEFTS Core Library Placeholder - Version $Version"
    "$TempDir\lib\bhefts-api.jar"          = "BHEFTS API Library Placeholder - Version $Version"
    "$TempDir\docs\RELEASE_NOTES.txt"      = "BHEFTS Release Notes - $Version`n`nChanges in this release:`n- Bug fixes and performance improvements`n- Security patches`n- Vendor: Adroit Technology`n- Date: $(Get-Date -Format 'yyyy-MM-dd')"
    "$TempDir\docs\CHECKSUM.txt"           = "# SHA256 Checksums for BHEFTS $Version`n# Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    "$TempDir\README.txt"                  = "BHEFTS Release Package - $Version`nVendor: Adroit Technology`nGTS ID: GTS-0012707`nITAM/CI ID: 50274`nDate: $(Get-Date -Format 'yyyy-MM-dd')"
}

foreach ($entry in $Files.GetEnumerator()) {
    Set-Content -Path $entry.Key -Value $entry.Value -Encoding UTF8
    Write-OK "Created: $(Split-Path $entry.Key -Leaf)"
}

# ── Create Gen_Release.zip ───────────────────────────────────────────────────
Write-Host ""
Write-Info "Creating Gen_Release.zip..."

if (Test-Path $ZipPath) {
    Remove-Item $ZipPath -Force
    Write-Info "Removed existing Gen_Release.zip"
}

try {
    Compress-Archive -Path "$TempDir\*" -DestinationPath $ZipPath -Force
    Write-OK "Gen_Release.zip created successfully at: $ZipPath"
} catch {
    Write-Fail "Failed to create zip: $_"
    exit 1
}

# ── Clean up temp contents folder ────────────────────────────────────────────
Remove-Item $TempDir -Recurse -Force
Write-Info "Cleaned up temporary folder."

# ── Summary ──────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  Sample Release Created Successfully!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Version    : $Version"                  -ForegroundColor White
Write-Host "  Location   : $ZipPath"                  -ForegroundColor White
Write-Host "  Size       : $((Get-Item $ZipPath).Length) bytes" -ForegroundColor White
Write-Host ""
Write-Host "  Next step — Run the demo simulation:" -ForegroundColor Yellow
Write-Host "  .\BHEFTS_Demo_Simulation.ps1" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Or run the real automation script:" -ForegroundColor Yellow
Write-Host "  .\BHEFTS_Release_Automation.ps1" -ForegroundColor Cyan
Write-Host ""
