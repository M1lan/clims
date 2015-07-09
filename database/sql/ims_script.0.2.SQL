/*
created: 7/6/2015
modified: 7/7/2015
model: postgresql 9.4
database: postgresql 9.4
*/


-- create user data types section -------------------------------------------------

create type "units" as enum
 ( 'oz', 'pounds', 'grams', 'kilograms', 'item' )
;

create type "quantity" as
 ( units units,
amount float )
;

-- create tables section -------------------------------------------------

-- table components

create table "components"(
 "item-id" serial not null,
 "name" varchar,
 "type" integer,
 "price" double precision not null
)
;

-- add keys for table components

alter table "components" add constraint "key1" primary key ("item-id")
;

-- table employees

create table "employees"(
 "employee-id" serial not null,
 "wage-type" integer
)
;

-- add keys for table employees

alter table "employees" add constraint "key10" primary key ("employee-id")
;

-- table customers

create table "customers"(
 "customer-id" serial not null
)
;

-- add keys for table customers

alter table "customers" add constraint "key6" primary key ("customer-id")
;

-- table job

create table "job"(
 "job-number" serial not null,
 "name" varchar,
 "type" integer,
 "finished" boolean
)
;

-- add keys for table job

alter table "job" add constraint "key7" primary key ("job-number")
;

-- table manufacturing

create table "manufacturing"(
 "date" timestamp,
 "misc_info" varchar,
 "report" varchar,
 "cost" double precision,
 "job-number" integer not null,
 "batch-number" serial not null
)
;

-- add keys for table manufacturing

alter table "manufacturing" add constraint "key2" primary key ("job-number")
;

alter table "manufacturing" add constraint "batch-number" unique ("batch-number")
;

-- table elements

create table "elements"(
 "item-id" integer not null,
 "quantity" "quantity",
 "in-out" boolean,
 "job-number" integer not null
)
;

-- add keys for table elements

alter table "elements" add constraint "key9" primary key ("item-id","job-number")
;

-- table sales

create table "sales"(
 "sale-number" serial not null,
 "date" timestamp,
 "cost" double precision,
 "customer-id" integer not null,
 "job-number" integer not null
)
;

-- create indexes for table sales

create index "ix_relationship7" on "sales" ("customer-id")
;

-- add keys for table sales

alter table "sales" add constraint "key4" primary key ("job-number")
;

alter table "sales" add constraint "sale-number" unique ("sale-number")
;

-- table sold

create table "sold"(
 "item-id" integer not null,
 "quantity" "quantity",
 "price" double precision,
 "job-number" integer not null
)
;

-- add keys for table sold

alter table "sold" add constraint "key5" primary key ("item-id","job-number")
;

-- table crafting

create table "crafting"(
 "used-in" integer not null,
 "producing" integer not null,
 "quantity" "quantity",
 "labor-time" double precision
)
;

-- add keys for table crafting

alter table "crafting" add constraint "key3" primary key ("used-in","producing")
;

-- table administrative

create table "administrative"(
 "date" timestamp,
 "job-number" integer not null,
 "admin-number" serial not null
)
;

-- add keys for table administrative

alter table "administrative" add constraint "key8" primary key ("job-number")
;

alter table "administrative" add constraint "admin-number" unique ("admin-number")
;

-- table worked-on

create table "worked-on"(
 "employee-id" integer not null,
 "job-number" integer not null,
 "hours" double precision
)
;

-- add keys for table worked-on

alter table "worked-on" add constraint "key11" primary key ("employee-id","job-number")
;

-- table inventory

create table "inventory"(
 "employee-id" integer not null,
 "item-id" integer not null,
 "date" timestamp,
 "quantity" "quantity"
)
;

-- add keys for table inventory

alter table "inventory" add constraint "key12" primary key ("employee-id","item-id")
;

-- table equipment

create table "equipment"(
 "equipment-id" serial not null,
 "name" varchar,
 "training-manual" varchar,
 "use" varchar
)
;

-- add keys for table equipment

alter table "equipment" add constraint "key13" primary key ("equipment-id")
;

-- table trained-on

create table "trained-on"(
 "equipment-id" integer not null,
 "employee-id" integer not null
)
;

-- add keys for table trained-on

alter table "trained-on" add constraint "key14" primary key ("equipment-id","employee-id")
;

-- table equipment-used

create table "equipment-used"(
 "equipment-id" integer not null,
 "job-number" integer not null
)
;

-- add keys for table equipment-used

alter table "equipment-used" add constraint "key15" primary key ("equipment-id","job-number")
;

-- table suppliers

create table "suppliers"(
 "supplier-id" serial not null,
 "supplier-type" integer
)
;

-- add keys for table suppliers

alter table "suppliers" add constraint "key18" primary key ("supplier-id")
;

-- table orders

create table "orders"(
 "order-id" serial not null,
 "date" timestamp,
 "type" integer,
 "supplier-id" integer
)
;

-- create indexes for table orders

create index "ix_relationship30" on "orders" ("supplier-id")
;

-- add keys for table orders

alter table "orders" add constraint "key19" primary key ("order-id")
;

-- table maintenience-orders

create table "maintenience-orders"(
 "order-id" integer not null,
 "price" double precision
)
;

-- add keys for table maintenience-orders

alter table "maintenience-orders" add constraint "key24" primary key ("order-id")
;

-- table maintenience

create table "maintenience"(
 "maintenience-id" serial not null,
 "type" integer,
 "job-number" integer,
 "order-id" integer
)
;

-- create indexes for table maintenience

create index "ix_maintjob-num" on "maintenience" ("job-number")
;

create index "ix_relationship38" on "maintenience" ("order-id")
;

-- add keys for table maintenience

