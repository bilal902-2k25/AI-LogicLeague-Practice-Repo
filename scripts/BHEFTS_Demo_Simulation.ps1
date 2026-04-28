# =============================================================================
#  BHEFTS Release Automation - DEMO SIMULATION (Dry-Run)
#  No real uploads, no real ADO access needed.
#  Safe to run anytime on any Windows PC.
#  Application : BHEFTS | ITAM/CI ID : 50274
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

function Write-OK      { param([string]$Msg) Write-Host "  [OK]     $Msg" -ForegroundColor Green   }
function Write-Fail    { param([string]$Msg) Write-Host "  [FAILED] $Msg" -ForegroundColor Red     }
function Write-Info    { param([string]$Msg) Write-Host "  --> $Msg"      -ForegroundColor Yellow  }
function Write-Demo    { param([string]$Msg) Write-Host "  [DEMO]   $Msg" -ForegroundColor Magenta }
function Write-Warn    { param([string]$Msg) Write-Host "  WARNING: $Msg" -ForegroundColor Magenta }

function Show-ProgressBar {
    param([string]$Label, [int]$DurationMs = 1500)
    Write-Host "  $Label " -NoNewline -ForegroundColor White
    $steps = 20
    for ($i = 1; $i -le $steps; $i++) {
        Write-Host "#" -NoNewline -ForegroundColor Green
        Start-Sleep -Milliseconds ($DurationMs / $steps)
    }
    Write-Host " 100%" -ForegroundColor Green
}

# ── Simulated Config ─────────────────────────────────────────────────────────
$SimJFrogURL       = "https://artifactory.global.standardchartered.com/artifactory/restricted-generic-artifactingestion/50274-BHEFTS/package/Gen_Release.zip"
$NodeDevQaStaging  = "hki4ympy8hl0l00"
$NodeProduction    = "sg5qbxm2eh43z00, hkiqbxm2eh43z00"

$StagesPassed = 0
$TotalStages  = 6

# =============================================================================
#  DEMO HEADER
# =============================================================================
Write-Host ""
Write-Host "############################################################" -ForegroundColor Yellow
Write-Host "  BHEFTS RELEASE AUTOMATION — DEMO SIMULATION MODE"           -ForegroundColor Yellow
Write-Host "  No real uploads. No real ADO. Safe dry-run."                 -ForegroundColor Yellow
Write-Host "############################################################" -ForegroundColor Yellow
Write-Host ""
Write-Demo "This demo simulates all 6 stages including a failure/recovery scenario."
Write-Host ""
Start-Sleep -Milliseconds 800

# =============================================================================
#  STEP 0 — Simulated Input Collection
# =============================================================================
Write-Banner "STEP 0 - Input Collection (SIMULATED)"
Write-Demo "Simulating user input..."
Start-Sleep -Milliseconds 500

$ReleaseFolderPath = "C:\Releases\v0.9"
$ReleaseVersion    = "v0.9"
$WorkItemID        = "12345678"
$ZipPath           = "$ReleaseFolderPath\Gen_Release.zip"

Write-Host ""
Write-Host "  Enter full path to release folder : " -NoNewline -ForegroundColor White
Write-Host $ReleaseFolderPath -ForegroundColor Cyan
Write-Host "  Enter release version             : " -NoNewline -ForegroundColor White
Write-Host $ReleaseVersion    -ForegroundColor Cyan
Write-Host "  Enter Release Work Item ID        : " -NoNewline -ForegroundColor White
Write-Host $WorkItemID        -ForegroundColor Cyan
Write-Host ""
Write-OK "Inputs collected."
$StagesPassed++
Start-Sleep -Milliseconds 600

# =============================================================================
#  STEP 1 — Zip Validation (Simulated)
# =============================================================================
Write-Banner "STEP 1 - Validating Release Zip (SIMULATED)"
Write-Demo "Checking if Gen_Release.zip exists..."
Show-ProgressBar "  Scanning folder"
Write-Host ""
Write-OK "Gen_Release.zip found! (SIMULATED)"
Start-Sleep -Milliseconds 400

# ── Failure scenario demo ────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ─────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "  FAILURE SCENARIO DEMO — What if the zip is MISSING?" -ForegroundColor Red
Write-Host "  ─────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Start-Sleep -Milliseconds 400
Write-Fail "Gen_Release.zip not found at: C:\Releases\v0.9\Gen_Release.zip"
Start-Sleep -Milliseconds 300
Write-Host "  [RECOVERY] Place Gen_Release.zip in C:\Releases\v0.9 and re-run the script." -ForegroundColor Yellow
Write-Host "  ─────────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""
Write-Demo "Failure scenario shown. Continuing with SUCCESS path..."
Start-Sleep -Milliseconds 600

$StagesPassed++

# =============================================================================
#  STEP 2 — JFrog Upload (Simulated)
# =============================================================================
Write-Banner "STEP 2 - Uploading Artifacts to JFrog (SIMULATED)"
Write-Demo "Simulating JFrog upload via curl..."
Write-Info "Destination: $SimJFrogURL"
Write-Host ""
Show-ProgressBar "  Uploading Gen_Release.zip" 2000
Write-Host ""
Write-OK "Upload SUCCESS (SIMULATED - no real upload performed)"
Write-OK "JFrog Path: $SimJFrogURL"
Start-Sleep -Milliseconds 600
$StagesPassed++

