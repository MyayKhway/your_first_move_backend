--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2 (Debian 17.2-1.pgdg120+1)
-- Dumped by pg_dump version 17.2 (Debian 17.2-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS "first-move";
--
-- Name: first-move; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "first-move" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE "first-move" OWNER TO postgres;

\connect -reuse-previous=on "dbname='first-move'"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: car_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.car_categories (
    id smallint NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.car_categories OWNER TO postgres;

--
-- Name: car_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.car_categories_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.car_categories_id_seq OWNER TO postgres;

--
-- Name: car_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.car_categories_id_seq OWNED BY public.car_categories.id;


--
-- Name: cars; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cars (
    id bigint NOT NULL,
    make text NOT NULL,
    model text NOT NULL,
    year integer NOT NULL,
    fuel text NOT NULL,
    hp integer NOT NULL,
    cylinders integer NOT NULL,
    transmission integer NOT NULL,
    wheel_drive text NOT NULL,
    doors smallint NOT NULL,
    size text NOT NULL,
    style text NOT NULL,
    hw_mpg integer NOT NULL,
    city_mpg integer NOT NULL,
    msrp integer NOT NULL
);


ALTER TABLE public.cars OWNER TO postgres;

--
-- Name: cars_car_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cars_car_categories (
    car integer NOT NULL,
    category integer NOT NULL
);


ALTER TABLE public.cars_car_categories OWNER TO postgres;

--
-- Name: cars_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cars_id_seq OWNER TO postgres;

--
-- Name: cars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cars_id_seq OWNED BY public.cars.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    created_at date DEFAULT CURRENT_TIMESTAMP,
    updated_at date
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: car_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_categories ALTER COLUMN id SET DEFAULT nextval('public.car_categories_id_seq'::regclass);


--
-- Name: cars id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars ALTER COLUMN id SET DEFAULT nextval('public.cars_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: car_categories car_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.car_categories
    ADD CONSTRAINT car_categories_pkey PRIMARY KEY (id);


--
-- Name: cars_car_categories cars_car_categories-pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars_car_categories
    ADD CONSTRAINT "cars_car_categories-pk" PRIMARY KEY (car, category);


--
-- Name: cars cars_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: cars_car_categories car_categories_cars_car_categories_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars_car_categories
    ADD CONSTRAINT car_categories_cars_car_categories_fk FOREIGN KEY (category) REFERENCES public.car_categories(id);


--
-- Name: cars_car_categories cars_car_categories_cars_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars_car_categories
    ADD CONSTRAINT cars_car_categories_cars_fk FOREIGN KEY (car) REFERENCES public.cars(id);


--
-- PostgreSQL database dump complete
--

