# BHEFTS Release Automation - Azure DevOps Demo Environment

> **Application:** BHEFTS | **ITAM/CI ID:** 50274 | **Vendor:** Adroit Technology | **GTS ID:** GTS-0012707
>
> **Maintained by:** muhammad.bilal@avanzasolutions.com | **GitHub:** bilal902-2k25

---

## Table of Contents

1. [Overview](#overview)
2. [Repository Structure](#repository-structure)
3. [Setup Guide](#setup-guide)
4. [How to Run Each Script](#how-to-run-each-script)
5. [Step-by-Step Demo Walkthrough](#step-by-step-demo-walkthrough)
6. [Azure DevOps Free Account Setup](#azure-devops-free-account-setup)
7. [Pipeline Stage Descriptions](#pipeline-stage-descriptions)
8. [Node Tag Configuration](#node-tag-configuration)
9. [ADO Work Item Template](#ado-work-item-template)
10. [Troubleshooting](#troubleshooting)

---

## Overview

This repository contains everything needed to simulate and automate the **BHEFTS Release Automation** process on Azure DevOps. It covers:

- **JFrog artifact upload** via PowerShell + `curl.exe`
- **ADO artifact ingestion ticket** preparation
- **Pipeline execution** across CI → Dev → QA → Staging → Pre-release → Release stages
- **Demo simulation** (dry-run, no real uploads needed)
- **Sample release zip creator** for testing

---

## Repository Structure

```
AI-LogicLeague-Practice-Repo/
├── scripts/
│   ├── BHEFTS_Release_Automation.ps1   # Main automation script (real run)
│   ├── BHEFTS_Demo_Simulation.ps1      # Dry-run simulation with colored output
│   └── Create_Sample_Release.ps1       # Helper to create a test Gen_Release.zip
├── pipelines/
│   └── bhefts-release-pipeline.yml     # Azure DevOps pipeline YAML (all stages)
├── templates/
│   └── ADO_Ingestion_Ticket_Template.md # ADO work item template with placeholders
└── README.md                            # This file
```

---

## Setup Guide

### Prerequisites

| Requirement         | Details                                      |
|--------------------|----------------------------------------------|
| OS                 | Windows (PowerShell 5.1+)                    |
| `curl.exe`         | Built into Windows 10/11. Verify: `curl.exe --version` |
| VPN                | Must be connected to corporate network for JFrog access |
| ADO Account        | Free at [dev.azure.com](https://dev.azure.com) |
| PowerShell         | Run as **Administrator**                     |

### First Time Setup

1. **Clone or download** this repository.
2. Open **PowerShell as Administrator**.
3. Allow script execution (if needed):
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
4. Navigate to the `scripts/` folder:
   ```powershell
   cd C:\path\to\AI-LogicLeague-Practice-Repo\scripts
   ```

---

## How to Run Each Script

### 1. Demo Simulation (Start Here — No Setup Required)

Runs a full dry-run simulation. Nothing is uploaded; no ADO access needed.

```powershell
.\BHEFTS_Demo_Simulation.ps1
```

**What it shows:**
- Mock failure scenario (zip not found) + recovery steps
- Simulated JFrog upload with progress bar
- Generated ADO discussion table
- Node tag reminder
- Full pipeline stage walkthrough (CI → Release)

---

### 2. Create a Sample Release Zip

Generates a test `Gen_Release.zip` at `C:\Releases\<version>\`:

```powershell
.\Create_Sample_Release.ps1
```

You will be prompted for the release version (e.g. `v0.9`).

Output:
```
C:\Releases\v0.9\
├── content\
│   ├── bin\bhefts_service.exe
│   ├── config\app.config
│   ├── config\deployment.yml
│   ├── scripts\install.ps1
│   ├── scripts\uninstall.ps1
│   └── docs\release_notes.txt
├── README.txt
└── Gen_Release.zip   <-- ready to upload
```

---

### 3. Main Automation Script (Real Release Run)

Runs the full automation: validates zip, uploads to JFrog, prepares ADO ticket.

```powershell
.\BHEFTS_Release_Automation.ps1
```

You will be prompted for:
- **Release folder path** (e.g. `C:\Releases\v0.9`)
- **Release version** (e.g. `v0.9`)
- **Release Work Item ID** (e.g. `12345678`)

> **Note:** Update `$AdoIngestionTicketURL` in the script to your actual ADO org URL before running.

---

## Step-by-Step Demo Walkthrough

### Full Process Flow

```
[STEP 0] Input Collection
    │
    ▼
[STEP 1] Validate Gen_Release.zip exists
    │ ❌ File missing → STOP with recovery instructions
    │ ✅ Found
    ▼
[STEP 2] Upload to JFrog via curl.exe
    │ ❌ Upload fails (network/VPN) → STOP with recovery steps
    │ ✅ Uploaded successfully
    ▼
[STEP 3] ADO Ticket Preparation
    │   • Discussion table copied to clipboard (CTRL+V ready)
    │   • Browser opens ADO URL
    │   ⏸️ PAUSE: Complete manual ADO ticket steps
    ▼
[STEP 4] Node Tag Reminder
    │   • Displays correct node tags for each stage
    │   ⏸️ PAUSE: Confirm YAML node tags are correct
    ▼
[STEP 5] Artifacts Promotion Wait
    │   ⏸️ PAUSE: Wait for ADO ticket → "Artifacts Promoted"
    ▼
[STEP 6] Pipeline Execution Guide
    │   • Create PR: feature branch → Catalyst/Main
    │   • Run pipeline with Release Work Item ID
    ▼
[SUMMARY] All details printed
```

### Manual ADO Ticket Steps (STEP 3)

1. Open ADO and find: **Artifact Ingestion 10698033**
2. Click **Create copy of work item**
3. Update **Title** to: `Artifact Ingestion - Vendor release <version> Upload for Bhefts-50274`
4. Update **Artifacts download link** to the JFrog URL
5. Press `CTRL+V` to paste the discussion table into the Discussion field
6. Click **Save**
7. Monitor until state changes to **Artifacts Promoted**

### Pipeline Execution (STEP 6)

1. Create a PR from your feature branch → `Catalyst/Main` in [50274-REPO-BHEFTS](https://dev.azure.com)
2. Get PR approved and merged
3. Navigate to the `Catalyst/Main` pipeline
4. Click **Run pipeline**
5. Enter the **Release Work Item ID** when prompted
6. Monitor all stages: **CI → Dev → QA → Staging → Pre-release → Release**

---

## Azure DevOps Free Account Setup

### Option A — Azure DevOps Only (No credit card)

1. Go to [https://dev.azure.com](https://dev.azure.com)
2. Sign in with any **Microsoft / Outlook account**
3. Create a new **Organization** (e.g. `bhefts-demo`)
4. Create a **Project** (e.g. `50274-BHEFTS`)
5. Go to **Pipelines** → **New Pipeline**
6. Connect to this GitHub repository
7. Select `pipelines/bhefts-release-pipeline.yml`
8. Configure variables: `ReleaseWorkItemID`, `ReleaseVersion`, `ArtifactPath`
9. Click **Run**

### Option B — Full Azure + DevOps (with $200 free credit)

1. Go to [https://azure.microsoft.com/free](https://azure.microsoft.com/free)
2. Sign up with a Microsoft account (credit card required, not charged)
3. You get **$200 credit** for 30 days + always-free services
4. Access Azure DevOps from the Azure portal

### Setting Up a Self-Hosted Agent (for node tag simulation)

If you want to simulate node tags locally:

1. In ADO: go to **Project Settings → Agent Pools → New Agent**
2. Download and configure the agent on your machine
3. Set the agent name to match the node tag (e.g. `hki4ympy8hl0l00`)
4. The pipeline will then route jobs to your machine

---

## Pipeline Stage Descriptions

| Stage        | Purpose                                                                 | Node              |
|-------------|-------------------------------------------------------------------------|-------------------|
| **CI**       | Build vendor binaries, security checks, record build metrics           | `hki4ympy8hl0l00` |
| **Dev**      | Puppet deployment, record deployment, fetch build info, build metrics  | `hki4ympy8hl0l00` |
| **QA**       | Run all tests, generate test summary, DTM approval gate                | `hki4ympy8hl0l00` |
| **Staging**  | Deploy to staging, security checks, test summary                       | `hki4ympy8hl0l00` |
| **Pre-release** | Release checks, work item tab validation (Solutions Intent etc.)   | `hki4ympy8hl0l00` |
| **Release**  | Verify approval, artifact checksum, promote to production, update RWI | `sg5qbxm2eh43z00` / `hkiqbxm2eh43z00` |

### Stage Dependencies

```
CI → Dev → QA → Staging → Pre-release → Release
```

Each stage only runs if the previous stage succeeded.

---

## Node Tag Configuration

> ⚠️ **CRITICAL:** Using wrong node tags will deploy to **PRODUCTION** unintentionally.

| Environment                      | Node Tag(s)                                |
|---------------------------------|--------------------------------------------|
| dev, qa, staging, pre-release   | `hki4ympy8hl0l00`                          |
| production / release            | `sg5qbxm2eh43z00`, `hkiqbxm2eh43z00`      |

### In Pipeline YAML

```yaml
# Test stages (dev, qa, staging, pre-release)
pool:
  demands:
    - Agent.Name -equals hki4ympy8hl0l00

# Production / Release stage
pool:
  demands:
    - Agent.Name -in sg5qbxm2eh43z00,hkiqbxm2eh43z00
```

---

## ADO Work Item Template

See [`templates/ADO_Ingestion_Ticket_Template.md`](templates/ADO_Ingestion_Ticket_Template.md) for the full pre-filled template.

### Quick Reference — Application Details

| Field                | Value                  |
|---------------------|------------------------|
| Application Name     | BHEFTS                 |
| ITAM/CI ID           | 50274                  |
| Vendor Name          | Adroit Technology      |
| GTS ID               | GTS-0012707            |
| Product Name         | BHEFTS                 |
| Product Owner        | nemazie, sameer        |
| User PSIDs           | 1618688, 1228108       |
| ADO Repo             | 50274-REPO-BHEFTS      |
| Pipeline Branch      | Catalyst/Main          |

### JFrog Upload Destination

```
https://artifactory.global.standardchartered.com/artifactory/restricted-generic-artifactingestion/50274-BHEFTS/package/Gen_Release.zip
```

---

## Troubleshooting

### ❌ `curl.exe` not found

**Symptom:** `curl.exe : The term 'curl.exe' is not recognized`

**Fix:**
```powershell
# Check if curl is available
curl.exe --version

# If not found, install via winget
winget install curl.se.curl
```
> curl.exe is built into Windows 10 1803+ and Windows 11.

---

### ❌ Upload fails with "Could not resolve host"

**Symptom:** `curl: (6) Could not resolve host: artifactory.global.standardchartered.com`

**Fix:**
1. Connect to **corporate VPN**
2. Verify DNS: `nslookup artifactory.global.standardchartered.com`
3. Retry the script

---

### ❌ Upload fails with HTTP 401

**Symptom:** `curl: (22) The requested URL returned error: 401`

**Fix:**
1. Verify credentials in the script: `svc-incountry` / `vendorbin2upload`
2. Contact the JFrog admin to confirm the service account is active

---

### ❌ PowerShell execution policy error

**Symptom:** `cannot be loaded because running scripts is disabled on this system`

**Fix:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

### ❌ Pipeline fails at "Deploy via Puppet Agent" (node not found)

**Symptom:** `No agent found in pool with demands: Agent.Name -equals hki4ympy8hl0l00`

**Fix:**
1. Set up a self-hosted agent in ADO (Project Settings → Agent Pools)
2. Name the agent `hki4ympy8hl0l00`
3. Or update the node tag in the pipeline YAML to match your agent name

---

### ❌ ADO ticket state stuck at "Open"

**Cause:** ADO team processes ingestion requests manually.

**Actions:**
1. Verify the discussion table is correctly filled (all required fields present)
2. Verify the JFrog path is accessible
3. Follow up with the ADO team

---

*For issues or questions: muhammad.bilal@avanzasolutions.com*
