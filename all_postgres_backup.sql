--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE gamze_db;
ALTER ROLE gamze_db WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:JJdAVR8HV9DVVZZ4WtTGgQ==$p6jl93byywSiSen2C6jsdDgd0x258buVIM9eR1I9Cx4=:kN6dU1Zbw9lW4rLhSOFWc1eq0qi/YTvktQny/TpvTZY=';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Debian 15.13-0+deb12u1)
-- Dumped by pg_dump version 15.13 (Debian 15.13-0+deb12u1)

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
-- PostgreSQL database dump complete
--

--
-- Database "gamze_db" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Debian 15.13-0+deb12u1)
-- Dumped by pg_dump version 15.13 (Debian 15.13-0+deb12u1)

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
-- Name: gamze_db; Type: DATABASE; Schema: -; Owner: gamze_db
--

CREATE DATABASE gamze_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';


ALTER DATABASE gamze_db OWNER TO gamze_db;

\connect gamze_db

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
-- Name: update_guest_posts_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_guest_posts_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_guest_posts_updated_at() OWNER TO postgres;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: comment_likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comment_likes (
    id integer NOT NULL,
    comment_id integer,
    user_ip character varying(45) NOT NULL,
    user_agent text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.comment_likes OWNER TO postgres;

--
-- Name: comment_likes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comment_likes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comment_likes_id_seq OWNER TO postgres;

--
-- Name: comment_likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comment_likes_id_seq OWNED BY public.comment_likes.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    post_id integer NOT NULL,
    author character varying(100) NOT NULL,
    email character varying(255),
    content text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_approved boolean DEFAULT true
);


ALTER TABLE public.comments OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comments_id_seq OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: guest_posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.guest_posts (
    id integer NOT NULL,
    guest_name character varying(255) NOT NULL,
    guest_email character varying(255) NOT NULL,
    guest_title character varying(500) NOT NULL,
    guest_excerpt text,
    guest_content text NOT NULL,
    guest_category character varying(100) DEFAULT 'genel'::character varying,
    guest_tags text,
    submitted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(50) DEFAULT 'pending'::character varying,
    approved_at timestamp without time zone,
    approved_post_id integer,
    rejected_at timestamp without time zone,
    rejection_reason text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT guest_posts_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'approved'::character varying, 'rejected'::character varying])::text[])))
);


ALTER TABLE public.guest_posts OWNER TO postgres;

--
-- Name: guest_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.guest_posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.guest_posts_id_seq OWNER TO postgres;

--
-- Name: guest_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.guest_posts_id_seq OWNED BY public.guest_posts.id;


