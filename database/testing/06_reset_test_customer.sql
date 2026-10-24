-- Reset ONE test customer (chat memory + bargaining history). Replace the number, then Run.
-- Use only for testing; also delete that customer's row in Airtable by hand if you want a clean lead.
delete from public.n8n_chat_histories  where session_id = '8801XXXXXXXXX';
delete from public.wa_price_offers     where phone      = '8801XXXXXXXXX';
select 'test customer reset' as status;
