/*
Created: 7/6/2015
Modified: 7/6/2015
Model: PostgreSQL 9.4
Database: PostgreSQL 9.4
*/


-- Create user data types section -------------------------------------------------

CREATE TYPE "quantity" AS
 ( units units,
amount float )
;

CREATE TYPE "units" AS ENUM
 ( 'oz', 'pounds', 'grams', 'kilograms', 'item' )
;

-- Create tables section -------------------------------------------------

-- Table components

CREATE TABLE "components"(
 "item-id" Serial NOT NULL,
 "name" Varchar,
 "type" Integer,
 "price" Double precision NOT NULL
)
;

-- Add keys for table components

ALTER TABLE "components" ADD CONSTRAINT "Key1" PRIMARY KEY ("item-id")
;

-- Table manufacturing

CREATE TABLE "manufacturing"(
 "batch-number" Serial NOT NULL,
 "date" Timestamp,
 "misc_info" Varchar,
 "report" Varchar,
 "cost" Double precision,
 "job-number" Integer NOT NULL
)
;

-- Create indexes for table manufacturing

CREATE INDEX "IX_manufacture-job-num" ON "manufacturing" ("job-number")
;

-- Add keys for table manufacturing

ALTER TABLE "manufacturing" ADD CONSTRAINT "Key2" PRIMARY KEY ("batch-number")
;

-- Table crafting

CREATE TABLE "crafting"(
 "used-in" Integer NOT NULL,
 "producing" Integer NOT NULL,
 "quantity" "quantity",
 "labor-time" Double precision
)
;

-- Add keys for table crafting

ALTER TABLE "crafting" ADD CONSTRAINT "Key3" PRIMARY KEY ("used-in","producing")
;

-- Table sales

CREATE TABLE "sales"(
 "sale-number" Serial NOT NULL,
 "date" Timestamp,
 "cost" Double precision,
 "customer-id" Integer NOT NULL,
 "job-number" Integer
)
;

-- Create indexes for table sales

CREATE INDEX "IX_Relationship7" ON "sales" ("customer-id")
;

CREATE INDEX "IX_Relationship15" ON "sales" ("job-number")
;

-- Add keys for table sales

ALTER TABLE "sales" ADD CONSTRAINT "Key4" PRIMARY KEY ("sale-number")
;

-- Table sold

CREATE TABLE "sold"(
 "sale-number" Integer NOT NULL,
 "item-id" Integer NOT NULL,
 "quantity" "quantity",
 "price" Double precision
)
;

-- Add keys for table sold

ALTER TABLE "sold" ADD CONSTRAINT "Key5" PRIMARY KEY ("sale-number","item-id")
;

-- Table customers

CREATE TABLE "customers"(
 "customer-id" Serial NOT NULL
)
;

-- Add keys for table customers

ALTER TABLE "customers" ADD CONSTRAINT "Key6" PRIMARY KEY ("customer-id")
;

-- Table job

CREATE TABLE "job"(
 "job-number" Serial NOT NULL,
 "name" Varchar,
 "type" Integer,
 "finished" Boolean
)
;

-- Add keys for table job

ALTER TABLE "job" ADD CONSTRAINT "Key7" PRIMARY KEY ("job-number")
;

-- Table administrative

CREATE TABLE "administrative"(
 "admin-number" Serial NOT NULL,
 "date" Timestamp,
 "job-number" Integer NOT NULL
)
;

-- Create indexes for table administrative

CREATE INDEX "IX_admin-job-num" ON "administrative" ("job-number")
;

-- Add keys for table administrative

ALTER TABLE "administrative" ADD CONSTRAINT "Key8" PRIMARY KEY ("admin-number")
;

-- Table ekements

CREATE TABLE "ekements"(
 "item-id" Integer NOT NULL,
 "batch-number" Integer NOT NULL,
 "quantity" "quantity",
 "in-out" Boolean
)
;

-- Add keys for table ekements

ALTER TABLE "ekements" ADD CONSTRAINT "Key9" PRIMARY KEY ("item-id","batch-number")
;

-- Table employees

CREATE TABLE "employees"(
 "employee-id" Serial NOT NULL,
 "wage-type" Integer
)
;

-- Add keys for table employees

ALTER TABLE "employees" ADD CONSTRAINT "Key10" PRIMARY KEY ("employee-id")
;

-- Table worked-on

CREATE TABLE "worked-on"(
 "employee-id" Integer NOT NULL,
 "job-number" Integer NOT NULL,
 "hours" Double precision
)
;

-- Add keys for table worked-on

