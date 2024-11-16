create table if not exists transactions (
	ID UUID primary key default uuid_generate_v4() not NULL,
	type CHAR(1) NOT NULL CHECK (type IN ('d', 'c')),
	description varchar(10) not null,
	value integer not null CHECK (value > 0),
	client_id UUID not null,
	created_at  timestamp not null default now()
)

drop table transactions 

insert into transactions (type, description, value, client_id)
values ('d', 'yellow', 80000, 'c9f58508-b87f-4019-85fd-1c9a1d6822e1')


select
*
from transactions t 