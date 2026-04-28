# ============================================================
#   BHEFTS Release Automation Script
#   Application : BHEFTS | ITAM/CI ID : 50274
#   Author      : muhammad.bilal@avanzasolutions.com
#   GitHub      : bilal902-2k25
# ============================================================

# ---- CONFIGURATION (Update $AdoIngestionTicketURL per org) ----
param(
    [string]$ReleaseFolderPath = "",
    [string]$ReleaseVersion    = "",
    [string]$ReleaseWorkItemID = ""
)

$ReleaseZipName     = "Gen_Release.zip"
$JFrogBaseURL       = "https://artifactory.global.standardchartered.com/artifactory/restricted-generic-artifactingestion/50274-BHEFTS/package"
$JFrogUser          = "svc-incountry"
$JFrogPassword      = "vendorbin2upload"
$AdoIngestionTicketURL = "https://dev.azure.com"   # Replace with your ADO org URL

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

function Pause-ForUser {
    param([string]$Prompt = "Press ENTER to continue...")
    Write-Host ""
    Read-Host $Prompt
}

# ============================================================
#   STEP 0 - COLLECT INPUTS IF NOT PROVIDED
# ============================================================

Write-Header "BHEFTS Release Automation - Input Collection"

if (-not $ReleaseFolderPath) {
    $ReleaseFolderPath = Read-Host "  Enter full path to release folder (e.g. C:\Releases\v0.9)"
}

if (-not $ReleaseVersion) {
    $ReleaseVersion = Read-Host "  Enter release version (e.g. v0.9)"
}

if (-not $ReleaseWorkItemID) {
    $ReleaseWorkItemID = Read-Host "  Enter Release Work Item ID for pipeline"
}

$ZipFullPath    = Join-Path $ReleaseFolderPath $ReleaseZipName
$JFrogUploadURL = "$JFrogBaseURL/$ReleaseZipName"

Write-Host ""
Write-Host "  Release Folder : $ReleaseFolderPath"  -ForegroundColor Gray
Write-Host "  Zip File       : $ZipFullPath"         -ForegroundColor Gray
Write-Host "  Version        : $ReleaseVersion"      -ForegroundColor Gray
Write-Host "  Work Item ID   : $ReleaseWorkItemID"   -ForegroundColor Gray

# ============================================================
#   STEP 1 - VALIDATE RELEASE ZIP EXISTS
# ============================================================

Write-Header "STEP 1 - Validating Release Zip"
Write-Step "Checking: $ZipFullPath"

if (-not (Test-Path $ZipFullPath)) {
    Write-Fail "Release zip not found at: $ZipFullPath"
    Write-Host "  Please ensure '$ReleaseZipName' exists in '$ReleaseFolderPath'" -ForegroundColor Red
    Write-Host "  Tip: Run Create_Sample_Release.ps1 to generate a sample zip." -ForegroundColor Yellow
    exit 1
}

$zipInfo = Get-Item $ZipFullPath
Write-Success "Found: $ZipFullPath  (Size: $([Math]::Round($zipInfo.Length / 1KB, 2)) KB)"

# ============================================================
#   STEP 2 - JFROG ARTIFACT UPLOAD
# ============================================================

Write-Header "STEP 2 - Uploading Artifacts to JFrog"
Write-Step "Uploading $ReleaseZipName to JFrog..."
Write-Host "  Destination: $JFrogUploadURL" -ForegroundColor Gray

Push-Location $ReleaseFolderPath

try {
    $curlArgs = @(
        "-sSf",
        "-u", "${JFrogUser}:${JFrogPassword}",
        "-X", "PUT",
        "-T", $ReleaseZipName,
        $JFrogUploadURL
    )

    $result = & curl.exe @curlArgs 2>&1

    if ($LASTEXITCODE -eq 0) {
        Write-Success "Artifact uploaded successfully!"
        Write-Host "  JFrog Path: $JFrogUploadURL" -ForegroundColor Cyan
    } else {
        Write-Fail "Upload failed. Exit code: $LASTEXITCODE"
        Write-Host "  Output: $result" -ForegroundColor Red
        Pop-Location
        exit 1
    }
} catch {
    Write-Fail "curl.exe error: $_"
    Pop-Location
    exit 1
}

Pop-Location

# ============================================================
#   STEP 3 - ADO TICKET - COPY TABLE TO CLIPBOARD
# ============================================================

Write-Header "STEP 3 - ADO Artifact Ingestion Ticket"

$DiscussionTable = @"
required detail provided, please place the folders (Gen_Release.zip) in 'vendor-generic-lab-local' so it can be accessible from the pipeline, thanks.

Application Details        | Value
---------------------------|------------------------------------------
Application Name           | BHEFTS
ITAM/CI ID                 | 50274
Vendor Name                | Adroit Technology
GTS ID                     | GTS-0012707
Product Name               | BHEFTS
Product Owner              | nemazie, sameer
Product download link      | $JFrogUploadURL
Vendor package attestation | -
User(s) PSID (max 2)       | 1618688, 1228108
Reason for artifacts       | Vendor release $ReleaseVersion for pipeline execution. Pipeline will use 'vendor-generic-lab-local'.
"@

