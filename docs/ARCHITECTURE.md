# Architecture — Denim Wholesale WhatsApp AI Sales Agent

![System architecture](architecture-diagram.jpg)

> **Project context:** Independently implemented from real requirements provided by a prospective denim-wholesale client. The business identity, 120-item catalog, prices and buyer used in this proof of concept are demo data. It was **not a commissioned or client-delivered deployment**. The full workflow was tested through a working WhatsApp number.

## Main message flow

1. A wholesale buyer sends a text message, product screenshot, or other media to a WhatsApp Business number.
2. Meta WhatsApp Cloud API calls the n8n webhook. The main workflow verifies GET subscriptions and handles POST messages; delivery-status callbacks are ignored.
3. A Supabase `wa_processed_messages` check prevents duplicate message processing, then Meta receives a read receipt and typing indicator.
4. The message router separates **text**, **images**, and **unsupported media**. For a screenshot, OpenAI Vision reads the printed Product ID; Supabase returns the actual product record. Unsupported messages receive a polite request to type.
5. The n8n AI Sales Agent uses **OpenAI `gpt-4o-mini`**, Supabase-backed conversation memory (last 20 messages), and SQL tools (`get_product`, `search_products`, `request_discount`, `calculate_order`).
6. A code-level output guard parses the model's JSON, checks explicit catalog intent and required buyer details, and constructs safe output/fallback paths.
7. The system replies on WhatsApp; optionally triggers the Catalog Sender asynchronously; and finds then updates or creates the buyer's lead in Airtable.

## Two connected n8n workflows

| Workflow | Contents | Function |
| --- | --- | --- |
| `denim-whatsapp-ai-sales-agent.sanitized.json` | 39 functional nodes + 5 notes | Meta verification/webhook, message routing, AI and SQL tools, catalog trigger, WhatsApp reply, Airtable lead synchronization, fallback |
| `denim-catalog-sender.sanitized.json` | 8 functional nodes + 1 note | Loads a selected segment or the whole catalog, sends 20-image batches, pauses 15 seconds between batches, sends completion message |

**Catalog mechanics:** One image every ~1.2 seconds within the HTTP node's batch settings; six 20-item batches for a 120-item full catalog. The assistant does not send images unless the buyer explicitly asks to see them. Images are served from Cloudinary with JPG optimization (`f_jpg,q_auto,w_1080`).

## Responsibilities by platform

| Component | Responsibility |
| --- | --- |
| Meta WhatsApp Cloud API (Graph API v25.0, as configured in the source) | Incoming webhooks, text/image delivery, read and typing statuses |
| n8n (self-hosted) | Workflow execution, routing, code guards, API and SQL integration |
| OpenAI GPT-4o-mini | Natural-language dialog, tool-calling, screenshot Product ID vision |
| Supabase PostgreSQL | 120 demo products, message dedupe, conversation memory, per-buyer/product price-offer stages |
| Airtable | Sales CRM — one logical lead per WhatsApp buyer |
| Cloudinary | 120 demo catalog image assets, image links |

## Deterministic safeguards (separate from AI generation)

- Product/price/stock claims must be backed by the `products` table, not generated from memory.
- The `request_discount` SQL tool tracks stage 1 (TK 10 off) and stage 2 (TK 20 off, final) for each customer and product, preventing lower discounts on repeated requests.
- The `calculate_order` SQL tool handles quantities and arithmetic using prices already agreed with the buyer.
- Explicit text-intent guard prevents unsolicited catalog spam.
- The output guard blocks premature qualification when the seven required buyer details have not been collected.
- Lead merging preserves previously mentioned products, the highest score, and qualified states instead of overwriting history.
- The agent has a fallback reply if model processing fails.

## Database tables

`products`, `n8n_chat_histories`, `wa_processed_messages`, `wa_price_offers`.

For scripts see [`../database`](../database). For setup see [SETUP.md](SETUP.md), and for feature-by-feature evidence see [FEATURES.md](FEATURES.md).
