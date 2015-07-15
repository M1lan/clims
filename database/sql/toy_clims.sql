--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: units; Type: TYPE; Schema: public; Owner: clims_user
--

CREATE TYPE units AS ENUM (
    'oz',
    'pounds',
    'grams',
    'kilograms',
    'item'
);


ALTER TYPE units OWNER TO clims_user;

--
-- Name: quantity; Type: TYPE; Schema: public; Owner: clims_user
--

CREATE TYPE quantity AS (
	units units,
	amount double precision
);


ALTER TYPE quantity OWNER TO clims_user;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: administrative; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE administrative (
    date timestamp without time zone,
    job_number integer NOT NULL,
    admin_number integer NOT NULL
);


ALTER TABLE administrative OWNER TO clims_user;

--
-- Name: administrative_admin_number_seq; Type: SEQUENCE; Schema: public; Owner: clims_user
--

CREATE SEQUENCE administrative_admin_number_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE administrative_admin_number_seq OWNER TO clims_user;

--
-- Name: administrative_admin_number_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clims_user
--

ALTER SEQUENCE administrative_admin_number_seq OWNED BY administrative.admin_number;


--
-- Name: almanac; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE almanac (
    date date
);


ALTER TABLE almanac OWNER TO clims_user;

--
-- Name: components; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE components (
    item_id integer NOT NULL,
    name character varying,
    type integer,
    price double precision NOT NULL,
    quantity quantity
);


ALTER TABLE components OWNER TO clims_user;

--
-- Name: components_item_id_seq; Type: SEQUENCE; Schema: public; Owner: clims_user
--

CREATE SEQUENCE components_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE components_item_id_seq OWNER TO clims_user;

--
-- Name: components_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clims_user
--

ALTER SEQUENCE components_item_id_seq OWNED BY components.item_id;


--
-- Name: components_orders; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE components_orders (
    order_id integer NOT NULL
);


ALTER TABLE components_orders OWNER TO clims_user;

--
-- Name: composed_of_components; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE composed_of_components (
    order_id integer NOT NULL,
    item_id integer NOT NULL,
    quantity quantity,
    price double precision
);


ALTER TABLE composed_of_components OWNER TO clims_user;

--
-- Name: composed_of_equipment; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE composed_of_equipment (
    order_id integer NOT NULL,
    equipment_id integer NOT NULL,
    price double precision,
    quantity quantity
);


ALTER TABLE composed_of_equipment OWNER TO clims_user;

--
-- Name: crafting; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE crafting (
    used_in integer NOT NULL,
    producing integer NOT NULL,
    quantity quantity
);


ALTER TABLE crafting OWNER TO clims_user;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE customers (
    customer_id integer NOT NULL
);


ALTER TABLE customers OWNER TO clims_user;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: clims_user
--

CREATE SEQUENCE customers_customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customers_customer_id_seq OWNER TO clims_user;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clims_user
--

ALTER SEQUENCE customers_customer_id_seq OWNED BY customers.customer_id;


--
-- Name: elements; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE elements (
    item_id integer NOT NULL,
    quantity quantity,
    in_out boolean,
    job_number integer NOT NULL
);


ALTER TABLE elements OWNER TO clims_user;

--
-- Name: employees; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE employees (
    employee_id integer NOT NULL,
    wage_type integer,
    name character varying
);


ALTER TABLE employees OWNER TO clims_user;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: clims_user
--

CREATE SEQUENCE employees_employee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE employees_employee_id_seq OWNER TO clims_user;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clims_user
--

ALTER SEQUENCE employees_employee_id_seq OWNED BY employees.employee_id;


--
-- Name: equipment; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE equipment (
    equipment_id integer NOT NULL,
    name character varying,
    training_manual character varying,
    use character varying
);


ALTER TABLE equipment OWNER TO clims_user;

--
-- Name: equipment_equipment_id_seq; Type: SEQUENCE; Schema: public; Owner: clims_user
--

CREATE SEQUENCE equipment_equipment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE equipment_equipment_id_seq OWNER TO clims_user;

--
-- Name: equipment_equipment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clims_user
--

ALTER SEQUENCE equipment_equipment_id_seq OWNED BY equipment.equipment_id;


--
-- Name: equipment_orders; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE equipment_orders (
    order_id integer NOT NULL
);


