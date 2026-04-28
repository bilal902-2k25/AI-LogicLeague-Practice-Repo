# BHEFTS Release Automation — Demo Environment

**Application:** BHEFTS | **ITAM/CI ID:** 50274 | **Vendor:** Adroit Technology  
**ADO Repo:** 50274-REPO-BHEFTS | **Pipeline Branch:** Catalyst/Main  
**Demo User:** muhammad.bilal@avanzasolutions.com | **GitHub:** bilal902-2k25

---

## Table of Contents

1. [Repository Structure](#repository-structure)
2. [Quick Start](#quick-start)
3. [Script Reference](#script-reference)
4. [Step-by-Step Demo Walkthrough](#step-by-step-demo-walkthrough)
5. [Azure DevOps Free Account Setup](#azure-devops-free-account-setup)
6. [Pipeline Stage Descriptions](#pipeline-stage-descriptions)
7. [Node Tag Configuration](#node-tag-configuration)
8. [Application Details](#application-details)
9. [Troubleshooting](#troubleshooting)

---

## Repository Structure

```
AI-LogicLeague-Practice-Repo/
├── scripts/
│   ├── BHEFTS_Release_Automation.ps1   # Main automation script (real upload)
│   ├── BHEFTS_Demo_Simulation.ps1      # Dry-run simulation (no real upload)
│   └── Create_Sample_Release.ps1       # Helper: creates a sample Gen_Release.zip
├── pipelines/
│   └── bhefts-release-pipeline.yml     # Azure DevOps pipeline YAML
├── templates/
│   └── ADO_Ingestion_Ticket_Template.md # Pre-filled ADO work item template
└── README.md
```

---

## Quick Start

### 1 — Create a sample release zip (first time)

```powershell
# Run in PowerShell as Administrator
cd <repo-root>\scripts
.\Create_Sample_Release.ps1 -ReleaseVersion v0.9
```

This creates `C:\Releases\v0.9\Gen_Release.zip` with dummy files ready for upload.

### 2 — Run the demo simulation (no real upload)

```powershell
.\BHEFTS_Demo_Simulation.ps1
```

Simulates every step with colored output. Safe to run anywhere — no credentials needed.

### 3 — Run the real automation (requires VPN + JFrog access)

```powershell
.\BHEFTS_Release_Automation.ps1
```

Prompts for release folder path, version, and work item ID, then performs the real JFrog upload.

---

## Script Reference

### `BHEFTS_Release_Automation.ps1`

| Parameter | Description | Example |
|---|---|---|
| `-ReleaseFolderPath` | Path to folder containing `Gen_Release.zip` | `C:\Releases\v0.9` |
| `-ReleaseVersion` | Release version label | `v0.9` |
| `-ReleaseWorkItemID` | ADO release work item ID | `12345678` |

**Example:**
```powershell
.\BHEFTS_Release_Automation.ps1 -ReleaseFolderPath "C:\Releases\v0.9" -ReleaseVersion "v0.9" -ReleaseWorkItemID "12345678"
```

**What it does:**
- Validates `Gen_Release.zip` exists
- Uploads to JFrog via `curl.exe`
- Copies ADO discussion table to clipboard
- Opens ADO in browser
- Shows node tag reminders
- Provides step-by-step guided prompts with PAUSE points

---

### `BHEFTS_Demo_Simulation.ps1`

No parameters required. Uses demo defaults.

**Example:**
```powershell
.\BHEFTS_Demo_Simulation.ps1 -ReleaseVersion "v1.0-demo" -ReleaseWorkItemID "99999999"
```

**What it does:**
- Simulates all steps with fake success/failure outputs
- Shows mock curl upload response (no real upload)
- Demonstrates failure scenario (zip not found) and recovery
- Simulates artifact promotion status change
- Runs all pipeline stages with mock output

---

### `Create_Sample_Release.ps1`

| Parameter | Description | Example |
|---|---|---|
| `-ReleaseVersion` | Version label for the folder | `v0.9` |
| `-BaseOutputPath` | Parent folder to create release under | `C:\Releases` |

**Example:**
```powershell
.\Create_Sample_Release.ps1 -ReleaseVersion "v0.9" -BaseOutputPath "C:\Releases"
```

**Creates:**
```
C:\Releases\v0.9\
├── Gen_Release.zip          ← ready for upload
└── Gen_Release\
    ├── bin\bhefts_app.exe
    ├── bin\bhefts_service.exe
    ├── config\app.config
    ├── config\database.config
    ├── lib\bhefts_core.dll
    ├── lib\bhefts_utils.dll
    ├── docs\Release_Notes.txt
    ├── docs\Deployment_Guide.txt
    ├── scripts\install.ps1
    ├── scripts\uninstall.ps1
    ├── README.txt
    └── MANIFEST.txt
```

---

## Step-by-Step Demo Walkthrough

### Prerequisites

- Windows machine with PowerShell 5.1+
- `curl.exe` available (bundled with Windows 10/11)
- Corporate VPN connected (for real JFrog upload only)
- Microsoft account (for ADO free account setup)

---

### Phase 1 — Artifacts Upload

**Step 1.** Create the sample release package:
```powershell
.\Create_Sample_Release.ps1 -ReleaseVersion "v0.9"
```

**Step 2.** Run the automation (or demo simulation):
```powershell
# Demo (no real upload):
.\BHEFTS_Demo_Simulation.ps1

# Real run:
.\BHEFTS_Release_Automation.ps1
```

**Step 3.** When prompted, enter:
- Release folder path: `C:\Releases\v0.9`
- Release version: `v0.9`
- Work Item ID: `<your ADO work item ID>`

The script will:
- Validate `Gen_Release.zip` is present
- Upload to: `https://artifactory.global.standardchartered.com/artifactory/restricted-generic-artifactingestion/50274-BHEFTS/package/Gen_Release.zip`
- Copy the ADO discussion table to your clipboard

---

### Phase 2 — ADO Artifact Ingestion Ticket

**Step 4.** Open ADO and find ticket **Artifact Ingestion 10698033**

**Step 5.** Click **"Create copy of work item"**

**Step 6.** Update the following fields:
- **Title:** `Artifact Ingestion - Vendor release v0.9 Upload for Bhefts-50274`
- **Artifacts download link:** `https://artifactory.global.standardchartered.com/artifactory/restricted-generic-artifactingestion/50274-BHEFTS/package/Gen_Release.zip`
- **Discussion:** Paste from clipboard (`CTRL+V`)

**Step 7.** Save the ticket and wait for status: **Open → Artifacts Promoted**

See `templates/ADO_Ingestion_Ticket_Template.md` for the pre-filled template.

---

### Phase 3 — Pipeline Execution

**Step 8.** Create a Pull Request: `feature branch → Catalyst/Main`  
ADO Repo: `50274-REPO-BHEFTS`

**Step 9.** Get PR approved and all pipeline checks passing.

**Step 10.** Run the `Catalyst/Main` pipeline:
- Set **ReleaseWorkItemID** = your work item ID
- Set **ReleaseVersion** = e.g. `v0.9`
- Click **Run**

**Step 11.** Monitor all stages: `CI → Dev → QA → Staging → Pre-release → Release`

---

## Azure DevOps Free Account Setup

1. Go to **[dev.azure.com](https://dev.azure.com)**
2. Click **"Start free"**
3. Sign in with your Microsoft/Outlook account  
   *(Sign in with your Microsoft/Outlook account or organizational account)*
4. Create a new **Organization** (e.g. `bhefts-demo`)
5. Create a new **Project** (e.g. `BHEFTS-Demo`)
6. In the project, go to **Pipelines → New Pipeline**
7. Connect to GitHub, select this repo, and use `pipelines/bhefts-release-pipeline.yml`

> **Note:** Azure DevOps is completely free for up to 5 users. No credit card required.

---

## Pipeline Stage Descriptions

| Stage | Node | Tasks |
|---|---|---|
| **CI** | `hki4ympy8hl0l00` | Build vendor binaries, security checks, record build metrics |
| **Dev** | `hki4ympy8hl0l00` | deploy_puppet, record deployment, fetch build info, record metrics |
| **QA** | `hki4ympy8hl0l00` | Puppet deploy, run tests, generate test summary, DTM approval gate |
| **Staging** | `hki4ympy8hl0l00` | Deployment, security checks, generate test summary |
| **Pre-release** | `hki4ympy8hl0l00` | Release checks, work item tab validation (Solutions Intent etc.) |
| **Release** | `sg5qbxm2eh43z00` / `hkiqbxm2eh43z00` | Verify release approval, artifact checksum, promote to production, update RWI |

---

## Node Tag Configuration

> ⚠️ **CRITICAL:** Using wrong node tags will deploy to PRODUCTION unintentionally!

| Stages | Node Tag | Environment |
|---|---|---|
| dev, qa, staging, pre-release | `hki4ympy8hl0l00` | Test / Non-production |
| release / production | `sg5qbxm2eh43z00` | Production |
| release / production | `hkiqbxm2eh43z00` | Production |

**In your pipeline YAML:**
```yaml
# Non-production stages
pool:
  demands:
    - Agent.Name -equals hki4ympy8hl0l00

# Production stage ONLY
pool:
  demands:
    - Agent.Name -equals sg5qbxm2eh43z00
```

---

## Application Details

| Field | Value |
|---|---|
| Application Name | BHEFTS |
| ITAM/CI ID | 50274 |
| Vendor Name | Adroit Technology |
| GTS ID | GTS-0012707 |
| Product Name | BHEFTS |
| Product Owner | nemazie, sameer |
| User PSIDs | 1618688, 1228108 |
| ADO Repo | 50274-REPO-BHEFTS |
| Pipeline Branch | Catalyst/Main |
| JFrog Upload URL | `https://artifactory.global.standardchartered.com/artifactory/restricted-generic-artifactingestion/50274-BHEFTS/package/Gen_Release.zip` |

---

## Troubleshooting

### `Gen_Release.zip not found`

```
[FAILED] Release zip not found at: C:\Releases\v0.9\Gen_Release.zip
```

**Fix:** Run `Create_Sample_Release.ps1` first or manually place `Gen_Release.zip` in the release folder.

---

### `curl.exe upload failed — exit code 6`

```
[FAILED] Upload failed. Exit code: 6
Output: curl: (6) Could not resolve host
```

**Fix:**
1. Connect to corporate VPN
2. Verify `curl.exe` is available: `curl.exe --version`
3. Test connectivity: `ping artifactory.global.standardchartered.com`

---

### `PowerShell execution policy error`

```
.\BHEFTS_Release_Automation.ps1 cannot be loaded because running scripts is disabled
```

**Fix:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

### `Compress-Archive fails in Create_Sample_Release.ps1`

**Fix:** Ensure PowerShell 5.1+ is installed. Check: `$PSVersionTable.PSVersion`

---

### Pipeline stuck at approval gate

- Verify Release Manager has approved the work item
- Check that all previous stages passed
- Confirm the work item state is **Artifacts Promoted** before running the pipeline

---

### Wrong environment deployed

- Immediately stop the pipeline run
- Verify node tags in `pipelines/bhefts-release-pipeline.yml`
- Production nodes (`sg5qbxm2eh43z00`, `hkiqbxm2eh43z00`) should **only** appear in the **Release** stage
