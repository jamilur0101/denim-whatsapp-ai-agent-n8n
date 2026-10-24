-- Denim WhatsApp AI Agent — bargaining tracker (run once in Supabase SQL Editor)
-- One row per customer + product: stage 1 = first offer (asking − 10), stage 2 = final price (lowest_price).
create table if not exists public.wa_price_offers (
  phone       text not null,
  product_id  text not null,
  stage       int  not null default 1,
  updated_at  timestamptz not null default now(),
  primary key (phone, product_id)
);
alter table public.wa_price_offers enable row level security;
revoke all on public.wa_price_offers from anon, authenticated;

select 'wa_price_offers ready' as status;