ALTER TABLE equipment_orders OWNER TO clims_user;

--
-- Name: equipment_used; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE equipment_used (
    equipment_id integer NOT NULL,
    job_number integer NOT NULL
);


ALTER TABLE equipment_used OWNER TO clims_user;

--
-- Name: inventory; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE inventory (
    employee_id integer NOT NULL,
    item_id integer NOT NULL,
    date timestamp without time zone,
    quantity quantity
);


ALTER TABLE inventory OWNER TO clims_user;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE jobs (
    job_number integer NOT NULL,
    name character varying,
    type integer,
    finished boolean
);


ALTER TABLE jobs OWNER TO clims_user;

--
-- Name: jobs_job_number_seq; Type: SEQUENCE; Schema: public; Owner: clims_user
--

CREATE SEQUENCE jobs_job_number_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE jobs_job_number_seq OWNER TO clims_user;

--
-- Name: jobs_job_number_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clims_user
--

ALTER SEQUENCE jobs_job_number_seq OWNED BY jobs.job_number;


--
-- Name: maintained; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE maintained (
    maintenience_id integer NOT NULL,
    equipment_id integer NOT NULL,
    fixed character varying
);


ALTER TABLE maintained OWNER TO clims_user;

--
-- Name: maintenience; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE maintenience (
    maintenience_id integer NOT NULL,
    type integer,
    job_number integer,
    order_id integer
);


ALTER TABLE maintenience OWNER TO clims_user;

--
-- Name: maintenience_maintenience_id_seq; Type: SEQUENCE; Schema: public; Owner: clims_user
--

CREATE SEQUENCE maintenience_maintenience_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maintenience_maintenience_id_seq OWNER TO clims_user;

--
-- Name: maintenience_maintenience_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clims_user
--

ALTER SEQUENCE maintenience_maintenience_id_seq OWNED BY maintenience.maintenience_id;


--
-- Name: maintenience_orders; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE maintenience_orders (
    order_id integer NOT NULL,
    price double precision
);


ALTER TABLE maintenience_orders OWNER TO clims_user;

--
-- Name: manufacturing; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE manufacturing (
    date timestamp without time zone,
    misc_info character varying,
    report character varying,
    cost double precision,
    job_number integer NOT NULL,
    batch_number integer NOT NULL
);


ALTER TABLE manufacturing OWNER TO clims_user;

--
-- Name: manufacturing_batch_number_seq; Type: SEQUENCE; Schema: public; Owner: clims_user
--

CREATE SEQUENCE manufacturing_batch_number_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE manufacturing_batch_number_seq OWNER TO clims_user;

--
-- Name: manufacturing_batch_number_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clims_user
--

ALTER SEQUENCE manufacturing_batch_number_seq OWNED BY manufacturing.batch_number;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE orders (
    order_id integer NOT NULL,
    date timestamp without time zone,
    type integer,
    supplier_id integer
);


ALTER TABLE orders OWNER TO clims_user;

--
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: clims_user
--

CREATE SEQUENCE orders_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE orders_order_id_seq OWNER TO clims_user;

--
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clims_user
--

ALTER SEQUENCE orders_order_id_seq OWNED BY orders.order_id;


--
-- Name: recurring_costs; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE recurring_costs (
    date timestamp without time zone,
    cost_id integer NOT NULL,
    type integer,
    amount double precision
);


ALTER TABLE recurring_costs OWNER TO clims_user;

--
-- Name: recurring_costs_cost_id_seq; Type: SEQUENCE; Schema: public; Owner: clims_user
--

CREATE SEQUENCE recurring_costs_cost_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE recurring_costs_cost_id_seq OWNER TO clims_user;

--
-- Name: recurring_costs_cost_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clims_user
--

ALTER SEQUENCE recurring_costs_cost_id_seq OWNED BY recurring_costs.cost_id;


--
-- Name: sales; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE sales (
    sale_number integer NOT NULL,
    date timestamp without time zone,
    cost double precision,
    customer_id integer NOT NULL,
    job_number integer NOT NULL
);


ALTER TABLE sales OWNER TO clims_user;

--
-- Name: sales_sale_number_seq; Type: SEQUENCE; Schema: public; Owner: clims_user
--

