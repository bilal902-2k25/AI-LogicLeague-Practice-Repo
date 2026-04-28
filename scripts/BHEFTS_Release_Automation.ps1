# =============================================================================
#  BHEFTS Release Automation Script
#  Application : BHEFTS | ITAM/CI ID : 50274
#  Vendor      : Adroit Technology | GTS ID : GTS-0012707
#  ADO Repo    : 50274-REPO-BHEFTS | Branch : Catalyst/Main
#  Author      : muhammad.bilal@avanzasolutions.com
# =============================================================================

param()

# ── Helpers ──────────────────────────────────────────────────────────────────
function Write-Banner {
    param([string]$Title)
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
}

function Write-OK   { param([string]$Msg) Write-Host "  [OK] $Msg"     -ForegroundColor Green  }
function Write-Fail { param([string]$Msg) Write-Host "  [FAILED] $Msg" -ForegroundColor Red    }
function Write-Info { param([string]$Msg) Write-Host "  --> $Msg"      -ForegroundColor Yellow }
function Write-Warn { param([string]$Msg) Write-Host "  WARNING: $Msg" -ForegroundColor Magenta }

# ── JFrog Config ─────────────────────────────────────────────────────────────
$JFrogURL  = "https://artifactory.global.standardchartered.com/artifactory/restricted-generic-artifactingestion/50274-BHEFTS/package/Gen_Release.zip"
$JFrogUser = "svc-incountry"
$JFrogPass = "vendorbin2upload"

# ── Node Tags ────────────────────────────────────────────────────────────────
$NodeDevQaStaging = "hki4ympy8hl0l00"
$NodeProduction   = "sg5qbxm2eh43z00, hkiqbxm2eh43z00"

# =============================================================================
#  STEP 0 — Input Collection
# =============================================================================
Write-Banner "BHEFTS Release Automation - Input Collection"

$ReleaseFolderPath = Read-Host "  Enter full path to release folder (e.g. C:\Releases\v0.9)"
$ReleaseVersion    = Read-Host "  Enter release version (e.g. v0.9)"
$WorkItemID        = Read-Host "  Enter Release Work Item ID for pipeline"

$ZipPath = Join-Path $ReleaseFolderPath "Gen_Release.zip"

# =============================================================================
#  STEP 1 — Validate Release Zip
# =============================================================================
Write-Banner "STEP 1 - Validating Release Zip"
Write-Info "Checking: $ZipPath"

if (-not (Test-Path $ZipPath)) {
    Write-Fail "Release zip not found at: $ZipPath"
    Write-Host "  Please ensure 'Gen_Release.zip' exists in '$ReleaseFolderPath'" -ForegroundColor Red
    exit 1
}

Write-OK "Found: $ZipPath"

# =============================================================================
#  STEP 2 — JFrog Artifact Upload
# =============================================================================
Write-Banner "STEP 2 - Uploading Artifacts to JFrog"
Write-Info "Uploading Gen_Release.zip to JFrog..."
Write-Info "Destination: $JFrogURL"
Write-Host ""

