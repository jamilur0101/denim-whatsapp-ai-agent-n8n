-- Make lowest_price and bundle_price calculate automatically.
-- After this, change only asking_price (or max_discount) and the other two update by themselves.
alter table public.products drop constraint if exists lowest_price_check;
alter table public.products drop column lowest_price, drop column bundle_price;
alter table public.products
  add column lowest_price integer generated always as (asking_price - max_discount) stored,
  add column bundle_price integer generated always as (asking_price * bundle_size) stored;

-- Keep updated_at fresh on every edit
create or replace function public.set_updated_at() returns trigger
language plpgsql set search_path = '' as $$
begin new.updated_at = now(); return new; end; $$;
drop trigger if exists products_set_updated_at on public.products;
create trigger products_set_updated_at before update on public.products
for each row execute function public.set_updated_at();

-- Check
select product_id, asking_price, lowest_price, bundle_size, bundle_price from public.products order by product_id limit 5;