CREATE SEQUENCE sales_sale_number_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales_sale_number_seq OWNER TO clims_user;

--
-- Name: sales_sale_number_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clims_user
--

ALTER SEQUENCE sales_sale_number_seq OWNED BY sales.sale_number;


--
-- Name: sold; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE sold (
    item_id integer NOT NULL,
    quantity quantity,
    price double precision,
    job_number integer NOT NULL
);


ALTER TABLE sold OWNER TO clims_user;

--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE suppliers (
    supplier_id integer NOT NULL,
    supplier_type integer
);


ALTER TABLE suppliers OWNER TO clims_user;

--
-- Name: suppliers_supplier_id_seq; Type: SEQUENCE; Schema: public; Owner: clims_user
--

CREATE SEQUENCE suppliers_supplier_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE suppliers_supplier_id_seq OWNER TO clims_user;

--
-- Name: suppliers_supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: clims_user
--

ALTER SEQUENCE suppliers_supplier_id_seq OWNED BY suppliers.supplier_id;


--
-- Name: trained_on; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE trained_on (
    equipment_id integer NOT NULL,
    employee_id integer NOT NULL
);


ALTER TABLE trained_on OWNER TO clims_user;

--
-- Name: worked_on; Type: TABLE; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE TABLE worked_on (
    employee_id integer NOT NULL,
    job_number integer NOT NULL,
    hours double precision
);


ALTER TABLE worked_on OWNER TO clims_user;

--
-- Name: admin_number; Type: DEFAULT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY administrative ALTER COLUMN admin_number SET DEFAULT nextval('administrative_admin_number_seq'::regclass);


--
-- Name: item_id; Type: DEFAULT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY components ALTER COLUMN item_id SET DEFAULT nextval('components_item_id_seq'::regclass);


--
-- Name: customer_id; Type: DEFAULT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY customers ALTER COLUMN customer_id SET DEFAULT nextval('customers_customer_id_seq'::regclass);


--
-- Name: employee_id; Type: DEFAULT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY employees ALTER COLUMN employee_id SET DEFAULT nextval('employees_employee_id_seq'::regclass);


--
-- Name: equipment_id; Type: DEFAULT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY equipment ALTER COLUMN equipment_id SET DEFAULT nextval('equipment_equipment_id_seq'::regclass);


--
-- Name: job_number; Type: DEFAULT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY jobs ALTER COLUMN job_number SET DEFAULT nextval('jobs_job_number_seq'::regclass);


--
-- Name: maintenience_id; Type: DEFAULT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY maintenience ALTER COLUMN maintenience_id SET DEFAULT nextval('maintenience_maintenience_id_seq'::regclass);


--
-- Name: batch_number; Type: DEFAULT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY manufacturing ALTER COLUMN batch_number SET DEFAULT nextval('manufacturing_batch_number_seq'::regclass);


--
-- Name: order_id; Type: DEFAULT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY orders ALTER COLUMN order_id SET DEFAULT nextval('orders_order_id_seq'::regclass);


--
-- Name: cost_id; Type: DEFAULT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY recurring_costs ALTER COLUMN cost_id SET DEFAULT nextval('recurring_costs_cost_id_seq'::regclass);


--
-- Name: sale_number; Type: DEFAULT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY sales ALTER COLUMN sale_number SET DEFAULT nextval('sales_sale_number_seq'::regclass);


--
-- Name: supplier_id; Type: DEFAULT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY suppliers ALTER COLUMN supplier_id SET DEFAULT nextval('suppliers_supplier_id_seq'::regclass);


--
-- Data for Name: administrative; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY administrative (date, job_number, admin_number) FROM stdin;
\.


--
-- Name: administrative_admin_number_seq; Type: SEQUENCE SET; Schema: public; Owner: clims_user
--

SELECT pg_catalog.setval('administrative_admin_number_seq', 1, false);


