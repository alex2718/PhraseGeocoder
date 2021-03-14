-- tidy up to remove additional spaces
insert into addrtext
select
	addr_id,
	addr,
	array_agg(val order by seq_num) as addr_tokens
from (
	select
		addr_id,
		addr,
		val[1]::int,
		seq_num
	from (
		select
				address_detail_pid as addr_id,
				(
				coalesce(building_name, '') || ' ' ||
				coalesce(lot_number_prefix::text, '') || '' ||
				coalesce(lot_number::text, '') || '' ||
				coalesce(lot_number_suffix::text, '') || ' ' ||
				coalesce(flat_type, '') || ' ' ||
				coalesce(flat_number_prefix::text, '') || '' ||
				coalesce(flat_number::text, '') || '' ||
				coalesce(flat_number_suffix::text, '') || ' ' ||
				coalesce(level_type, '') || ' ' ||
				coalesce(level_number_prefix::text, '') || '' ||
				coalesce(level_number::text, '') || '' ||
				coalesce(level_number_suffix::text, '') || ' ' ||
				coalesce(number_first_prefix::text, '') || '' ||
				coalesce(number_first::text, '') || '' ||
				coalesce(number_first_suffix::text, '') || ' ' ||
				coalesce(number_last_prefix::text, '') || '' ||
				coalesce(number_last::text, '') || '' ||
				coalesce(number_last_suffix::text, '') || ' ' ||
				coalesce(street_name, '') || ' ' ||
				coalesce(street_type_code, '') || ' ' ||
				coalesce(locality_name, '') || ' ' ||
				coalesce(street_suffix_type, '') || ' ' ||
				coalesce(state_abbreviation, '') || ' ' ||
				coalesce(postcode::text, '')
				)
				as addr
			from
				address_view a
	) a,
	regexp_matches(regexp_replace(addr, '3\d{3}$', 'g'),'\d+','g') with ordinality as addr_tokens(val, seq_num)
) a
group by
	addr_id,
	addr