alter table "maintenience" add constraint "key16" primary key ("maintenience-id")
;

-- table maintained

create table "maintained"(
 "maintenience-id" integer not null,
 "equipment-id" integer not null,
 "fixed" varchar
)
;

-- add keys for table maintained

alter table "maintained" add constraint "key17" primary key ("maintenience-id","equipment-id")
;

-- table components-orders

create table "components-orders"(
 "order-id" integer not null
)
;

-- add keys for table components-orders

alter table "components-orders" add constraint "key20" primary key ("order-id")
;

-- table composed-of-components

create table "composed-of-components"(
 "order-id" integer not null,
 "item-id" integer not null,
 "quantity" "quantity",
 "price" double precision
)
;

-- add keys for table composed-of-components

alter table "composed-of-components" add constraint "key21" primary key ("order-id","item-id")
;

-- table equipment-orders

create table "equipment-orders"(
 "order-id" integer not null
)
;

-- add keys for table equipment-orders

alter table "equipment-orders" add constraint "key22" primary key ("order-id")
;

-- table composed-of-equipment

create table "composed-of-equipment"(
 "order-id" integer not null,
 "equipment-id" integer not null,
 "price" double precision,
 "quantity" "quantity"
)
;

-- add keys for table composed-of-equipment

alter table "composed-of-equipment" add constraint "key23" primary key ("order-id","equipment-id")
;

-- table recurring-costs

create table "recurring-costs"(
 "date" timestamp,
 "cost-id" serial not null,
 "type" integer,
 "amount" double precision
)
;

-- add keys for table recurring-costs

alter table "recurring-costs" add constraint "key26" primary key ("cost-id")
;

-- create relationships section ------------------------------------------------- 

alter table "crafting" add constraint "used-in" foreign key ("used-in") references "components" ("item-id") on delete no action on update no action
;

alter table "crafting" add constraint "producing" foreign key ("producing") references "components" ("item-id") on delete no action on update no action
;

alter table "sold" add constraint "sale" foreign key ("job-number") references "sales" ("job-number") on delete no action on update no action
;

alter table "sold" add constraint "sale-item" foreign key ("item-id") references "components" ("item-id") on delete no action on update no action
;

alter table "sales" add constraint "buyer" foreign key ("customer-id") references "customers" ("customer-id") on delete no action on update no action
;

alter table "administrative" add constraint "admin-job-num" foreign key ("job-number") references "job" ("job-number") on delete no action on update no action
;

alter table "manufacturing" add constraint "manufacture-job-num" foreign key ("job-number") references "job" ("job-number") on delete no action on update no action
;

alter table "elements" add constraint "manufacture-item" foreign key ("item-id") references "components" ("item-id") on delete no action on update no action
;

alter table "elements" add constraint "batch" foreign key ("job-number") references "manufacturing" ("job-number") on delete no action on update no action
;

alter table "sales" add constraint "sale-job-num" foreign key ("job-number") references "job" ("job-number") on delete no action on update no action
;

alter table "worked-on" add constraint "employee" foreign key ("employee-id") references "employees" ("employee-id") on delete no action on update no action
;

alter table "worked-on" add constraint "job" foreign key ("job-number") references "job" ("job-number") on delete no action on update no action
;

alter table "inventory" add constraint "employee-inv" foreign key ("employee-id") references "employees" ("employee-id") on delete no action on update no action
;

alter table "inventory" add constraint "inv-item" foreign key ("item-id") references "components" ("item-id") on delete no action on update no action
;

alter table "trained-on" add constraint "train-equipment" foreign key ("equipment-id") references "equipment" ("equipment-id") on delete no action on update no action
;

alter table "trained-on" add constraint "employee-train" foreign key ("employee-id") references "employees" ("employee-id") on delete no action on update no action
;

alter table "equipment-used" add constraint "equipment-used" foreign key ("equipment-id") references "equipment" ("equipment-id") on delete no action on update no action
;

alter table "equipment-used" add constraint "process" foreign key ("job-number") references "manufacturing" ("job-number") on delete no action on update no action
;

alter table "maintained" add constraint "maintain" foreign key ("maintenience-id") references "maintenience" ("maintenience-id") on delete no action on update no action
;

alter table "maintained" add constraint "equipment-fixed" foreign key ("equipment-id") references "equipment" ("equipment-id") on delete no action on update no action
;

alter table "maintenience" add constraint "maint-job-num" foreign key ("job-number") references "job" ("job-number") on delete no action on update no action
;

alter table "orders" add constraint "supplier" foreign key ("supplier-id") references "suppliers" ("supplier-id") on delete no action on update no action
;

alter table "components-orders" add constraint "component-order-num" foreign key ("order-id") references "orders" ("order-id") on delete no action on update no action
;

alter table "composed-of-components" add constraint "component-order" foreign key ("order-id") references "components-orders" ("order-id") on delete no action on update no action
;

alter table "composed-of-components" add constraint "order-item" foreign key ("item-id") references "components" ("item-id") on delete no action on update no action
;

alter table "equipment-orders" add constraint "equip-order-num" foreign key ("order-id") references "orders" ("order-id") on delete no action on update no action
;

alter table "composed-of-equipment" add constraint "equipment-order" foreign key ("order-id") references "equipment-orders" ("order-id") on delete no action on update no action
;

alter table "composed-of-equipment" add constraint "order-equipment" foreign key ("equipment-id") references "equipment" ("equipment-id") on delete no action on update no action
;

alter table "maintenience-orders" add constraint "maint-order-num" foreign key ("order-id") references "orders" ("order-id") on delete no action on update no action
;

alter table "maintenience" add constraint "maint-order" foreign key ("order-id") references "maintenience-orders" ("order-id") on delete no action on update no action
;




