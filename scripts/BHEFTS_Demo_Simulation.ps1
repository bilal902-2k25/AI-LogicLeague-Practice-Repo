# ============================================================
#   BHEFTS Release Automation - DEMO SIMULATION SCRIPT
#   Dry-run: no real uploads, no real ADO access required
#   Application  : BHEFTS | ITAM/CI ID: 50274
#   Author       : muhammad.bilal@avanzasolutions.com
# ============================================================

$ErrorActionPreference = "Continue"

# ---- SIMULATED CONFIG ----
$SimReleaseFolderPath = "C:\Releases\v0.9"
$SimReleaseVersion    = "v0.9"
$SimWorkItemID        = "12345678"
$SimZipName           = "Gen_Release.zip"
$SimZipPath           = Join-Path $SimReleaseFolderPath $SimZipName
$SimJFrogURL          = "https://artifactory.global.standardchartered.com/artifactory/restricted-generic-artifactingestion/50274-BHEFTS/package/Gen_Release.zip"
$TestNodes            = "hki4ympy8hl0l00"
$ProdNodes            = "sg5qbxm2eh43z00, hkiqbxm2eh43z00"

# ---- HELPER FUNCTIONS ----

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

function Write-Info {
    param([string]$Message)
    Write-Host "  [INFO] $Message" -ForegroundColor Magenta
}

function Simulate-Delay {
    param([int]$Seconds = 1)
    Start-Sleep -Seconds $Seconds
}

function Write-MockBanner {
    Write-Host ""
    Write-Host "  *** SIMULATION MODE - No real actions performed ***" -ForegroundColor DarkYellow
    Write-Host ""
}

# ============================================================
#   BANNER
# ============================================================

Clear-Host
Write-Host ""
Write-Host "  ########################################################" -ForegroundColor DarkCyan
Write-Host "  #   BHEFTS RELEASE AUTOMATION - DEMO SIMULATION        #" -ForegroundColor DarkCyan
Write-Host "  #   Application: BHEFTS | ITAM/CI ID: 50274            #" -ForegroundColor DarkCyan
Write-Host "  #   This is a DRY RUN - nothing real will happen        #" -ForegroundColor DarkCyan
Write-Host "  ########################################################" -ForegroundColor DarkCyan
Write-Host ""
Write-Host "  Simulated by : muhammad.bilal@avanzasolutions.com" -ForegroundColor Gray
Write-Host "  Date         : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host ""
Start-Sleep -Seconds 2

# ============================================================
#   SIMULATED STEP 0 - INPUT COLLECTION
# ============================================================

Write-Header "STEP 0 - Input Collection (Simulated)"
Write-MockBanner

Write-Step "Collecting release inputs..."
Simulate-Delay 1

Write-Host "  Release Folder Path : $SimReleaseFolderPath" -ForegroundColor White
Write-Host "  Release Version     : $SimReleaseVersion"    -ForegroundColor White
Write-Host "  Work Item ID        : $SimWorkItemID"        -ForegroundColor White
Write-Host "  Zip Name            : $SimZipName"           -ForegroundColor White

Write-Success "Inputs collected successfully."

# ============================================================
#   SCENARIO A - FAILURE: ZIP NOT FOUND (Mock Failure Demo)
# ============================================================

Write-Header "SCENARIO A - Mock Failure: Zip File Not Found"
Write-MockBanner

Write-Step "Checking for zip at: C:\Releases\v0.9-WRONG\Gen_Release.zip"
Simulate-Delay 1

Write-Fail "Release zip not found at: C:\Releases\v0.9-WRONG\Gen_Release.zip"
Write-Host ""
Write-Host "  [RECOVERY] What you should do:" -ForegroundColor Yellow
Write-Host "    1. Verify the release folder path is correct." -ForegroundColor White
Write-Host "    2. Ensure Gen_Release.zip exists inside the folder." -ForegroundColor White
Write-Host "    3. Run Create_Sample_Release.ps1 to generate a test zip." -ForegroundColor White
Write-Host "    4. Re-run the automation script." -ForegroundColor White
Write-Host ""
Write-Info "Simulating recovery: using correct path '$SimReleaseFolderPath'..."
Simulate-Delay 1

# ============================================================
#   SIMULATED STEP 1 - VALIDATE RELEASE ZIP
# ============================================================

Write-Header "STEP 1 - Validating Release Zip (Simulated)"
Write-MockBanner

Write-Step "Checking: $SimZipPath"
Simulate-Delay 1

