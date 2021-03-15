create unique index on addrtext(addr_id);

create index on phraseinverted(tokenphrase);

create unique index address_default_geocode_address_detail_pid_idx on public.address_default_geocode USING btree (address_detail_pid);