--
-- Name: post_likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_likes (
    id integer NOT NULL,
    post_id integer,
    user_ip character varying(45) NOT NULL,
    user_agent text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.post_likes OWNER TO postgres;

--
-- Name: post_likes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.post_likes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_likes_id_seq OWNER TO postgres;

--
-- Name: post_likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.post_likes_id_seq OWNED BY public.post_likes.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posts (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    content text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    excerpt text,
    tags text,
    author text,
    updated_at text,
    status character varying(20) DEFAULT 'public'::character varying,
    publish_at timestamp without time zone,
    featured boolean DEFAULT false,
    comments_enabled boolean DEFAULT true,
    category character varying(100),
    language character varying(10) DEFAULT 'tr'::character varying,
    password text,
    image text
);


ALTER TABLE public.posts OWNER TO postgres;

--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.posts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.posts_id_seq OWNER TO postgres;

--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- Name: site_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.site_settings (
    id integer NOT NULL,
    site_title character varying(255) DEFAULT 'Gamze Bıçakçı | Yaratıcı Portfolyo'::character varying NOT NULL,
    site_description text DEFAULT 'Yazmaya, üretmeye ve ilham olmaya gönül vermiş bir reklamcılık öğrencisi'::text,
    default_author character varying(255) DEFAULT 'Gamze Bıçakçı'::character varying,
    author_bio text DEFAULT 'Reklamcılık öğrencisi, yaratıcı içerik üreticisi.'::text,
    hero_title character varying(255) DEFAULT 'Gamze Bıçakçı'::character varying,
    hero_subtitle character varying(255) DEFAULT 'Yaratıcı Portfolyo'::character varying,
    hero_description text DEFAULT 'Yazmaya, üretmeye ve ilham olmaya gönül vermiş bir reklamcılık öğrencisi'::text,
    contact_email character varying(255) DEFAULT 'gamze@example.com'::character varying,
    social_links jsonb DEFAULT '{"twitter": "https://twitter.com/gamzebicakci", "linkedin": "https://linkedin.com/in/gamzebicakci", "instagram": "https://instagram.com/gamzebicakci"}'::jsonb,
    theme_color character varying(7) DEFAULT '#667eea'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    dark_mode boolean DEFAULT false
);


ALTER TABLE public.site_settings OWNER TO postgres;

--
-- Name: site_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.site_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.site_settings_id_seq OWNER TO postgres;

--
-- Name: site_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.site_settings_id_seq OWNED BY public.site_settings.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: gamze_db
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO gamze_db;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: gamze_db
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO gamze_db;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gamze_db
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: comment_likes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_likes ALTER COLUMN id SET DEFAULT nextval('public.comment_likes_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: guest_posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guest_posts ALTER COLUMN id SET DEFAULT nextval('public.guest_posts_id_seq'::regclass);


--
-- Name: post_likes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_likes ALTER COLUMN id SET DEFAULT nextval('public.post_likes_id_seq'::regclass);


--
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- Name: site_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site_settings ALTER COLUMN id SET DEFAULT nextval('public.site_settings_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: gamze_db
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: comment_likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comment_likes (id, comment_id, user_ip, user_agent, created_at) FROM stdin;
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, post_id, author, email, content, created_at, is_approved) FROM stdin;
2	35	ibrahim gül		ileride yapıcam. şimdilik sıkıntı çıkartıyor. taslak olarak kaydetme işlemi diyelim bunun adına	2025-08-21 21:51:11.207746	t
3	35	gamze		pekiiiiiiiiiiiiii	2025-08-21 22:07:49.323773	t
4	36	gamze		Annem bugün "müzik dinlerken aklıma sen geldin, ne güzel hareketler yapıyordun" dedi. Danslarımı kast ediyo. Eve gideyim de herkesi eğlendireyim, özledim onları..	2025-08-22 00:01:32.999347	t
\.


--
-- Data for Name: guest_posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.guest_posts (id, guest_name, guest_email, guest_title, guest_excerpt, guest_content, guest_category, guest_tags, submitted_at, status, approved_at, approved_post_id, rejected_at, rejection_reason, created_at, updated_at) FROM stdin;
1	abram	asd@gmail.com	deneme		asdfa	genel		2025-08-12 17:35:29.573	approved	2025-08-12 21:34:41.520897	\N	\N	\N	2025-08-12 20:35:29.717895	2025-08-12 21:34:41.520897
3	asd		asd		asd	Seyahat		2025-08-12 21:36:05.629488	approved	2025-08-12 21:36:18.509858	\N	\N	\N	2025-08-12 21:36:05.629488	2025-08-12 21:36:18.509858
2	sdfsdf		sdfsdfs	dfsd	sdfsdf	Genel		2025-08-12 21:35:42.984951	rejected	\N	\N	\N	ananın amı	2025-08-12 21:35:42.984951	2025-08-12 21:37:07.060341
4	ibrahim		dgko	asd	asd	Genel		2025-08-12 21:38:39.951218	rejected	\N	\N	\N	Belirtilmedi	2025-08-12 21:38:39.951218	2025-08-12 21:55:11.23337
5	asd		asd	sd	sdfsd	Genel		2025-08-12 21:45:14.894274	rejected	\N	\N	\N	Belirtilmedi	2025-08-12 21:45:14.894274	2025-08-12 21:55:14.020173
6	asdf		asdf	asdf	asdf	Genel		2025-08-12 21:50:56.641682	rejected	\N	\N	\N	Belirtilmedi	2025-08-12 21:50:56.641682	2025-08-12 21:55:16.947204
7	asd		asd	asd	asd	Genel		2025-08-12 21:52:45.340668	rejected	\N	\N	\N	Belirtilmedi	2025-08-12 21:52:45.340668	2025-08-12 21:55:19.184984
8	asdfasdf		asdfa	sdf	dsf	Genel		2025-08-12 21:54:44.41484	rejected	\N	\N	\N	Belirtilmedi	2025-08-12 21:54:44.41484	2025-08-12 21:55:21.311978
9	ibrahim gül		deneme	merhaba gamze hanım	31	Genel		2025-08-14 00:19:52.853056	rejected	\N	\N	\N	sapık	2025-08-14 00:19:52.853056	2025-08-14 00:22:30.226256
10	gamzo		arsız bella		AAAAAA ARSIZ BELLA 20255555555555555555555555555 OOOOOAĞĞĞĞĞ	Yemek		2025-08-15 00:11:51.583694	approved	2025-08-15 00:12:19.367651	\N	\N	\N	2025-08-15 00:11:51.583694	2025-08-15 00:12:19.367651
11	gAMZEsu		sular	suyun keişfi	yıllar yıllar önce su keşfedşldi. Bütün insanlar onu içti. Biri hariç. Bunun okuyan sen hariç. GİT VE O SUYU İÇ. YOKSA BAŞIN AĞIRIR ANLIOR MMUSUN ANLA BUNU BY<3	Genel		2025-08-15 00:29:35.279737	approved	2025-08-15 00:30:14.38955	\N	\N	\N	2025-08-15 00:29:35.279737	2025-08-15 00:30:14.38955
12	iboram	bacim@gmail.com	burger yiyecez	burger	yemek	Yemek	aksam yemegi, sevgi,	2025-08-15 21:38:18.291283	pending	\N	\N	\N	\N	2025-08-15 21:38:18.291283	2025-08-15 21:38:18.291283
13	gamze		acı		çok güzel upuzun bir şey yazıyordum elim bi tuşa çarptı her şey gitti amk\n	Sağlık		2025-08-17 04:17:35.116002	approved	2025-08-17 04:17:52.186438	\N	\N	\N	2025-08-17 04:17:35.116002	2025-08-17 04:17:52.186438
\.


--
-- Data for Name: post_likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_likes (id, post_id, user_ip, user_agent, created_at) FROM stdin;
2	35	::ffff:127.0.0.1	Mozilla/5.0 (X11; Linux x86_64; rv:141.0) Gecko/20100101 Firefox/141.0	2025-08-17 20:05:16.229378
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts (id, title, content, created_at, excerpt, tags, author, updated_at, status, publish_at, featured, comments_enabled, category, language, password, image) FROM stdin;
30	İYİ Kİ DOĞDUN GAMZOŞ 	Sevgili Gamze,\n\nDaha birinci sınıfta aynı okuldaydık ama hiç yolumuz kesişmemişti. Sonra ikinci sınıfta hayat bizi aynı gruba getirdi. Hatta seni gruba almak için arkadaşlarımı ikna eden kişi bendim ve iyi ki de etmişim. Çünkü o günden beri grubumuzun enerjisi, çalışkanı ve en önemlisi ruh hastası sensin.\n\nKafasına her şeyi takan ama iş derslere gelince benden çok daha başarılı olan bir arkadaş olarak(teorik derslerde tabikide caniii beniiii), seni tanımak gerçekten büyük bir şans. İyi ki doğdun, iyi ki varsın. Nice yıllara, hep birlikte güzel anılar biriktirelim! 🎂💙	2025-08-13 22:20:39.688415	HAPPY BİRTDAY 	#doğumgünü #iyikidoğdun #gamzebugündoğdu #kalkkızgamzesendoğdun #ruhhastası21yaşında #21yaşındabirruhhastası	Emirhan Yalçınkaya	2025-08-14 00:21:24.26404+03	public	\N	t	t	doğum günü	tr		https://res.cloudinary.com/dk49zlfug/image/upload/v1755112838/blog-images/v2ytdmitiznhj7dmqzte.jpg
29	İYİ Kİ DOĞDUN RUH HASTAM ❤️	Gamzecim,\nİyi ki doğdun hayatım.🫂💞\n21. yaşında bütün güzellikler senin olsun. 21. yaşa bir yaşında yetişkin derler çokta kafanda büyütüp "yaşlandım" tiplerine girme sakın. Harika bir hayat yaşamak için daha çok vaktimiz var. Yaşama heyecanını kaybetmeden hayallerine ulaştığın bir yaş olsun!! \nNice senelere 🥳😍💐	2025-08-13 21:52:35.436037		happybirthday 	naile 	2025-08-13 21:53:17.262694+03	public	\N	f	t		tr		https://res.cloudinary.com/dk49zlfug/image/upload/v1755111154/blog-images/wkogqzvgcknwsusmdvj9.jpg
4	güncelleme	artık	2025-08-04 02:38:24.838428	artık yazar isimleri değiştirilebiliyor		İbrahim Gül	2025-08-14 00:40:51.963235+03	private	\N	f	t		tr		blob:https://gamzebicakci.com/04b25c3f-2a69-4db3-81d1-bcf498553a67
28	CANUM RUH HASTAM	🌈🌈😘😘💅🏻💅🏻Yeni yaşında mutluluklar dilerim!!!🦩🦩🦩🧜🏻‍♀️🧜🏻‍♀️\nGamze Bıçakçı umarım yeni yaşında çok mutlu olursun hayatın tadını çıkardığın, nur gibi etrafa neşe saçtığın, kariyerinde başarılarının arttığı bir yıl olsun SENİ ÇOK SEVO ÖPO👁️👄👁️🌸🌷🥀💮🌷🌺🪷💮💮🌷🪷🪷🌺💮	2025-08-13 21:47:22.8194		@gamzebicakci	Gamze Bıçakçı	2025-08-13 21:55:41.39868+03	public	\N	f	t	BİRTHDAY PARTY	tr		https://res.cloudinary.com/dk49zlfug/image/upload/v1755111340/blog-images/jsu6t513amkpl0gpene2.jpg
23	denemeresim7	asd	2025-08-10 20:37:29.000088	asd	as	Gamze Bıçakçı	\N	public	\N	f	t		tr		https://res.cloudinary.com/dk49zlfug/image/upload/v1754847448/blog-images/faarwpgi4gbuoqzfp0ni.jpg
7	Güncelleme	.	2025-08-07 06:21:17.659369	admin login page oluşturuldu	commit	İbrahim Gül	2025-08-14 00:41:14.623635+03	private	\N	f	t		tr		
1	doğum günün kutlu olsun mutlu ol senelerce	canım sevgilim doğum günün kutlu olsun. bu siteyi senin blog siten olsun diye yaptım. muhtemelen şu an yapmaya devam ediyorum. bugünün tarihini vermeyeceğim çünkü bir yazı yazıldığında ne zaman yazıldığını da saklıyor olacak. ha ileride yazıyı düzeltmek veya foto vs eklemek istersen o da olacak. o olduğu zaman bu yazıyı nasıl bir yere yazdığımın fotosunu yanına koyarım. neyse sadede gelelim. bu siteyi kendi portfolyo siten olarak düşünebilirsin. insanları buraya seni tanımaları için vs yönlendirebiirsin. bir anı defteri olarak da kullanabilirsin. muhtemelen yazdılanları gizeleme özelliği vs de ekleyeceğim. fotoları da ekleyebilmek için bir cloud şirketinden üyelik açmalıyım. neyse şu sıralar takılıyorum geceleri işte sen de uyuyorsun. ileride bu yazıyı gizle. geliştirme sürecinin notlarını buraya yazıalr olarak ekleyeceğim. sağlıcakla kal	2025-08-04 01:41:50.570598	deneme	first commit, deneme	İbrahim Gul	2025-08-14 00:37:21.694922+03	private	\N	f	t		tr		
8	Güncelleme	.	2025-08-07 18:10:28.775793	admin logout added	commit	İbrahim Gül	2025-08-14 00:41:23.006183+03	private	\N	f	t		tr		
13	resim1	resim	2025-08-09 04:30:29.250674	resim1		Gamze Bıçakçı	2025-08-14 00:41:50.180663+03	private	\N	f	t		tr		
16	Resim2	deneme	2025-08-09 04:47:19.410409	Eğer bu resmi görüyosan sorun düzelmiştir		İbrahim Gül	2025-08-14 00:42:32.079004+03	private	\N	f	t		tr		
18	resim4	asd	2025-08-10 19:42:41.849198	görünüyorsa tamamdır		Gamze Bıçakçı	2025-08-14 00:42:37.128982+03	private	\N	f	t		tr		
17	resim deneme3	asd	2025-08-10 19:09:28.868798			Gamze Bıçakçı	2025-08-14 00:42:45.395283+03	private	\N	f	t		tr		
19	resim deneem5	asd	2025-08-10 20:22:30.656564	dsfasdasdfadsfasdfasdfasdfadfsa		Gamze Bıçakçı	2025-08-14 00:45:44.104649+03	private	\N	f	t		tr		
31	arsız bella	AAAAAA ARSIZ BELLA 20255555555555555555555555555 OOOOOAĞĞĞĞĞ	2025-08-15 00:12:19.363169			gamzo	\N	public	\N	f	t	Yemek	tr	\N	\N
32	sular	yıllar yıllar önce su keşfedşldi. Bütün insanlar onu içti. Biri hariç. Bunun okuyan sen hariç. GİT VE O SUYU İÇ. YOKSA BAŞIN AĞIRIR ANLIOR MMUSUN ANLA BUNU BY<3	2025-08-15 00:30:14.386014	suyun keişfi		gAMZEsu	\N	public	\N	f	t	Genel	tr	\N	\N
33	sessizlik	Eskiden kendimi hep uzun uzun anlatır,uğraşır dururdum. Sonra tahammülüm bitti tabi. Artık hiç kimseyle konuşmuyorum. "He öyle mi olmuş, iyi peki öyle olsun" diyorum. Bir şeyi bir iki defa söylüyorum, aynı şeyler devam ederse bir süre susuyorum sonra da siktir olup gidiyorum genelde. Çünkü ben de insanım ve bu kadar sakin kalamam. Hiçbir insan evladına tahammülüm yoktur. Aslında çok öfkeliyimdir. Kendime bile zarar verebilirim öfkemden dolayı. Ağzıma sıçarım kendimin, yani aslında bu gösteriyor ki başkalarına neler neler yaparım, öylesine de demiyorum. Bunları zamanında yaşadım. Her şeyin farkındayım ama nasıl oluyorsa hiçbir şeyi parçalamadan durabiliyorum. Bazen bir güç bulutu hissediyorum. Beni öylesine sarmalıyor ki teslim olursam, neler olabileceğini biliyorum diye sadece ama sadece duruyorum. Bazen çıldırmak istiyorum. Düşüncelerim beni çıldırtıyor ve çıldırışımı yansıtmak istiyorum. Ama yapmıyorum ve bu beni daha da çıldırtıyor.Neyse çok onurluca bu. Benim kadar delirip susan hiç kimse olduğunu sanmıyorum. Demek ki peygamber sabrı var. İçime şeytoş girene kadar tabi:) 	2025-08-17 04:01:39.866232	delirmek usulca, susarken boğan	#günlük1	Gamze Bıçakçı	\N	public	\N	f	t	deli suskunluk	tr		https://res.cloudinary.com/dk49zlfug/image/upload/v1755392498/blog-images/t6znhvvsyltejgtnro5u.jpg
34	acı	çok güzel upuzun bir şey yazıyordum elim bi tuşa çarptı her şey gitti amk\n	2025-08-17 04:17:52.183556			gamze	\N	public	\N	f	t	Sağlık	tr	\N	\N
35	talebim	yazdıklarımın göndere basmadan otomatik bir yere kaydedilemsini istiyorum. Yazma aşamasındayken güvende olmalılar...........................................	2025-08-17 04:21:06.894381	ibrahime talebim		Gamze Bıçakçı	\N	public	\N	f	t	güvenlik	tr		
36	günaydın	Bu şarkıyı dinlerken bir şeyler yazmak istedim. Oksijen israf eden mumumu da yakayım.. Yaktım, geldim.  \nHayatın bazı kısımları üzerinde durmak istiyorum.Bazen çok mutlu oluyorum. Ama öyle böyle değil. Kendi kendime eğleniyorum. Kimse bana zarar vermiyor, kimse enerjime zarar vermiyor. Açıyorum müziğimi oynuyorum, dans ederken enerjimi atıyorum. Sevdiğim tatlıları yiyorum. İçiyorum, sarhoş olmuyorum. Bazen kendime çok önemli biriymişim gibi davranıyorum. Çok iyi hissettiriyor. Bunu kimseden beklemeden kendim için yapabiliyor olmakla gurur duyuyorum. Bugün de mutluyum, yalnızım.. Açtım müziğimi. Çocukluktan beri hayalim olan şeyi yapıyorum, yazıyorum işte, gelişine. Şarkının atmosferine uymadı yazdıklarım ama olsun. Kendime huzur vermeyi seviyorum. Bence bu dünyada bana hak ettiğim gibi davranan sadece benim. Gerçekten diyorum. Bazen kendime sümüklü peçete gibi de davranıyorum evet ama bu aralar kendime şefkatliyim. Çünkü kimse benim için bana şefkatli olmuyor. Bugün küçük çocuklarla arkadaş oldum, bana çok güzel yaklaştılar. Bir çocuğun sevgisi ne yüce mutlulukmuş. O kadar masumlar ki, kötü niyet yok içlerinde. Az rastlanan bir güzellik bu. Hayatı bazen çok seviyorum, en güzel şekilde yaşamak istiyorum , bazense yaşamamak istiyorum. Herkes zaman zaman öyle hisseder, biliyorum. Hayatta çok zorluklar yaşadım, kimsenin bilmediği savaşlar verdim ve tamamen tükendiğim bittiğim oldu. Hayatımın bitmek üzere olduğu da oldu, tamamen yalnız kaldığım da. Karanlığa gömüldüğüm de oldu. Ama herkesin bildiği bir "gamze" var. Beni yakından tanıyanların bildiği. Her ne yaşarsa yaşasın, gülüşünü kaybetmeyen. O sevdiklerine umut veren bir kız. Ben ondan hiç vazgeçmiyorum bu yüzden. Sevdiklerime ilham olabilmek bana yaşama sebebi, neşesi veriyor. \n Kimseyle var olmadığım gibi yok da olmuyorum. Aşmaya çalışıyorum tepeleri, pes etmemeye çalışıyorum. Kendime iyi gelebilmeye çalışıyorum. Umut etmeyi bıraktığımda her şey biter. O yüzden bütün çabam. Her neyse, yoruldum. Keşke ilham gelse de güzel fikirler bulsam... Ah ne zor bölüm. Aşırı kolay gözüküyor uzaktan.. Bayyyyyyyyyyyyy	2025-08-21 23:56:56.365625	yalın-günaydın	#günlük2	Gamze Bıçakçı	\N	public	\N	f	t	bugün	tr		https://res.cloudinary.com/dk49zlfug/image/upload/v1755809815/blog-images/l7zlnfot8ae2dauwxdby.jpg
\.


--
-- Data for Name: site_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.site_settings (id, site_title, site_description, default_author, author_bio, hero_title, hero_subtitle, hero_description, contact_email, social_links, theme_color, created_at, updated_at, dark_mode) FROM stdin;
1	Gamze Bıçakçı		Gamze Bıçakçı					gamzebicakci14@gmail.com	{"tiktok": "", "twitter": "https://x.com/hassasprenses", "youtube": "https://www.youtube.com", "facebook": "", "linkedin": "https://www.linkedin.com/in/gamze-b%C4%B1%C3%A7ak%C3%A7%C4%B1-05a703286/", "snapchat": "", "instagram": "https://instagram.com/gmzbckc4", "pinterest": ""}	#9141ac	2025-08-11 19:17:49.67874	2025-08-20 01:28:39.837642	f
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: gamze_db
--

COPY public.users (id, username, password_hash, created_at) FROM stdin;
1	admin	$2b$10$8QUG7zqmZm7oC7iq/1fFjOYA/sS6QRqoQBjV.ekJtGeJPNVLzwNVa	2025-08-07 06:20:33.59923
\.


--
-- Name: comment_likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comment_likes_id_seq', 1, false);


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_id_seq', 4, true);


--
-- Name: guest_posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.guest_posts_id_seq', 13, true);


--
-- Name: post_likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.post_likes_id_seq', 3, true);


--
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 36, true);