--
-- Data for Name: almanac; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY almanac (date) FROM stdin;
2015-07-07
2015-07-08
2015-07-09
2015-07-10
2015-07-11
2015-07-12
2015-07-13
2015-07-14
2015-07-15
2015-07-16
2015-07-17
2015-07-18
2015-07-19
2015-07-20
2015-07-21
2015-07-22
2015-07-23
2015-07-24
2015-07-25
2015-07-26
2015-07-27
2015-07-28
2015-07-29
2015-07-30
2015-07-31
2015-08-01
2015-08-02
2015-08-03
2015-08-04
2015-08-05
2015-08-06
2015-08-07
2015-08-08
2015-08-09
2015-08-10
2015-08-11
2015-08-12
2015-08-13
2015-08-14
2015-08-15
2015-08-16
2015-08-17
2015-08-18
2015-08-19
2015-08-20
2015-08-21
2015-08-22
2015-08-23
2015-08-24
2015-08-25
2015-08-26
2015-08-27
2015-08-28
2015-08-29
2015-08-30
2015-08-31
2015-09-01
2015-09-02
2015-09-03
2015-09-04
2015-09-05
2015-09-06
2015-09-07
2015-09-08
2015-09-09
2015-09-10
2015-09-11
2015-09-12
2015-09-13
2015-09-14
2015-09-15
2015-09-16
2015-09-17
2015-09-18
2015-09-19
2015-09-20
2015-09-21
2015-09-22
2015-09-23
2015-09-24
2015-09-25
2015-09-26
2015-09-27
2015-09-28
2015-09-29
2015-09-30
2015-10-01
2015-10-02
2015-10-03
2015-10-04
2015-10-05
2015-10-06
2015-10-07
2015-10-08
2015-10-09
2015-10-10
2015-10-11
2015-10-12
2015-10-13
2015-10-14
2015-10-15
2015-10-16
2015-10-17
2015-10-18
2015-10-19
2015-10-20
2015-10-21
2015-10-22
2015-10-23
2015-10-24
2015-10-25
2015-10-26
2015-10-27
2015-10-28
2015-10-29
2015-10-30
2015-10-31
2015-11-01
2015-11-02
2015-11-03
2015-11-04
2015-11-05
2015-11-06
2015-11-07
2015-11-08
2015-11-09
2015-11-10
2015-11-11
2015-11-12
2015-11-13
2015-11-14
2015-11-15
2015-11-16
2015-11-17
2015-11-18
2015-11-19
2015-11-20
2015-11-21
2015-11-22
2015-11-23
2015-11-24
2015-11-25
2015-11-26
2015-11-27
2015-11-28
2015-11-29
2015-11-30
2015-12-01
2015-12-02
2015-12-03
2015-12-04
2015-12-05
2015-12-06
2015-12-07
2015-12-08
2015-12-09
2015-12-10
2015-12-11
2015-12-12
2015-12-13
2015-12-14
2015-12-15
2015-12-16
2015-12-17
2015-12-18
2015-12-19
2015-12-20
2015-12-21
2015-12-22
2015-12-23
2015-12-24
2015-12-25
2015-12-26
2015-12-27
2015-12-28
2015-12-29
2015-12-30
2015-12-31
2016-01-01
2016-01-02
2016-01-03
2016-01-04
2016-01-05
2016-01-06
2016-01-07
2016-01-08
2016-01-09
2016-01-10
2016-01-11
2016-01-12
2016-01-13
2016-01-14
2016-01-15
2016-01-16
2016-01-17
2016-01-18
2016-01-19
2016-01-20
2016-01-21
2016-01-22
2016-01-23
2016-01-24
2016-01-25
2016-01-26
2016-01-27
2016-01-28
2016-01-29
2016-01-30
2016-01-31
2016-02-01
2016-02-02
2016-02-03
2016-02-04
2016-02-05
2016-02-06
2016-02-07
2016-02-08
2016-02-09
2016-02-10
2016-02-11
2016-02-12
2016-02-13
2016-02-14
2016-02-15
2016-02-16
2016-02-17
2016-02-18
2016-02-19
2016-02-20
2016-02-21
2016-02-22
2016-02-23
2016-02-24
2016-02-25
2016-02-26
2016-02-27
2016-02-28
2016-02-29
2016-03-01
2016-03-02
2016-03-03
2016-03-04
2016-03-05
2016-03-06
2016-03-07
2016-03-08
2016-03-09
2016-03-10
2016-03-11
2016-03-12
2016-03-13
2016-03-14
2016-03-15
2016-03-16
2016-03-17
2016-03-18
2016-03-19
2016-03-20
2016-03-21
2016-03-22
2016-03-23
2016-03-24
2016-03-25
2016-03-26
2016-03-27
2016-03-28
2016-03-29
2016-03-30
2016-03-31
2016-04-01
2016-04-02
2016-04-03
2016-04-04
2016-04-05
2016-04-06
2016-04-07
2016-04-08
2016-04-09
2016-04-10
2016-04-11
2016-04-12
2016-04-13
2016-04-14
2016-04-15
2016-04-16
2016-04-17
2016-04-18
2016-04-19
2016-04-20
2016-04-21
2016-04-22
2016-04-23
2016-04-24
2016-04-25
2016-04-26
2016-04-27
2016-04-28
2016-04-29
2016-04-30
2016-05-01
2016-05-02
2016-05-03
2016-05-04
2016-05-05
2016-05-06
2016-05-07
2016-05-08
2016-05-09
2016-05-10
2016-05-11
2016-05-12
2016-05-13
2016-05-14
2016-05-15
2016-05-16
2016-05-17
2016-05-18
2016-05-19
2016-05-20
2016-05-21
2016-05-22
2016-05-23
2016-05-24
2016-05-25
2016-05-26
2016-05-27
2016-05-28
2016-05-29
2016-05-30
2016-05-31
2016-06-01
2016-06-02
2016-06-03
2016-06-04
2016-06-05
2016-06-06
2016-06-07
2016-06-08
2016-06-09
2016-06-10
2016-06-11
2016-06-12
2016-06-13
2016-06-14
2016-06-15
2016-06-16
2016-06-17
2016-06-18
2016-06-19
2016-06-20
2016-06-21
2016-06-22
2016-06-23
2016-06-24
2016-06-25
2016-06-26
2016-06-27
2016-06-28
2016-06-29
2016-06-30
2016-07-01
2016-07-02
2016-07-03
2016-07-04
2016-07-05
2016-07-06
2016-07-07
\.


