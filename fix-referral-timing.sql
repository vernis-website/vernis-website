-- Fixes referral codes being generated at signup (wrong) instead of
-- after a customer's first real purchase (correct — prevents misuse
-- by people who sign up but never buy anything).
-- Run this whole thing in SQL Editor → New Query → Run.

-- 1. Signup no longer generates a referral code — profile starts blank.
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id) values (new.id);
  return new;
end;
$$ language plpgsql security definer;

-- 2. A referral code is generated automatically the moment someone's
--    first order is placed — not before.
create or replace function public.generate_referral_on_first_order()
returns trigger as $$
declare
  existing_code text;
begin
  select referral_code into existing_code from public.profiles where id = new.user_id;

  if existing_code is null then
    update public.profiles
    set referral_code = 'VRN-' || upper(substring(replace(gen_random_uuid()::text,'-',''),1,6))
    where id = new.user_id;
  end if;

  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_order_created on public.orders;
create trigger on_order_created
  after insert on public.orders
  for each row execute procedure public.generate_referral_on_first_order();

grant execute on function public.generate_referral_on_first_order() to authenticated;

-- Note: this does NOT retroactively remove codes already given to
-- existing test accounts (like yours). If you want to reset your own
-- test account's code so you can verify the new behavior, run:
--
-- update public.profiles set referral_code = null, referral_uses_count = 0
-- where id = (select id from auth.users where email = 'youremail@example.com');
