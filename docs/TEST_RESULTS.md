# Test Results & Evidence

This summary is based on the supplied original `README.txt` and the 11 numbered screenshots from the recorded final WhatsApp test. It documents an **end-to-end test with demonstration data**, not a paid/production customer deployment.

## Recorded end-to-end test

| Sequence | Buyer action / system behavior | Evidence |
| --- | --- | --- |
| 01 | Simple greeting; category overview; request for two retail pieces politely declined | [01-greeting-categories-retail-declined.jpg](../screenshots/01-greeting-categories-retail-declined.jpg) |
| 02 | Buyer explicitly requests the full catalog; 120 demo product images sent in batches of 20 | [02-full-catalog-sent-in-batches.jpg](../screenshots/02-full-catalog-sent-in-batches.jpg) |
| 03 | Buyer sends design screenshot (example PD115); agent reads ID and returns exact database product details | [03-screenshot-to-product-details.jpg](../screenshots/03-screenshot-to-product-details.jpg) |
| 04 | Four products negotiated: first TK 10 off, second TK 20 off each; extra TK 50 refused | [04-bargaining-two-rounds-final-price.jpg](../screenshots/04-bargaining-two-rounds-final-price.jpg) |
| 05 | Buyer confirms two bundles of each of four products (8 bundles), SQL total **TK 115,600**, supplies required business details and is qualified | [05-order-summary-details-confirmed.jpg](../screenshots/05-order-summary-details-confirmed.jpg) |
| 06 | Main n8n agent workflow, routing and lead update path | [06-n8n-main-workflow-ai-sales-agent.jpg](../screenshots/06-n8n-main-workflow-ai-sales-agent.jpg) |
| 07 | Catalog Sender sub-workflow (20-image batches, 15 s pause) | [07-n8n-catalog-sender-workflow.jpg](../screenshots/07-n8n-catalog-sender-workflow.jpg) |
| 08 | Supabase database with four tables | [08-supabase-database-tables.jpg](../screenshots/08-supabase-database-tables.jpg) |
| 09 | Supabase product table (120 demo records) | [09-supabase-products-table.jpg](../screenshots/09-supabase-products-table.jpg) |
| 10 | Price stages 2 for all four test designs | [10-supabase-price-offers-table.jpg](../screenshots/10-supabase-price-offers-table.jpg) |
| 11 | Catalog images stored on Cloudinary | [11-cloudinary-product-images.jpg](../screenshots/11-cloudinary-product-images.jpg) |

## Final test products and order

| Product ID | Segment | Final price per piece | Test order |
| --- | --- | ---: | --- |
| PD115 | Adult Female | TK 720 | 2 bundles × 20 pcs = 40 pcs |
| AM-DJ-002 | Adult Male | TK 720 | 2 bundles × 20 pcs = 40 pcs |
| KG-DJ-001 | Kids Girl | TK 400 | 2 bundles × 32 pcs = 64 pcs |
| PD107 | Kids Boy | TK 540 | 2 bundles × 30 pcs = 60 pcs |

**Total:** 8 bundles, **204 pieces**, **TK 115,600**. All four products were shown at the final price (TK 20 reduction from their original asking price). The test lead ended as **Qualified – Ready for Sales**, score **5**, in Airtable. [Sanitized CSV](../data/sanitized-lead-example.csv).

## A documented test anomaly (screenshot 05)

The agent and the output safety check both requested the seven required buyer details in the recorded conversation, causing a duplicated list. **The screenshot is intentionally preserved unedited**. The source `README.txt` states the guard was then changed to detect an existing details request before adding its own. The original order total and qualified Airtable lead were correct.

This is documented as a **post-test fix reported by the project source**; no additional post-fix video or independent execution result is claimed here.

## Other problems identified during project testing and corresponding fixes

| Issue | Fix implemented |
| --- | --- |
| AI repeatedly offered only first-stage discount | SQL `request_discount` tracks stages per buyer and product |
| Wrong product prices from chat context | `get_product` lookup for explicit IDs; database lookup after Vision extraction |
| Catalog sent even when no pictures requested | Code-level explicit intent check |
| Overlong greeting on just “Hello” | Short greeting-only guard |
| Order total incorrect by TK 1,000 | SQL `calculate_order` and copy exact return values |
| Agent closed order without all details | Validate seven buyer fields before qualification |
| Airtable upsert failed when matching phone-number field | Find by Lead ID then Update or Create; merge preserves prior fields |

## Video and supporting evidence

- [Watch the full recorded final test](https://drive.google.com/file/d/1_yWxXDk5LtWC9U1KoM8k6y3AByp9fHqk/view?usp=sharing)
- [Open the read-only Airtable CRM view](https://airtable.com/appaQDgOQdg9xNqoz/shrPiGrpdq9VRPKFF/tblH2SXlfPpWyAkht/viwd9bEV105HkNaZy)

The test uses demo buyer/business data, and images/screenshots were supplied by the project author.
