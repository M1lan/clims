/*
created: 7/6/2015
modified: 7/9/2015
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
 "item_id" serial not null,
 "name" varchar,
 "type" integer,
 "price" double precision not null,
 "quantity" "quantity"
)
;

-- add keys for table components

alter table "components" add constraint "key1" primary key ("item_id")
;

-- table employees

create table "employees"(
 "employee_id" serial not null,
 "wage_type" integer,
 "name" varchar
)
;

-- add keys for table employees

alter table "employees" add constraint "key10" primary key ("employee_id")
;

-- table customers

create table "customers"(
 "customer_id" serial not null
)
;

-- add keys for table customers

alter table "customers" add constraint "key6" primary key ("customer_id")
;

-- table jobs

create table "jobs"(
 "job_number" serial not null,
 "name" varchar,
 "type" integer,
 "finished" boolean
)
;

-- add keys for table jobs

alter table "jobs" add constraint "key7" primary key ("job_number")
;

-- table manufacturing

create table "manufacturing"(
 "date" timestamp,
 "misc_info" varchar,
 "report" varchar,
 "cost" double precision,
 "job_number" integer not null,
 "batch_number" serial not null
)
;

-- add keys for table manufacturing

alter table "manufacturing" add constraint "key2" primary key ("job_number")
;

alter table "manufacturing" add constraint "batch_number" unique ("batch_number")
;

-- table elements

create table "elements"(
 "item_id" integer not null,
 "quantity" "quantity",
 "in_out" boolean,
 "job_number" integer not null
)
;

-- add keys for table elements

alter table "elements" add constraint "key9" primary key ("item_id","job_number")
;

-- table sales

create table "sales"(
 "sale_number" serial not null,
 "date" timestamp,
 "cost" double precision,
 "customer_id" integer not null,
 "job_number" integer not null
)
;

-- create indexes for table sales

create index "ix_relationship7" on "sales" ("customer_id")
;

-- add keys for table sales

alter table "sales" add constraint "key4" primary key ("job_number")
;

alter table "sales" add constraint "sale_number" unique ("sale_number")
;

-- table sold

create table "sold"(
 "item_id" integer not null,
 "quantity" "quantity",
 "price" double precision,
 "job_number" integer not null
)
;

-- add keys for table sold

alter table "sold" add constraint "key5" primary key ("item_id","job_number")
;

-- table crafting

create table "crafting"(
 "used_in" integer not null,
 "producing" integer not null,
 "quantity" "quantity"
)
;

-- add keys for table crafting

alter table "crafting" add constraint "key3" primary key ("used_in","producing")
;

-- table administrative

create table "administrative"(
 "date" timestamp,
 "job_number" integer not null,
 "admin_number" serial not null
)
;

-- add keys for table administrative

alter table "administrative" add constraint "key8" primary key ("job_number")
;

alter table "administrative" add constraint "admin_number" unique ("admin_number")
;

-- table worked_on

create table "worked_on"(
 "employee_id" integer not null,
 "job_number" integer not null,
 "hours" double precision
)
;

-- add keys for table worked_on

alter table "worked_on" add constraint "key11" primary key ("employee_id","job_number")
;

-- table inventory

create table "inventory"(
 "employee_id" integer not null,
 "item_id" integer not null,
 "date" timestamp,
 "quantity" "quantity"
)
;

-- add keys for table inventory

alter table "inventory" add constraint "key12" primary key ("employee_id","item_id")
;

-- table equipment

create table "equipment"(
 "equipment_id" serial not null,
 "name" varchar,
 "training_manual" varchar,
 "use" varchar
)
;

-- add keys for table equipment

alter table "equipment" add constraint "key13" primary key ("equipment_id")
;

-- table trained_on

create table "trained_on"(
 "equipment_id" integer not null,
 "employee_id" integer not null
)
;

-- add keys for table trained_on

alter table "trained_on" add constraint "key14" primary key ("equipment_id","employee_id")
;

-- table equipment_used

create table "equipment_used"(
 "equipment_id" integer not null,
 "job_number" integer not null
)
;

-- add keys for table equipment_used

alter table "equipment_used" add constraint "key15" primary key ("equipment_id","job_number")
;

-- table suppliers

create table "suppliers"(
 "supplier_id" serial not null,
 "supplier_type" integer
)
;

-- add keys for table suppliers

alter table "suppliers" add constraint "key18" primary key ("supplier_id")
;

-- table orders

create table "orders"(
 "order_id" serial not null,
 "date" timestamp,
 "type" integer,
 "supplier_id" integer
)
;

-- create indexes for table orders

create index "ix_relationship30" on "orders" ("supplier_id")
;

-- add keys for table orders

alter table "orders" add constraint "key19" primary key ("order_id")
;

-- table maintenience_orders

create table "maintenience_orders"(
 "order_id" integer not null,
 "price" double precision
)
;

-- add keys for table maintenience_orders

alter table "maintenience_orders" add constraint "key24" primary key ("order_id")
;

-- table maintenience

create table "maintenience"(
 "maintenience_id" serial not null,
 "type" integer,
 "job_number" integer,
 "order_id" integer
)
;

-- create indexes for table maintenience

create index "ix_maintjob_num" on "maintenience" ("job_number")
;

create index "ix_relationship38" on "maintenience" ("order_id")
;

-- add keys for table maintenience

alter table "maintenience" add constraint "key16" primary key ("maintenience_id")
;

-- table maintained

create table "maintained"(
 "maintenience_id" integer not null,
 "equipment_id" integer not null,
 "fixed" varchar
)
;

-- add keys for table maintained

alter table "maintained" add constraint "key17" primary key ("maintenience_id","equipment_id")
;

-- table components_orders

create table "components_orders"(
 "order_id" integer not null
)
;

-- add keys for table components_orders

alter table "components_orders" add constraint "key20" primary key ("order_id")
;

-- table composed_of_components

create table "composed_of_components"(
 "order_id" integer not null,
 "item_id" integer not null,
 "quantity" "quantity",
 "price" double precision
)
;

-- add keys for table composed_of_components

alter table "composed_of_components" add constraint "key21" primary key ("order_id","item_id")
;

-- table equipment_orders

create table "equipment_orders"(
 "order_id" integer not null
)
;

-- add keys for table equipment_orders

alter table "equipment_orders" add constraint "key22" primary key ("order_id")
;

-- table composed_of_equipment

create table "composed_of_equipment"(
 "order_id" integer not null,
 "equipment_id" integer not null,
 "price" double precision,
 "quantity" "quantity"
)
;

-- add keys for table composed_of_equipment

alter table "composed_of_equipment" add constraint "key23" primary key ("order_id","equipment_id")
;

-- table recurring_costs

create table "recurring_costs"(
 "date" timestamp,
 "cost_id" serial not null,
 "type" integer,
 "amount" double precision
)
;

-- add keys for table recurring_costs

alter table "recurring_costs" add constraint "key26" primary key ("cost_id")
;

-- create relationships section ------------------------------------------------- 

alter table "crafting" add constraint "used_in" foreign key ("used_in") references "components" ("item_id") on delete no action on update no action
;

alter table "crafting" add constraint "producing" foreign key ("producing") references "components" ("item_id") on delete no action on update no action
;

alter table "sold" add constraint "sale" foreign key ("job_number") references "sales" ("job_number") on delete no action on update no action
;

alter table "sold" add constraint "sale_item" foreign key ("item_id") references "components" ("item_id") on delete no action on update no action
;

alter table "sales" add constraint "buyer" foreign key ("customer_id") references "customers" ("customer_id") on delete no action on update no action
;

alter table "administrative" add constraint "admin_job_num" foreign key ("job_number") references "jobs" ("job_number") on delete no action on update no action
;

alter table "manufacturing" add constraint "manufacture_job_num" foreign key ("job_number") references "jobs" ("job_number") on delete no action on update no action
;

alter table "elements" add constraint "manufacture_item" foreign key ("item_id") references "components" ("item_id") on delete no action on update no action
;

alter table "elements" add constraint "batch" foreign key ("job_number") references "manufacturing" ("job_number") on delete no action on update no action
;

alter table "sales" add constraint "sale_job_num" foreign key ("job_number") references "jobs" ("job_number") on delete no action on update no action
;

alter table "worked_on" add constraint "employee" foreign key ("employee_id") references "employees" ("employee_id") on delete no action on update no action
;

alter table "worked_on" add constraint "job" foreign key ("job_number") references "jobs" ("job_number") on delete no action on update no action
;

alter table "inventory" add constraint "employee_inv" foreign key ("employee_id") references "employees" ("employee_id") on delete no action on update no action
;

alter table "inventory" add constraint "inv_item" foreign key ("item_id") references "components" ("item_id") on delete no action on update no action
;

alter table "trained_on" add constraint "train_equipment" foreign key ("equipment_id") references "equipment" ("equipment_id") on delete no action on update no action
;

alter table "trained_on" add constraint "employee_train" foreign key ("employee_id") references "employees" ("employee_id") on delete no action on update no action
;

alter table "equipment_used" add constraint "equipment_used" foreign key ("equipment_id") references "equipment" ("equipment_id") on delete no action on update no action
;

alter table "equipment_used" add constraint "process" foreign key ("job_number") references "manufacturing" ("job_number") on delete no action on update no action
;

alter table "maintained" add constraint "maintain" foreign key ("maintenience_id") references "maintenience" ("maintenience_id") on delete no action on update no action
;

alter table "maintained" add constraint "equipment_fixed" foreign key ("equipment_id") references "equipment" ("equipment_id") on delete no action on update no action
;

alter table "maintenience" add constraint "maint_job_num" foreign key ("job_number") references "jobs" ("job_number") on delete no action on update no action
;

alter table "orders" add constraint "supplier" foreign key ("supplier_id") references "suppliers" ("supplier_id") on delete no action on update no action
;

alter table "components_orders" add constraint "component_order_num" foreign key ("order_id") references "orders" ("order_id") on delete no action on update no action
;

alter table "composed_of_components" add constraint "component_order" foreign key ("order_id") references "components_orders" ("order_id") on delete no action on update no action
;

alter table "composed_of_components" add constraint "order_item" foreign key ("item_id") references "components" ("item_id") on delete no action on update no action
;

alter table "equipment_orders" add constraint "equip_order_num" foreign key ("order_id") references "orders" ("order_id") on delete no action on update no action
;

alter table "composed_of_equipment" add constraint "equipment_order" foreign key ("order_id") references "equipment_orders" ("order_id") on delete no action on update no action
;

alter table "composed_of_equipment" add constraint "order_equipment" foreign key ("equipment_id") references "equipment" ("equipment_id") on delete no action on update no action
;

alter table "maintenience_orders" add constraint "maint_order_num" foreign key ("order_id") references "orders" ("order_id") on delete no action on update no action
;

alter table "maintenience" add constraint "maint_order" foreign key ("order_id") references "maintenience_orders" ("order_id") on delete no action on update no action
;




