-- the table containing the 'nicely formatted' addresses
create table addrtext (
    addr_id varchar(20) not null,
    addr text not null,
	addr_tokens int[] not null
);

CREATE TABLE phrase -- Compute 2-word phrase tokens
(addr_id varchar not null,
tokenphrase text not null);

CREATE TABLE phraseinverted -- Compute inverted index
(tokenphrase text not null,
addr_ids varchar[] not null,
frequency bigint not null);

CREATE TABLE streetabbrev
(name text not null,
abbrev text not null);