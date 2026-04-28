# ADO Artifact Ingestion Ticket Template
# Application: BHEFTS | ITAM/CI ID: 50274
# Copy this template into your Azure DevOps work item

---

## Work Item Title

```
Artifact Ingestion - Vendor release {{RELEASE_VERSION}} Upload for Bhefts-50274
```

---

## Work Item Type
**Artifact Ingestion**

## Area Path
`50274-REPO-BHEFTS\Ingestion`

## Iteration Path
`50274-REPO-BHEFTS\{{RELEASE_VERSION}}`

---

## Description

Vendor artifact ingestion request for BHEFTS release **{{RELEASE_VERSION}}**.

**Artifacts Download Link:**
```
{{JFROG_PATH}}
```

**Upload Date:** {{DATE}}

---

## Application Details

| Field              | Value                     |
|--------------------|---------------------------|
| Application Name   | BHEFTS                    |
| ITAM/CI ID         | 50274                     |
| Vendor Name        | Adroit Technology         |
| GTS ID             | GTS-0012707               |
| Product Name       | BHEFTS                    |
| Product Owner      | nemazie, sameer           |
| User PSIDs         | 1618688, 1228108          |
| ADO Repository     | 50274-REPO-BHEFTS         |
| Pipeline Branch    | Catalyst/Main             |
| Release Version    | {{RELEASE_VERSION}}       |
| Upload Date        | {{DATE}}                  |

---

## JFrog Artifact Path

```
{{JFROG_PATH}}
```

Base URL:
```
https://artifactory.global.standardchartered.com/artifactory/restricted-generic-artifactingestion/50274-BHEFTS/package/
```

---

## Discussion Table (paste into ADO Discussion field)

```
| Field                    | Value                                                                                      |
|--------------------------|--------------------------------------------------------------------------------------------|
| Application Name         | BHEFTS                                                                                     |
| ITAM/CI ID               | 50274                                                                                      |
| Vendor Name              | Adroit Technology                                                                          |
| GTS ID                   | GTS-0012707                                                                                |
| Product Name             | BHEFTS                                                                                     |
| Product Owner            | nemazie, sameer                                                                            |
| User PSIDs               | 1618688, 1228108                                                                           |
| Release Version          | {{RELEASE_VERSION}}                                                                        |
| JFrog Artifact Path      | {{JFROG_PATH}}                                                                             |
| Upload Date              | {{DATE}}                                                                                   |
```

---

## Instructions for Copying to ADO

1. Open Azure DevOps at [https://dev.azure.com](https://dev.azure.com)
2. Navigate to project: **50274-REPO-BHEFTS**
3. Go to **Boards → Work Items**
4. Find the existing ticket: `Artifact Ingestion 10698033`
5. Click **"Create copy of work item"**
6. Update the **Title** field using the template above (replace `{{RELEASE_VERSION}}`)
7. Update the **Artifacts Download Link** field with `{{JFROG_PATH}}`
8. In the **Discussion** section, paste the Discussion Table above (replace all placeholders)
9. Set **State** to: `Open`
10. Click **Save**

### Placeholder Reference

| Placeholder          | Replace With                          | Example                              |
|----------------------|---------------------------------------|--------------------------------------|
| `{{RELEASE_VERSION}}`| Your release version                  | `v0.9`                               |
| `{{JFROG_PATH}}`     | Full JFrog artifact URL               | `https://artifactory.global.../Gen_Release.zip` |
| `{{DATE}}`           | Today's date (YYYY-MM-DD)             | `2025-01-15`                         |

---

## Node Tag Reference

| Stage            | Node Tag                              |
|------------------|---------------------------------------|
| Dev              | `hki4ympy8hl0l00`                     |
| QA               | `hki4ympy8hl0l00`                     |
| Staging          | `hki4ympy8hl0l00`                     |
| Pre-release      | `hki4ympy8hl0l00`                     |
| Production/Release | `sg5qbxm2eh43z00`, `hkiqbxm2eh43z00` |

> ⚠️ **WARNING:** Using wrong node tags may result in unintended production deployments.

---

## Ticket State Flow

```
Open → In Review → Artifacts Promoted → Released
```

The pipeline will not proceed to the Release stage until the ticket shows **"Artifacts Promoted"** status.

---

*Template for: muhammad.bilal@avanzasolutions.com | GitHub: bilal902-2k25*