--
-- Data for Name: components; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY components (item_id, name, type, price, quantity) FROM stdin;
1	'snozzberries'	0	0.5	(kilograms,30)
2	'eldritch snozzberries'	1	2	(kilograms,3)
3	'fairy dust'	0	0.349999999999999978	(grams,15.5)
4	'leather pouches'	0	1	(item,50)
5	'pouch-o-snozz'	1	20	(item,3)
6	'water'	0	0.100000000000000006	(kilograms,100)
7	'health liquid'	0	2	(kilograms,20)
8	'health potion'	1	20	(item,5)
9	'bottle'	0	0.5	(item,20)
10	'potion bandolier'	1	70.5	(item,3)
11	'distillate of snozz'	1	50	(grams,10)
12	'bottled distilled snozz'	1	80	(item,5)
\.


--
-- Name: components_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clims_user
--

SELECT pg_catalog.setval('components_item_id_seq', 1, false);


--
-- Data for Name: components_orders; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY components_orders (order_id) FROM stdin;
\.


--
-- Data for Name: composed_of_components; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY composed_of_components (order_id, item_id, quantity, price) FROM stdin;
\.


--
-- Data for Name: composed_of_equipment; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY composed_of_equipment (order_id, equipment_id, price, quantity) FROM stdin;
\.


--
-- Data for Name: crafting; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY crafting (used_in, producing, quantity) FROM stdin;
1	2	(kilograms,1)
3	2	(grams,5)
2	5	(kilograms,1.5)
4	5	(item,1)
3	7	(grams,3)
6	7	(kilograms,1)
7	8	(kilograms,1.33000000000000007)
9	8	(item,1)
4	10	(item,5)
8	10	(item,3)
2	11	(kilograms,0.660000000000000031)
11	12	(grams,1)
9	12	(item,1)
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY customers (customer_id) FROM stdin;
\.


--
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clims_user
--

SELECT pg_catalog.setval('customers_customer_id_seq', 1, false);


--
-- Data for Name: elements; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY elements (item_id, quantity, in_out, job_number) FROM stdin;
2	(kilograms,0.660000000000000031)	f	1
11	(grams,1)	t	1
11	(grams,1)	f	2
9	(item,3)	f	2
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY employees (employee_id, wage_type, name) FROM stdin;
1	0	'dumpy'
2	1	'bumpy'
3	1	'stumpy'
4	0	'fuckhead'
\.