--
-- Name: site_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.site_settings_id_seq', 1, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gamze_db
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: comment_likes comment_likes_comment_id_user_ip_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_likes
    ADD CONSTRAINT comment_likes_comment_id_user_ip_key UNIQUE (comment_id, user_ip);


--
-- Name: comment_likes comment_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_likes
    ADD CONSTRAINT comment_likes_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: guest_posts guest_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guest_posts
    ADD CONSTRAINT guest_posts_pkey PRIMARY KEY (id);


--
-- Name: post_likes post_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_likes
    ADD CONSTRAINT post_likes_pkey PRIMARY KEY (id);


--
-- Name: post_likes post_likes_post_id_user_ip_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_likes
    ADD CONSTRAINT post_likes_post_id_user_ip_key UNIQUE (post_id, user_ip);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: site_settings site_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site_settings
    ADD CONSTRAINT site_settings_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: gamze_db
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: gamze_db
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: idx_comment_likes_comment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_comment_likes_comment_id ON public.comment_likes USING btree (comment_id);


--
-- Name: idx_comments_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_comments_created_at ON public.comments USING btree (created_at);


--
-- Name: idx_comments_post_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_comments_post_id ON public.comments USING btree (post_id);


--
-- Name: idx_guest_posts_guest_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_guest_posts_guest_email ON public.guest_posts USING btree (guest_email);