ALTER TABLE "worked-on" ADD CONSTRAINT "Key11" PRIMARY KEY ("employee-id","job-number")
;

-- Table inventory

CREATE TABLE "inventory"(
 "employee-id" Integer NOT NULL,
 "item-id" Integer NOT NULL,
 "date" Timestamp,
 "quantity" "quantity"
)
;

-- Add keys for table inventory

ALTER TABLE "inventory" ADD CONSTRAINT "Key12" PRIMARY KEY ("employee-id","item-id")
;

-- Table equipment

CREATE TABLE "equipment"(
 "equipment-id" Serial NOT NULL,
 "name" Varchar,
 "training-manual" Varchar,
 "use" Varchar
)
;

-- Add keys for table equipment

ALTER TABLE "equipment" ADD CONSTRAINT "Key13" PRIMARY KEY ("equipment-id")
;

-- Table trained-on

CREATE TABLE "trained-on"(
 "equipment-id" Integer NOT NULL,
 "employee-id" Integer NOT NULL
)
;

-- Add keys for table trained-on

ALTER TABLE "trained-on" ADD CONSTRAINT "Key14" PRIMARY KEY ("equipment-id","employee-id")
;

-- Table equipment-used

CREATE TABLE "equipment-used"(
 "equipment-id" Integer NOT NULL,
 "batch-number" Integer NOT NULL
)
;

-- Add keys for table equipment-used

ALTER TABLE "equipment-used" ADD CONSTRAINT "Key15" PRIMARY KEY ("equipment-id","batch-number")
;

-- Table maintenience

CREATE TABLE "maintenience"(
 "maintenience-id" Serial NOT NULL,
 "type" Integer,
 "job-number" Integer,
 "order-id" Integer
)
;

-- Create indexes for table maintenience

CREATE INDEX "IX_maintjob-num" ON "maintenience" ("job-number")
;

CREATE INDEX "IX_Relationship38" ON "maintenience" ("order-id")
;

-- Add keys for table maintenience

ALTER TABLE "maintenience" ADD CONSTRAINT "Key16" PRIMARY KEY ("maintenience-id")
;

-- Table maintained

CREATE TABLE "maintained"(
 "maintenience-id" Integer NOT NULL,
 "equipment-id" Integer NOT NULL,
 "fixed" Varchar
)
;

-- Add keys for table maintained

ALTER TABLE "maintained" ADD CONSTRAINT "Key17" PRIMARY KEY ("maintenience-id","equipment-id")
;

-- Table suppliers

CREATE TABLE "suppliers"(
 "supplier-id" Serial NOT NULL,
 "supplier-type" Integer
)
;

-- Add keys for table suppliers

ALTER TABLE "suppliers" ADD CONSTRAINT "Key18" PRIMARY KEY ("supplier-id")
;

-- Table orders

CREATE TABLE "orders"(
 "order-id" Serial NOT NULL,
 "date" Timestamp,
 "type" Integer,
 "supplier-id" Integer
)
;

-- Create indexes for table orders

CREATE INDEX "IX_Relationship30" ON "orders" ("supplier-id")
;

-- Add keys for table orders

ALTER TABLE "orders" ADD CONSTRAINT "Key19" PRIMARY KEY ("order-id")
;

-- Table components-orders

CREATE TABLE "components-orders"(
 "order-id" Integer NOT NULL
)
;

-- Add keys for table components-orders

ALTER TABLE "components-orders" ADD CONSTRAINT "Key20" PRIMARY KEY ("order-id")
;

-- Table composed-of-components

CREATE TABLE "composed-of-components"(
 "order-id" Integer NOT NULL,
 "item-id" Integer NOT NULL,
 "quantity" "quantity",
 "price" Double precision
)
;

-- Add keys for table composed-of-components

ALTER TABLE "composed-of-components" ADD CONSTRAINT "Key21" PRIMARY KEY ("order-id","item-id")
;

-- Table equipment-orders

CREATE TABLE "equipment-orders"(
 "order-id" Integer NOT NULL
)
;

-- Add keys for table equipment-orders

ALTER TABLE "equipment-orders" ADD CONSTRAINT "Key22" PRIMARY KEY ("order-id")
;

-- Table composed-of-equipment

CREATE TABLE "composed-of-equipment"(
 "order-id" Integer NOT NULL,
 "equipment-id" Integer NOT NULL,
 "price" Double precision,
 "quantity" "quantity"
)
;

-- Add keys for table composed-of-equipment

ALTER TABLE "composed-of-equipment" ADD CONSTRAINT "Key23" PRIMARY KEY ("order-id","equipment-id")
;

-- Table maintenience-orders

