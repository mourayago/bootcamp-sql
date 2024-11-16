create extension if not exists "uuid-ossp";

create table if not exists clients (
--id SERIAL PRIMARY KEY,
id UUID PRIMARY key default uuid_generate_v4(),
balance integer not null check (balance >= -credit_limit),
credit_limit integer not null check (credit_limit >= 0)
);

--ALTER TABLE clients AUTO_INCREMENT = 1 MYSQL

--TRUNCATE TABLE clients RESTART IDENTITY;

drop table clients 


insert into clients (balance, credit_limit)
values
(0,10000),
(0, 80000),
(0, 100000),
(0,1000000),
(0,5000)


--delete from clients c 

select * from clients c 