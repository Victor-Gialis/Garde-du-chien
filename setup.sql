-- Garde du chien : création des tables
-- À coller dans Supabase > SQL Editor > New query, puis "Run".

create table if not exists tarifs (
  code text primary key check (code in ('j','n')),
  prix numeric not null check (prix >= 0)
);

create table if not exists gardes (
  id bigint generated always as identity primary key,
  date date not null unique,
  type text not null check (type in ('j','n'))
);

create table if not exists paiements (
  mois text primary key check (mois ~ '^\d{4}-\d{2}$'),
  paye boolean not null default false
);

-- Accès ouvert à toute personne qui a le lien (clé publique "anon")
alter table tarifs enable row level security;
alter table gardes enable row level security;
alter table paiements enable row level security;

create policy "acces ouvert tarifs" on tarifs for all to anon using (true) with check (true);
create policy "acces ouvert gardes" on gardes for all to anon using (true) with check (true);
create policy "acces ouvert paiements" on paiements for all to anon using (true) with check (true);

-- Tarifs (modifiables ensuite depuis la page)
insert into tarifs (code, prix) values ('j', 25), ('n', 30)
on conflict (code) do nothing;