--
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clims_user
--

SELECT pg_catalog.setval('employees_employee_id_seq', 1, false);


--
-- Data for Name: equipment; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY equipment (equipment_id, name, training_manual, use) FROM stdin;
1	'berry press'	'berry-man.txt'	'distilling snozzberries'
2	'enchanting table'	'enchant.txt'	'creating eldritch snozzberries'
3	'vat'	'vat.txt'	'mixing potions'
4	'table'	'table.txt'	'packaging items'
\.


--
-- Name: equipment_equipment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clims_user
--

SELECT pg_catalog.setval('equipment_equipment_id_seq', 1, false);


--
-- Data for Name: equipment_orders; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY equipment_orders (order_id) FROM stdin;
\.


--
-- Data for Name: equipment_used; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY equipment_used (equipment_id, job_number) FROM stdin;
1	1
4	2
3	2
\.


--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY inventory (employee_id, item_id, date, quantity) FROM stdin;
1	2	2015-07-11 09:07:00	(kilograms,1.5)
1	5	2015-07-11 09:07:00	(item,5)
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY jobs (job_number, name, type, finished) FROM stdin;
1	'make distilate'	3	t
2	'package distilate'	3	f
3	'service berry press'	4	t
\.


--
-- Name: jobs_job_number_seq; Type: SEQUENCE SET; Schema: public; Owner: clims_user
--

SELECT pg_catalog.setval('jobs_job_number_seq', 1, false);


--
-- Data for Name: maintained; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY maintained (maintenience_id, equipment_id, fixed) FROM stdin;
1	1	'fixed completely'
\.


--
-- Data for Name: maintenience; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY maintenience (maintenience_id, type, job_number, order_id) FROM stdin;
1	0	3	\N
\.


--
-- Name: maintenience_maintenience_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clims_user
--

SELECT pg_catalog.setval('maintenience_maintenience_id_seq', 1, false);


--
-- Data for Name: maintenience_orders; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY maintenience_orders (order_id, price) FROM stdin;
\.


--
-- Data for Name: manufacturing; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY manufacturing (date, misc_info, report, cost, job_number, batch_number) FROM stdin;
2015-07-09 06:04:26	'worked fine'	'1-report.txt'	25	1	1
2015-07-10 12:24:15	'used extra packaging'	'2-report.txt	0	2	2
\.


--
-- Name: manufacturing_batch_number_seq; Type: SEQUENCE SET; Schema: public; Owner: clims_user
--

SELECT pg_catalog.setval('manufacturing_batch_number_seq', 1, false);


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY orders (order_id, date, type, supplier_id) FROM stdin;
\.


--
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clims_user
--

SELECT pg_catalog.setval('orders_order_id_seq', 1, false);


--
-- Data for Name: recurring_costs; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY recurring_costs (date, cost_id, type, amount) FROM stdin;
\.


--
-- Name: recurring_costs_cost_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clims_user
--

SELECT pg_catalog.setval('recurring_costs_cost_id_seq', 1, false);


--
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY sales (sale_number, date, cost, customer_id, job_number) FROM stdin;
\.


--
-- Name: sales_sale_number_seq; Type: SEQUENCE SET; Schema: public; Owner: clims_user
--

SELECT pg_catalog.setval('sales_sale_number_seq', 1, false);


--
-- Data for Name: sold; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY sold (item_id, quantity, price, job_number) FROM stdin;
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY suppliers (supplier_id, supplier_type) FROM stdin;
\.


--
-- Name: suppliers_supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: clims_user
--

SELECT pg_catalog.setval('suppliers_supplier_id_seq', 1, false);


--
-- Data for Name: trained_on; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY trained_on (equipment_id, employee_id) FROM stdin;
1	1
1	2
4	4
1	3
2	3
3	1
3	4
\.


--
-- Data for Name: worked_on; Type: TABLE DATA; Schema: public; Owner: clims_user
--

COPY worked_on (employee_id, job_number, hours) FROM stdin;
1	1	2.5
2	1	5
4	2	1.5
3	3	1.5
\.


--
-- Name: admin_number; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY administrative
    ADD CONSTRAINT admin_number UNIQUE (admin_number);


--
-- Name: batch_number; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY manufacturing
    ADD CONSTRAINT batch_number UNIQUE (batch_number);


