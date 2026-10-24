# Requirements Coverage & Bonus Features

The table and features below reflect the project's provided `README.txt` (sections 1–4 and 7–10). **Client requirements** are distinguished from the **additional functionality independently implemented**. The project is a demonstration based on a genuine prospective-client brief, not an official client deployment.

## Client brief → implementation

| Original requirement | Implementation | Evidence |
| --- | --- | --- |
| Handle wholesale buyers; politely decline retail | Wholesale-only policy, minimum one bundle/design; retail lead marked `Retail-Declined` | Screenshot 01 |
| Deliver approximately 120 catalog images in groups of 20, with pauses | Dedicated n8n Catalog Sender; six batches; 15-second interval; Cloudinary image delivery | Screenshots 02, 07, 11 |
| Identify products from screenshots and give accurate information | OpenAI Vision reads printed Product ID → database lookup → exact prices, sizes, bundle and stock details | Screenshot 03 |
| Allow bargaining, no more than TK 20 per piece | SQL-maintained stages; first TK 10 reduction; second TK 20 reduction labeled final; refuse further reduction | Screenshots 04, 10 |
| Collect qualified buyers for Sales Team | Airtable single-lead record, buyer/order fields, status `Qualified – Ready for Sales` | Final conversation, sanitized CSV, Airtable shared view |

## Bonus features beyond the client brief

1. **Segment-only catalog** — buyer can ask for Adult Male, Adult Female, Kids Boy, or Kids Girl pictures instead of all 120 designs.
2. **Product search** — supports segment, a color/fit/style keyword and maximum per-piece budget (for example black jeans under TK 700).
3. **Exact database order totals** — calculates pieces, agreed price per piece, line totals, bundles and full total through SQL tools, not model arithmetic.
4. **Seven buyer-detail checks** — name, shop/business name, business type, city, full delivery address, payment method, requested delivery date; qualification waits for completeness.
5. **Lead scoring & progression** — 1–5 score; New → Browsing Catalog → Negotiating → Collecting Details → Qualified – Ready for Sales; Handed Over, Retail-Declined and Not Interested are also supported.
6. **Cumulative lead merging** — previously discussed Product IDs, highest score and qualified status are preserved when the same buyer returns.
7. **Human handover on request** — if buyer asks for a real person/call, lead is marked `Handed Over` and human sales follow-up is promised; automated sales-team notification is **not** implemented.
8. **Customer-specific memory** — last 20 messages stored in Supabase, keyed by the buyer's WhatsApp number.
9. **Policy-grounded business FAQs** — minimum order value, payments, dispatch and courier delivery, samples, private label, returns and sales hours use configured business policy.
10. **Read receipts & typing indicator** while the agent prepares its reply.
11. **Duplicate webhook handling** — `wa_processed_messages` prevents reprocessing the same inbound message ID.
12. **Unsupported media handling** — voice notes, video, stickers, documents and locations trigger a request for a typed message; voice transcription is not implemented.
13. **Short natural greetings** — a simple “Hi” is not answered with an entire catalog or long wall of prices.
14. **Fallback reply** — customers still get a polite message if model processing fails.
15. **24/7 automated replies** — separate from the human team's Saturday–Thursday, 10:00–19:00 local business hours.

## Natural-language request examples

| Buyer request | Expected system action |
| --- | --- |
| “Show me only kids girl jeans” | Sends only Kids Girl images (24 demo designs) |
| “What do you sell?” | Lists four segments, counts and price ranges, **no unsolicited images** |
| “Any black jeans under 700 taka?” | Returns a short, database-backed product list |
| “How much is PD045?” | Calls `get_product` for exact details |
| Screenshot with readable Product ID | Vision extraction, Supabase lookup, exact product response |
| “Give me a discount on all three” | Calls `request_discount` separately per discussed product |
| “I'll take two bundles of each” | Calls `calculate_order` for the totals; requests missing buyer details |
| “Can someone call me?” | Marks lead `Handed Over` for human follow-up |

## Business-specific demo policy

The source implements **wholesale only**, minimum one bundle per design, a demo minimum order value of **TK 30,000**, and a demo maximum reduction of **TK 20 per piece**. Its generated prices, products, business name and stock are demonstration data and must be replaced for real-business use.

See [TEST_RESULTS.md](TEST_RESULTS.md) for observed test evidence and [IMPLEMENTATION_NOTES.md](IMPLEMENTATION_NOTES.md) for design decisions.
