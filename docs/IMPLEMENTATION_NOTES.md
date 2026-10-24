# Implementation Notes & Engineering Decisions

This file captures the implementation reflected in `README.txt` and the provided n8n workflow exports.

## Main workflow (39 nodes + 5 notes)

**1. Webhook verification:** `WhatsApp Verify (GET)` → `Verify Token OK?` → `Return Challenge` / `Reject`.

**2. Inbound:** `WhatsApp Inbound (POST)` → `Config` → `Extract Message` → `Dedupe Message` → `New Message?` → `Mark Read + Typing` → `Message Type`.

**3. Text/vision/model:** Text runs through explicit guard notes. Image messages run through `Get Media URL` → `Download Image` → `Read Product ID (Vision)` → `Lookup Screenshot Product`. Unsupported types receive a request to type. `Denim Sales Agent` uses `OpenAI Chat Model`, `Chat Memory (Supabase)`, and four SQL tools: `get_product`, `search_products`, `request_discount`, `calculate_order`.

**4. Outputs:** `Parse Agent Output` → WhatsApp reply; `Send Catalog?` → `Catalog Job` → `Run Catalog Sender`; `Lead Update?` → `Build Airtable Fields` → `Find Lead (Airtable)` → `Lead Exists?` → merge/update or create. Model failures run a fallback path.

## Catalog Sender sub-workflow (8 nodes + 1 note)

`Catalog Trigger` → `Load Catalog` → `Prepare Images` → `Batches of 20` → `Send Product Image` → `Pause 15s` → next batch; when done, `One Item` → `Send Closing Message`.

The sender may be called asynchronously so the main AI agent can respond while catalog images are being delivered. The full catalog has 120 demo items in six batches. Cloudinary image URLs are transformed to optimized JPG delivery (`f_jpg,q_auto,w_1080`).

## SQL-owned business logic

- `get_product` reads exact product data by ID instead of reusing model memory.
- `search_products` supports a segment, single keyword and maximum per-item price, with up to 15 results ordered by price.
- `request_discount` maintains a per-customer, per-product stage in `wa_price_offers`: first TK 10, second TK 20 final. The stage cannot advance beyond 2.
- `calculate_order` joins agreed offer stages with product bundle sizes and quantities, producing exact line and grand totals.

## CRM merge strategy

Airtable `Leads` is keyed logically by `Lead ID = WA-<WhatsApp number>`. The original Airtable upsert approach failed to match using a phone-number field; the actual workflow now **finds the lead, then updates or creates**. Merging preserves the union of interest Product IDs, highest score and qualified status.

`Qualified – Ready for Sales` means the buyer has confirmed items/quantities and supplied all seven required details; it is **not** a completed invoice or payment. `Handed Over` is reserved for a buyer explicitly requesting a person or call.

## Input/output guards and known boundaries

- The text guard distinguishes explicit image/catalog requests from category/price questions.
- The vision route requires a readable printed Product ID; otherwise the system asks the buyer to resend/type the ID rather than inventing product details.
- `Parse Agent Output` parses model JSON, checks explicit catalog intent and incomplete lead fields, and limits reply length.
- The source test exposed a duplicate seven-details prompt; this was fixed in the post-test output guard and documented rather than concealed.
- The workflow is **English-only** and does not transcribe voice notes.
- Automated notification of newly qualified buyers to the human Sales Team has **not** been implemented; the team can view the Airtable status.
- Business-initiated messages outside the customer-service window, invoice generation, payment integration and real inventory write-back are outside the provided version.

## Runtime/credential notes

The original main export's Config node contained actual Meta Phone Number and Airtable IDs, while the webhook verification comparison contained a fixed verification token. These fields are replaced with placeholders in the public workflow JSON. The main workflow's `Run Catalog Sender` node has an unset target workflow ID in the provided export, so after importing both workflows you must select the Catalog Sender in n8n.

For production, secure secrets as n8n credentials and rotate any previously exposed verification token. Do not publish screenshots containing API keys or database connection secrets.