# =============================================================================
#  STEP 3 — ADO Ticket Preparation (Simulated)
# =============================================================================
Write-Banner "STEP 3 - ADO Artifact Ingestion Ticket (SIMULATED)"
Write-Demo "Building discussion table..."
Start-Sleep -Milliseconds 400

$SimTable = @"

  | Field               | Value                          |
  |---------------------|--------------------------------|
  | Application Name    | BHEFTS                         |
  | ITAM/CI ID          | 50274                          |
  | Vendor Name         | Adroit Technology              |
  | GTS ID              | GTS-0012707                    |
  | Product Name        | BHEFTS                         |
  | Product Owner       | nemazie, sameer                |
  | User PSIDs          | 1618688, 1228108               |
  | Release Version     | $ReleaseVersion                |
  | JFrog Artifact Path | $SimJFrogURL                   |
  | Upload Date         | $(Get-Date -Format 'yyyy-MM-dd')|
"@

Write-Host $SimTable -ForegroundColor White
Write-Host ""
Write-Demo "Simulating clipboard copy..."
Start-Sleep -Milliseconds 300
Write-OK "Clipboard ready - CTRL+V to paste into ADO ticket (SIMULATED)"
Write-Demo "Would open browser to: https://dev.azure.com (SIMULATED)"
Write-Host ""
Write-Info "In the real script, the browser opens and you paste the table into the Discussion section."
$StagesPassed++
Start-Sleep -Milliseconds 600

# =============================================================================
#  STEP 4 — Node Tag Reminder (Simulated)
# =============================================================================
Write-Banner "STEP 4 - Pipeline Node Tag Reminder (SIMULATED)"
Write-Host ""
Write-Host "  Stages: dev, qa, staging, pre-release" -ForegroundColor Cyan
Write-Host "    nodes: '$NodeDevQaStaging'" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Stage: production" -ForegroundColor Cyan
Write-Host "    nodes: '$NodeProduction'" -ForegroundColor Yellow
Write-Host ""
Write-Warn "Wrong node tags will deploy to PRODUCTION unintentionally!"
Write-Host ""
Write-Demo "Node tag check shown. (SIMULATED — no PAUSE in demo mode)"
$StagesPassed++
Start-Sleep -Milliseconds 600

# =============================================================================
#  STEP 5 — Artifacts Promotion Wait (Simulated)
# =============================================================================
Write-Banner "STEP 5 - Waiting for Artifacts Promotion (SIMULATED)"
Write-Demo "Simulating wait for ADO ticket state change..."
Write-Host ""
Write-Host "  ADO Ticket Status: " -NoNewline -ForegroundColor White
Write-Host "Open" -ForegroundColor Red
Start-Sleep -Milliseconds 800
Write-Host "  ADO Ticket Status: " -NoNewline -ForegroundColor White
Write-Host "In Progress" -ForegroundColor Yellow
Start-Sleep -Milliseconds 800
Write-Host "  ADO Ticket Status: " -NoNewline -ForegroundColor White
Write-Host "Artifacts Promoted" -ForegroundColor Green
Write-Host ""
Write-OK "Ticket state changed to 'Artifacts Promoted' (SIMULATED)"
$StagesPassed++
Start-Sleep -Milliseconds 600

# =============================================================================
#  STEP 6 — Pipeline Execution Guide
# =============================================================================
Write-Banner "STEP 6 - Pipeline Execution Guide"
Write-Host ""
Write-Host "  1. Create Pull Request: feature branch --> Catalyst/Main" -ForegroundColor White
Write-Host "     ADO Repo: 50274-REPO-BHEFTS" -ForegroundColor Yellow
Write-Host ""
Write-Host "  2. Get PR approved and passed" -ForegroundColor White
Write-Host ""
Write-Host "  3. Run Catalyst/Main pipeline with:" -ForegroundColor White
Write-Host "     Release Work Item ID: $WorkItemID" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Pipeline Stages:" -ForegroundColor White
$stages = @("CI","Dev","QA","Staging","Pre-release","Release")
foreach ($s in $stages) {
    Write-Host "    [+] $s" -ForegroundColor Green
    Start-Sleep -Milliseconds 200
}

# =============================================================================
#  DEMO SUMMARY REPORT
# =============================================================================
Write-Banner "DEMO SUMMARY REPORT"
Write-Host ""
Write-Host "  Release Version   : $ReleaseVersion"      -ForegroundColor White
Write-Host "  Zip Path          : $ZipPath"              -ForegroundColor White
Write-Host "  JFrog Destination : $SimJFrogURL"          -ForegroundColor White
Write-Host "  Work Item ID      : $WorkItemID"           -ForegroundColor White
Write-Host ("  Stages Simulated  : " + $StagesPassed + "/" + $TotalStages) -ForegroundColor White
Write-Host ""

if ($StagesPassed -eq $TotalStages) {
    Write-Host "  Status            : " -NoNewline -ForegroundColor White
    Write-Host "ALL PASSED (DEMO MODE)" -ForegroundColor Green
} else {
    Write-Host "  Status            : " -NoNewline -ForegroundColor White
    Write-Host "$StagesPassed/$TotalStages stages passed (DEMO MODE)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "############################################################" -ForegroundColor Yellow
Write-Host "  DEMO COMPLETE — Ready for real run when ADO is configured!" -ForegroundColor Yellow
Write-Host "  Run BHEFTS_Release_Automation.ps1 for the real execution." -ForegroundColor Yellow
Write-Host "############################################################" -ForegroundColor Yellow
Write-Host ""
