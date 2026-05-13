-- Run this once in Supabase SQL Editor.
-- This schema matches the current HTML app fields.

create table if not exists categories (
  id text primary key,
  name text not null,
  tokped_mall_fee numeric(6,2) not null default 0,
  tokped_regular_fee numeric(6,2) not null default 0,
  shopee_fee numeric(6,2) not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists projects (
  id text primary key,
  name text not null,
  type text not null check (type in ('marketplace_to_net_income', 'net_income_to_marketplace')),
  created_at timestamptz not null default now()
);

create table if not exists project_rows (
  id text primary key,
  project_id text not null references projects(id) on delete cascade,
  row_order integer not null default 0,
  item_name text not null default '',
  category_id text null references categories(id) on delete set null,
  source_value text not null default '',
  created_at timestamptz not null default now()
);

create index if not exists idx_project_rows_project_order
  on project_rows(project_id, row_order);

create table if not exists app_settings (
  id integer primary key check (id = 1),
  default_category_id text null references categories(id) on delete set null,
  updated_at timestamptz not null default now()
);

insert into app_settings (id)
values (1)
on conflict (id) do nothing;

alter table categories enable row level security;
alter table projects enable row level security;
alter table project_rows enable row level security;
alter table app_settings enable row level security;

drop policy if exists "public categories all" on categories;
drop policy if exists "public projects all" on projects;
drop policy if exists "public project_rows all" on project_rows;
drop policy if exists "public app_settings all" on app_settings;

create policy "public categories all"
on categories for all to anon
using (true) with check (true);

create policy "public projects all"
on projects for all to anon
using (true) with check (true);

create policy "public project_rows all"
on project_rows for all to anon
using (true) with check (true);

create policy "public app_settings all"
on app_settings for all to anon
using (true) with check (true);
