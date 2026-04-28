# BHEFTS Release Automation — Azure DevOps Demo Environment

**Application:** BHEFTS | **ITAM/CI ID:** 50274 | **Vendor:** Adroit Technology | **GTS ID:** GTS-0012707

> Demo environment for `muhammad.bilal@avanzasolutions.com` | GitHub: [bilal902-2k25](https://github.com/bilal902-2k25)

---

## 📦 Repository Structure

```
.
├── scripts/
│   ├── BHEFTS_Release_Automation.ps1    # Real automation script
│   ├── BHEFTS_Demo_Simulation.ps1       # Dry-run demo (no real access needed)
│   └── Create_Sample_Release.ps1        # Creates sample Gen_Release.zip
├── pipelines/
│   └── bhefts-release-pipeline.yml      # Azure DevOps pipeline YAML
├── templates/
│   └── ADO_Ingestion_Ticket_Template.md # ADO work item template
└── README.md
```

---

## 🚀 Quick Start (Demo — No ADO account needed)

```powershell
# Step 1 — Clone the repo
git clone https://github.com/bilal902-2k25/AI-LogicLeague-Practice-Repo.git
cd AI-LogicLeague-Practice-Repo

# Step 2 — Create a sample release zip
.\scripts\Create_Sample_Release.ps1

# Step 3 — Run the DEMO simulation (fully offline, safe dry-run)
.\scripts\BHEFTS_Demo_Simulation.ps1
```

---

## 📋 Script Reference

### 1. `Create_Sample_Release.ps1` — Sample Zip Creator

Creates a dummy release folder and `Gen_Release.zip` for testing.

```powershell
# Default version v0.9 at C:\Releases\v0.9
.\scripts\Create_Sample_Release.ps1

# Custom version
.\scripts\Create_Sample_Release.ps1 -Version "v1.0" -BaseDir "D:\MyReleases"
```

**Creates:**
```
C:\Releases\v0.9\
└── Gen_Release.zip
      ├── bin\BHEFTS.exe
      ├── bin\BHEFTS_Service.exe
      ├── config\app.config
      ├── config\release.properties
      ├── lib\bhefts-core.jar
      ├── lib\bhefts-api.jar
      ├── docs\RELEASE_NOTES.txt
      ├── docs\CHECKSUM.txt
      └── README.txt
```

---

### 2. `BHEFTS_Demo_Simulation.ps1` — Demo Dry-Run

Simulates the full release automation process without any real uploads or ADO access.

```powershell
.\scripts\BHEFTS_Demo_Simulation.ps1
```

**What it does:**
- ✅ Simulates all 6 stages with colored output
- ✅ Shows a mock failure/recovery scenario (zip not found)
- ✅ Displays progress bars for upload simulation
- ✅ Prints a final summary report
- ❌ Does NOT upload to JFrog
- ❌ Does NOT require ADO access
- ❌ Does NOT open any browser

---

### 3. `BHEFTS_Release_Automation.ps1` — Real Automation Script

The production automation script. Requires network access to JFrog and an ADO account.

```powershell
.\scripts\BHEFTS_Release_Automation.ps1
```

**What it does (step by step):**

| Step | Description | Automated? |
|------|-------------|------------|
| 0 | Collect inputs (path, version, work item ID) | ✅ Interactive |
| 1 | Validate `Gen_Release.zip` exists | ✅ Auto |
| 2 | Upload zip to JFrog via `curl.exe` | ✅ Auto |
| 3 | Copy ADO discussion table to clipboard + open browser | ✅ Auto |
| 4 | Show node tag reminder (PAUSE for confirmation) | ⏸️ Manual confirm |
| 5 | Wait for ADO ticket "Artifacts Promoted" status | ⏸️ Manual confirm |
| 6 | Show pipeline execution guide | ✅ Auto |

**Prerequisites:**
- Windows PowerShell 5.1+
- `curl.exe` installed (included with Windows 10+)
- Network access / VPN to JFrog
- ADO account at [dev.azure.com](https://dev.azure.com)

---

## 🔄 Step-by-Step Demo Walkthrough

### Full End-to-End Flow

```
Run Script
    │
    ▼
[INPUT] Enter Path, Version, Work Item ID
    │
    ▼
[STEP 1] Validate Gen_Release.zip ──❌──► STOP (File Missing — place zip and retry)
    │ ✅
    ▼
[STEP 2] Upload to JFrog via curl ──❌──► STOP (Check VPN/network)
    │ ✅
    ▼
[STEP 3] Copy Table to Clipboard + Open ADO Browser
    │ ⏸️ PAUSE (Create ADO Ticket manually)
    ▼
[STEP 4] Show Node Tag Warning
    │ ⏸️ PAUSE (Confirm pipeline YAML is correct)
    ▼
[STEP 5] Wait for "Artifacts Promoted"
    │ ⏸️ PAUSE (Monitor ADO Ticket status)
    ▼
[STEP 6] Show Pipeline Execution Guide
    │
    ▼
[SUMMARY] Print all details
    │
    ▼
   DONE ✅
```

---

## 🏗️ Azure DevOps Pipeline Stages

Pipeline file: `pipelines/bhefts-release-pipeline.yml`

| Stage | Description | Node Tag |
|-------|-------------|----------|
| **CI** | Build vendor binaries, security checks, record build metrics | `hki4ympy8hl0l00` |
| **Dev** | deploy_puppet, record deployment, fetch build info, record metrics | `hki4ympy8hl0l00` |
| **QA** | Run tests, generate test summary, DTM approval gate | `hki4ympy8hl0l00` |
| **Staging** | Deployment, security checks, test summary | `hki4ympy8hl0l00` |
| **Pre-release** | Release checks, work item tab validation, sign-off gate | `hki4ympy8hl0l00` |
| **Release** | Verify approval, artifact checksum, promote to production, update RWI | `sg5qbxm2eh43z00`, `hkiqbxm2eh43z00` |

### Pipeline Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `ReleaseWorkItemID` | ADO work item ID | `12345678` |
| `ReleaseVersion` | Release version string | `v0.9` |
| `ArtifactPath` | Full JFrog artifact URL | `https://artifactory.global.../Gen_Release.zip` |

---

## 🔖 Node Tag Configuration

> ⚠️ **CRITICAL:** Wrong node tags can cause unintended production deployments!

| Stage | Node Tag |
|-------|----------|
| Dev / QA / Staging / Pre-release | `hki4ympy8hl0l00` |
| Production / Release | `sg5qbxm2eh43z00` |
| Production / Release (secondary) | `hkiqbxm2eh43z00` |

---

## 🆓 ADO Free Account Setup

You can set up a **free** Azure DevOps account (no credit card required):

1. Go to 👉 [https://dev.azure.com](https://dev.azure.com)
2. Click **"Start free"**
3. Sign in with: `muhammad.bilal@avanzasolutions.com`
   - If no Microsoft account exists → create one free at [https://signup.live.com](https://signup.live.com)
4. Create Organization: `BHEFTS-DemoOrg`
5. Create Project: `BHEFTS-Demo`
6. Import `pipelines/bhefts-release-pipeline.yml`
7. ✅ Done — takes less than 5 minutes!

**Free tier includes:**
- Boards (Work Items, Backlogs, Sprints)
- Repos (Git)
- Pipelines (1,800 free minutes/month)
- Artifacts (2 GB free)

---

## 🎫 ADO Work Item Template

Template file: `templates/ADO_Ingestion_Ticket_Template.md`

**Usage:**
1. Open `templates/ADO_Ingestion_Ticket_Template.md`
2. Replace the placeholders:
   - `{{RELEASE_VERSION}}` → e.g. `v0.9`
   - `{{JFROG_PATH}}` → full JFrog URL
   - `{{DATE}}` → today's date (YYYY-MM-DD)
3. Follow the step-by-step instructions in the template

---

## 🔧 Troubleshooting

### ❌ `curl.exe not found`
```powershell
# Check if curl is available
curl.exe --version

# If not found, use Windows PowerShell alternative
Invoke-WebRequest -Uri $JFrogURL -Method PUT -InFile $ZipPath -Credential (Get-Credential)
```

### ❌ `Gen_Release.zip not found`
```powershell
# Run the zip creator first
.\scripts\Create_Sample_Release.ps1 -Version "v0.9"

# Then verify
Test-Path "C:\Releases\v0.9\Gen_Release.zip"
```

### ❌ `JFrog upload failed` (network error)
- Ensure you are connected to the correct VPN
- Verify credentials: user `svc-incountry`
- Check the JFrog URL is accessible from your network

### ❌ `Set-Clipboard not available`
```powershell
# If Set-Clipboard is not available (older PowerShell), use:
$DiscussionTable | clip
```

### ❌ Pipeline stuck at approval gate
- Check that the approver (`muhammad.bilal@avanzasolutions.com`) has received the notification email
- Navigate to the pipeline run in ADO → Approve manually

### ❌ Wrong environment deployed
- Verify node tags in `pipelines/bhefts-release-pipeline.yml`
- Dev/QA/Staging/Pre-release must use: `hki4ympy8hl0l00`
- Production must use: `sg5qbxm2eh43z00`, `hkiqbxm2eh43z00`

---

## ⏱️ Time Savings

| Task | Without Script | With Script |
|------|---------------|-------------|
| JFrog Upload | ~5 min (manual curl) | ✅ Auto |
| Table Preparation | ~10 min (typing) | ✅ Auto (clipboard) |
| Node Tag Check | Often forgotten ❌ | ✅ Forced reminder |
| Summary Report | Manual notes | ✅ Auto printed |

---

## 📞 Application Details

| Field | Value |
|-------|-------|
| Application Name | BHEFTS |
| ITAM/CI ID | 50274 |
| Vendor Name | Adroit Technology |
| GTS ID | GTS-0012707 |
| Product Name | BHEFTS |
| Product Owner | nemazie, sameer |
| User PSIDs | 1618688, 1228108 |
| ADO Repo | 50274-REPO-BHEFTS |
| Pipeline Branch | Catalyst/Main |

---

*Setup by GitHub Copilot for `muhammad.bilal@avanzasolutions.com`*