--
-- Name: idx_guest_posts_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_guest_posts_status ON public.guest_posts USING btree (status);


--
-- Name: idx_guest_posts_submitted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_guest_posts_submitted_at ON public.guest_posts USING btree (submitted_at);


--
-- Name: idx_post_likes_post_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_post_likes_post_id ON public.post_likes USING btree (post_id);


--
-- Name: idx_posts_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_posts_created_at ON public.posts USING btree (created_at);


--
-- Name: idx_posts_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_posts_status ON public.posts USING btree (status);


--
-- Name: comments update_comments_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_comments_updated_at BEFORE UPDATE ON public.comments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: guest_posts update_guest_posts_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_guest_posts_updated_at BEFORE UPDATE ON public.guest_posts FOR EACH ROW EXECUTE FUNCTION public.update_guest_posts_updated_at();


--
-- Name: posts update_posts_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_posts_updated_at BEFORE UPDATE ON public.posts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: site_settings update_site_settings_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_site_settings_updated_at BEFORE UPDATE ON public.site_settings FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: comment_likes comment_likes_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_likes
    ADD CONSTRAINT comment_likes_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES public.comments(id) ON DELETE CASCADE;


--
-- Name: comments comments_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: guest_posts guest_posts_approved_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.guest_posts
    ADD CONSTRAINT guest_posts_approved_post_id_fkey FOREIGN KEY (approved_post_id) REFERENCES public.posts(id);


