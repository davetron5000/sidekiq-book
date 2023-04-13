SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    quantity integer NOT NULL,
    address text NOT NULL,
    email text NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    user_id bigint NOT NULL,
    charge_completed_at timestamp(6) with time zone,
    charge_successful boolean DEFAULT false NOT NULL,
    charge_decline_reason text,
    charge_id text,
    email_id text,
    fulfillment_request_id text
);


--
-- Name: TABLE orders; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.orders IS 'Orders created';


--
-- Name: COLUMN orders.product_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.product_id IS 'Which product is in this order?';


--
-- Name: COLUMN orders.quantity; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.quantity IS 'How many?';


--
-- Name: COLUMN orders.address; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.address IS 'What address should it be shipped to?';


--
-- Name: COLUMN orders.email; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.email IS 'What email address should be notified?';


--
-- Name: COLUMN orders.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.user_id IS 'Which user placed and paid-for this order?';


--
-- Name: COLUMN orders.charge_completed_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.charge_completed_at IS 'If set, when was the charge completed?';


--
-- Name: COLUMN orders.charge_successful; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.charge_successful IS 'If the charge was completed, was it successful or was it declined?';


--
-- Name: COLUMN orders.charge_decline_reason; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.charge_decline_reason IS 'If the charge was declined, why?';


--
-- Name: COLUMN orders.charge_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.charge_id IS 'If this was paid for, what was the charge id from the remote system?';


--
-- Name: COLUMN orders.email_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.email_id IS 'If the email confirmation went out, what was the id in the remote system?';


--
-- Name: COLUMN orders.fulfillment_request_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.orders.fulfillment_request_id IS 'If the order''s fulfillment was requested,, what was the id in the remote system?';


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    name public.citext NOT NULL,
    quantity_remaining integer NOT NULL,
    price_cents integer NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: TABLE products; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.products IS 'List of products, prices and quantities available';


--
-- Name: COLUMN products.name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.name IS 'Name of the product';


--
-- Name: COLUMN products.quantity_remaining; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.quantity_remaining IS 'How many of this product are left?';


--
-- Name: COLUMN products.price_cents; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.products.price_cents IS 'Price of one product, in cents';


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email public.citext NOT NULL,
    payments_customer_id text NOT NULL,
    payments_payment_method_id text NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.users IS 'Users of the system';


--
-- Name: COLUMN users.email; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.email IS 'Email address of this user';


--
-- Name: COLUMN users.payments_customer_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.payments_customer_id IS 'ID of the customer in our payments service';


--
-- Name: COLUMN users.payments_payment_method_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.payments_payment_method_id IS 'ID of the customer''s chosen payment method in our payments service';


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_orders_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_product_id ON public.orders USING btree (product_id);


--
-- Name: index_orders_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_user_id ON public.orders USING btree (user_id);


--
-- Name: index_products_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_products_on_name ON public.products USING btree (name);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_payments_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_payments_customer_id ON public.users USING btree (payments_customer_id);


--
-- Name: index_users_on_payments_payment_method_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_payments_payment_method_id ON public.users USING btree (payments_payment_method_id);


--
-- Name: orders fk_rails_dfb33b2de0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_rails_dfb33b2de0 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: orders fk_rails_f868b47f6a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_rails_f868b47f6a FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20230225183202'),
('20230303185842');