--
-- Name: key1; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY components
    ADD CONSTRAINT key1 PRIMARY KEY (item_id);


--
-- Name: key10; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY employees
    ADD CONSTRAINT key10 PRIMARY KEY (employee_id);


--
-- Name: key11; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY worked_on
    ADD CONSTRAINT key11 PRIMARY KEY (employee_id, job_number);


--
-- Name: key12; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY inventory
    ADD CONSTRAINT key12 PRIMARY KEY (employee_id, item_id);


--
-- Name: key13; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY equipment
    ADD CONSTRAINT key13 PRIMARY KEY (equipment_id);


--
-- Name: key14; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY trained_on
    ADD CONSTRAINT key14 PRIMARY KEY (equipment_id, employee_id);


--
-- Name: key15; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY equipment_used
    ADD CONSTRAINT key15 PRIMARY KEY (equipment_id, job_number);


--
-- Name: key16; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY maintenience
    ADD CONSTRAINT key16 PRIMARY KEY (maintenience_id);


--
-- Name: key17; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY maintained
    ADD CONSTRAINT key17 PRIMARY KEY (maintenience_id, equipment_id);


--
-- Name: key18; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY suppliers
    ADD CONSTRAINT key18 PRIMARY KEY (supplier_id);


--
-- Name: key19; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT key19 PRIMARY KEY (order_id);


--
-- Name: key2; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY manufacturing
    ADD CONSTRAINT key2 PRIMARY KEY (job_number);


--
-- Name: key20; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY components_orders
    ADD CONSTRAINT key20 PRIMARY KEY (order_id);


--
-- Name: key21; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY composed_of_components
    ADD CONSTRAINT key21 PRIMARY KEY (order_id, item_id);


--
-- Name: key22; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY equipment_orders
    ADD CONSTRAINT key22 PRIMARY KEY (order_id);


--
-- Name: key23; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY composed_of_equipment
    ADD CONSTRAINT key23 PRIMARY KEY (order_id, equipment_id);


--
-- Name: key24; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY maintenience_orders
    ADD CONSTRAINT key24 PRIMARY KEY (order_id);


--
-- Name: key26; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY recurring_costs
    ADD CONSTRAINT key26 PRIMARY KEY (cost_id);


--
-- Name: key3; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY crafting
    ADD CONSTRAINT key3 PRIMARY KEY (used_in, producing);


--
-- Name: key4; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY sales
    ADD CONSTRAINT key4 PRIMARY KEY (job_number);


--
-- Name: key5; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY sold
    ADD CONSTRAINT key5 PRIMARY KEY (item_id, job_number);


--
-- Name: key6; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT key6 PRIMARY KEY (customer_id);


--
-- Name: key7; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT key7 PRIMARY KEY (job_number);


--
-- Name: key8; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY administrative
    ADD CONSTRAINT key8 PRIMARY KEY (job_number);


--
-- Name: key9; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY elements
    ADD CONSTRAINT key9 PRIMARY KEY (item_id, job_number);


--
-- Name: sale_number; Type: CONSTRAINT; Schema: public; Owner: clims_user; Tablespace: 
--

ALTER TABLE ONLY sales
    ADD CONSTRAINT sale_number UNIQUE (sale_number);


--
-- Name: ix_maintjob_num; Type: INDEX; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE INDEX ix_maintjob_num ON maintenience USING btree (job_number);


--
-- Name: ix_relationship30; Type: INDEX; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE INDEX ix_relationship30 ON orders USING btree (supplier_id);


--
-- Name: ix_relationship38; Type: INDEX; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE INDEX ix_relationship38 ON maintenience USING btree (order_id);


--
-- Name: ix_relationship7; Type: INDEX; Schema: public; Owner: clims_user; Tablespace: 
--

CREATE INDEX ix_relationship7 ON sales USING btree (customer_id);


--
-- Name: admin_job_num; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY administrative
    ADD CONSTRAINT admin_job_num FOREIGN KEY (job_number) REFERENCES jobs(job_number);


--
-- Name: batch; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY elements
    ADD CONSTRAINT batch FOREIGN KEY (job_number) REFERENCES manufacturing(job_number);


