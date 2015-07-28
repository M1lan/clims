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
-- Name: direction; Type: TYPE; Schema: public; Owner: eric
--

CREATE TYPE direction AS ENUM (
    'in',
    'out'
);


ALTER TYPE direction OWNER TO eric;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: buyers; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE buyers (
    buyer_id bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE buyers OWNER TO eric;

--
-- Name: buyers_buyer_id_seq; Type: SEQUENCE; Schema: public; Owner: eric
--

CREATE SEQUENCE buyers_buyer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE buyers_buyer_id_seq OWNER TO eric;

--
-- Name: buyers_buyer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eric
--

ALTER SEQUENCE buyers_buyer_id_seq OWNED BY buyers.buyer_id;


--
-- Name: elements; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE elements (
    batch_id bigint NOT NULL,
    order_id bigint NOT NULL,
    name character varying NOT NULL,
    in_out direction NOT NULL,
    quantity bigint NOT NULL
);


ALTER TABLE elements OWNER TO eric;

--
-- Name: finished_materials; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE finished_materials (
    quantity_made bigint NOT NULL,
    name character varying NOT NULL,
    batch_id bigint NOT NULL,
    quantity_in_stock bigint NOT NULL
);


ALTER TABLE finished_materials OWNER TO eric;

--
-- Name: manufacturing; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE manufacturing (
    batch_id bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE manufacturing OWNER TO eric;

--
-- Name: manufacturing_batch_id_seq; Type: SEQUENCE; Schema: public; Owner: eric
--

CREATE SEQUENCE manufacturing_batch_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE manufacturing_batch_id_seq OWNER TO eric;

--
-- Name: manufacturing_batch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eric
--

ALTER SEQUENCE manufacturing_batch_id_seq OWNED BY manufacturing.batch_id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE orders (
    order_id bigint NOT NULL,
    supplier_id bigint
);


ALTER TABLE orders OWNER TO eric;

--
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: eric
--

CREATE SEQUENCE orders_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE orders_order_id_seq OWNER TO eric;

--
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eric
--

ALTER SEQUENCE orders_order_id_seq OWNED BY orders.order_id;


--
-- Name: raw_materials; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE raw_materials (
    name character varying NOT NULL,
    quantity_bought bigint NOT NULL,
    cost bigint NOT NULL,
    "quantity _fresh" bigint NOT NULL,
    quantity_used_1 bigint NOT NULL,
    quantity_used_2 bigint NOT NULL,
    quantity_used_3 bigint NOT NULL,
    quantity_trashed bigint NOT NULL,
    order_id bigint NOT NULL
);


ALTER TABLE raw_materials OWNER TO eric;

--
-- Name: sales; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE sales (
    sale_id bigint NOT NULL,
    buyer_id bigint
);


ALTER TABLE sales OWNER TO eric;

--
-- Name: sales_sale_id_seq; Type: SEQUENCE; Schema: public; Owner: eric
--

CREATE SEQUENCE sales_sale_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sales_sale_id_seq OWNER TO eric;

--
-- Name: sales_sale_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eric
--

ALTER SEQUENCE sales_sale_id_seq OWNED BY sales.sale_id;


--
-- Name: sold; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE sold (
    name character varying NOT NULL,
    batch_id bigint NOT NULL,
    sale_id bigint NOT NULL,
    quantity_sold bigint NOT NULL,
    price bigint NOT NULL
);


ALTER TABLE sold OWNER TO eric;

--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: eric; Tablespace: 
--

CREATE TABLE suppliers (
    supplier_id bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE suppliers OWNER TO eric;

--
-- Name: suppliers_supplier_id_seq; Type: SEQUENCE; Schema: public; Owner: eric
--

CREATE SEQUENCE suppliers_supplier_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE suppliers_supplier_id_seq OWNER TO eric;

--
-- Name: suppliers_supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: eric
--

ALTER SEQUENCE suppliers_supplier_id_seq OWNED BY suppliers.supplier_id;


--
-- Name: buyer_id; Type: DEFAULT; Schema: public; Owner: eric
--

ALTER TABLE ONLY buyers ALTER COLUMN buyer_id SET DEFAULT nextval('buyers_buyer_id_seq'::regclass);


--
-- Name: batch_id; Type: DEFAULT; Schema: public; Owner: eric
--

ALTER TABLE ONLY manufacturing ALTER COLUMN batch_id SET DEFAULT nextval('manufacturing_batch_id_seq'::regclass);


--
-- Name: order_id; Type: DEFAULT; Schema: public; Owner: eric
--

ALTER TABLE ONLY orders ALTER COLUMN order_id SET DEFAULT nextval('orders_order_id_seq'::regclass);


--
-- Name: sale_id; Type: DEFAULT; Schema: public; Owner: eric
--

ALTER TABLE ONLY sales ALTER COLUMN sale_id SET DEFAULT nextval('sales_sale_id_seq'::regclass);


--
-- Name: supplier_id; Type: DEFAULT; Schema: public; Owner: eric
--

ALTER TABLE ONLY suppliers ALTER COLUMN supplier_id SET DEFAULT nextval('suppliers_supplier_id_seq'::regclass);


--
-- Data for Name: buyers; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY buyers (buyer_id, name) FROM stdin;
1	fancy joes flower spray
2	big box store
\.


--
-- Name: buyers_buyer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eric
--

SELECT pg_catalog.setval('buyers_buyer_id_seq', 1, false);


--
-- Data for Name: elements; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY elements (batch_id, order_id, name, in_out, quantity) FROM stdin;
1	1	lilies	in	10
1	3	lilies	in	10
1	1	lilies	out	10
1	3	lilies	out	10
2	1	orchids	in	10
2	1	orchids	out	10
3	1	orchids	in	5
3	1	orchids	out	5
4	2	lilies	in	5
4	2	lilies	out	5
\.


--
-- Data for Name: finished_materials; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY finished_materials (quantity_made, name, batch_id, quantity_in_stock) FROM stdin;
10	lily juice	1	5
5	lily pulp	1	5
3	orchid juice	2	3
1	orchid starch	3	0
3	lily juice	4	3
\.


--
-- Data for Name: manufacturing; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY manufacturing (batch_id, name) FROM stdin;
1	drain lilies
2	drain orchids
3	mash orchids
4	drain lilies
\.


--
-- Name: manufacturing_batch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eric
--

SELECT pg_catalog.setval('manufacturing_batch_id_seq', 1, false);


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY orders (order_id, supplier_id) FROM stdin;
1	1
2	1
3	2
\.


--
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eric
--

SELECT pg_catalog.setval('orders_order_id_seq', 1, false);


--
-- Data for Name: raw_materials; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY raw_materials (name, quantity_bought, cost, "quantity _fresh", quantity_used_1, quantity_used_2, quantity_used_3, quantity_trashed, order_id) FROM stdin;
lilies	20	5	10	10	0	0	0	1
lilies	15	2	5	10	0	0	0	3
orchids	30	20	20	5	5	0	0	1
lilies	8	2	3	5	0	0	0	2
\.


--
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY sales (sale_id, buyer_id) FROM stdin;
1	1
2	2
3	1
\.


--
-- Name: sales_sale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eric
--

SELECT pg_catalog.setval('sales_sale_id_seq', 1, false);


--
-- Data for Name: sold; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY sold (name, batch_id, sale_id, quantity_sold, price) FROM stdin;
lily juice	1	1	3	21
orchid juice	2	1	1	10
lily juice	1	2	2	10
orchid starch	3	3	1	5
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: eric
--

COPY suppliers (supplier_id, name) FROM stdin;
1	bobs plants
2	jims horticulture
\.


--
-- Name: suppliers_supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: eric
--

SELECT pg_catalog.setval('suppliers_supplier_id_seq', 1, false);


--
-- Name: key1; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY suppliers
    ADD CONSTRAINT key1 PRIMARY KEY (supplier_id);


--
-- Name: key2; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT key2 PRIMARY KEY (order_id);


--
-- Name: key3; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY raw_materials
    ADD CONSTRAINT key3 PRIMARY KEY (order_id, name);


--
-- Name: key4; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY manufacturing
    ADD CONSTRAINT key4 PRIMARY KEY (batch_id);


--
-- Name: key5; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY elements
    ADD CONSTRAINT key5 PRIMARY KEY (batch_id, order_id, name, in_out);


--
-- Name: key6; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY finished_materials
    ADD CONSTRAINT key6 PRIMARY KEY (name, batch_id);


--
-- Name: key7; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY sales
    ADD CONSTRAINT key7 PRIMARY KEY (sale_id);


--
-- Name: key8; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY buyers
    ADD CONSTRAINT key8 PRIMARY KEY (buyer_id);


--
-- Name: key9; Type: CONSTRAINT; Schema: public; Owner: eric; Tablespace: 
--

ALTER TABLE ONLY sold
    ADD CONSTRAINT key9 PRIMARY KEY (name, batch_id, sale_id);


--
-- Name: ix_relationship3; Type: INDEX; Schema: public; Owner: eric; Tablespace: 
--

CREATE INDEX ix_relationship3 ON orders USING btree (supplier_id);


--
-- Name: ix_relationship8; Type: INDEX; Schema: public; Owner: eric; Tablespace: 
--

CREATE INDEX ix_relationship8 ON sales USING btree (buyer_id);


--
-- Name: batch; Type: FK CONSTRAINT; Schema: public; Owner: eric
--

ALTER TABLE ONLY elements
    ADD CONSTRAINT batch FOREIGN KEY (batch_id) REFERENCES manufacturing(batch_id);


--
-- Name: buyer; Type: FK CONSTRAINT; Schema: public; Owner: eric
--

ALTER TABLE ONLY sales
    ADD CONSTRAINT buyer FOREIGN KEY (buyer_id) REFERENCES buyers(buyer_id);


--
-- Name: item_in_out; Type: FK CONSTRAINT; Schema: public; Owner: eric
--

ALTER TABLE ONLY elements
    ADD CONSTRAINT item_in_out FOREIGN KEY (order_id, name) REFERENCES raw_materials(order_id, name);


--
-- Name: order_items; Type: FK CONSTRAINT; Schema: public; Owner: eric
--

ALTER TABLE ONLY raw_materials
    ADD CONSTRAINT order_items FOREIGN KEY (order_id) REFERENCES orders(order_id);


--
-- Name: output; Type: FK CONSTRAINT; Schema: public; Owner: eric
--

ALTER TABLE ONLY finished_materials
    ADD CONSTRAINT output FOREIGN KEY (batch_id) REFERENCES manufacturing(batch_id);


--
-- Name: sale; Type: FK CONSTRAINT; Schema: public; Owner: eric
--

ALTER TABLE ONLY sold
    ADD CONSTRAINT sale FOREIGN KEY (sale_id) REFERENCES sales(sale_id);


--
-- Name: sale_items; Type: FK CONSTRAINT; Schema: public; Owner: eric
--

ALTER TABLE ONLY sold
    ADD CONSTRAINT sale_items FOREIGN KEY (name, batch_id) REFERENCES finished_materials(name, batch_id);


--
-- Name: supplier; Type: FK CONSTRAINT; Schema: public; Owner: eric
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id);


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

