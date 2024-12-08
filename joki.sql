--
-- PostgreSQL database dump
--

-- Dumped from database version 15.7
-- Dumped by pg_dump version 16.4

-- Started on 2024-12-09 01:32:57

-- SET statement_timeout = 0;
-- SET lock_timeout = 0;
-- SET idle_in_transaction_session_timeout = 0;
-- SET client_encoding = 'UTF8';
-- SET standard_conforming_strings = on;
-- SELECT pg_catalog.set_config('search_path', '', false);
-- SET check_function_bodies = false;
-- SET xmloption = content;
-- SET client_min_messages = warning;
-- SET row_security = off;

--
-- TOC entry 909 (class 1247 OID 106497)
-- Name: shipment_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.shipment_status AS ENUM (
    'CREATED',
    'PICKED_UP',
    'IN_TRANSIT',
    'DELIVERED',
    'COMPLETED'
);


ALTER TYPE public.shipment_status OWNER TO postgres;

--
-- TOC entry 906 (class 1247 OID 74095)
-- Name: status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status AS ENUM (
    'PENDING',
    'REJECT',
    'APPROVE'
);


ALTER TYPE public.status OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 73815)
-- Name: access_token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.access_token (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    token text NOT NULL,
    expired_at timestamp without time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.access_token OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 73824)
-- Name: carts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    product_id uuid NOT NULL,
    quantity integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    is_preorder boolean DEFAULT false
);


ALTER TABLE public.carts OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 73807)
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    hash text NOT NULL,
    created_at bigint
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 73806)
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO postgres;

--
-- TOC entry 3543 (class 0 OID 0)
-- Dependencies: 214
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- TOC entry 218 (class 1259 OID 73833)
-- Name: order_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    is_rating boolean DEFAULT false,
    quantity integer DEFAULT 0 NOT NULL,
    total double precision DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    order_id uuid NOT NULL
);


ALTER TABLE public.order_products OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 74047)
-- Name: order_shipping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_shipping (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    fullname character varying NOT NULL,
    phone character varying NOT NULL,
    address character varying NOT NULL,
    city character varying NOT NULL,
    postal_code character varying NOT NULL,
    delivery_method character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    email character varying NOT NULL
);


ALTER TABLE public.order_shipping OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 73844)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    status character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    additional_item json DEFAULT '{}'::json
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 74066)
-- Name: preorders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.preorders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    product_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    status public.status DEFAULT 'PENDING'::public.status NOT NULL,
    additional_info json DEFAULT '{}'::json
);


ALTER TABLE public.preorders OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 73854)
-- Name: product_cagetories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_cagetories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_cagetories OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 73866)
-- Name: product_has_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_has_category (
    product_id uuid NOT NULL,
    product_category_id uuid NOT NULL
);


ALTER TABLE public.product_has_category OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 73871)
-- Name: product_ratings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_ratings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    user_id uuid NOT NULL,
    content text NOT NULL,
    rate integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.product_ratings OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 73881)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying NOT NULL,
    description text,
    images text[],
    price double precision DEFAULT 0 NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    weight double precision DEFAULT 0 NOT NULL,
    weight_unit character varying DEFAULT 'kg'::character varying NOT NULL,
    sire character varying,
    dam character varying,
    gender character varying,
    birth_at timestamp with time zone,
    expired_at timestamp with time zone,
    is_active boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    postal_code character varying,
    province_id integer,
    city_id integer,
    province_name character varying,
    city_name character varying
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 73951)
-- Name: refresh_token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refresh_token (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    token text NOT NULL,
    expired_at timestamp without time zone NOT NULL,
    revoked boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.refresh_token OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 73896)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 106507)
-- Name: shipments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    transaction_id uuid NOT NULL,
    address_id uuid NOT NULL,
    shipping_cost double precision NOT NULL,
    shipment_status public.shipment_status DEFAULT 'CREATED'::public.shipment_status NOT NULL,
    estimated_delivery timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.shipments OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 73906)
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    total double precision DEFAULT 0 NOT NULL,
    status character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    order_id uuid NOT NULL,
    payment_type character varying NOT NULL,
    preorder_id uuid,
    order_items json DEFAULT '{}'::json
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 73917)
-- Name: user_addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_addresses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    label character varying NOT NULL,
    full_address text NOT NULL,
    postal_code character varying NOT NULL,
    recipient character varying NOT NULL,
    recipient_phone_number character varying NOT NULL,
    is_primary boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    province_id integer,
    city_id integer,
    province_name character varying,
    city_name character varying
);


ALTER TABLE public.user_addresses OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 73928)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    role_id uuid NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    username character varying,
    password character varying NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    phone_number character varying,
    avatar character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    otp character varying,
    otp_expired character varying
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 73943)
-- Name: wishlists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wishlists (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    product_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE public.wishlists OWNER TO postgres;

--
-- TOC entry 3247 (class 2604 OID 73810)
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- TOC entry 3521 (class 0 OID 73815)
-- Dependencies: 216
-- Data for Name: access_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.access_token (id, user_id, token, expired_at, created_at) FROM stdin;



--
-- TOC entry 3522 (class 0 OID 73824)
-- Dependencies: 217
-- Data for Name: carts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.carts (id, user_id, product_id, quantity, created_at, updated_at, deleted_at, is_preorder) FROM stdin;


--
-- TOC entry 3520 (class 0 OID 73807)
-- Dependencies: 215
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, hash, created_at) FROM stdin;