$DiscussionTable | Set-Clipboard
Write-Success "Discussion table copied to clipboard!"

Write-Step "ACTION REQUIRED - Manual ADO Steps:"
Write-Host ""
Write-Host "  1. Open ADO and find ticket: 'Artifact Ingestion 10698033'" -ForegroundColor White
Write-Host "  2. Click 'Create copy of work item'" -ForegroundColor White
Write-Host "  3. Update Title to:" -ForegroundColor White
Write-Host "     Artifact Ingestion - Vendor release $ReleaseVersion Upload for Bhefts-50274" -ForegroundColor Cyan
Write-Host "  4. Update Artifacts download link to:" -ForegroundColor White
Write-Host "     $JFrogUploadURL" -ForegroundColor Cyan
Write-Host "  5. Paste clipboard content (CTRL+V) into Discussion section" -ForegroundColor White
Write-Host "  6. Save the ticket and wait for 'Artifacts Promoted' status" -ForegroundColor White
Write-Host ""
Write-Host "  [Clipboard already contains the Discussion Table - just CTRL+V]" -ForegroundColor Green

Write-Step "Opening ADO in browser..."
Start-Process $AdoIngestionTicketURL

Pause-ForUser "Complete ADO ticket steps above, then press ENTER to continue..."

# ============================================================
#   STEP 4 - NODE TAG REMINDER
# ============================================================

Write-Header "STEP 4 - Pipeline Node Tag Verification"

Write-Host ""
Write-Host "  Ensure your pipeline YAML has the correct node tags:" -ForegroundColor White
Write-Host ""
Write-Host "  Stages: dev, qa, staging, pre-release" -ForegroundColor Yellow
Write-Host "    nodes: 'hki4ympy8hl0l00'" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Stage: release / production" -ForegroundColor Yellow
Write-Host "    nodes: 'sg5qbxm2eh43z00, hkiqbxm2eh43z00'" -ForegroundColor Cyan
Write-Host ""
Write-Host "  [WARNING] Wrong node tags will deploy to PRODUCTION unintentionally!" -ForegroundColor Red

Pause-ForUser "Confirm node tags are correct in your pipeline YAML, then press ENTER to continue..."

# ============================================================
#   STEP 5 - WAIT FOR ARTIFACTS PROMOTED STATUS
# ============================================================

Write-Header "STEP 5 - Waiting for Artifacts Promotion"

Write-Host ""
Write-Host "  Monitor your ADO ticket status." -ForegroundColor White
Write-Host "  Wait for state change:  Open  -->  Artifacts Promoted" -ForegroundColor Yellow
Write-Host ""

Pause-ForUser "Once the ticket shows 'Artifacts Promoted', press ENTER to continue..."

# ============================================================
#   STEP 6 - PIPELINE EXECUTION GUIDE
# ============================================================

Write-Header "STEP 6 - Pipeline Execution"

Write-Host ""
Write-Host "  Next Steps:" -ForegroundColor White
Write-Host "  1. Create Pull Request: feature branch --> Catalyst/Main" -ForegroundColor White
Write-Host "     ADO Repo: 50274-REPO-BHEFTS" -ForegroundColor Cyan
Write-Host ""
Write-Host "  2. Get PR approved and pipeline checks passing" -ForegroundColor White
Write-Host ""
Write-Host "  3. Run the Catalyst/Main pipeline with:" -ForegroundColor White
Write-Host "     Release Work Item ID : $ReleaseWorkItemID" -ForegroundColor Cyan
Write-Host "     Pipeline Branch      : Catalyst/Main" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Pipeline Stages to Monitor:" -ForegroundColor White
Write-Host "  CI --> Dev --> QA --> Staging --> Pre-release --> Release" -ForegroundColor Green
Write-Host ""
Write-Host "  Stage Details:" -ForegroundColor White
Write-Host "  [CI]          Build vendor binaries, security checks, record metrics" -ForegroundColor Gray
Write-Host "  [Dev]         deploy_puppet, record deployment, fetch build info" -ForegroundColor Gray
Write-Host "  [QA]          Run tests, generate test summary, DTM approval" -ForegroundColor Gray
Write-Host "  [Staging]     Deployment, security checks, test summary" -ForegroundColor Gray
Write-Host "  [Pre-release] Release checks, work item tab validation" -ForegroundColor Gray
Write-Host "  [Release]     Verify approval, artifact checksum, promote to prod, update RWI" -ForegroundColor Gray

# ============================================================
#   FINAL SUMMARY
# ============================================================

Write-Header "AUTOMATION COMPLETE - Summary"

Write-Host ""
Write-Host "  Release Version   : $ReleaseVersion"       -ForegroundColor White
Write-Host "  Zip Uploaded      : $ZipFullPath"          -ForegroundColor White
Write-Host "  JFrog Path        : $JFrogUploadURL"       -ForegroundColor Cyan
Write-Host "  Work Item ID      : $ReleaseWorkItemID"    -ForegroundColor White
Write-Host "  ADO Repo          : 50274-REPO-BHEFTS"     -ForegroundColor White
Write-Host "  Pipeline Branch   : Catalyst/Main"         -ForegroundColor White
Write-Host ""
Write-Success "All automated steps completed. Follow manual steps in browser to finish."
Write-Host ""
