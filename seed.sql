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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cars; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cars (
    id bigint NOT NULL,
    make text NOT NULL,
    model text NOT NULL,
    fuel text NOT NULL,
    style text NOT NULL,
    hw_mpg integer,
    city_mpg integer,
    msrp integer NOT NULL,
    cc integer,
    torque integer,
    seats smallint NOT NULL,
    main_pic_url text NOT NULL,
    other_image_urls text[],
    year integer,
    features text[],
    dealer_id integer
);


ALTER TABLE public.cars OWNER TO postgres;

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
-- Name: cars_users_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cars_users_reviews (
    car_id integer NOT NULL,
    user_id integer NOT NULL,
    content text NOT NULL,
    rating integer NOT NULL,
    date date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.cars_users_reviews OWNER TO postgres;

--
-- Name: dealers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dealers (
    id integer NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    created_at date DEFAULT CURRENT_TIMESTAMP,
    updated_at date,
    location point NOT NULL,
    "verificationToken" character varying(64),
    verified boolean DEFAULT false NOT NULL,
    "resetToken" character varying(64),
    address character varying,
    "contactNumber" text NOT NULL,
    website text
);


ALTER TABLE public.dealers OWNER TO postgres;

--
-- Name: dealers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dealers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dealers_id_seq OWNER TO postgres;

--
-- Name: dealers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dealers_id_seq OWNED BY public.dealers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    created_at date DEFAULT CURRENT_TIMESTAMP,
    updated_at date,
    "verificationToken" character varying(64),
    verified boolean DEFAULT false NOT NULL,
    "resetToken" character varying(64)
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
-- Name: cars id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars ALTER COLUMN id SET DEFAULT nextval('public.cars_id_seq'::regclass);


--
-- Name: dealers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealers ALTER COLUMN id SET DEFAULT nextval('public.dealers_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: cars; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cars (id, make, model, fuel, style, hw_mpg, city_mpg, msrp, cc, torque, seats, main_pic_url, other_image_urls, year, features, dealer_id) FROM stdin;
14	Lotus	Elite S	Diesel	Coupe	12	12	5000000	5000	1222	2	https://first-move-dev.s3.ap-southeast-1.amazonaws.com/Elite%20S-Lotus-1741978848501main-image-lotus.jpeg	{https://first-move-dev.s3.ap-southeast-1.amazonaws.com/Elite%20S-Lotus-1741978848501other-lotus1.jpg,https://first-move-dev.s3.ap-southeast-1.amazonaws.com/Elite%20S-Lotus-1741978848636other-lotus2.jpg}	2023	{Green,"I mean it is Lotus","Looks nice"}	1
15	Toyota	Yaris Ativ Premium Luxury	Petrol	Sedan	40	30	699000	1197	110	5	https://www.toyota.co.th/media/product/series/gallery/large/e3e606a4a31e0f3c69068aeb8929d17964e0b413722a3109c685ae4d80c55bd0.webp	{https://www.toyota.co.th/media/product/series/gallery/large/e3e606a4a31e0f3c69068aeb8929d17964e0b413722a3109c685ae4d80c55bd0.webp,https://www.toyota.co.th/media/product/series/gallery/large/2bec681ebd97aeb964c7858cf8efdec1aad7857692f323246a875989336be8a6.webp}	2024	{Sunroof,"Leather Seats","Blind Spot Monitoring","Lane Assist"}	2
16	Toyota	Yaris Ativ Nightshade	Petrol	Sedan	40	30	669000	1197	110	5	https://www.toyota.co.th/media/product/series/gallery/large/70fd3bd169a88b098779e8189c7f6d8a2946ea6180de431c093f6796be200b43.webp	{https://www.toyota.co.th/media/product/series/gallery/large/50c0202a2a8e131aeca12203e1499873db2f8196f511427399d8f8f7fba9ea35.webp,https://www.toyota.co.th/media/product/series/gallery/large/c50e0b61880459dfa353d4b78919e0e01ed450ad4e71010ac2245b1f00671905.webp}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	2
17	Toyota	Yaris	Petrol	Sedan	40	30	695000	1197	109	5	https://www.toyota.co.th/media/product/series/gallery/large/41e91590e10ae668f856d50b3f6cf7d386301743ecd92fde1648ed2144ab6c24.webp	{https://www.toyota.co.th/media/product/series/gallery/large/2971c61530757a2f9302a8dcbdee839cb53ca649befb25f7fe403441789d9fa9.webp,https://www.toyota.co.th/media/product/series/gallery/large/82743ad022acd58dd2dec4cd2c92dc3dd0ca1d1bab9ad86b5122269db649c0b4.webp}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	2
11	Porsche	911	Gas	Coupe	22	22	11000000	3000	222	2	https://first-move-dev.s3.ap-southeast-1.amazonaws.com/911-Porsche-1741973886996main-image-porsche.jpeg	{https://first-move-dev.s3.ap-southeast-1.amazonaws.com/911-Porsche-1741973886997other-porsche1.jpeg,https://first-move-dev.s3.ap-southeast-1.amazonaws.com/911-Porsche-1741973886998other-porsche2.jpeg}	2024	{"Aluminium Rims","Chick Magnet","Dude magnet as well"}	1
18	Toyota	Corolla Altis	Petrol	Sedan	35	25	894000	1798	142	5	https://www.toyota.co.th/media/product/series/gallery/large/1e6250ae0dd15aa80e16075ba87d05d245ed4d648363b33832a7b00147c3c4cf.webp	{https://www.toyota.co.th/media/product/series/gallery/large/b45e2ec9c49f632b247034a3df922ebb8dce320e59045ea6464d46759f8fef78.webp,https://www.toyota.co.th/media/product/series/gallery/large/3874cb5e7b0c6d42a014ca7f3114e5e8e2ed5a5aa0045ade4410f75f08fa3271.webp}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	2
19	Toyota	Corolla Altis GR 	Petrol	Sedan	35	25	1129000	1798	142	5	https://www.toyota.co.th/media/product/series/gallery/large/33e92af360aefb48e50523773d1fcd9e84265e6ae671a082c90129db51e37aa8.webp	{https://www.toyota.co.th/media/product/series/gallery/large/4a8063a06b0ece04a5ece569c068d4d9aaf91ffee66a8080bc8405b4baba1171.webp,https://www.toyota.co.th/media/product/series/gallery/large/c39be1776511fffa1a824d941fced7a3fe6f6805a484068411440fe1ac1fd8cd.webp}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	2
20	Toyota	Camry HEV Premium Luxury	Hybrid	Sedan	35	25	1789000	2487	221	5	https://www.toyota.co.th/media/product/series/gallery/large/52901443f98712096a22eecd78edbca4dd5c75708f9ccdac52f9ebab78c5b28c.webp	{https://www.toyota.co.th/media/product/series/gallery/large/004db4d0e2bf634eb46faad540cb681e79a398a6acdb1584077fddcde64dcfe2.webp,https://www.toyota.co.th/media/product/series/gallery/large/aa99c517e5735f0be58023e3035d3a0238b878ea683eef3b3fa3bc1f6858b0c5.webp}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	2
21	Toyota	Camry HEV Premium	Hybrid	Sedan	35	25	1639000	2487	221	5	https://www.toyota.co.th/media/product/series/grades/v/camry/11/f1e6c8e17ef81419187d4535b3171c53918cd09292cb592c6e25343412124836.webp	{https://www.toyota.co.th/media/product/series/gallery/large/393f4324102a60fbfbed35f9e34255b2685c64caed9ba8da8e2369609ec0f8a9.webp,https://www.toyota.co.th/media/product/series/gallery/large/a83732ed34ddfccc1626d935cda41dc4f902d3d0efd92da79168fd525c510d58.webp}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	2
22	Toyota	Camry HEV Smart	Hybrid	Sedan	35	25	1455000	2487	221	5	https://www.toyota.co.th/media/product/series/grades/v/camry/11/d6bb71a15dc3b4c2a529f728bb648e97e14080ea93984f412908ae6584b4190f.webp	{https://www.toyota.co.th/media/product/series/gallery/large/00007a3a9823585abe637d40143f89f28861ae7bbec3d007a46956bed3863e1d.webp,https://www.toyota.co.th/media/product/series/gallery/large/a83732ed34ddfccc1626d935cda41dc4f902d3d0efd92da79168fd525c510d58.webp}	2024	{Sunroof,"Leather Seats","Blind Spot Monitoring","Lane Assist"}	2
23	Toyota	GR Yaris	Petrol	Hatchback	35	25	3499000	1618	390	5	https://www.toyota.co.th/media/product/series/gallery/large/8f2c44dfb09ef5ac65608169ec58625caf235d1099188d2cda9d8aeeb4c1f108.webp	{https://www.toyota.co.th/media/product/series/gallery/large/80dc0b6a1df11604d515f086020fbf0288b9b47bb6eff3a4b54e6d671d72d34b.webp,https://www.toyota.co.th/media/product/series/gallery/large/c32fbe73081ccde42826fe3e075d2ee625abdbc9dd04776b9f3aa0502e76ae23.webp}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	2
24	Toyota	GR Corolla	Petrol	Hatchback	35	25	4199000	1618	400	5	https://www.toyota.co.th/media/product/series/gallery/large/45de745eb33b00af709adfd16f7ace8b1ef18e37fd17714703dedc96b096cb50.webp	{https://www.toyota.co.th/media/product/series/gallery/large/32d20499f40fcb2b7f937fbbcf0de329fa8fe71936c25977e4cdb5c1e50a66d4.webp,https://www.toyota.co.th/media/product/series/gallery/large/01ac02de00174e7ab668754ce9f85fbe35ad41af2c7e6471c434a24a5867c058.webp}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	2
25	Toyota	Yaris Cross HEV Premium Luxury	Hybrid	SUV	35	25	899000	1496	121	5	https://www.toyota.co.th/media/product/series/grades/v/yariscross/17/6f4a8b34bcd92096c1efd1b4cdee6c69235f2ea07fea4e2b84df58b1d67de678.webp	{https://www.toyota.co.th/media/product/series/gallery/large/5c6eb28dd6ba77bb6195b5f140b7d312c5f1662e4b3b6c5ff89d4e29d7e022f9.webp,https://www.toyota.co.th/media/product/series/gallery/large/bc9dc413c55759fb7502625e9a0db927950fe9a7e9a4e4e4dde3da7900706585.webp}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	2
26	Toyota	Yaris Cross HEV Premium	Hybrid	SUV	35	25	849000	1496	121	5	https://www.toyota.co.th/media/product/series/grades/v/yariscross/17/a5425f9d5d136de4fb078b77d02635a82df1378a069ff43ad784590dce4e2472.webp	{https://www.toyota.co.th/media/product/series/gallery/large/5c6eb28dd6ba77bb6195b5f140b7d312c5f1662e4b3b6c5ff89d4e29d7e022f9.webp,https://www.toyota.co.th/media/product/series/gallery/large/bc9dc413c55759fb7502625e9a0db927950fe9a7e9a4e4e4dde3da7900706585.webp}	2024	{Sunroof,"Leather Seats","Blind Spot Monitoring","Lane Assist"}	2
27	Toyota	Yaris Cross HEV Smart	Hybrid	SUV	35	25	789000	1496	121	5	https://www.toyota.co.th/media/product/series/grades/v/yariscross/17/c4f53df92d2bcdb25bd92782d7eb434cdeea945ee834341e367f078335ce6a56.webp	{https://www.toyota.co.th/media/product/series/gallery/large/5c6eb28dd6ba77bb6195b5f140b7d312c5f1662e4b3b6c5ff89d4e29d7e022f9.webp,https://www.toyota.co.th/media/product/series/gallery/large/bc9dc413c55759fb7502625e9a0db927950fe9a7e9a4e4e4dde3da7900706585.webp}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	2
28	Toyota	Corolla Cross HEV Premium Luxury	Hybrid	SUV	35	25	1204000	1798	142	5	https://www.toyota.co.th/media/product/series/grades/v/corollacross/10/7189d9bc58e03a3e2867855d9d47374a988ed149d4031316658b1523fa16abb3.webp	{https://www.toyota.co.th/media/product/series/gallery/large/32fcc0395a98b6ec7e525929852a891d01fb6e0f43b4ccdc92681aa008a861ee.webp,https://www.toyota.co.th/media/product/series/gallery/large/e9c539572fbcaf362f5315996dfa051fc4581d1d517b332891ce317f5e66c3ae.webp}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	2
29	Toyota	Corolla Cross HEV Premium 	Hybrid	SUV	35	25	1094000	1798	142	5	https://www.toyota.co.th/media/product/series/grades/v/corollacross/10/c8f8ddfcfdfffcd3cb071b88088c45be91063d1afbda53434ee2379615dceff3.webp	{https://www.toyota.co.th/media/product/series/gallery/large/d21ce5405f70bc437d1ca090cb28e57697ce6712dfccdda00634a16a2074e16d.webp,https://www.toyota.co.th/media/product/series/gallery/large/dbdab548597f37785c9a0520780a03d44ee79ca86dd3d2e767cf2d60ec452835.webp}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	2
30	Toyota	Corolla Cross HEV Premium Smart	Hybrid	SUV	35	25	999000	1798	142	5	https://www.toyota.co.th/media/product/series/grades/v/corollacross/10/da652638b0bbd795980a2e9651bc163a69dbd095a06e23fb98c0661bfac35023.webp	{https://www.toyota.co.th/media/product/series/gallery/large/b03145e3e3858ec52528c298b85d45e7c8e58b3d2055a92e6060fadbd0fa2345.webp,https://www.toyota.co.th/media/product/series/gallery/large/bd28a9275fbf446dd27e85a0c35e4778cec7027591708195299d5f2643101ad8.webp}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	2
31	Toyota	Corolla Cross GR Sport	Hybrid	SUV	35	25	1254000	1798	142	5	https://www.toyota.co.th/media/product/series/gallery/large/ac74f0843a215feb6bbfda6f5a45b16c513dc6ee9279f2e14a5432f69582f8c5.webp	{https://www.toyota.co.th/media/product/series/gallery/large/ed51f1a5e6959cc80639fc9366cb19ee922eb1ba332e28d46b9829ff1590b35a.webp,https://www.toyota.co.th/media/product/series/gallery/large/b51b4cdbfdaa67f223b2f0b9cfcc77b93dfc11b9f93ec24cf4829aee306b4e54.webp}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	2
32	Toyota	Fortuner Leader 2.4 Leader V 4WD	Petrol	SUV	35	25	1600000	2393	400	7	https://www.toyota.co.th/media/product/series/gallery/large/3284e55f3a549a12a5297d02d4f7a1db4b63433fdb6c2dd03a98140aa110b5e1.webp	{https://www.toyota.co.th/media/product/series/gallery/large/f5e46a6f7b874e727962cca79adf2805817e7e796c795ec2fba21cce0d86d17f.webp,https://www.toyota.co.th/media/product/series/gallery/large/367c348b358998aa35f8af2ef5d1ce23f443a480bd17cd9ce42a8e52bb8d144e.webp}	2024	{Sunroof,"Leather Seats","Blind Spot Monitoring","Lane Assist"}	2
33	Toyota	Fortuner Leader 2.4 Leader V	Petrol	SUV	35	25	1530000	2393	400	7	https://www.toyota.co.th/media/product/series/gallery/large/3284e55f3a549a12a5297d02d4f7a1db4b63433fdb6c2dd03a98140aa110b5e1.webp	{https://www.toyota.co.th/media/product/series/gallery/large/f5e46a6f7b874e727962cca79adf2805817e7e796c795ec2fba21cce0d86d17f.webp,https://www.toyota.co.th/media/product/series/gallery/large/367c348b358998aa35f8af2ef5d1ce23f443a480bd17cd9ce42a8e52bb8d144e.webp}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	2
34	Toyota	Fortuner Leader 2.4 Leader G	Petrol	SUV	35	25	1400000	2393	400	7	https://www.toyota.co.th/media/product/series/gallery/large/3284e55f3a549a12a5297d02d4f7a1db4b63433fdb6c2dd03a98140aa110b5e1.webp	{https://www.toyota.co.th/media/product/series/gallery/large/f5e46a6f7b874e727962cca79adf2805817e7e796c795ec2fba21cce0d86d17f.webp,https://www.toyota.co.th/media/product/series/gallery/large/367c348b358998aa35f8af2ef5d1ce23f443a480bd17cd9ce42a8e52bb8d144e.webp}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	2
35	Toyota	Fortuner Legender 2.8 Legender 4WD	Petrol	SUV	26	26	1904000	2755	500	7	https://www.toyota.co.th/media/product/series/grades/v/fortuner_legender/47/60206d0f2e120fce5c431cddf9fca7d386878b12da29015845a12420748a2e3d.webp	{https://www.toyota.co.th/media/product/series/gallery/large/88b5a377fe85d8ed71a3b025dcfd57608c907e811f366f24696b1ffe0a8bddd6.webp,https://www.toyota.co.th/media/product/series/gallery/large/6bb395dcc65beecdcbaf657dc2cb3d3b1f051cc4796deb4d248a39fd1a0a8464.webp}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	2
36	Toyota	Fortuner Legender 2.8 Legender	Petrol	SUV	26	27	1835000	2755	500	7	https://www.toyota.co.th/media/product/series/grades/v/fortuner_legender/47/474d4d906946a5fb8014dd0bb405d22913333dc8d4f5620216877d356c8b84af.webp	{https://www.toyota.co.th/media/product/series/gallery/large/88b5a377fe85d8ed71a3b025dcfd57608c907e811f366f24696b1ffe0a8bddd6.webp,https://www.toyota.co.th/media/product/series/gallery/large/6bb395dcc65beecdcbaf657dc2cb3d3b1f051cc4796deb4d248a39fd1a0a8464.webp}	2024	{Sunroof,"Leather Seats","Blind Spot Monitoring","Lane Assist"}	2
37	Toyota	Fortuner Legender 2.4 Legender 4WD	Petrol	SUV	26	28	1713000	2393	400	7	https://www.toyota.co.th/media/product/series/grades/v/fortuner_legender/47/07ced21143e7b60fafed6eee2be4d24f56570cfb9b85790bc9ea12526983b1c4.webp	{https://www.toyota.co.th/media/product/series/gallery/large/88b5a377fe85d8ed71a3b025dcfd57608c907e811f366f24696b1ffe0a8bddd6.webp,https://www.toyota.co.th/media/product/series/gallery/large/6bb395dcc65beecdcbaf657dc2cb3d3b1f051cc4796deb4d248a39fd1a0a8464.webp}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	2
38	Toyota	Fortuner GR Sport	Petrol	SUV	26	25	1969000	2755	500	7	https://www.toyota.co.th/media/product/series/gallery/large/6a99364b9112367ea64f465fb0eaca1d84011cd23060dea69e751879fa5ae730.webp	{https://www.toyota.co.th/media/product/series/gallery/large/f5c804335b72ffa480b137d80058ac2aca678ef50e96ab14cf8581f6fca4860c.webp,https://www.toyota.co.th/media/product/series/gallery/large/8ba4165a06d747b14bcfc3578e2647c4da85025d918cf5c2c718d20f69a5bece.webp}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	2
39	Toyota	Velox Premium	Petrol	MPV	26	25	875000	1496	138	7	https://www.toyota.co.th/media/product/series/grades/v/veloz/39/c64c45c4a3e250f2c457758978352dba.png	{https://www.toyota.co.th/media/product/series/gallery/large/6ea12e2bf11feef132bb346d2b60b599d3c7ea7bdbb64a387c4daf5e711a4ecd.webp,https://www.toyota.co.th/media/product/series/gallery/large/7b7a355ba9c3f38717091d761ab8451910f1f280a56dbe3ad5d51482a298cc15.webp}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	2
40	Toyota	Velox Smart	Petrol	MPV	35	25	795000	1496	138	7	https://www.toyota.co.th/media/product/series/grades/v/veloz/39/ac6ff45e2eb838f7cc7888fdc5882fabdffc60de377f7489644209799067d7ca.webp	{https://www.toyota.co.th/media/product/series/gallery/large/6ea12e2bf11feef132bb346d2b60b599d3c7ea7bdbb64a387c4daf5e711a4ecd.webp,https://www.toyota.co.th/media/product/series/gallery/large/7b7a355ba9c3f38717091d761ab8451910f1f280a56dbe3ad5d51482a298cc15.webp}	2024	{Sunroof,"Leather Seats","Blind Spot Monitoring","Lane Assist"}	2
41	Toyota	Innova Zenix 2.0 HEV Premium	Hybrid	MPV	35	25	1479000	1987	112	7	https://www.toyota.co.th/media/product/series/grades/v/innovazenix/7/b92df9032d3a40048f85fcd1fbe01a769bb97117cb3cfe99894b055b2e4a6edc.webp	{https://www.toyota.co.th/media/product/series/gallery/large/389315a98a8cb860f617a8f06c35394886bc7cadab0d27a2b456f4b8f4496e0a.webp,https://www.toyota.co.th/media/product/series/gallery/large/cc7ec6ff87d576477fa508de980bf670ff4e643f9d579dfffe12b5763d6a5abd.webp}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	2
42	Toyota	Innova Zenix 2.0 HEV Smart	Hybrid	MPV	35	25	1379000	1987	112	7	https://www.toyota.co.th/media/product/series/grades/v/innovazenix/7/e8bd3c24388c41f57ef22b3b69ed08112f5f894475aed674a9fde28fb16c4089.webp	{https://www.toyota.co.th/media/product/series/gallery/large/389315a98a8cb860f617a8f06c35394886bc7cadab0d27a2b456f4b8f4496e0a.webp,https://www.toyota.co.th/media/product/series/gallery/large/cc7ec6ff87d576477fa508de980bf670ff4e643f9d579dfffe12b5763d6a5abd.webp}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	2
43	Toyota	Alphard 2.5 HEV Luxury	Hybrid	MPV	35	25	4639000	2487	238	7	https://www.toyota.co.th/media/product/series/grades/v/alphard/12/9bd8c8811a6213ea1429d91b5bcba32246b73d1255cbb3ae6be04309d1231b08.webp	{https://www.toyota.co.th/media/product/series/gallery/large/fb73f916acf87d37ac0a4d06baa23624b9ae992c080fda26289250b36c2833b2.webp,https://www.toyota.co.th/media/product/series/gallery/large/d3f384a0947a02494fa7258b03dc9b53bcd9d37b11afa87b50abaffc543e4230.webp}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	2
44	Toyota	Alphard 2.5 HEV Luxury	Hybrid	MPV	35	25	4269000	2487	238	7	https://www.toyota.co.th/media/product/series/grades/v/alphard/12/c7b8b8549adf34429d54588205bcb095a72fada0f0e60ab8a7521bc8376a67b4.webp	{https://www.toyota.co.th/media/product/series/gallery/large/d3f384a0947a02494fa7258b03dc9b53bcd9d37b11afa87b50abaffc543e4230.webp,https://www.toyota.co.th/media/product/series/gallery/large/5858118cdfaeed9a74eb3800f693251d9afcacde3e531677cb6339e18ccadffc.webp}	2024	{Sunroof,"Leather Seats","Blind Spot Monitoring","Lane Assist"}	2
45	Toyota	Vellfire 2.5 HEV	Hybrid	MPV	35	25	4419000	2487	238	7	https://www.toyota.co.th/media/product/series/grades/v/alphard/12/515b595871ca44c0d807c674068d62602071db5de4d6b077c57f836b85daca37.webp	{https://www.toyota.co.th/media/product/series/gallery/large/4faf3a09ba999dbe96f2a64363d3a3468907ebbc16ab637135bf390b09b603d2.webp,https://www.toyota.co.th/media/product/series/gallery/large/d3f384a0947a02494fa7258b03dc9b53bcd9d37b11afa87b50abaffc543e4230.webp}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	2
46	Toyota	Hilux Champ 2.4 Diesel AT SWB Attractive Package	Petrol	Truck	23	23	597000	2393	400	2	https://www.toyota.co.th/media/product/series/grades/v/hilux_champ/8/ce0d3f56bd803961e1c65dea8a720e3e7a32ae30577a08ad71b574c7b13be9ae.webp	{https://www.toyota.co.th/media/product/series/gallery/large/1c8de8cd24157e98f130c003ba68ca490538d55ed65116ee2ade7df6ddf2aec2.webp,https://www.toyota.co.th/media/product/series/gallery/large/461b68ca5c70a1bb3637f909ea6c7b5a1cefdf8681dc4b716dfab30a213e7ca3.webp}	2024	{Sunroof,"Leather Seats","Blind Spot Monitoring","Lane Assist"}	2
47	Toyota	Hilux Champ 2.4 Diesel AT LWB	Petrol	Truck	23	23	577000	2393	400	2	https://www.toyota.co.th/media/product/series/grades/v/hilux_champ/8/aed4c46e736a8b67427bae6cb03dd2dbf6397fcbade089bb55014d30629ec7cc.webp	{https://www.toyota.co.th/media/product/series/gallery/large/6fe032740f392f82164fa0b7289e3650ab2caf7479dcbcf2a941ef99e7fd3195.webp,https://www.toyota.co.th/media/product/series/gallery/large/092d98212db60b1e9b2778a9cf5e6584213228ba95b424533146de6919c853a7.webp}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	2
48	Toyota	Hilux Champ 2.4 Diesel AT C&C SWB	Petrol	Truck	23	23	552000	2393	400	2	https://www.toyota.co.th/media/product/series/grades/v/hilux_champ/8/2a03069a171d62cbc56667f3a14acf41736c9147dff8510cf03d0f975ef7cc17.webp	{https://www.toyota.co.th/media/product/series/gallery/large/6fe032740f392f82164fa0b7289e3650ab2caf7479dcbcf2a941ef99e7fd3195.webp,https://www.toyota.co.th/media/product/series/gallery/large/092d98212db60b1e9b2778a9cf5e6584213228ba95b424533146de6919c853a7.webp}	2024	{Sunroof,"Leather Seats","Blind Spot Monitoring","Lane Assist"}	2
49	Toyota	Hilux Revo Standard Cab 4x4 2.8 Entry AT	Petrol	Truck	23	23	801000	2755	420	2	https://www.toyota.co.th/media/product/series/grades/v/hilux_revo_standard/185/ec78f1f49a768c1a57d56a5e90778c9550f233efe9813ec1124dc4e15b4abf5f.webp	{https://www.toyota.co.th/media/product/series/gallery/large/bbca6c834e55f7e9afe40bb77a8d82a59c9f4b907eb2c37ef9ad0f8b243f21a1.webp,https://www.toyota.co.th/media/product/series/gallery/large/d5c556fd2bf229ca22f3f815874c492ce076ccb50382e14eb4fa0c6613017b41.webp}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	2
50	Toyota	Hilux Revo Standard Cab 4x4 2.8 Entry AT	Petrol	Truck	23	23	749000	2755	420	2	https://www.toyota.co.th/media/product/series/grades/v/hilux_revo_standard/185/872dcbfb0e17bbd224092802bd24f5ec247f56c3696d4bf56e7eb2354d69cd2a.webp	{https://www.toyota.co.th/media/product/series/gallery/large/bbca6c834e55f7e9afe40bb77a8d82a59c9f4b907eb2c37ef9ad0f8b243f21a1.webp,https://www.toyota.co.th/media/product/series/gallery/large/d5c556fd2bf229ca22f3f815874c492ce076ccb50382e14eb4fa0c6613017b41.webp}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	2
51	Toyota	Hilux Revo Standard Cab 4X2 2.8 Entry	Petrol	Truck	23	23	639000	2755	420	2	https://www.toyota.co.th/media/product/series/grades/v/hilux_revo_standard/185/8aa862d10109e58d535bde166aeb3ec4b7e8c4798c7ac6718c1245cf5f3d6e64.webp	{https://www.toyota.co.th/media/product/series/gallery/large/bbca6c834e55f7e9afe40bb77a8d82a59c9f4b907eb2c37ef9ad0f8b243f21a1.webp,https://www.toyota.co.th/media/product/series/gallery/large/d5c556fd2bf229ca22f3f815874c492ce076ccb50382e14eb4fa0c6613017b41.webp}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	2
52	Toyota	Hilux Revo Prerunner & 4x4 Double Cab 4x4 2.8 High AT	Petrol	Truck	23	23	1252000	2755	500	5	https://www.toyota.co.th/media/product/series/grades/v/hilux_revo_prerunner/190/a4bc9c0025733d22d2a21aba146ec53778cf4c1232a53472251d76d0bdec2550.webp	{https://www.toyota.co.th/media/product/series/gallery/large/d9335a758fca203c52f6e84b55021b8c3d7ee4ee04e451b2e93a1eca49222c3b.webp,https://www.toyota.co.th/media/product/series/gallery/large/135be01e4fe713fa619f3e8a207523db787b0703cfd8206815f7aee7d1926ca1.webp}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	2
53	Toyota	Hilux Revo Prerunner & 4x4 Double Cab 4x4 2.8 High	Petrol	Truck	23	23	1202000	2755	500	5	https://www.toyota.co.th/media/product/series/grades/v/hilux_revo_prerunner/190/52d3b1d4a733d3e9632582147a9a5052d032edf5131a34b585884367cb34aefe.webp	{https://www.toyota.co.th/media/product/series/gallery/large/d9335a758fca203c52f6e84b55021b8c3d7ee4ee04e451b2e93a1eca49222c3b.webp,https://www.toyota.co.th/media/product/series/gallery/large/135be01e4fe713fa619f3e8a207523db787b0703cfd8206815f7aee7d1926ca1.webp}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	2
54	Toyota	Hilux Revo Prerunner & 4x4 Double Cab 4x4 2.4 Mid	Petrol	Truck	23	23	1050000	2755	500	5	https://www.toyota.co.th/media/product/series/grades/v/hilux_revo_prerunner/190/95788b4c4aeeb9139987daac68aca9f51e5de570caf644697c15ce07c24dcfa9.webp	{https://www.toyota.co.th/media/product/series/gallery/large/d9335a758fca203c52f6e84b55021b8c3d7ee4ee04e451b2e93a1eca49222c3b.webp,https://www.toyota.co.th/media/product/series/gallery/large/135be01e4fe713fa619f3e8a207523db787b0703cfd8206815f7aee7d1926ca1.webp}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	2
55	Toyota	Hilux Revo Rocco Double Cab 4x4 2.8 Rocco AT	Petrol	Truck	23	23	1326000	2755	500	5	https://www.toyota.co.th/media/product/series/grades/v/hilux_revo_rocco/187/835e60c0fa9b165031333ff0db666c3e7a6c021666937121724197bede0dd10f.webp	{https://www.toyota.co.th/media/product/series/gallery/large/e63da25d3a2950a617fa4c4b3624fb51c48991e348f9249df85a6b8b3fd911f3.webp,https://www.toyota.co.th/media/product/series/gallery/large/718618393ba6aeecc71be8f3a508ee829dfa7f53c495a27118f2d3e4b5c8351e.webp}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	2
56	Toyota	Hilux Revo Rocco Double Cab Prerunner 2x4 2.4 Rocco AT	Petrol	Truck	23	23	1136000	2755	500	5	https://www.toyota.co.th/media/product/series/grades/v/hilux_revo_rocco/187/39be70df0206cb234ef0ad4e0701754c3a06af2949a65287b15ac908e85cf3af.webp	{https://www.toyota.co.th/media/product/series/gallery/large/e63da25d3a2950a617fa4c4b3624fb51c48991e348f9249df85a6b8b3fd911f3.webp,https://www.toyota.co.th/media/product/series/gallery/large/718618393ba6aeecc71be8f3a508ee829dfa7f53c495a27118f2d3e4b5c8351e.webp}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	2
57	Toyota	Hilux Revo Rocco Smart Cab 4x4 2.8 Rocco AT	Petrol	Truck	23	23	1161000	2755	500	5	https://www.toyota.co.th/media/product/series/grades/v/hilux_revo_rocco/187/6a2aa258e7ab38bff9d4a4238b030cff78497424687b163656f961ef1587b32a.webp	{https://www.toyota.co.th/media/product/series/gallery/large/723bac937aaa9f60fa3f6f8af062a82007b275087e6529d59c3718cf6cfdab12.webp,https://www.toyota.co.th/media/product/series/gallery/large/3bd4210c7332d9cec1668dee4dab4800fe9ed5037ca8186d584ea36107c2a03e.webp}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	2
58	Toyota	Hilux Revo GR Sport Double Cab 4x4 2.8 GR Sport AT	Petrol	Truck	23	23	1499000	2755	550	5	https://www.toyota.co.th/media/product/series/grades/v/hilux_revo_grsport/185/65c4562da9fa98cd8e8d730656a18e9ebf865f2cdfb83769e0b831b2941f8818.webp	{https://www.toyota.co.th/media/product/series/gallery/large/f5783cbf1bab1c8b9bec53edfe2aaa9d4eb23bb2cfcc3888cbfacdaf8be46355.webp,https://www.toyota.co.th/media/product/series/gallery/large/bf8133d399600cbf51c3c51d4bb458709b5130485d5c71f1eecef53e6411f839.webp}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	2
59	Toyota	Hilux Revo GR Sport Double Cab 4x4 2.8 GR Sport AT Base Model	Petrol	Truck	23	23	1479000	2755	550	5	https://www.toyota.co.th/media/product/series/grades/v/hilux_revo_grsport/185/8752867699734966c3dc588ee87be43ea5c77a5a2bed3860a31216a39fdb42be.webp	{https://www.toyota.co.th/media/product/series/gallery/large/f5783cbf1bab1c8b9bec53edfe2aaa9d4eb23bb2cfcc3888cbfacdaf8be46355.webp,https://www.toyota.co.th/media/product/series/gallery/large/bf8133d399600cbf51c3c51d4bb458709b5130485d5c71f1eecef53e6411f839.webp}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	2
60	Toyota	Hilux Revo GR Sport Double Cab 4x2 2.8 GR Sport AT	Petrol	Truck	23	23	934000	2755	550	5	https://www.toyota.co.th/media/product/series/grades/v/hilux_revo_grsport/185/5fb0017b3cce9ac0edc22756bdead887cff62f59b2d9cf7926f9f786be489f01.webp	{https://www.toyota.co.th/media/product/series/gallery/large/da048d0c307827cda27b8bf21dd891784dad851e6d87a06407c91f057a6ee6d5.webp,https://www.toyota.co.th/media/product/series/gallery/large/ec03a7a075cda27ae38101aa0ee50d29d7e8fb7bd6b996382f14311ed17cc596.webp}	2024	{Sunroof,"Leather Seats","Blind Spot Monitoring","Lane Assist"}	2
67	Honda	HR-V e:HEV E	Hybrid	SUV	60	48	949000	1498	127	5	https://www.honda.co.th/uploads/car_models/grade/1730783502_26.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1730896112_264.jpg}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	3
68	Honda	HR-V e:HEV EL	Hybrid	SUV	60	48	1079000	1498	127	5	https://www.honda.co.th/uploads/car_models/grade/1730783502_399.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1730896113_928.jpg}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	3
69	Honda	HR-V e:HEV RS	Hybrid	SUV	60	48	1179000	1498	127	5	https://www.honda.co.th/uploads/car_models/grade/1730783502_458.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1730896113_390.jpg}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	3
89	Honda	HR-V e:HEV E	Hybrid	SUV	60	48	949000	1498	127	5	https://www.honda.co.th/uploads/car_models/grade/1730783502_26.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1730896112_264.jpg}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	3
90	Honda	HR-V e:HEV EL	Hybrid	SUV	60	48	1079000	1498	127	5	https://www.honda.co.th/uploads/car_models/grade/1730783502_399.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1730896113_928.jpg}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	3
91	Honda	HR-V e:HEV RS	Hybrid	SUV	60	48	1179000	1498	127	5	https://www.honda.co.th/uploads/car_models/grade/1730783502_458.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1730896113_390.jpg}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	3
92	Honda	Civic EL+	Petrol	Sedan	40	33	1039000	1498	240	5	https://www.honda.co.th/uploads/car_models/grade/1723361504_815.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1724207292_458.jpg}	2024	{Sunroof,"Leather Seats","Blind Spot Monitoring","Lane Assist"}	3
93	Honda	Civic e:HEV EL+	Hybrid	Sedan	59	47	1099000	1993	315	5	https://www.honda.co.th/uploads/car_models/grade/1723359037_915.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1724207292_730.jpg}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	3
94	Honda	Civic e:HEV RS	Hybrid	Sedan	59	47	1239000	1993	315	5	https://www.honda.co.th/uploads/car_models/grade/1723359037_193.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1724207293_849.jpg}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	3
95	Honda	e:N1	EV	SUV	\N	\N	1490000	\N	310	5	https://www.honda.co.th/uploads/car_models/grade/1704455861_388.png	{https://www.honda.co.th/uploads/car_models/interior_color/1704448734_55.jpg}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	3
96	Honda	City S	Petrol	Sedan	55	44	599000	988	173	5	https://www.honda.co.th/uploads/car_models/grade/1709478856_844.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1709480012_243.jpg}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	3
97	Honda	City V	Petrol	Sedan	55	44	629000	988	173	5	https://www.honda.co.th/uploads/car_models/grade/1709196621_981.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1709480012_318.jpg}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	3
98	Honda	City SV	Petrol	Sedan	55	44	679000	988	173	5	https://www.honda.co.th/uploads/car_models/grade/1709196786_869.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1709480012_940.jpg}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	3
99	Honda	City RS	Petrol	Sedan	55	44	749000	988	173	5	https://www.honda.co.th/uploads/car_models/grade/1709196868_378.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1709480012_941.jpg}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	3
100	Honda	City e:HEV SV	Hybrid	Sedan	65	56	729000	1498	253	5	https://www.honda.co.th/uploads/car_models/grade/1709196964_469.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1709480012_485.jpg}	2024	{Sunroof,"Leather Seats","Blind Spot Monitoring","Lane Assist"}	3
101	Honda	City e:HEV RS	Hybrid	Sedan	65	56	799000	1498	253	5	https://www.honda.co.th/uploads/car_models/grade/1709479126_934.jpeg	{https://www.honda.co.th/uploads/car_models/interior_color/1709480012_995.jpg}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	3
102	Honda	City hatchback S+	Petrol	Hatchback	55	44	599000	988	173	5	https://www.honda.co.th/uploads/car_models/grade/1705465774_128.png	{https://www.honda.co.th/uploads/car_models/interior_color/1705902044_752.jpg}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	3
103	Honda	City hatchback SV	Petrol	Hatchback	55	44	679000	988	173	5	https://www.honda.co.th/uploads/car_models/grade/1705465774_552.png	{https://www.honda.co.th/uploads/car_models/interior_color/1705902044_2.jpg}	2024	{Sunroof,"Leather Seats","Blind Spot Monitoring","Lane Assist"}	3
104	Honda	City hatchback RS	Petrol	Hatchback	55	44	749000	988	173	5	https://www.honda.co.th/uploads/car_models/grade/1705465774_51.png	{https://www.honda.co.th/uploads/car_models/interior_color/1705902045_752.jpg}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	3
105	Honda	City hatchback e:HEV SV	Hybrid	Hatchback	65	56	729000	1498	253	5	https://www.honda.co.th/uploads/car_models/grade/1705465774_314.png	{https://www.honda.co.th/uploads/car_models/interior_color/1705902045_823.jpg}	2024	{Sunroof,"Leather Seats","Blind Spot Monitoring","Lane Assist"}	3
106	Honda	City hatchback e:HEV RS	Hybrid	Hatchback	65	56	799000	1498	253	5	https://www.honda.co.th/uploads/car_models/grade/1705465775_197.png	{https://www.honda.co.th/uploads/car_models/interior_color/1705902045_339.jpg}	2024	{Sunroof,"Leather Seats","Blind Spot Monitoring","Lane Assist"}	3
107	Honda	Accord e:HEV E	Hybrid	Sedan	57	48	1529000	1993	335	5	https://www.honda.co.th/uploads/car_models/grade/1697019579_763.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1697705849_840.jpg}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	3
108	Honda	Accord e:HEV EL	Hybrid	Sedan	57	48	1669000	1993	335	5	https://www.honda.co.th/uploads/car_models/grade/1697019579_595.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1697705849_297.jpg}	2024	{Sunroof,"Leather Seats","Blind Spot Monitoring","Lane Assist"}	3
109	Honda	Accord e:HEV RS	Hybrid	Sedan	57	48	1799000	1993	335	5	https://www.honda.co.th/uploads/car_models/grade/1711353608_87.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1697705849_354.jpg}	2024	{Sunroof,"Leather Seats","Blind Spot Monitoring","Lane Assist"}	3
110	Honda	Civic Type R	Petrol	Hatchback	30	23	3990000	1996	420	5	https://www.honda.co.th/uploads/car_models/grade/1678589161_587.jpg	{https://www.honda.co.th/uploads/car_models/design_style/1679259147_797.jpg}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	3
111	Honda	CRV E	Petrol	SUV	33	26	1419000	1498	240	5	https://www.honda.co.th/uploads/car_models/grade/1678430740_127.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1678517406_621.jpg}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	3
112	Honda	CRV ES 4WD	Petrol	SUV	31	24	1599000	1498	240	5	https://www.honda.co.th/uploads/car_models/grade/1678430740_520.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1678517406_508.jpg}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	3
113	Honda	CRV EL 4WD	Petrol	SUV	31	24	1649000	1498	240	5	https://www.honda.co.th/uploads/car_models/grade/1678431887_982.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1678517406_753.jpg}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	3
114	Honda	CRV e:HEV ES	Hybrid	SUV	47	40	1589000	1993	335	5	https://www.honda.co.th/uploads/car_models/grade/1678431887_674.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1678517406_866.jpg}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	3
115	Honda	CRV e:HEV RS 4WD	Hybrid	SUV	46	39	1729000	1993	335	5	https://www.honda.co.th/uploads/car_models/grade/1678431887_437.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1678517406_203.jpg}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	3
116	Honda	WR-V SV	Petrol	SUV	47	36	799000	1498	145	5	https://www.honda.co.th/uploads/car_models/grade/1678164031_392.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1678152690_702.jpg}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	3
117	Honda	WR-V RS	Petrol	SUV	47	36	869000	1498	145	5	https://www.honda.co.th/uploads/car_models/grade/1678164098_992.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1678152689_425.jpg}	2024	{ABS,Airbags,"Touchscreen Infotainment","Rear Parking Sensors"}	3
118	Honda	BR-V E - Taffeta White	Petrol	SUV	44	31	915000	1498	145	7	https://www.honda.co.th/uploads/car_models/grade/1660883074_705.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1658824477_542.jpg}	2024	{"Cruise Control","Apple CarPlay","Android Auto","Keyless Entry"}	3
119	Honda	BR-V E - Crystal Black	Petrol	SUV	44	31	921000	1498	145	7	https://www.honda.co.th/uploads/car_models/grade/1658383042_706.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1658824477_542.jpg}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	3
120	Honda	BR-V EL - Crystal Black	Petrol	SUV	44	31	973000	1498	145	7	https://www.honda.co.th/uploads/car_models/grade/1660883077_800.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1658824477_441.jpg}	2024	{"Heated Seats","Wireless Charging","Adaptive Cruise Control","Rear Camera"}	3
121	Honda	BR-V EL - Premium Sunlight	Petrol	SUV	44	31	977000	1498	145	7	https://www.honda.co.th/uploads/car_models/grade/1658889083_165.jpg	{https://www.honda.co.th/uploads/car_models/interior_color/1658824477_441.jpg}	2024	{Sunroof,"Leather Seats","Blind Spot Monitoring","Lane Assist"}	3
\.


--
-- Data for Name: cars_users_reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cars_users_reviews (car_id, user_id, content, rating, date) FROM stdin;
25	18	I am a student commuting a 2hour drive every day. Yaris is a life saver for me not because of the commute but because I can bring all my friends for the road trip.	5	2025-03-16
25	19	I am a father of three. My kids absolutely loved the car. It makes my wife happy, which in turn makes my life easier. Thanks Toyota	5	2025-03-16
92	19	Love my Civic. Fast, fuel-efficient and more importantly I am popular in school. How nice is that!	5	2025-03-16
46	19	Hilux literally changed my life.	5	2025-03-16
\.


--
-- Data for Name: dealers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dealers (id, name, email, password, created_at, updated_at, location, "verificationToken", verified, "resetToken", address, "contactNumber", website) FROM stdin;
1	The Best Dealership	fafapnr@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$QN1VxyXzPVYbZrJ7koZyFA$kr39nLVWoFrI3SERwuKCC8CqwZa12t76cwCmINgHMcg	2025-03-11	2025-03-11	(13.740963641511762,100.82649707881502)	fdbe5004f446a976e95e6426fa814f5b8c26726b8518039afa885d2c5af19505	f	\N	Bangkok-Chon Buri Road Left Side Service Road, ชุมชนสุทธาวาส, Thap Yao Subdistrict, Lat Krabang District, Bangkok, 10520, Thailand	+66943030517	thebest.co.th
2	Toyota Bangkok	bangkok@toyota.ac.jp	$argon2id$v=19$m=65536,t=3,p=4$/7KxmmSovVQz669ixYrfWQ$zrbZ5F2qekCx5O+CUyzvJVqCHS7IFUNNILNqRJbh9zY	2025-03-15	2025-03-15	(13.69731597992758,100.52068948789385)	3cb2a8fde8d4b54c1e808630f21e8da19e9a39aecbd4f74055106d1176d9726b	f	\N	Soi Chan 43 Yeak 18-17, Muang Yoo Dee Community, Bang Khlo Subdistrict, Bang Kho Laem District, Bangkok, 10120, Thailand	+66943030552	toyota.com
3	Honda Bangkok	bangkok@honda.ac.jp	$argon2id$v=19$m=65536,t=3,p=4$cMPagK0A3Cm9qnmVBSJ4qg$tMTsGbzT8RrRDnDxN/22Bh4aeEdg3l/bpoUyORGd44g	2025-03-16	2025-03-16	(13.77571141519127,100.53514480940068)	fdc3708076c1d8fbdeee90b113209168ede60da479faf1cc6ff1c323eabd3beb	f	\N	Soi Ari Samphan 5, Ari Samphan, Phaya Thai Subdistrict, Phaya Thai District, Bangkok, 10400, Thailand	+66956634755	https://www.honda.co.th/
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email, password, created_at, updated_at, "verificationToken", verified, "resetToken") FROM stdin;
18	fafa	fafapnr@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$kP04akthP8DWU7CEexHeOg$miW9H4M0zez5/MjOp+e1y3K3Ywb5pXGNxwZtGAq3A08	2025-03-09	2025-03-09	\N	t	\N
19	KentN	kentnyilynn@proton.me	$argon2id$v=19$m=65536,t=3,p=4$lz6Xhso68u3wR9T7G0mG6A$h5Oee+qpgxjqvhTzb8Wk18+qiaMJ/FjKLNDqGKf4Hss	2025-03-11	2025-03-11	2715af28b1627df91c497593c1b4548673024689fc92c14fc590d3edd686a218	f	\N
34	Aye Moh Khin	amohkhin@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$3fjpHn2ReOpnd0IvDwR0Kg$WbmwG11gyKdVCmAPz1m8bcZVuzADFr/qHgWCNd2JEcg	2025-03-19	2025-03-19	9366b77ca3df48ed7d39c25baca7026c148eeffa65793e069aae808cfb3636c4	f	\N
\.


--
-- Name: cars_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cars_id_seq', 121, true);


--
-- Name: dealers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dealers_id_seq', 3, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 34, true);


--
-- Name: cars cars_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_pkey PRIMARY KEY (id);


--
-- Name: cars_users_reviews cars_users_like_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars_users_reviews
    ADD CONSTRAINT cars_users_like_pk PRIMARY KEY (car_id, user_id);


--
-- Name: dealers dealers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dealers
    ADD CONSTRAINT dealers_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- Name: cars cars_dealers_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_dealers_fk FOREIGN KEY (dealer_id) REFERENCES public.dealers(id) NOT VALID;


--
-- Name: cars_users_reviews fk_cars_cars_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars_users_reviews
    ADD CONSTRAINT fk_cars_cars_users FOREIGN KEY (car_id) REFERENCES public.cars(id) NOT VALID;


--
-- Name: cars_users_reviews fk_users_cars_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cars_users_reviews
    ADD CONSTRAINT fk_users_cars_users FOREIGN KEY (user_id) REFERENCES public.users(id) NOT VALID;


--
-- PostgreSQL database dump complete
--