--
-- TOC entry 3523 (class 0 OID 73833)
-- Dependencies: 218
-- Data for Name: order_products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_products (id, product_id, is_rating, quantity, total, created_at, updated_at, deleted_at, order_id) FROM stdin;


--
-- TOC entry 3535 (class 0 OID 74047)
-- Dependencies: 230
-- Data for Name: order_shipping; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_shipping (id, fullname, phone, address, city, postal_code, delivery_method, created_at, updated_at, email) FROM stdin;

--
-- TOC entry 3524 (class 0 OID 73844)
-- Dependencies: 219
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, user_id, status, created_at, updated_at, deleted_at, additional_item) FROM stdin;



--
-- TOC entry 3536 (class 0 OID 74066)
-- Dependencies: 231
-- Data for Name: preorders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.preorders (id, user_id, product_id, created_at, updated_at, deleted_at, status, additional_info) FROM stdin;



--
-- TOC entry 3525 (class 0 OID 73854)
-- Dependencies: 220
-- Data for Name: product_cagetories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_cagetories (id, name, slug, created_at, updated_at, deleted_at) FROM stdin;

--
-- TOC entry 3526 (class 0 OID 73866)
-- Dependencies: 221
-- Data for Name: product_has_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_has_category (product_id, product_category_id) FROM stdin;

--
-- TOC entry 3527 (class 0 OID 73871)
-- Dependencies: 222
-- Data for Name: product_ratings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_ratings (id, product_id, user_id, content, rate, created_at, updated_at, deleted_at) FROM stdin;


--
-- TOC entry 3528 (class 0 OID 73881)
-- Dependencies: 223
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, title, description, images, price, stock, weight, weight_unit, sire, dam, gender, birth_at, expired_at, is_active, created_at, updated_at, deleted_at, postal_code, province_id, city_id, province_name, city_name) FROM stdin;


--
-- TOC entry 3534 (class 0 OID 73951)
-- Dependencies: 229
-- Data for Name: refresh_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refresh_token (id, user_id, token, expired_at, revoked, created_at) FROM stdin;


--
-- TOC entry 3529 (class 0 OID 73896)
-- Dependencies: 224
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, created_at, updated_at, deleted_at) FROM stdin;


--
-- TOC entry 3537 (class 0 OID 106507)
-- Dependencies: 232
-- Data for Name: shipments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipments (id, transaction_id, address_id, shipping_cost, shipment_status, estimated_delivery, created_at, updated_at) FROM stdin;

--
-- TOC entry 3530 (class 0 OID 73906)
-- Dependencies: 225
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (id, user_id, total, status, created_at, updated_at, deleted_at, order_id, payment_type, preorder_id, order_items) FROM stdin;



--
-- TOC entry 3531 (class 0 OID 73917)
-- Dependencies: 226
-- Data for Name: user_addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_addresses (id, user_id, label, full_address, postal_code, recipient, recipient_phone_number, is_primary, created_at, updated_at, deleted_at, province_id, city_id, province_name, city_name) FROM stdin;

--
-- TOC entry 3532 (class 0 OID 73928)
-- Dependencies: 227
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, role_id, name, email, username, password, is_active, phone_number, avatar, created_at, updated_at, deleted_at, otp, otp_expired) FROM stdin;

--
-- TOC entry 3533 (class 0 OID 73943)
-- Dependencies: 228
-- Data for Name: wishlists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wishlists (id, user_id, product_id, created_at, updated_at, deleted_at) FROM stdin;


--
-- TOC entry 3544 (class 0 OID 0)
-- Dependencies: 214
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 25, true);


--
-- TOC entry 3316 (class 2606 OID 73823)
-- Name: access_token access_token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_token
    ADD CONSTRAINT access_token_pkey PRIMARY KEY (id);


--
-- TOC entry 3318 (class 2606 OID 73832)
-- Name: carts carts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- TOC entry 3314 (class 2606 OID 73814)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3320 (class 2606 OID 73843)
-- Name: order_products order_products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_products
    ADD CONSTRAINT order_products_pkey PRIMARY KEY (id);


--
-- TOC entry 3350 (class 2606 OID 74056)
-- Name: order_shipping order_shipping_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_shipping
    ADD CONSTRAINT order_shipping_pkey PRIMARY KEY (id);


--
-- TOC entry 3322 (class 2606 OID 73853)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- TOC entry 3352 (class 2606 OID 74077)
-- Name: preorders preorders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preorders
    ADD CONSTRAINT preorders_pkey PRIMARY KEY (id);


--
-- TOC entry 3324 (class 2606 OID 73863)
-- Name: product_cagetories product_cagetories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_cagetories
    ADD CONSTRAINT product_cagetories_pkey PRIMARY KEY (id);


