# Demo & Project Resources

## End-to-end WhatsApp test recording

[**Watch the recorded end-to-end test on Google Drive**](https://drive.google.com/file/d/1_yWxXDk5LtWC9U1KoM8k6y3AByp9fHqk/view?usp=sharing)

The supplied recording demonstrates the demo wholesale buyer interacting with the WhatsApp AI agent through greeting and retailer screening, full 120-item catalog request, screenshot-based product selection, two bargaining rounds, SQL-calculated order, buyer detail collection and Airtable-ready lead qualification.

> A screenshot from the final test includes one repeated request for buyer details. The issue was fixed afterward; the screenshot is retained to show the original test evidence. See [TEST_RESULTS.md](TEST_RESULTS.md).

## Supporting source links

| Resource | Link | Notes |
| --- | --- | --- |
| Full shared project folder | [Google Drive](https://drive.google.com/drive/folders/1oh_sF_jLUmoLzIdRB8S52jk_FJ6u9cOX?usp=sharing) | Source materials and complete project assets |
| Full 120 design image collection | [Product Images](https://drive.google.com/drive/folders/1S5Vb0fs96AMKw8cbrHyNAwEg1V0vEvHJ?usp=sharing) | Demo catalog generated for testing; this repo keeps only 8 representative cards |
| Airtable CRM shared view | [Read-only Leads view](https://airtable.com/appaQDgOQdg9xNqoz/shrPiGrpdq9VRPKFF/tblH2SXlfPpWyAkht/viwd9bEV105HkNaZy) | One test lead; current public view and access permissions may change |
| Main n8n workflow | [`workflows/denim-whatsapp-ai-sales-agent.sanitized.json`](../workflows/denim-whatsapp-ai-sales-agent.sanitized.json) | Sanitized importable workflow; requires credentials/configuration |
| Catalog Sender | [`workflows/denim-catalog-sender.sanitized.json`](../workflows/denim-catalog-sender.sanitized.json) | Sanitized importable sub-workflow |
| Source dataset | [`data/Denim_Wholesale_Agent_Data.xlsx`](../data/Denim_Wholesale_Agent_Data.xlsx) | 120 demo products, business policies, FAQ/lead templates |
| Sanitized CRM test result | [`data/sanitized-lead-example.csv`](../data/sanitized-lead-example.csv) | Replaces contact information with placeholders while preserving original test totals |

The live business phone number, third-party accounts, credentials, assets and external resource availability are **not guaranteed** to remain accessible. The recorded demo and local evidence are the project proof.