--
-- Name: post_likes post_likes_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_likes
    ADD CONSTRAINT post_likes_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO gamze_db;


--
-- Name: TABLE comment_likes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.comment_likes TO gamze_db;


--
-- Name: SEQUENCE comment_likes_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.comment_likes_id_seq TO gamze_db;


--
-- Name: TABLE comments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.comments TO gamze_db;


--
-- Name: SEQUENCE comments_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.comments_id_seq TO gamze_db;


--
-- Name: TABLE guest_posts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.guest_posts TO gamze_db;


--
-- Name: SEQUENCE guest_posts_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.guest_posts_id_seq TO gamze_db;


--
-- Name: TABLE post_likes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.post_likes TO gamze_db;


--
-- Name: SEQUENCE post_likes_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.post_likes_id_seq TO gamze_db;


--
-- Name: TABLE posts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.posts TO gamze_db;


--
-- Name: SEQUENCE posts_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.posts_id_seq TO gamze_db;


--
-- Name: TABLE site_settings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.site_settings TO gamze_db;


--
-- Name: SEQUENCE site_settings_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.site_settings_id_seq TO gamze_db;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO gamze_db;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO gamze_db;


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Debian 15.13-0+deb12u1)
-- Dumped by pg_dump version 15.13 (Debian 15.13-0+deb12u1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: users; Type: TABLE; Schema: public; Owner: gamze_db
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO gamze_db;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: gamze_db
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO gamze_db;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gamze_db
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: gamze_db
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: gamze_db
--

COPY public.users (id, username, password_hash, created_at) FROM stdin;
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gamze_db
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: gamze_db
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: gamze_db
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO gamze_db;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO gamze_db;


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