CREATE TABLE "maintenience-orders"(
 "order-id" Integer NOT NULL,
 "price" Double precision
)
;

-- Add keys for table maintenience-orders

ALTER TABLE "maintenience-orders" ADD CONSTRAINT "Key24" PRIMARY KEY ("order-id")
;

-- Create relationships section ------------------------------------------------- 

ALTER TABLE "crafting" ADD CONSTRAINT "used-in" FOREIGN KEY ("used-in") REFERENCES "components" ("item-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "crafting" ADD CONSTRAINT "producing" FOREIGN KEY ("producing") REFERENCES "components" ("item-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "sold" ADD CONSTRAINT "sale" FOREIGN KEY ("sale-number") REFERENCES "sales" ("sale-number") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "sold" ADD CONSTRAINT "sale-item" FOREIGN KEY ("item-id") REFERENCES "components" ("item-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "sales" ADD CONSTRAINT "buyer" FOREIGN KEY ("customer-id") REFERENCES "customers" ("customer-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "administrative" ADD CONSTRAINT "admin-job-num" FOREIGN KEY ("job-number") REFERENCES "job" ("job-number") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "manufacturing" ADD CONSTRAINT "manufacture-job-num" FOREIGN KEY ("job-number") REFERENCES "job" ("job-number") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "ekements" ADD CONSTRAINT "manufacture-item" FOREIGN KEY ("item-id") REFERENCES "components" ("item-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "ekements" ADD CONSTRAINT "batch" FOREIGN KEY ("batch-number") REFERENCES "manufacturing" ("batch-number") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "sales" ADD CONSTRAINT "sale-job-num" FOREIGN KEY ("job-number") REFERENCES "job" ("job-number") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "worked-on" ADD CONSTRAINT "employee" FOREIGN KEY ("employee-id") REFERENCES "employees" ("employee-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "worked-on" ADD CONSTRAINT "job" FOREIGN KEY ("job-number") REFERENCES "job" ("job-number") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "inventory" ADD CONSTRAINT "employee" FOREIGN KEY ("employee-id") REFERENCES "employees" ("employee-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "inventory" ADD CONSTRAINT "inv-item" FOREIGN KEY ("item-id") REFERENCES "components" ("item-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "trained-on" ADD CONSTRAINT "train-equipment" FOREIGN KEY ("equipment-id") REFERENCES "equipment" ("equipment-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "trained-on" ADD CONSTRAINT "employee" FOREIGN KEY ("employee-id") REFERENCES "employees" ("employee-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "equipment-used" ADD CONSTRAINT "equipment-used" FOREIGN KEY ("equipment-id") REFERENCES "equipment" ("equipment-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "equipment-used" ADD CONSTRAINT "process" FOREIGN KEY ("batch-number") REFERENCES "manufacturing" ("batch-number") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "maintained" ADD CONSTRAINT "maintenience-order" FOREIGN KEY ("maintenience-id") REFERENCES "maintenience" ("maintenience-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "maintained" ADD CONSTRAINT "equipment-fixed" FOREIGN KEY ("equipment-id") REFERENCES "equipment" ("equipment-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "maintenience" ADD CONSTRAINT "maint-job-num" FOREIGN KEY ("job-number") REFERENCES "job" ("job-number") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "orders" ADD CONSTRAINT "supplier" FOREIGN KEY ("supplier-id") REFERENCES "suppliers" ("supplier-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "components-orders" ADD CONSTRAINT "component-order-num" FOREIGN KEY ("order-id") REFERENCES "orders" ("order-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "composed-of-components" ADD CONSTRAINT "component-order" FOREIGN KEY ("order-id") REFERENCES "components-orders" ("order-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "composed-of-components" ADD CONSTRAINT "order-item" FOREIGN KEY ("item-id") REFERENCES "components" ("item-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "equipment-orders" ADD CONSTRAINT "equip-order-num" FOREIGN KEY ("order-id") REFERENCES "orders" ("order-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "composed-of-equipment" ADD CONSTRAINT "equipment-order" FOREIGN KEY ("order-id") REFERENCES "equipment-orders" ("order-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "composed-of-equipment" ADD CONSTRAINT "order-equipment" FOREIGN KEY ("equipment-id") REFERENCES "equipment" ("equipment-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "maintenience-orders" ADD CONSTRAINT "maint-order-num" FOREIGN KEY ("order-id") REFERENCES "orders" ("order-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "maintenience" ADD CONSTRAINT "maint-order" FOREIGN KEY ("order-id") REFERENCES "maintenience-orders" ("order-id") ON DELETE NO ACTION ON UPDATE NO ACTION
;