Write-Success "Found: $SimZipPath (1,024 KB) [SIMULATED]"

# ============================================================
#   SIMULATED STEP 2 - JFROG UPLOAD (MOCK)
# ============================================================

Write-Header "STEP 2 - JFrog Artifact Upload (Simulated)"
Write-MockBanner

Write-Step "Simulating curl upload command..."
Write-Host ""
Write-Host "  [MOCK COMMAND THAT WOULD RUN]:" -ForegroundColor DarkGray
Write-Host '  curl.exe -sSf -u "svc-incountry:vendorbin2upload" -X PUT -T "Gen_Release.zip" \' -ForegroundColor DarkGray
Write-Host "  $SimJFrogURL" -ForegroundColor DarkGray
Write-Host ""

Write-Info "Simulating upload progress..."
$progress = 0
while ($progress -le 100) {
    Write-Host "`r  Upload: $progress% " -NoNewline -ForegroundColor Green
    $progress += 20
    Start-Sleep -Milliseconds 300
}
Write-Host ""

Write-Success "Artifact uploaded successfully! [SIMULATED]"
Write-Host "  JFrog Path: $SimJFrogURL" -ForegroundColor Cyan

# SCENARIO B - Simulated Upload Failure
Write-Host ""
Write-Host "  [SCENARIO B - Simulated Upload Failure]:" -ForegroundColor DarkYellow
Write-Host ""
Write-Step "Simulating a failed upload (e.g. network/VPN issue)..."
Simulate-Delay 1
Write-Fail "Upload failed. curl exit code: 6 (Could not resolve host)"
Write-Host "  Output: curl: (6) Could not resolve host: artifactory.global.standardchartered.com" -ForegroundColor Red
Write-Host ""
Write-Host "  [RECOVERY STEPS]:" -ForegroundColor Yellow
Write-Host "    1. Ensure you are connected to the corporate VPN." -ForegroundColor White
Write-Host "    2. Verify curl.exe is installed: 'curl.exe --version'" -ForegroundColor White
Write-Host "    3. Check credentials: svc-incountry / vendorbin2upload" -ForegroundColor White
Write-Host "    4. Re-run the script after fixing the issue." -ForegroundColor White
Write-Host ""
Write-Info "Simulating successful retry after VPN fix..."
Simulate-Delay 1
Write-Success "Upload retry succeeded! [SIMULATED]"

# ============================================================
#   SIMULATED STEP 3 - ADO TICKET PREPARATION
# ============================================================

Write-Header "STEP 3 - ADO Artifact Ingestion Ticket (Simulated)"
Write-MockBanner

Write-Step "Generating discussion table content..."
Simulate-Delay 1

$DiscussionTable = @"
required detail provided, please place the folders (Gen_Release.zip) in 'vendor-generic-lab-local' so it can be accessible from the pipeline, thanks.

Application Details    | Value
-----------------------|------------------------------------------
Application Name       | BHEFTS
ITAM/CI ID             | 50274
Vendor Name            | Adroit Technology
GTS ID                 | GTS-0012707
Product Name           | BHEFTS
Product Owner          | nemazie, sameer
Product download link  | $SimJFrogURL
Vendor pkg attestation | -
User PSIDs (max 2)     | 1618688, 1228108
Reason                 | Vendor release $SimReleaseVersion for pipeline execution. Pipeline will use 'vendor-generic-lab-local'.
"@

Write-Host ""
Write-Host "  [SIMULATED CLIPBOARD CONTENT]:" -ForegroundColor DarkYellow
Write-Host $DiscussionTable -ForegroundColor Gray

Write-Success "Discussion table would be copied to clipboard. [SIMULATED]"
Write-Info "In real run: Set-Clipboard copies table. Browser opens ADO URL."
Write-Host ""
Write-Host "  ADO Manual Steps (real run would guide you through these):" -ForegroundColor White
Write-Host "    1. Find ticket: 'Artifact Ingestion 10698033'" -ForegroundColor Gray
Write-Host "    2. Click 'Create copy of work item'" -ForegroundColor Gray
Write-Host "    3. Update Title: Artifact Ingestion - Vendor release $SimReleaseVersion Upload for Bhefts-50274" -ForegroundColor Gray
Write-Host "    4. Paste clipboard into Discussion section" -ForegroundColor Gray
Write-Host "    5. Save the ticket" -ForegroundColor Gray
Write-Host ""
Write-Info "PAUSE point skipped in simulation (real script waits for user ENTER)."

# ============================================================
#   SIMULATED STEP 4 - NODE TAG REMINDER
# ============================================================

