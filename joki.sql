CREATE TYPE public.shipment_status AS ENUM (
    'CREATED',
    'PICKED_UP',
    'IN_TRANSIT',
    'DELIVERED',
    'COMPLETED'
);


CREATE TYPE public.status AS ENUM (
    'PENDING',
    'REJECT',
    'APPROVE'
);


CREATE TABLE public.access_token (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    token text NOT NULL,
    expired_at timestamp without time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);



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


CREATE TABLE public.migrations (
    id integer NOT NULL,
    hash text NOT NULL,
    created_at bigint
);



CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



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



CREATE TABLE public.orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    status character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    additional_item json DEFAULT '{}'::json
);





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




CREATE TABLE public.product_cagetories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);



CREATE TABLE public.product_has_category (
    product_id uuid NOT NULL,
    product_category_id uuid NOT NULL
);



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




CREATE TABLE public.refresh_token (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    token text NOT NULL,
    expired_at timestamp without time zone NOT NULL,
    revoked boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);




CREATE TABLE public.roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);




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




CREATE TABLE public.wishlists (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    product_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);
