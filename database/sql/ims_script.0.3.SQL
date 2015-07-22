/*
created: 7/22/2015
modified: 7/22/2015
model: postgresql 9.4
database: postgresql 9.4
*/


-- create user data types section -------------------------------------------------

create type "direction" as
 ( enum ('in', 'out') )
;

-- create tables section -------------------------------------------------

-- table suppliers

create table "suppliers"(
 "supplier_id" bigserial not null
)
;

-- add keys for table suppliers

alter table "suppliers" add constraint "key1" primary key ("supplier_id")
;

-- table orders

create table "orders"(
 "order_id" bigserial not null,
 "supplier_id" bigint
)
;

-- create indexes for table orders

create index "ix_relationship3" on "orders" ("supplier_id")
;

-- add keys for table orders

alter table "orders" add constraint "key2" primary key ("order_id")
;

-- table raw_materials

create table "raw_materials"(
 "name" varchar not null,
 "quantity_bought" bigint,
 "cost" bigint,
 "quantity _fresh" bigint,
 "quantity_used_1" bigint,
 "quantity_used_2" bigint,
 "quantity_used_3" bigint,
 "quantity_trashed" bigint,
 "order_id" bigint not null
)
;

-- add keys for table raw_materials

alter table "raw_materials" add constraint "key3" primary key ("order_id","name")
;

-- table manufacturing

create table "manufacturing"(
 "batch_id" bigserial not null
)
;

-- add keys for table manufacturing

alter table "manufacturing" add constraint "key4" primary key ("batch_id")
;

-- table elements

create table "elements"(
 "batch_id" bigint not null,
 "order_id" bigint not null,
 "name" varchar not null,
 "in_out" "direction",
 "quantity" bigint
)
;

-- add keys for table elements

alter table "elements" add constraint "key5" primary key ("batch_id","order_id","name")
;

-- table finished_materials

create table "finished_materials"(
 "quantity_made" bigint,
 "name" varchar not null,
 "batch_id" bigint not null,
 "quantity_in_stock" bigint
)
;

-- add keys for table finished_materials

alter table "finished_materials" add constraint "key6" primary key ("name","batch_id")
;

-- table sales

create table "sales"(
 "sale_id" bigserial not null,
 "buyer_id" bigint
)
;

-- create indexes for table sales

create index "ix_relationship8" on "sales" ("buyer_id")
;

-- add keys for table sales

alter table "sales" add constraint "key7" primary key ("sale_id")
;

-- table buyers

create table "buyers"(
 "buyer_id" bigserial not null
)
;

-- add keys for table buyers

alter table "buyers" add constraint "key8" primary key ("buyer_id")
;

-- table sold

create table "sold"(
 "name" varchar not null,
 "batch_id" bigint not null,
 "sale_id" bigint not null,
 "quantity_sold" bigint,
 "price" bigint
)
;

-- add keys for table sold

alter table "sold" add constraint "key9" primary key ("name","batch_id","sale_id")
;

-- create relationships section ------------------------------------------------- 

alter table "orders" add constraint "supplier" foreign key ("supplier_id") references "suppliers" ("supplier_id") on delete no action on update no action
;

alter table "raw_materials" add constraint "order_items" foreign key ("order_id") references "orders" ("order_id") on delete no action on update no action
;

alter table "elements" add constraint "batch" foreign key ("batch_id") references "manufacturing" ("batch_id") on delete no action on update no action
;

alter table "elements" add constraint "item_in_out" foreign key ("order_id", "name") references "raw_materials" ("order_id", "name") on delete no action on update no action
;

alter table "finished_materials" add constraint "output" foreign key ("batch_id") references "manufacturing" ("batch_id") on delete no action on update no action
;

alter table "sales" add constraint "buyer" foreign key ("buyer_id") references "buyers" ("buyer_id") on delete no action on update no action
;

alter table "sold" add constraint "sale_items" foreign key ("name", "batch_id") references "finished_materials" ("name", "batch_id") on delete no action on update no action
;

alter table "sold" add constraint "sale" foreign key ("sale_id") references "sales" ("sale_id") on delete no action on update no action
;




