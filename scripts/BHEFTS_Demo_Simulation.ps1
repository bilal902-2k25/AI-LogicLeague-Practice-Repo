# ============================================================
#   BHEFTS Demo Simulation Script  (DRY-RUN — No real uploads)
#   Application : BHEFTS | ITAM/CI ID : 50274
#   Author      : muhammad.bilal@avanzasolutions.com
#   GitHub      : bilal902-2k25
#
#   PURPOSE: Fully simulated walk-through of the release
#            automation process. No JFrog upload is performed.
#            No ADO access is required.
# ============================================================

param(
    [string]$ReleaseVersion    = "v0.9-demo",
    [string]$ReleaseWorkItemID = "99999999",
    [string]$ReleaseFolderPath = "C:\Releases\v0.9-demo"
)

$ReleaseZipName     = "Gen_Release.zip"
$JFrogBaseURL       = "https://artifactory.global.standardchartered.com/artifactory/restricted-generic-artifactingestion/50274-BHEFTS/package"
$JFrogUser          = if ($Env:JFROG_USER) { $Env:JFROG_USER } else { "svc-incountry" }
$JFrogUploadURL     = "$JFrogBaseURL/$ReleaseZipName"
$ZipFullPath        = Join-Path $ReleaseFolderPath $ReleaseZipName

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

function Write-Info {
    param([string]$Message)
    Write-Host "  [INFO] $Message" -ForegroundColor Magenta
}

function Write-Mock {
    param([string]$Message)
    Write-Host "  [MOCK] $Message" -ForegroundColor DarkYellow
}

function Simulate-Delay {
    param([int]$Milliseconds = 800)
    Start-Sleep -Milliseconds $Milliseconds
}

# ============================================================
#   BANNER
# ============================================================

Write-Host ""
Write-Host "************************************************************" -ForegroundColor Magenta
Write-Host "*   BHEFTS Release Automation - DEMO / DRY-RUN MODE        *" -ForegroundColor Magenta
Write-Host "*   No actual uploads or ADO changes will be made           *" -ForegroundColor Magenta
Write-Host "*   All outputs are SIMULATED                               *" -ForegroundColor Magenta
Write-Host "************************************************************" -ForegroundColor Magenta
Write-Host ""
Write-Host "  Demo User    : muhammad.bilal@avanzasolutions.com" -ForegroundColor Gray
Write-Host "  Application  : BHEFTS  |  ITAM/CI: 50274" -ForegroundColor Gray
Write-Host "  Version      : $ReleaseVersion" -ForegroundColor Gray
Write-Host "  Work Item ID : $ReleaseWorkItemID" -ForegroundColor Gray

Simulate-Delay 1200

# ============================================================
#   STEP 0 - INPUT COLLECTION (SIMULATED)
# ============================================================

Write-Header "STEP 0 - Input Collection (Simulated)"
Write-Mock "Using demo values — no user input required"
Write-Host ""
Write-Host "  Release Folder : $ReleaseFolderPath"  -ForegroundColor Gray
Write-Host "  Zip File       : $ZipFullPath"         -ForegroundColor Gray
Write-Host "  Version        : $ReleaseVersion"      -ForegroundColor Gray
Write-Host "  Work Item ID   : $ReleaseWorkItemID"   -ForegroundColor Gray
Simulate-Delay

# ============================================================
#   STEP 1a - FAILURE SCENARIO: ZIP NOT FOUND
# ============================================================

Write-Header "STEP 1 - Validating Release Zip  [Scenario A: File Missing]"
Write-Step "Checking: $ZipFullPath"
Simulate-Delay 600

Write-Fail "Release zip not found at: $ZipFullPath"
Write-Host "  This is what happens if the file does not exist." -ForegroundColor DarkRed
Write-Host ""
Write-Info "RECOVERY: Script would stop here. User must ensure Gen_Release.zip exists."
Write-Host "  Tip: Run Create_Sample_Release.ps1 to generate a sample zip." -ForegroundColor Yellow
Simulate-Delay 1500

# ============================================================
#   STEP 1b - SUCCESS SCENARIO: ZIP FOUND (MOCK FILE)
# ============================================================

Write-Header "STEP 1 - Validating Release Zip  [Scenario B: File Found]"
Write-Mock "Simulating file presence — no actual file is checked"
Write-Step "Checking: $ZipFullPath"
Simulate-Delay 600

Write-Success "Found: $ZipFullPath  (Size: 4.20 KB  [mock])"

# ============================================================
#   STEP 2 - JFROG UPLOAD (MOCKED)
# ============================================================

