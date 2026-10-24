# Setup Guide (Portfolio Reproduction)

> **Important:** This repository contains sanitized demo artifacts. It is **not plug-and-play**: you must use your own WhatsApp Business account/app, n8n instance, OpenAI API key, Supabase database, Airtable base and Cloudinary library. Follow the documented sequence and never paste credentials into a public repository.

## 1. Supabase PostgreSQL

1. Create a Supabase project.
2. In the SQL Editor, run `database/01_products_setup.sql`, `database/03_agent_tables.sql` and `database/04_price_offers.sql` **in that order**. These create the 120-row demo product catalog plus chat memory, processed messages and price-offer tables.
3. Use Supabase's **Session pooler** host/port, database name, user and password in a private n8n Postgres credential. The provided README used port 5432, 10 maximum connections and “Ignore SSL Issues”; adapt SSL settings to your own secure environment, ideally with certificate verification enabled.
4. RLS is enabled and public `anon`/`authenticated` access is revoked by the supplied SQL. The n8n workflows query PostgreSQL using n8n Postgres credentials; never expose owner/service-role secrets in browser code.
5. `database/legacy/02_auto_prices.sql` is for an **older products schema only**. Do **not** run it after `01_products_setup.sql`: generated price columns are already present.

## 2. Cloudinary image hosting

1. Upload the 120 demo image cards from the [shared Product Images folder](https://drive.google.com/drive/folders/1S5Vb0fs96AMKw8cbrHyNAwEg1V0vEvHJ?usp=sharing) to your Cloudinary library, for example a `denim-catalog` folder.
2. Update the `image_url` values in `public.products` if your Cloudinary URLs differ from those in the supplied demo data.
3. The catalog workflow creates delivery URLs with `f_jpg,q_auto,w_1080`. This repo includes **8 representative cards**, not the entire catalog.

## 3. Airtable CRM

1. Create a base with a `Leads` table. Use the `Leads_Template` worksheet from `data/Denim_Wholesale_Agent_Data.xlsx` as the reference for **exact column names**. `data/sanitized-lead-example.csv` is a **test result**, not a multi-record production CRM database.
2. `Lead Status` options: `New`, `Browsing Catalog`, `Negotiating`, `Collecting Details`, `Qualified – Ready for Sales`, `Handed Over`, `Retail-Declined`, `Not Interested`.
3. `Business Type` options: `Retailer (shop)`, `Wholesaler`, `Online Seller`, `Boutique`, `Distributor`, `Other`. Preserve punctuation and the en dash in `Qualified – Ready for Sales` and `Lead Score (1–5)`; the workflow matches field names.
4. Create an Airtable Personal Access Token with `data.records:read` and `data.records:write` scoped to this base. Configure it privately as an n8n Airtable PAT credential.
5. Save your Base ID (`app...`) and Table ID (`tbl...`) for the main n8n `Config` node.

## 4. OpenAI

Create your OpenAI credential within n8n. Both the Agent's Chat Model and the image Product ID Vision node are configured to use `gpt-4o-mini` in the provided export.

## 5. Meta WhatsApp Cloud API

1. In the Meta Developer portal, create the appropriate Business app and add WhatsApp.
2. Verify your WhatsApp business phone, copy the **Phone Number ID** and configure a long-lived/system-user token using the least required WhatsApp permissions. Store it in an n8n **Header Auth** credential as `Authorization: Bearer <token>`.
3. Activate the production webhook verification path `denim-whatsapp`. In `Verify Token OK?`, replace `REPLACE_WITH_YOUR_PRIVATE_WEBHOOK_VERIFY_TOKEN` with a newly generated private secret and configure the exact same value in Meta WhatsApp Configuration.
4. Use the production webhook URL, verify callback, and subscribe to `messages`. The source README additionally notes that you may need to subscribe the WhatsApp Business Account to the correct app (`POST /<WABA_ID>/subscribed_apps`) to receive notifications on the intended app.
5. The original source used **Graph API v25.0**. Confirm compatibility with your current Meta application before deploying; this repository documents the tested configuration rather than claiming it is the latest version.
6. Complete applicable privacy-policy and app-publication requirements for receiving real users' messages.

### Access-token safety

The temporary token from the Meta WhatsApp API setup panel may expire. The source implementation used a System User token with WhatsApp messaging/management permissions. Never publish access tokens in workflow files, documentation or screenshots. Rotate/revoke any leaked token promptly.

## 6. Import into n8n

1. Import `workflows/denim-catalog-sender.sanitized.json`, then `workflows/denim-whatsapp-ai-sales-agent.sanitized.json`.
2. In the main workflow's `Config` node, replace `YOUR_META_PHONE_NUMBER_ID`, `YOUR_AIRTABLE_BASE_ID`, `YOUR_AIRTABLE_TABLE_ID` and confirm `GRAPH_VERSION`. Set the new private verify token in `Verify Token OK?`.
3. Attach your n8n Postgres, OpenAI, Header Auth and Airtable credentials to all appropriate nodes.
4. In **Run Catalog Sender**, explicitly select the imported **Denim – Catalog Sender** workflow. In the provided export the target workflow ID is intentionally empty; importing without selecting it will not send images.
5. Save and **publish/activate both workflows** (in supported n8n versions). Register the production webhook URL and send a test greeting to your WhatsApp business number.

## 7. Test the required scenarios

Use the scenarios in [TEST_RESULTS.md](TEST_RESULTS.md): greeting, categories, retail decline, full catalog, image Product ID recognition, two discount rounds and lower-price refusal, exact order total, buyer qualification and CRM record. Test with your own test number. For fresh repeat runs see `database/testing/06_reset_test_customer.sql`, but **review the DELETE statements** and make sure the placeholder phone is replaced with the test number, not any live buyer's number.

## Constraints

- The agent replies in English only; unsupported voice/video/sticker/document/location input prompts the buyer to type.
- Sending a business-initiated message outside Meta's active customer-service window requires applicable approved message templates; not implemented here.
- This is a portfolio implementation with demo business data; verify pricing, shipping and business policies before any real deployment.