--
-- TOC entry 3326 (class 2606 OID 73865)
-- Name: product_cagetories product_cagetories_slug_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_cagetories
    ADD CONSTRAINT product_cagetories_slug_unique UNIQUE (slug);


--
-- TOC entry 3328 (class 2606 OID 73870)
-- Name: product_has_category product_has_category_product_category_id_product_id_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_has_category
    ADD CONSTRAINT product_has_category_product_category_id_product_id_pk PRIMARY KEY (product_category_id, product_id);


--
-- TOC entry 3330 (class 2606 OID 73880)
-- Name: product_ratings product_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_ratings
    ADD CONSTRAINT product_ratings_pkey PRIMARY KEY (id);


--
-- TOC entry 3332 (class 2606 OID 73895)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 3348 (class 2606 OID 73960)
-- Name: refresh_token refresh_token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_token
    ADD CONSTRAINT refresh_token_pkey PRIMARY KEY (id);


--
-- TOC entry 3334 (class 2606 OID 73905)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3354 (class 2606 OID 106515)
-- Name: shipments shipments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_pkey PRIMARY KEY (id);


--
-- TOC entry 3336 (class 2606 OID 73916)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 3338 (class 2606 OID 73927)
-- Name: user_addresses user_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_pkey PRIMARY KEY (id);


--
-- TOC entry 3340 (class 2606 OID 73940)
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- TOC entry 3342 (class 2606 OID 73938)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3344 (class 2606 OID 73942)
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- TOC entry 3346 (class 2606 OID 73950)
-- Name: wishlists wishlists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_pkey PRIMARY KEY (id);


--
-- TOC entry 3355 (class 2606 OID 73961)
-- Name: access_token access_token_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_token
    ADD CONSTRAINT access_token_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3356 (class 2606 OID 73971)
-- Name: carts carts_product_id_products_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_product_id_products_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3357 (class 2606 OID 73966)
-- Name: carts carts_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3358 (class 2606 OID 74037)
-- Name: order_products order_products_order_id_orders_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_products
    ADD CONSTRAINT order_products_order_id_orders_id_fk FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- TOC entry 3359 (class 2606 OID 73976)
-- Name: order_products order_products_product_id_products_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_products
    ADD CONSTRAINT order_products_product_id_products_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3360 (class 2606 OID 73981)
-- Name: orders orders_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3373 (class 2606 OID 74083)
-- Name: preorders preorders_product_id_products_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preorders
    ADD CONSTRAINT preorders_product_id_products_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3374 (class 2606 OID 74078)
-- Name: preorders preorders_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preorders
    ADD CONSTRAINT preorders_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3361 (class 2606 OID 73991)
-- Name: product_has_category product_has_category_product_category_id_product_cagetories_id_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_has_category
    ADD CONSTRAINT product_has_category_product_category_id_product_cagetories_id_ FOREIGN KEY (product_category_id) REFERENCES public.product_cagetories(id) ON DELETE CASCADE;


--
-- TOC entry 3362 (class 2606 OID 73986)
-- Name: product_has_category product_has_category_product_id_products_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_has_category
    ADD CONSTRAINT product_has_category_product_id_products_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 3363 (class 2606 OID 73996)
-- Name: product_ratings product_ratings_product_id_products_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_ratings
    ADD CONSTRAINT product_ratings_product_id_products_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3364 (class 2606 OID 74001)
-- Name: product_ratings product_ratings_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_ratings
    ADD CONSTRAINT product_ratings_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3372 (class 2606 OID 74031)
-- Name: refresh_token refresh_token_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_token
    ADD CONSTRAINT refresh_token_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3375 (class 2606 OID 106521)
-- Name: shipments shipments_address_id_user_addresses_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_address_id_user_addresses_id_fk FOREIGN KEY (address_id) REFERENCES public.user_addresses(id);


--
-- TOC entry 3376 (class 2606 OID 106516)
-- Name: shipments shipments_transaction_id_transactions_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipments
    ADD CONSTRAINT shipments_transaction_id_transactions_id_fk FOREIGN KEY (transaction_id) REFERENCES public.transactions(id);


--
-- TOC entry 3365 (class 2606 OID 74042)
-- Name: transactions transactions_order_id_orders_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_order_id_orders_id_fk FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- TOC entry 3366 (class 2606 OID 74106)
-- Name: transactions transactions_preorder_id_preorders_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_preorder_id_preorders_id_fk FOREIGN KEY (preorder_id) REFERENCES public.preorders(id);


--
-- TOC entry 3367 (class 2606 OID 74006)
-- Name: transactions transactions_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3368 (class 2606 OID 74011)
-- Name: user_addresses user_addresses_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3369 (class 2606 OID 74016)
-- Name: users users_role_id_roles_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_roles_id_fk FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- TOC entry 3370 (class 2606 OID 74026)
-- Name: wishlists wishlists_product_id_products_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_product_id_products_id_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 3371 (class 2606 OID 74021)
-- Name: wishlists wishlists_user_id_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_user_id_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);