Write-Header "STEP 4 - Pipeline Node Tag Reminder (Simulated)"
Write-MockBanner

Write-Host ""
Write-Host "  Pipeline YAML node tag configuration:" -ForegroundColor White
Write-Host ""
Write-Host "  Stages : dev, qa, staging, pre-release" -ForegroundColor Yellow
Write-Host "    nodes: '$TestNodes'" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Stage  : production / release" -ForegroundColor Yellow
Write-Host "    nodes: '$ProdNodes'" -ForegroundColor Cyan
Write-Host ""
Write-Host "  WARNING: Wrong node tags deploy to PRODUCTION unintentionally!" -ForegroundColor Red
Write-Host ""
Write-Info "PAUSE point skipped in simulation (real script waits for user confirmation)."

# ============================================================
#   SIMULATED STEP 5 - ARTIFACTS PROMOTION STATUS
# ============================================================

Write-Header "STEP 5 - Artifacts Promotion Status (Simulated)"
Write-MockBanner

Write-Step "Simulating ADO ticket status monitoring..."
Simulate-Delay 1
Write-Host "  [t=0s]  ADO Ticket Status: Open"            -ForegroundColor Gray
Start-Sleep -Milliseconds 500
Write-Host "  [t=5s]  ADO Ticket Status: In Review"       -ForegroundColor Yellow
Start-Sleep -Milliseconds 500
Write-Host "  [t=15s] ADO Ticket Status: Artifacts Promoted" -ForegroundColor Green

Write-Success "Ticket is now 'Artifacts Promoted'. Proceeding to pipeline. [SIMULATED]"

# ============================================================
#   SIMULATED STEP 6 - PIPELINE EXECUTION GUIDE
# ============================================================

Write-Header "STEP 6 - Pipeline Execution (Simulated)"
Write-MockBanner

Write-Step "Simulating pipeline execution flow..."
Simulate-Delay 1

$stages = @(
    @{ Name = "CI Stage";          Tasks = @("Build vendor binaries", "Security checks", "Record build metrics") },
    @{ Name = "Dev Stage";         Tasks = @("deploy_puppet", "Record deployment", "Fetch build info", "Record build metrics") },
    @{ Name = "QA Stage";          Tasks = @("Run tests", "Generate test summary", "DTM approval gate") },
    @{ Name = "Staging Stage";     Tasks = @("Deployment", "Security checks", "Test summary") },
    @{ Name = "Pre-release Stage"; Tasks = @("Release checks", "Work item tab validation") },
    @{ Name = "Release Stage";     Tasks = @("Verify release approval", "Artifact checksum", "Promote to production", "Update RWI") }
)

foreach ($stage in $stages) {
    Write-Host ""
    Write-Host "  [$($stage.Name)]" -ForegroundColor Magenta
    foreach ($task in $stage.Tasks) {
        Start-Sleep -Milliseconds 400
        Write-Host "    [PASS] $task" -ForegroundColor Green
    }
}

# ============================================================
#   SIMULATED FINAL SUMMARY
# ============================================================

Write-Header "DEMO SIMULATION COMPLETE - Summary"
Write-MockBanner

Write-Host ""
Write-Host "  Release Version   : $SimReleaseVersion"  -ForegroundColor White
Write-Host "  Zip Path          : $SimZipPath"         -ForegroundColor White
Write-Host "  JFrog Path        : $SimJFrogURL"        -ForegroundColor Cyan
Write-Host "  Work Item ID      : $SimWorkItemID"      -ForegroundColor White
Write-Host ""
Write-Host "  Scenarios Demonstrated:" -ForegroundColor White
Write-Host "  [OK] Input collection" -ForegroundColor Green
Write-Host "  [OK] Zip validation (pass + fail recovery)" -ForegroundColor Green
Write-Host "  [OK] JFrog upload mock (pass + fail recovery)" -ForegroundColor Green
Write-Host "  [OK] ADO ticket table generation" -ForegroundColor Green
Write-Host "  [OK] Node tag reminder" -ForegroundColor Green
Write-Host "  [OK] Artifacts promotion status simulation" -ForegroundColor Green
Write-Host "  [OK] Full pipeline stage walkthrough" -ForegroundColor Green
Write-Host ""
Write-Host "  To run the REAL script: .\BHEFTS_Release_Automation.ps1" -ForegroundColor Yellow
Write-Host ""
Write-Success "Simulation complete. The real script performs all the same steps for real."
Write-Host ""
