-- =====================================================================
-- Denim Wholesale WhatsApp AI Agent — tables used by n8n (run once)
-- Supabase → SQL Editor → New query → paste → Run
-- =====================================================================

-- 1) Conversation memory (used by n8n "Postgres Chat Memory" node)
create table if not exists public.n8n_chat_histories (
  id          serial primary key,
  session_id  varchar(255) not null,          -- customer WhatsApp number
  message     jsonb not null
);
create index if not exists n8n_chat_histories_session_idx on public.n8n_chat_histories (session_id);

-- 2) Processed WhatsApp message IDs (Meta can deliver the same webhook twice)
create table if not exists public.wa_processed_messages (
  message_id  text primary key,               -- WhatsApp message id (wamid...)
  wa_from     text,
  received_at timestamptz not null default now()
);

-- Security: no public API access; n8n connects as the database owner
alter table public.n8n_chat_histories    enable row level security;
alter table public.wa_processed_messages enable row level security;
revoke all on public.n8n_chat_histories, public.wa_processed_messages from anon, authenticated;

-- Check
select table_name from information_schema.tables
where table_schema = 'public' and table_name in ('products','n8n_chat_histories','wa_processed_messages')
order by table_name;