Write-Header "STEP 2 - Uploading Artifacts to JFrog  [MOCKED]"
Write-Mock "curl.exe call is SIMULATED — no real upload occurs"
Write-Step "Uploading $ReleaseZipName to JFrog..."
Write-Host "  Destination: $JFrogUploadURL" -ForegroundColor Gray
Write-Host "  User       : $JFrogUser" -ForegroundColor Gray
Write-Host ""
Write-Host "  [MOCK CMD] curl.exe -sSf -u `"${JFrogUser}:***`" -X PUT -T `"$ReleaseZipName`" $JFrogUploadURL" -ForegroundColor DarkGray

Simulate-Delay 2000

Write-Host ""
Write-Host "  {" -ForegroundColor DarkGray
Write-Host '    "repo"        : "restricted-generic-artifactingestion",' -ForegroundColor DarkGray
Write-Host '    "path"        : "50274-BHEFTS/package/Gen_Release.zip",' -ForegroundColor DarkGray
Write-Host '    "created"     : "2026-04-28T12:30:00.000Z",' -ForegroundColor DarkGray
Write-Host '    "size"        : "4301",' -ForegroundColor DarkGray
Write-Host '    "mimeType"    : "application/zip",' -ForegroundColor DarkGray
Write-Host '    "uri"         : "' + $JFrogUploadURL + '"' -ForegroundColor DarkGray
Write-Host "  }" -ForegroundColor DarkGray
Write-Host ""

Write-Success "Artifact uploaded successfully!  [MOCK — Exit Code: 0]"
Write-Host "  JFrog Path: $JFrogUploadURL" -ForegroundColor Cyan

Simulate-Delay 1000

# ============================================================
#   STEP 2 - FAILURE SCENARIO: UPLOAD FAILS
# ============================================================

Write-Header "STEP 2 - JFrog Upload Failure Scenario  [SIMULATED]"
Write-Mock "Demonstrating what happens when curl returns a non-zero exit code"
Write-Step "Simulating network/auth failure..."
Simulate-Delay 1200

Write-Fail "Upload failed. Exit code: 6"
Write-Host "  Output: curl: (6) Could not resolve host: artifactory.global.standardchartered.com" -ForegroundColor Red
Write-Host ""
Write-Info "RECOVERY OPTIONS:"
Write-Host "  1. Check VPN connection — corporate network required" -ForegroundColor Yellow
Write-Host "  2. Verify credentials: user=$JFrogUser" -ForegroundColor Yellow
Write-Host "  3. Verify the JFrog URL is reachable" -ForegroundColor Yellow
Write-Host "  4. Re-run the script once network is restored" -ForegroundColor Yellow
Write-Host ""
Write-Mock "Continuing demo with assumed success..."
Simulate-Delay 1200

# ============================================================
#   STEP 3 - ADO TICKET (SIMULATED)
# ============================================================

Write-Header "STEP 3 - ADO Artifact Ingestion Ticket  [SIMULATED]"
Write-Mock "No real clipboard or browser interaction"

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

Write-Host ""
Write-Host "  --- CLIPBOARD CONTENT WOULD BE: ---" -ForegroundColor DarkYellow
Write-Host $DiscussionTable -ForegroundColor Gray
Write-Host "  --- END CLIPBOARD CONTENT ---" -ForegroundColor DarkYellow

Write-Success "Discussion table would be copied to clipboard"
Simulate-Delay 800

Write-Host ""
Write-Host "  Manual steps the user would perform:" -ForegroundColor White
Write-Host "  1. Open ADO ticket 'Artifact Ingestion 10698033'" -ForegroundColor Gray
Write-Host "  2. Click 'Create copy of work item'" -ForegroundColor Gray
Write-Host "  3. Update title: Artifact Ingestion - Vendor release $ReleaseVersion Upload for Bhefts-50274" -ForegroundColor Gray
Write-Host "  4. Paste table into Discussion section" -ForegroundColor Gray
Write-Host "  5. Save ticket" -ForegroundColor Gray
Write-Host ""
Write-Mock "Browser would open: https://dev.azure.com"
Simulate-Delay 1000

Write-Info "PAUSE POINT: In real script, execution waits here for user to confirm ADO ticket is complete."
Simulate-Delay 800

# ============================================================
#   STEP 4 - NODE TAG REMINDER (SIMULATED)
# ============================================================

Write-Header "STEP 4 - Pipeline Node Tag Verification  [SIMULATED]"

