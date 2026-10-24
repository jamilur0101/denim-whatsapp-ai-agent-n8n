-- See every bargaining request: which customer asked for a discount on which product.
-- stage 1 = first offer (asking price − TK 10), stage 2 = final price (asking price − TK 20).
select phone, product_id, stage, updated_at
from public.wa_price_offers
order by updated_at desc;