--
-- Name: buyer; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY sales
    ADD CONSTRAINT buyer FOREIGN KEY (customer_id) REFERENCES customers(customer_id);


--
-- Name: component_order; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY composed_of_components
    ADD CONSTRAINT component_order FOREIGN KEY (order_id) REFERENCES components_orders(order_id);


--
-- Name: component_order_num; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY components_orders
    ADD CONSTRAINT component_order_num FOREIGN KEY (order_id) REFERENCES orders(order_id);


--
-- Name: employee; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY worked_on
    ADD CONSTRAINT employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id);


--
-- Name: employee_inv; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY inventory
    ADD CONSTRAINT employee_inv FOREIGN KEY (employee_id) REFERENCES employees(employee_id);


--
-- Name: employee_train; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY trained_on
    ADD CONSTRAINT employee_train FOREIGN KEY (employee_id) REFERENCES employees(employee_id);


--
-- Name: equip_order_num; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY equipment_orders
    ADD CONSTRAINT equip_order_num FOREIGN KEY (order_id) REFERENCES orders(order_id);


--
-- Name: equipment_fixed; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY maintained
    ADD CONSTRAINT equipment_fixed FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id);


--
-- Name: equipment_order; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY composed_of_equipment
    ADD CONSTRAINT equipment_order FOREIGN KEY (order_id) REFERENCES equipment_orders(order_id);


--
-- Name: equipment_used; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY equipment_used
    ADD CONSTRAINT equipment_used FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id);


--
-- Name: inv_item; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY inventory
    ADD CONSTRAINT inv_item FOREIGN KEY (item_id) REFERENCES components(item_id);


--
-- Name: job; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY worked_on
    ADD CONSTRAINT job FOREIGN KEY (job_number) REFERENCES jobs(job_number);


--
-- Name: maint_job_num; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY maintenience
    ADD CONSTRAINT maint_job_num FOREIGN KEY (job_number) REFERENCES jobs(job_number);


--
-- Name: maint_order; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY maintenience
    ADD CONSTRAINT maint_order FOREIGN KEY (order_id) REFERENCES maintenience_orders(order_id);


--
-- Name: maint_order_num; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY maintenience_orders
    ADD CONSTRAINT maint_order_num FOREIGN KEY (order_id) REFERENCES orders(order_id);


--
-- Name: maintain; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY maintained
    ADD CONSTRAINT maintain FOREIGN KEY (maintenience_id) REFERENCES maintenience(maintenience_id);


--
-- Name: manufacture_item; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY elements
    ADD CONSTRAINT manufacture_item FOREIGN KEY (item_id) REFERENCES components(item_id);


--
-- Name: manufacture_job_num; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY manufacturing
    ADD CONSTRAINT manufacture_job_num FOREIGN KEY (job_number) REFERENCES jobs(job_number);


--
-- Name: order_equipment; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY composed_of_equipment
    ADD CONSTRAINT order_equipment FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id);


--
-- Name: order_item; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY composed_of_components
    ADD CONSTRAINT order_item FOREIGN KEY (item_id) REFERENCES components(item_id);


--
-- Name: process; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY equipment_used
    ADD CONSTRAINT process FOREIGN KEY (job_number) REFERENCES manufacturing(job_number);


--
-- Name: producing; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY crafting
    ADD CONSTRAINT producing FOREIGN KEY (producing) REFERENCES components(item_id);


--
-- Name: sale; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY sold
    ADD CONSTRAINT sale FOREIGN KEY (job_number) REFERENCES sales(job_number);


--
-- Name: sale_item; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY sold
    ADD CONSTRAINT sale_item FOREIGN KEY (item_id) REFERENCES components(item_id);


--
-- Name: sale_job_num; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY sales
    ADD CONSTRAINT sale_job_num FOREIGN KEY (job_number) REFERENCES jobs(job_number);


--
-- Name: supplier; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id);


--
-- Name: train_equipment; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY trained_on
    ADD CONSTRAINT train_equipment FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id);


--
-- Name: used_in; Type: FK CONSTRAINT; Schema: public; Owner: clims_user
--

ALTER TABLE ONLY crafting
    ADD CONSTRAINT used_in FOREIGN KEY (used_in) REFERENCES components(item_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

