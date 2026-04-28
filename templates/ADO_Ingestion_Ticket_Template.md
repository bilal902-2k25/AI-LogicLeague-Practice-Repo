# ADO Artifact Ingestion Ticket Template
## BHEFTS / 50274 — Artifact Ingestion Request

> **Instructions:**  
> 1. Open Azure DevOps and locate ticket **Artifact Ingestion 10698033**  
> 2. Click **"Create copy of work item"**  
> 3. Replace all `{{PLACEHOLDER}}` values below with the real values  
> 4. Copy the discussion table into the **Discussion** field of the new work item  
> 5. Update the **Title** and **Artifacts download link** fields  
> 6. Click **Save**

---

## Work Item Title

```
Artifact Ingestion - Vendor release {{RELEASE_VERSION}} Upload for Bhefts-50274
```

**Example:**
```
Artifact Ingestion - Vendor release v0.9 Upload for Bhefts-50274
```

---

## Artifacts Download Link / Location Field

```
{{JFROG_PATH}}
```

**Example:**
```
https://artifactory.global.standardchartered.com/artifactory/restricted-generic-artifactingestion/50274-BHEFTS/package/Gen_Release.zip
```

---

## Discussion Section — Copy & Paste Table

> Paste the following block into the **Discussion** field of the ADO work item.  
> Replace `{{JFROG_PATH}}` and `{{RELEASE_VERSION}}` with the actual values before pasting.

---

required detail provided, please place the folders (Gen_Release.zip) in 'vendor-generic-lab-local' so it can be accessible from the pipeline, thanks.

| Application Details | Value |
|---|---|
| Application Name | BHEFTS |
| ITAM/CI ID | 50274 |
| Vendor Name | Adroit Technology |
| GTS ID | GTS-0012707 |
| Product Name | BHEFTS |
| Product Owner | nemazie, sameer |
| Product download link | `{{JFROG_PATH}}` |
| Vendor package attestation (upload vendor mail reference) | - |
| User(s) PSID need upload access (max 2 - onetime input) | 1618688, 1228108 |
| Reason for downloading the artifacts | Vendor release {{RELEASE_VERSION}} for pipeline execution, pipeline will use this "vendor-generic-lab-local". |

---

## Filled Example (for reference)

| Application Details | Value |
|---|---|
| Application Name | BHEFTS |
| ITAM/CI ID | 50274 |
| Vendor Name | Adroit Technology |
| GTS ID | GTS-0012707 |
| Product Name | BHEFTS |
| Product Owner | nemazie, sameer |
| Product download link | `https://artifactory.global.standardchartered.com/artifactory/restricted-generic-artifactingestion/50274-BHEFTS/package/Gen_Release.zip` |
| Vendor package attestation (upload vendor mail reference) | - |
| User(s) PSID need upload access (max 2 - onetime input) | 1618688, 1228108 |
| Reason for downloading the artifacts | Vendor release v0.9 for pipeline execution, pipeline will use this "vendor-generic-lab-local". |

---

## After Saving the Ticket

- Monitor the ticket status in ADO
- Wait for the state to change from **Open** → **Artifacts Promoted**
- Once promoted, proceed with pipeline execution

---

## Key Details Reference

| Field | Value |
|---|---|
| Application Name | BHEFTS |
| ITAM/CI ID | 50274 |
| Vendor Name | Adroit Technology |
| GTS ID | GTS-0012707 |
| ADO Repo | 50274-REPO-BHEFTS |
| Pipeline Branch | Catalyst/Main |
| Product Owner | nemazie, sameer |
| PSIDs | 1618688, 1228108 |
| JFrog Base URL | `https://artifactory.global.standardchartered.com/artifactory/restricted-generic-artifactingestion/50274-BHEFTS/package/` |
| Date | {{DATE}} |
