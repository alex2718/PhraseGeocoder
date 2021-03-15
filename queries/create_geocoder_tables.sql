CREATE EXTENSION pg_trgm;

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