$CurlOutput = & curl.exe -s -o /dev/null -w "%{http_code}" `
    -u "${JFrogUser}:${JFrogPass}" `
    -T "$ZipPath" `
    "$JFrogURL" 2>&1

$ExitCode = $LASTEXITCODE

if ($ExitCode -ne 0 -or $CurlOutput -notmatch "^2") {
    Write-Fail "Upload failed. Exit code: $ExitCode"
    Write-Host "  Output: $CurlOutput" -ForegroundColor Red
    Write-Host "  Check network/VPN connection and retry." -ForegroundColor Red
    exit 1
}

Write-OK "Artifact uploaded successfully!"
Write-OK "JFrog Path: $JFrogURL"

# =============================================================================
#  STEP 3 — ADO Ticket Preparation
# =============================================================================
Write-Banner "STEP 3 - ADO Artifact Ingestion Ticket"

$DiscussionTable = @"
| Field                    | Value                                                                                      |
|--------------------------|--------------------------------------------------------------------------------------------|
| Application Name         | BHEFTS                                                                                     |
| ITAM/CI ID               | 50274                                                                                      |
| Vendor Name              | Adroit Technology                                                                          |
| GTS ID                   | GTS-0012707                                                                                |
| Product Name             | BHEFTS                                                                                     |
| Product Owner            | nemazie, sameer                                                                            |
| User PSIDs               | 1618688, 1228108                                                                           |
| Release Version          | $ReleaseVersion                                                                            |
| JFrog Artifact Path      | $JFrogURL                                                                                  |
| Upload Date              | $(Get-Date -Format 'yyyy-MM-dd')                                                           |
"@

Set-Clipboard -Value $DiscussionTable
Write-OK "Discussion table copied to clipboard!"
Write-Host ""
Write-Info "ACTION REQUIRED - Manual ADO Steps:"
Write-Host ""
Write-Host "  1. Open ADO and find ticket: 'Artifact Ingestion 10698033'" -ForegroundColor White
Write-Host "  2. Click 'Create copy of work item'" -ForegroundColor White
Write-Host "  3. Update Title to:" -ForegroundColor White
Write-Host "     Artifact Ingestion - Vendor release $ReleaseVersion Upload for Bhefts-50274" -ForegroundColor Yellow
Write-Host "  4. Update Artifacts download link to:" -ForegroundColor White
Write-Host "     $JFrogURL" -ForegroundColor Yellow
Write-Host "  5. Paste clipboard content into Discussion section" -ForegroundColor White
Write-Host "  6. Save the ticket" -ForegroundColor White
Write-Host ""
Write-Host "  [Clipboard already contains the Discussion Table - just CTRL+V]" -ForegroundColor Green
Write-Host ""
Write-Info "Opening ADO in browser..."
Start-Process "https://dev.azure.com"
Write-Host ""
Read-Host "  Press ENTER to continue after completing ADO ticket"

# =============================================================================
#  STEP 4 — Node Tag Reminder
# =============================================================================
Write-Banner "STEP 4 - Pipeline Node Tag Reminder"
Write-Host ""
Write-Host "  Ensure your pipeline YAML has correct node tags:" -ForegroundColor White
Write-Host ""
Write-Host "  Stages: dev, qa, staging, pre-release" -ForegroundColor Cyan
Write-Host "    nodes: '$NodeDevQaStaging'" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Stage: production" -ForegroundColor Cyan
Write-Host "    nodes: '$NodeProduction'" -ForegroundColor Yellow
Write-Host ""
Write-Warn "Wrong node tags will deploy to PRODUCTION unintentionally!"
Write-Host ""
Read-Host "  Confirm node tags are correct, then press ENTER to continue"

# =============================================================================
#  STEP 5 — Waiting for Artifacts Promotion
# =============================================================================
Write-Banner "STEP 5 - Waiting for Artifacts Promotion"
Write-Host ""
Write-Host "  Monitor your ADO ticket status." -ForegroundColor White
Write-Host "  Wait for state to change: Open --> Artifacts Promoted" -ForegroundColor White
Write-Host ""
Read-Host "  Once ticket shows 'Artifacts Promoted', press ENTER to continue"

# =============================================================================
#  STEP 6 — Pipeline Execution Guide
# =============================================================================
Write-Banner "STEP 6 - Pipeline Execution"
Write-Host ""
Write-Host "  Next Steps:" -ForegroundColor White
Write-Host "  1. Create Pull Request: feature branch --> Catalyst/Main" -ForegroundColor White
Write-Host "     ADO Repo: 50274-REPO-BHEFTS" -ForegroundColor Yellow
Write-Host ""
Write-Host "  2. Get PR approved and passed" -ForegroundColor White
Write-Host ""
Write-Host "  3. Run Catalyst/Main pipeline with:" -ForegroundColor White
Write-Host "     Release Work Item ID: $WorkItemID" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Pipeline Stages to Monitor:" -ForegroundColor White
Write-Host "  CI --> Dev --> QA --> Staging --> Pre-release --> Release" -ForegroundColor Cyan

# =============================================================================
#  FINAL SUMMARY
# =============================================================================
Write-Banner "AUTOMATION COMPLETE - Summary"
Write-Host ""
Write-Host ("  Release Version   : " + $ReleaseVersion)      -ForegroundColor White
Write-Host ("  Zip Uploaded      : " + $ZipPath)              -ForegroundColor White
Write-Host ("  JFrog Path        : " + $JFrogURL)             -ForegroundColor White
Write-Host ("  Work Item ID      : " + $WorkItemID)           -ForegroundColor White
Write-Host ""
Write-OK "All automated steps completed. Follow manual steps above to finish."
Write-Host ""
