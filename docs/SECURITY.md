# Public Repository Security & Sanitization

The files in this repository are **demo/portfolio artifacts**, intended for study and reproduction. Do not use a real production number or customer database without configuring and validating your own security, consent and billing controls.

## Changes made before public sharing

- Main n8n workflow's original **Meta Phone Number ID** replaced with `YOUR_META_PHONE_NUMBER_ID`.
- **Airtable Base ID** and **Table ID** replaced with `YOUR_AIRTABLE_BASE_ID` and `YOUR_AIRTABLE_TABLE_ID`.
- The hardcoded **Meta webhook verification token** replaced with `REPLACE_WITH_YOUR_PRIVATE_WEBHOOK_VERIFY_TOKEN` (including the n8n note and IF node).
- `data/sanitized-lead-example.csv` replaces identifying buyer fields with demo placeholders while preserving the observed product IDs, quantities, status and totals.
- No n8n credentials or Bearer tokens are embedded in the supplied JSON exports; attach your own credentials in n8n after import.

## Safe public elements

- Product prices, Cloudinary image URLs, product descriptions and the business name in the SQL/product data are **fictional demonstration data**.
- The supplied 11 evidence screenshots are intentionally unedited and **may display the author's test phone number and demo buyer details**, which the author approved for public portfolio use.
- The 8 catalog cards are generated demonstration images, not genuine manufacturer-supplied product photography.

## Do not publish

- Meta access token or current verification secret, Airtable PAT, OpenAI secret, Supabase database connection password/privileged key, private webhooks, live customer records or unredacted credentials exports.
- For public sharing of Airtable, use a read-only view and verify that unintended customer/employee/secret fields are hidden. Public views can be copied by visitors.

## Important setup notes

- The original main workflow export contains an empty `Run Catalog Sender` target workflow reference. Configure this manually after import.
- A system-user Meta WhatsApp token may be configured for long-lived access but must still be secured, monitored and revoked if leaked.
- All data and screenshots are provided as evidence for a portfolio exercise, not as a production service guarantee.
