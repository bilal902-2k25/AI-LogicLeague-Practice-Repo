# BHEFTS Artifact Ingestion Ticket Template

> **Instructions:** Copy the content of this file into your ADO work item.
> Replace all `{{PLACEHOLDER}}` values before saving the ticket.
> To copy this template into ADO: open the source work item → **Create copy of work item** → paste content below.

---

## Work Item Title

```
Artifact Ingestion - Vendor release {{RELEASE_VERSION}} Upload for Bhefts-50274
```

---

## Artifacts Download Location

```
{{JFROG_PATH}}
```

> Example:
> `https://artifactory.global.standardchartered.com/artifactory/restricted-generic-artifactingestion/50274-BHEFTS/package/Gen_Release.zip`

---

## Discussion Section (Copy & Paste into ADO Discussion)

```
required detail provided, please place the folders (Gen_Release.zip) in 'vendor-generic-lab-local' 
so it can be accessible from the pipeline, thanks.

Application Details    | Value
-----------------------|------------------------------------------
Application Name       | BHEFTS
ITAM/CI ID             | 50274
Vendor Name            | Adroit Technology
GTS ID                 | GTS-0012707
Product Name           | BHEFTS
Product Owner          | nemazie, sameer
Product download link  | {{JFROG_PATH}}
Vendor pkg attestation | -
User PSIDs (max 2)     | 1618688, 1228108
Reason                 | Vendor release {{RELEASE_VERSION}} for pipeline execution.
                       | Pipeline will use 'vendor-generic-lab-local'.
```

---

## Application Details Reference Table

| Field                          | Value                          | Mandatory? |
|-------------------------------|--------------------------------|------------|
| Application Name               | BHEFTS                         | Yes        |
| ITAM/CI ID                     | 50274                          | Yes        |
| Vendor Name                    | Adroit Technology              | Yes        |
| GTS ID                         | GTS-0012707                    | Yes        |
| Product Name                   | BHEFTS                         | Yes        |
| Product Owner                  | nemazie, sameer                | Yes        |
| Product download link          | `{{JFROG_PATH}}`               | Yes        |
| Vendor package attestation     | -                              | No         |
| User PSIDs (max 2)             | 1618688, 1228108               | Yes        |
| Reason for downloading         | Vendor release for pipeline    | Yes        |
| Release Version                | `{{RELEASE_VERSION}}`          | Yes        |
| Date                           | `{{DATE}}`                     | Yes        |

---

## Placeholders Reference

| Placeholder          | Description                          | Example                                                                                              |
|---------------------|--------------------------------------|------------------------------------------------------------------------------------------------------|
| `{{JFROG_PATH}}`    | Full JFrog artifact URL              | `https://artifactory.global.standardchartered.com/artifactory/restricted-generic-artifactingestion/50274-BHEFTS/package/Gen_Release.zip` |
| `{{RELEASE_VERSION}}` | Release version string             | `v0.9`                                                                                               |
| `{{DATE}}`          | Date of ingestion request            | `2025-01-15`                                                                                         |

---

## ADO Steps to Create Ingestion Ticket

1. Open ADO and navigate to the project board.
2. Find the source ticket: **Artifact Ingestion 10698033**.
3. Click **"Create copy of work item"**.
4. In the popup, check the copy option and click **Copy**.
5. **Update the Title** to:
   ```
   Artifact Ingestion - Vendor release {{RELEASE_VERSION}} Upload for Bhefts-50274
   ```
6. **Update Artifacts download location** field with `{{JFROG_PATH}}`.
7. **Paste the discussion table** (from Discussion Section above) into the Discussion field.
8. Click **Save**.
9. Monitor the ticket — state will change from **Open** → **Artifacts Promoted** once the ADO team processes it.

---

## JFrog Upload Path (Reference)

```
https://artifactory.global.standardchartered.com/artifactory/restricted-generic-artifactingestion/50274-BHEFTS/package/Gen_Release.zip
```

---

## Pipeline Node Tags (Reference)

| Stage(s)                             | Node Tag              |
|-------------------------------------|-----------------------|
| dev, qa, staging, pre-release       | `hki4ympy8hl0l00`     |
| production / release                | `sg5qbxm2eh43z00`     |
| production / release (secondary)    | `hkiqbxm2eh43z00`     |

---

*Template maintained by: muhammad.bilal@avanzasolutions.com*