Write-Host ""
Write-Host "  Pipeline YAML Node Tags:" -ForegroundColor White
Write-Host ""
Write-Host "  Stage              | Node Tag" -ForegroundColor White
Write-Host "  -------------------|-----------------------------" -ForegroundColor Gray
Write-Host "  dev                | hki4ympy8hl0l00" -ForegroundColor Cyan
Write-Host "  qa                 | hki4ympy8hl0l00" -ForegroundColor Cyan
Write-Host "  staging            | hki4ympy8hl0l00" -ForegroundColor Cyan
Write-Host "  pre-release        | hki4ympy8hl0l00" -ForegroundColor Cyan
Write-Host "  release/production | sg5qbxm2eh43z00, hkiqbxm2eh43z00" -ForegroundColor Red
Write-Host ""
Write-Host "  [WARNING] Wrong node tags will deploy to PRODUCTION unintentionally!" -ForegroundColor Red

Write-Info "PAUSE POINT: In real script, user must confirm node tags before proceeding."
Simulate-Delay 1200

# ============================================================
#   STEP 5 - ARTIFACTS PROMOTED WAIT (SIMULATED)
# ============================================================

Write-Header "STEP 5 - Waiting for Artifacts Promotion  [SIMULATED]"

Write-Mock "Simulating ADO ticket status change: Open --> Artifacts Promoted"
Write-Host ""
Write-Host "  [00s] ADO Ticket Status: Open" -ForegroundColor Yellow
Simulate-Delay 800
Write-Host "  [03s] ADO Ticket Status: In Review..." -ForegroundColor Yellow
Simulate-Delay 800
Write-Host "  [07s] ADO Ticket Status: Artifacts Promoted" -ForegroundColor Green
Write-Host ""
Write-Success "Artifacts Promoted!  (In real workflow this can take hours/days)"
Simulate-Delay 1000

# ============================================================
#   STEP 6 - PIPELINE EXECUTION GUIDE (SIMULATED)
# ============================================================

Write-Header "STEP 6 - Pipeline Execution  [SIMULATED]"

Write-Host ""
Write-Host "  Actions in real workflow:" -ForegroundColor White
Write-Host "  1. Create PR: feature branch --> Catalyst/Main" -ForegroundColor Gray
Write-Host "     ADO Repo: 50274-REPO-BHEFTS" -ForegroundColor Cyan
Write-Host "  2. PR approved and pipeline checks pass" -ForegroundColor Gray
Write-Host "  3. Run Catalyst/Main pipeline with Work Item ID: $ReleaseWorkItemID" -ForegroundColor Gray
Write-Host ""

$stages = @(
    @{ Name = "CI Stage";         Status = "PASS"; Node = "N/A";             Tasks = "Build vendor binaries, security checks, record metrics" }
    @{ Name = "Dev Stage";        Status = "PASS"; Node = "hki4ympy8hl0l00"; Tasks = "deploy_puppet, record deployment, fetch build info" }
    @{ Name = "QA Stage";         Status = "PASS"; Node = "hki4ympy8hl0l00"; Tasks = "Run tests, generate test summary, DTM approval" }
    @{ Name = "Staging Stage";    Status = "PASS"; Node = "hki4ympy8hl0l00"; Tasks = "Deployment, security checks, test summary" }
    @{ Name = "Pre-release Stage";Status = "PASS"; Node = "hki4ympy8hl0l00"; Tasks = "Release checks, work item tab validation" }
    @{ Name = "Release Stage";    Status = "PASS"; Node = "sg5qbxm2eh43z00"; Tasks = "Verify approval, checksum, promote to prod, update RWI" }
)

Write-Host "  Simulating pipeline run..." -ForegroundColor White
Write-Host ""

foreach ($stage in $stages) {
    Write-Host "  Running: $($stage.Name)" -ForegroundColor Yellow
    Write-Host "    Node   : $($stage.Node)" -ForegroundColor Gray
    Write-Host "    Tasks  : $($stage.Tasks)" -ForegroundColor Gray
    Simulate-Delay 700
    Write-Host "    Result : [$($stage.Status)]" -ForegroundColor Green
    Write-Host ""
}

# ============================================================
#   FINAL SUMMARY
# ============================================================

Write-Header "DEMO COMPLETE - Summary"

Write-Host ""
Write-Host "  Release Version   : $ReleaseVersion"       -ForegroundColor White
Write-Host "  Zip (mock)        : $ZipFullPath"          -ForegroundColor White
Write-Host "  JFrog Path (mock) : $JFrogUploadURL"       -ForegroundColor Cyan
Write-Host "  Work Item ID      : $ReleaseWorkItemID"    -ForegroundColor White
Write-Host "  ADO Repo          : 50274-REPO-BHEFTS"     -ForegroundColor White
Write-Host "  Pipeline Branch   : Catalyst/Main"         -ForegroundColor White
Write-Host ""
Write-Success "Demo run complete — all steps simulated successfully!"
Write-Host ""
Write-Host "  To run the REAL automation script use:" -ForegroundColor Yellow
Write-Host "  .\BHEFTS_Release_Automation.ps1" -ForegroundColor Cyan
Write-Host ""
