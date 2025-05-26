--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)

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
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: ariel
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO ariel;

--
-- Name: dispositivos; Type: TABLE; Schema: public; Owner: ariel
--

CREATE TABLE public.dispositivos (
    id integer NOT NULL,
    numero_serie character varying(50) NOT NULL,
    mac_address character varying(50),
    version_firmware character varying(50) NOT NULL,
    descripcion_ubicacion character varying(200) NOT NULL,
    fecha_registro timestamp without time zone NOT NULL,
    tipo_dispositivo_id integer NOT NULL,
    estado_actual character varying(20),
    coordenadas_gps character varying(50)
);


ALTER TABLE public.dispositivos OWNER TO ariel;

--
-- Name: dispositivos_agrupados; Type: TABLE; Schema: public; Owner: ariel
--

CREATE TABLE public.dispositivos_agrupados (
    dispositivo_id integer NOT NULL,
    grupo_dispositivo_id integer NOT NULL
);


ALTER TABLE public.dispositivos_agrupados OWNER TO ariel;

--
-- Name: dispositivos_id_seq; Type: SEQUENCE; Schema: public; Owner: ariel
--

CREATE SEQUENCE public.dispositivos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dispositivos_id_seq OWNER TO ariel;

--
-- Name: dispositivos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ariel
--

ALTER SEQUENCE public.dispositivos_id_seq OWNED BY public.dispositivos.id;


--
-- Name: grupos_dispositivos; Type: TABLE; Schema: public; Owner: ariel
--

CREATE TABLE public.grupos_dispositivos (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    descripcion character varying(200)
);


ALTER TABLE public.grupos_dispositivos OWNER TO ariel;

--
-- Name: grupos_dispositivos_id_seq; Type: SEQUENCE; Schema: public; Owner: ariel
--

CREATE SEQUENCE public.grupos_dispositivos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.grupos_dispositivos_id_seq OWNER TO ariel;

--
-- Name: grupos_dispositivos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ariel
--

ALTER SEQUENCE public.grupos_dispositivos_id_seq OWNED BY public.grupos_dispositivos.id;


--
-- Name: lecturas_datos; Type: TABLE; Schema: public; Owner: ariel
--

CREATE TABLE public.lecturas_datos (
    id integer NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    valor_leido character varying(50) NOT NULL,
    sensor_id integer NOT NULL
);


ALTER TABLE public.lecturas_datos OWNER TO ariel;

--
-- Name: lecturas_datos_id_seq; Type: SEQUENCE; Schema: public; Owner: ariel
--

CREATE SEQUENCE public.lecturas_datos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lecturas_datos_id_seq OWNER TO ariel;

--
-- Name: lecturas_datos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ariel
--

ALTER SEQUENCE public.lecturas_datos_id_seq OWNED BY public.lecturas_datos.id;


--
-- Name: logs_estado_dispositivo; Type: TABLE; Schema: public; Owner: ariel
--

CREATE TABLE public.logs_estado_dispositivo (
    id integer NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    estado character varying(20) NOT NULL,
    mensaje_opcional character varying(200),
    dispositivo_id integer NOT NULL
);


ALTER TABLE public.logs_estado_dispositivo OWNER TO ariel;

--
-- Name: logs_estado_dispositivo_id_seq; Type: SEQUENCE; Schema: public; Owner: ariel
--

CREATE SEQUENCE public.logs_estado_dispositivo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logs_estado_dispositivo_id_seq OWNER TO ariel;

--
-- Name: logs_estado_dispositivo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ariel
--

ALTER SEQUENCE public.logs_estado_dispositivo_id_seq OWNED BY public.logs_estado_dispositivo.id;


--
-- Name: sensores; Type: TABLE; Schema: public; Owner: ariel
--

CREATE TABLE public.sensores (
    id integer NOT NULL,
    tipo_sensor character varying(50) NOT NULL,
    unidad_medida character varying(20) NOT NULL,
    dispositivo_id integer NOT NULL,
    umbral_alerta double precision
);


ALTER TABLE public.sensores OWNER TO ariel;

--
-- Name: sensores_id_seq; Type: SEQUENCE; Schema: public; Owner: ariel
--

CREATE SEQUENCE public.sensores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sensores_id_seq OWNER TO ariel;

--
-- Name: sensores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ariel
--

ALTER SEQUENCE public.sensores_id_seq OWNED BY public.sensores.id;


--
-- Name: tipos_dispositivos; Type: TABLE; Schema: public; Owner: ariel
--

CREATE TABLE public.tipos_dispositivos (
    id integer NOT NULL,
    fabricante character varying(50) NOT NULL,
    modelo character varying(50) NOT NULL,
    descripcion character varying(200)
);


ALTER TABLE public.tipos_dispositivos OWNER TO ariel;

--
-- Name: tipos_dispositivos_id_seq; Type: SEQUENCE; Schema: public; Owner: ariel
--

CREATE SEQUENCE public.tipos_dispositivos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipos_dispositivos_id_seq OWNER TO ariel;

--
-- Name: tipos_dispositivos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ariel
--

ALTER SEQUENCE public.tipos_dispositivos_id_seq OWNED BY public.tipos_dispositivos.id;


--
-- Name: dispositivos id; Type: DEFAULT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.dispositivos ALTER COLUMN id SET DEFAULT nextval('public.dispositivos_id_seq'::regclass);


--
-- Name: grupos_dispositivos id; Type: DEFAULT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.grupos_dispositivos ALTER COLUMN id SET DEFAULT nextval('public.grupos_dispositivos_id_seq'::regclass);


--
-- Name: lecturas_datos id; Type: DEFAULT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.lecturas_datos ALTER COLUMN id SET DEFAULT nextval('public.lecturas_datos_id_seq'::regclass);


--
-- Name: logs_estado_dispositivo id; Type: DEFAULT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.logs_estado_dispositivo ALTER COLUMN id SET DEFAULT nextval('public.logs_estado_dispositivo_id_seq'::regclass);


--
-- Name: sensores id; Type: DEFAULT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.sensores ALTER COLUMN id SET DEFAULT nextval('public.sensores_id_seq'::regclass);


--
-- Name: tipos_dispositivos id; Type: DEFAULT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.tipos_dispositivos ALTER COLUMN id SET DEFAULT nextval('public.tipos_dispositivos_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: ariel
--

COPY public.alembic_version (version_num) FROM stdin;
7f8f268c84ab
\.


--
-- Data for Name: dispositivos; Type: TABLE DATA; Schema: public; Owner: ariel
--

COPY public.dispositivos (id, numero_serie, mac_address, version_firmware, descripcion_ubicacion, fecha_registro, tipo_dispositivo_id, estado_actual, coordenadas_gps) FROM stdin;
1	bea2f362-8823-4838-85e5-b3a6c1633ecc	1c:d3:5a:7d:58:26	4.3.12	4804 Christian Track Suite 822, Kimberlyville, NM 37886	2025-02-12 22:33:45.82389	23	\N	\N
2	210c58f9-e99c-42ff-a034-7a705dae3e0c	de:57:d7:0e:42:c8	1.9.8	2378 Russell Meadows, Harveytown, LA 09212	2025-03-23 21:30:01.677162	4	\N	\N
3	2c36ecf4-538f-4314-b6d1-94eb4c59f189	a2:f5:2b:16:16:f5	3.6.6	Unit 6228 Box 6111, DPO AE 20299	2025-03-08 13:55:58.36754	11	\N	\N
4	0c74d122-2aaf-4342-81dc-86db042c1c2d	0c:ba:db:65:ef:58	5.4.10	58255 Jeffrey Expressway, Stewartland, IN 88889	2025-03-01 20:33:58.939605	9	\N	\N
5	766248fc-3c6b-477b-b429-f616c0a0020a	ea:7e:69:e6:b1:c3	3.0.12	PSC 3123, Box 8938, APO AA 87112	2025-05-21 02:29:56.507313	3	\N	\N
6	bf05342f-7be4-4476-b3ee-6192a75f304b	2a:f5:e9:57:3c:bb	5.4.9	PSC 0055, Box 2314, APO AP 59201	2025-04-24 04:21:50.09317	19	\N	\N
7	822e206d-8273-4fae-89f5-24edafb31582	80:01:eb:b8:e6:4e	2.7.10	96697 Jones Ways, Deborahborough, VT 19468	2025-03-02 19:28:41.593007	16	\N	\N
8	d23885e0-9c66-4fa4-a3cd-0bc897f958cb	54:c0:cd:77:08:67	5.1.6	PSC 9002, Box 7463, APO AA 70083	2025-05-18 08:57:01.989672	11	\N	\N
9	bd939c10-ddd3-431c-ac94-19a3e4aa5bfa	6c:d1:8b:2c:f3:1c	5.2.15	501 Goodwin Springs Suite 133, Carneyhaven, AR 50746	2025-05-12 03:10:18.866814	11	\N	\N
10	01182824-7039-419a-843a-d5ef700ec948	6a:e3:7c:0a:d5:a3	4.0.18	627 Penny Meadow Suite 673, Brianchester, AL 88566	2025-04-04 00:04:54.476252	4	\N	\N
11	e2d8557f-9f03-4860-8f1b-4ca9910dee8c	3a:76:50:54:03:64	3.6.15	26039 Thompson Knolls, Sarahborough, MO 61497	2025-01-07 06:35:58.841661	3	\N	\N
12	cf0b454a-55bf-4165-af88-f559b86f21e5	c6:08:ea:1d:77:2f	2.1.14	9997 Garcia Mills, Monicaview, IN 34538	2025-01-27 08:58:55.65015	8	\N	\N
13	5b347942-3a53-4790-8e39-a5b7a915ba6b	24:e5:5a:57:42:33	4.2.17	0515 Matthew Path Suite 415, Allentown, GA 68571	2025-03-08 04:01:32.268204	20	\N	\N
14	ab5a0e99-e576-4344-8d1a-da688145fe24	be:01:1c:1f:46:39	2.9.11	788 Jennifer Stravenue Suite 753, South Austinmouth, KS 20238	2025-01-15 23:16:50.60294	11	\N	\N
15	37e9faaa-dc41-420d-bee3-34075b9c3037	62:29:5f:3f:ff:4f	4.9.3	694 Contreras Union Apt. 655, Rodneyland, MN 47782	2025-03-24 02:39:17.704936	1	\N	\N
16	58461c38-0226-4a16-8d61-82b8fd58a455	ca:0d:c5:88:76:8a	2.4.12	2817 Richards Port, Port Kylemouth, UT 38761	2025-03-07 15:52:17.448	22	\N	\N
17	1cdc7a43-d590-4ccb-ab6b-601e4779de3a	58:2f:be:ba:95:f8	1.3.5	53201 Bailey Plains Suite 554, South Scottton, KS 71152	2025-03-29 08:10:40.844583	22	\N	\N
18	7060318c-9abd-41f1-b20a-b693e7413e40	ea:0d:98:9b:c4:37	2.7.15	Unit 9784 Box 5243, DPO AP 32701	2025-05-03 13:44:24.100861	1	\N	\N
19	6636523b-62db-44f5-8f20-0fdb97361b18	b8:45:f4:c3:49:03	2.6.3	2361 Mark Glen, Howardtown, NY 78181	2025-05-11 09:55:37.489712	17	\N	\N
20	fadb611e-ad37-4f8b-8dfa-17ccd51b60a7	dc:a2:06:f9:7f:2c	5.0.5	PSC 1562, Box 3372, APO AP 39729	2025-04-11 06:57:45.84324	19	\N	\N
21	854ad165-535e-4e98-bd6d-3e9861dff336	52:b1:98:e4:1f:71	4.5.11	4770 Gill Freeway, Padillamouth, DC 12772	2025-03-28 09:15:03.519856	21	\N	\N
22	c9963c77-7f2d-40e2-aa78-ae5c0d2d99ac	90:dd:a2:23:39:28	1.8.18	849 Diaz Island, Colinchester, ND 97403	2025-02-02 11:32:11.494579	2	\N	\N
23	3397af17-7d4d-482d-ad0c-98d504c1e46d	ae:b7:f0:bc:6d:bb	1.6.13	89172 Burke Pike Suite 621, East Madison, OK 84891	2025-01-13 00:17:28.413341	18	\N	\N
24	52d6f6fe-b3d8-4d15-af8f-dfd5af8847e7	e2:8b:ed:a8:56:92	4.0.16	69749 Tyler Fork Suite 098, West Robertborough, NH 73758	2025-04-06 23:55:45.342534	8	\N	\N
25	5396f00c-98d8-440a-8ad6-6560ca022a66	46:aa:78:72:3b:53	3.9.1	060 Alexandria Streets Apt. 105, New Nicholasborough, NJ 41604	2025-04-22 19:22:57.087741	25	\N	\N
26	5413e5ac-3d68-4111-9d9d-46248205acab	3e:a7:0b:89:e9:47	5.0.4	42826 Wilson Field, Port Thomasstad, TX 59779	2025-04-22 15:54:55.633405	12	\N	\N
27	f4d4045c-80a6-42e6-a3df-83a4eb691974	46:5a:7b:c0:0a:41	5.6.11	1851 Jill Trace Suite 592, New Stephanieborough, KY 82280	2025-02-24 19:55:30.982511	5	\N	\N
28	ce846be3-8d09-48a2-b1ab-756032ee6327	ec:12:17:e4:a8:f4	4.6.8	3205 Melinda Flat, Port Jessicabury, HI 12120	2025-04-14 23:35:11.941463	16	\N	\N
29	f14ec496-26e9-4f51-8300-1541cfa3f4df	d0:44:d2:39:f7:45	2.2.4	85630 Anthony Bypass, Pearsontown, MT 76249	2025-04-03 04:24:52.263163	21	\N	\N
30	5ed37abe-ea04-4873-9408-7e4eb8c77c22	80:ee:75:d2:a8:8d	2.3.0	73872 Amanda Points, Lake David, AK 42018	2025-05-19 04:29:17.021675	21	\N	\N
31	849aef3d-9df8-4cd8-9006-9bb6d819f48f	da:cb:fa:22:9b:6a	1.8.7	2163 Robert Ranch, Katherinefurt, VA 82457	2025-04-20 21:24:06.245494	15	\N	\N
32	5faea7b1-5556-45b4-a00f-74114a615bb7	e2:40:5d:bd:1d:da	4.2.8	0230 Bryan Plaza Apt. 470, Tylerton, NV 46217	2025-03-03 15:50:37.328188	12	\N	\N
33	d26310e2-d6ae-44ca-bc6e-c2ca407a960e	d0:98:d0:30:d0:88	4.3.7	37929 Eric Branch Apt. 392, New Davidstad, VA 44184	2025-04-09 19:05:47.350981	10	\N	\N
34	6813e57d-5115-46e0-8359-ff0ab6d74bd1	1e:b2:81:75:fc:0b	4.7.20	559 Smith Orchard, Washingtonfurt, FL 08940	2025-02-18 21:50:29.400573	1	\N	\N
35	3beb63ea-3df5-4f06-b1ac-7d79692d2230	76:3b:2a:45:28:1d	2.1.9	PSC 9443, Box 1918, APO AA 42074	2025-04-25 06:44:43.160254	2	\N	\N
36	0a227aee-ebd6-4088-bdef-c0acf057bb07	60:af:dd:10:5e:23	3.3.5	6072 Jennifer Pass, Port Morganfort, OH 28833	2025-02-03 11:10:55.597491	3	\N	\N
37	bdf31de3-6fea-4743-80b3-51813fbbc648	88:11:78:61:5d:73	5.2.7	2115 Debra Field Apt. 961, Tuckerchester, MO 08200	2025-01-20 11:15:00.711276	24	\N	\N
38	c2890322-0315-45a7-8aac-a472c455817f	24:49:18:b1:70:14	3.8.7	3733 Adrian Plaza Suite 243, Timothyland, LA 22372	2025-02-10 04:42:50.758613	5	\N	\N
39	bc73661d-9cec-445b-a241-2acdcb219d87	d0:6b:06:d7:69:70	5.1.6	04815 Wilson Freeway Suite 712, North Jonathanberg, TX 41131	2025-04-22 11:50:25.783296	2	\N	\N
40	192a3eb0-714b-4cd6-95b7-14e357a6545d	06:f0:7b:54:92:4b	3.5.17	3326 Annette Grove, Shannontown, HI 37937	2025-01-10 13:32:21.581875	5	\N	\N
41	8b9535eb-1b44-4d55-803b-f7ebb04ff5c2	d2:b1:e8:0e:e5:d2	3.6.0	317 Bryan Crossing, New Joshuastad, CO 12962	2025-05-19 20:05:58.702429	11	\N	\N
42	17fcd1d7-6c7c-4381-b716-728961c58061	74:d1:f2:47:54:c7	5.4.16	596 Thomas Mountains, Lake Josemouth, SC 75352	2025-01-22 21:57:34.207546	25	\N	\N
43	5ebc0eca-ee70-445a-ba6d-debee2e3f487	5e:67:ee:6f:63:8a	3.8.2	583 Patrick Forges, Lake Emily, UT 03856	2025-04-25 01:41:43.543451	9	\N	\N
44	aba92be5-a81a-4947-9d74-b7a7b3970a2a	4a:08:10:82:78:31	2.4.5	516 Jennifer Islands, Timothychester, AR 46052	2025-02-07 05:25:36.067244	5	\N	\N
45	9c6417e5-ca0e-47f8-9d19-8a6ffa978b8b	de:19:8b:62:75:50	4.5.13	4365 Martin Tunnel, East Jacobville, PA 36344	2025-04-28 01:09:47.2927	17	\N	\N
46	16acac4f-0ce7-40da-a71b-883383b4ec7c	0a:0e:82:8b:e0:90	1.3.1	00371 Espinoza Forge, Davidbury, MP 31970	2025-02-06 05:59:55.979362	12	\N	\N
47	28d83e6c-f21d-4847-8678-80802707feb1	de:f3:11:7b:bd:ec	2.9.4	9257 Smith Islands, Thomasborough, WV 89448	2025-05-17 11:58:25.606747	19	\N	\N
48	b90dc9d1-7988-4cfa-8b33-08ba57576833	82:0e:0f:7b:16:1d	3.8.19	43805 James Ways Suite 909, West Tony, NY 73640	2025-03-07 07:16:53.916402	25	\N	\N
49	dd33a9d7-769c-476a-9a7b-5b0cdd68c832	80:73:04:be:5b:10	2.8.20	959 Thomas Lodge, North Rachelbury, MT 71925	2025-04-17 09:24:41.170517	6	\N	\N
50	d51c9854-d540-4727-aa33-be730b17bde6	be:bd:f0:9c:a9:98	4.2.13	Unit 3223 Box 4124, DPO AE 21848	2025-02-15 09:20:49.379985	22	\N	\N
51	c366f1b0-2618-403a-b791-5582c90fab4a	3c:02:05:f4:10:db	1.8.2	3132 Chavez Cape, Quinnville, MS 14070	2025-04-27 09:57:15.410691	13	\N	\N
52	ef11de67-1036-4089-9783-133cf847e0e5	60:dd:d3:a8:e1:73	1.6.5	688 Jennifer Fort Suite 051, Andrewview, ID 44476	2025-04-20 04:13:17.80602	22	\N	\N
53	f50c8613-ebb5-49f6-a737-a4660258e872	6c:19:d8:01:2a:ba	1.9.17	94748 Steven Coves Suite 197, New James, DC 46878	2025-03-24 14:58:47.728397	1	\N	\N
54	152eaf01-b8de-461c-a604-57d3fc41c563	12:4b:43:be:a3:4c	4.2.7	629 Raymond Spring, East Danastad, NV 84169	2025-02-03 13:02:16.970276	14	\N	\N
55	178f1e37-6cba-471e-834d-1b6aa13cd1eb	aa:ae:67:60:72:1e	3.6.17	30457 Jennifer Rue, Millerhaven, ID 44254	2025-03-12 21:51:36.120435	5	\N	\N
56	d4101c81-cdb6-49bf-bb12-60559446f576	1a:86:df:08:da:7c	5.0.14	9937 Laura Hills Apt. 247, Morgantown, DC 15919	2025-05-04 05:58:01.070243	4	\N	\N
57	cc85bc52-7829-42d1-a47c-37036b82d5cb	b8:3e:92:f3:85:a9	1.1.10	588 Sarah Ridges, Bridgetport, NM 82883	2025-03-28 11:57:52.661141	22	\N	\N
58	ede81dfa-c9fa-40a9-9408-df67a34e91ac	a8:b6:10:a6:36:e1	5.1.2	24900 Olivia Canyon, Port Stephanie, WI 82166	2025-02-04 19:49:32.658106	20	\N	\N
59	29c4ea52-23b7-451f-ba87-109ec67d39d8	b6:1c:2c:46:cb:5c	5.8.15	1992 Tina Views, Simontown, CT 05830	2025-02-10 21:06:23.058681	23	\N	\N
60	7082cf36-12aa-4880-aafa-87fc6029b038	ec:0b:87:50:d1:1f	3.6.0	30390 Ryan Squares, Hamiltonchester, OR 65376	2025-05-16 10:41:44.68208	23	\N	\N
61	8a86b0d9-34d1-4565-a7e4-fc85213bd057	ea:51:2b:07:dc:85	5.7.7	72684 Cooke Burgs, South Teresaville, MP 49786	2025-02-12 00:16:08.183008	22	\N	\N
62	8cf0c30b-fd48-4b25-83e0-7337fc9a1eed	e0:57:d9:a2:ed:1f	4.6.5	13909 French Cape, Nicholsshire, MT 31126	2025-01-01 11:23:56.072885	3	\N	\N
63	cbd01982-f3fe-4623-9a65-e94925abce55	62:89:7e:96:7f:69	3.4.15	Unit 3052 Box 3355, DPO AA 77905	2025-02-16 17:18:09.627369	18	\N	\N
64	5957fe34-4b5b-47fe-b983-ff50771723fe	c0:d8:ef:3e:2a:88	5.5.16	05835 Bonilla Glen, North Alexisland, NC 51560	2025-02-05 01:46:24.685816	17	\N	\N
65	b9d8b8a0-1a00-4cad-9c58-619b7ffea560	ca:31:96:23:35:fa	3.3.11	6813 Dana Mountain Suite 995, Fuentesborough, MA 57599	2025-02-07 09:06:13.371589	23	\N	\N
66	9d8e25d2-2dee-424a-b632-05aae8873e0f	52:4d:33:77:a5:de	5.1.10	023 Matthews Centers Apt. 285, North Curtis, VI 64173	2025-01-08 08:58:25.61975	8	\N	\N
67	666325dd-825a-4137-8823-81aac68e2b3f	42:e9:0c:92:35:cf	4.2.6	4538 Sue Hill Suite 845, East Dominiqueport, WV 51738	2025-04-24 07:06:47.24852	1	\N	\N
68	a8412d38-89f0-4434-8b1f-ae490aa09425	28:54:03:9e:f7:eb	4.7.13	147 Ho Walks, Darrenport, VI 12258	2025-04-17 06:55:05.030508	12	\N	\N
69	d76cb777-b42a-473d-a5d6-c5492989e852	b4:e6:9f:8f:7a:37	2.1.9	99629 Newman Corners, Robinville, CO 87190	2025-05-23 01:29:59.305125	24	\N	\N
70	913cad1f-90bf-4008-b873-39bb1d5c6a6c	90:0f:a4:cd:94:13	2.4.9	Unit 3605 Box 3135, DPO AE 21773	2025-04-18 08:44:50.944172	3	\N	\N
71	d8c177b2-4224-479f-9380-05fb6a49d44c	44:58:4c:d4:78:cb	3.1.19	01242 Kelly Motorway Suite 611, Thorntonville, AK 87173	2025-03-05 04:39:28.334909	4	\N	\N
72	55fc7936-02f4-459a-ad13-2261b41cb898	44:c4:57:a2:c2:cd	5.2.0	8744 Kimberly Roads, Joshuamouth, WY 09247	2025-05-08 07:48:11.433087	4	\N	\N
73	3c8cd250-8b9e-4865-8868-9a47afc0fd3e	f4:0b:b6:c9:b5:da	4.5.12	795 Martinez Forge Apt. 006, Lake Troy, PA 82421	2025-05-06 08:00:26.570338	24	\N	\N
74	a2b43b52-fd20-44f3-ae07-2a37164cbdfb	f6:89:02:71:a9:c8	4.9.11	30756 Fisher Squares Suite 777, New Bryanshire, AS 40706	2025-04-21 21:19:23.14593	13	\N	\N
75	e0026ddd-65e2-4586-94c0-29e1fe0803a3	2e:e0:c5:5c:fa:cc	5.7.8	2744 Sandra Hollow Apt. 675, Bruceberg, VI 63918	2025-01-13 22:28:30.443072	9	\N	\N
76	c63a9b00-402c-45f9-abd0-07297251d31e	88:e2:51:78:19:92	2.2.18	847 Jessica Greens, Lake Travis, TN 97436	2025-05-20 20:25:35.468356	6	\N	\N
77	3376c4a2-c1b4-409a-9ec6-dcf661032dbf	2c:4f:4e:b1:fb:33	2.8.1	6327 Kevin Alley, Jaclynton, WY 04508	2025-05-05 06:57:58.004177	10	\N	\N
78	1db3e1de-c611-4de5-895d-b53d39e9c7b5	88:a4:1b:ad:e2:c3	4.8.0	18107 Weber Falls, East Adam, MS 42234	2025-02-22 02:01:17.473339	2	\N	\N
79	83991093-3ad9-47ff-913b-84a6715a49b3	d4:7f:f0:dc:7c:69	5.5.19	638 Catherine Crescent, North Andrewfurt, ND 42505	2025-02-28 08:24:30.978724	13	\N	\N
80	4028f10a-dd03-4d1b-b1f0-e3d9ca7f346f	fa:c9:a1:f0:9d:61	4.6.11	838 Mitchell Bridge Suite 428, Craigburgh, GA 46786	2025-01-04 16:30:44.73841	15	\N	\N
\.


--
-- Data for Name: dispositivos_agrupados; Type: TABLE DATA; Schema: public; Owner: ariel
--

COPY public.dispositivos_agrupados (dispositivo_id, grupo_dispositivo_id) FROM stdin;
59	8
73	9
73	2
45	5
25	2
79	8
47	4
79	3
39	5
57	9
55	8
48	7
34	8
9	7
8	5
52	4
35	6
24	2
50	1
58	6
13	9
68	7
13	10
75	8
75	9
23	8
35	4
64	10
28	9
19	5
6	6
42	7
34	1
35	2
31	8
22	5
15	1
36	2
4	9
74	7
51	3
48	8
3	2
7	4
2	1
17	2
20	2
14	9
72	8
27	9
46	2
41	1
3	8
14	5
39	9
21	9
35	10
52	5
3	5
60	2
76	7
11	6
43	9
5	3
8	3
27	3
54	6
25	10
24	6
63	5
17	7
18	10
57	8
11	5
79	5
54	8
58	5
57	10
12	1
4	10
45	10
2	4
12	6
42	5
46	1
32	7
67	8
21	1
5	4
32	2
46	6
47	2
74	3
46	5
28	8
29	1
17	9
36	6
78	9
26	2
65	8
20	9
71	6
13	6
43	3
\.


--
-- Data for Name: grupos_dispositivos; Type: TABLE DATA; Schema: public; Owner: ariel
--

COPY public.grupos_dispositivos (id, nombre, descripcion) FROM stdin;
1	LightSalmon-100	Similar animal with live story air. Week step south sometimes.
2	Turquoise-5	Amount movement according mother. Run whatever claim water free almost.
3	Navy-82	System simple others owner. Mother public loss upon capital next son.
4	DarkKhaki-70	Ok herself knowledge. Against gas turn.
5	MediumSlateBlue-73	Garden side often particular. Music red expect itself note front tonight stock.
6	SlateGray-54	Become different act shake ability down argue. While one become position health.
7	Gold-36	Financial three behind buy third. Detail that value system while education design need.
8	OldLace-3	Reality seven offer. Act today avoid vote.
9	FloralWhite-66	Modern necessary remember if stop knowledge. Break step huge response.
10	Ivory-81	Budget thank professional federal together strong. Detail American ahead end.
\.


--
-- Data for Name: lecturas_datos; Type: TABLE DATA; Schema: public; Owner: ariel
--

COPY public.lecturas_datos (id, "timestamp", valor_leido, sensor_id) FROM stdin;
1	2025-05-25 22:58:23.482465	88.43	59
2	2025-05-25 22:58:23.486184	67.85	40
3	2025-05-25 22:58:23.488497	35.76	110
4	2025-05-25 22:58:23.491061	60.13	92
5	2025-05-25 22:58:23.493204	38.88	87
6	2025-05-25 22:58:23.495253	23.27	104
7	2025-05-25 22:58:23.497281	83.83	100
8	2025-05-25 22:58:23.499283	84.86	43
9	2025-05-25 22:58:23.501275	91.98	72
10	2025-05-25 22:58:23.503296	44.89	16
11	2025-05-25 22:58:23.505303	95.31	57
12	2025-05-25 22:58:23.507352	65.99	66
13	2025-05-25 22:58:23.509412	41.69	12
14	2025-05-25 22:58:23.511417	24.29	90
15	2025-05-25 22:58:23.513393	45.43	69
16	2025-05-25 22:58:23.515496	14.75	16
17	2025-05-25 22:58:23.517478	54.12	87
18	2025-05-25 22:58:23.519564	74.23	59
19	2025-05-25 22:58:23.521749	46.16	11
20	2025-05-25 22:58:23.524103	95.89	107
21	2025-05-25 22:58:23.52637	65.95	13
22	2025-05-25 22:58:23.528796	62.78	12
23	2025-05-25 22:58:23.531265	58.45	23
24	2025-05-25 22:58:23.533573	35.34	65
25	2025-05-25 22:58:23.53564	41.89	52
26	2025-05-25 22:58:23.537914	75.35	45
27	2025-05-25 22:58:23.540068	45.06	58
28	2025-05-25 22:58:23.542317	26.69	119
29	2025-05-25 22:58:23.544372	59.33	57
30	2025-05-25 22:58:23.546437	81.77	99
31	2025-05-25 22:58:23.548453	75.23	11
32	2025-05-25 22:58:23.550444	57.14	116
33	2025-05-25 22:58:23.552409	62.83	16
34	2025-05-25 22:58:23.55442	97.89	62
35	2025-05-25 22:58:23.556566	68.93	19
36	2025-05-25 22:58:23.558717	46.37	74
37	2025-05-25 22:58:23.560793	18.31	114
38	2025-05-25 22:58:23.563573	26.01	4
39	2025-05-25 22:58:23.565606	36.05	107
40	2025-05-25 22:58:23.567681	67.24	56
41	2025-05-25 22:58:23.569671	42.68	87
42	2025-05-25 22:58:23.572004	52.58	24
43	2025-05-25 22:58:23.574356	58.39	76
44	2025-05-25 22:58:23.576452	92.55	106
45	2025-05-25 22:58:23.578598	68.21	95
46	2025-05-25 22:58:23.580775	81.48	92
47	2025-05-25 22:58:23.583251	70.61	87
48	2025-05-25 22:58:23.58544	65.5	120
49	2025-05-25 22:58:23.58769	36.69	112
50	2025-05-25 22:58:23.590279	42.01	102
51	2025-05-25 22:58:23.5923	21.98	95
52	2025-05-25 22:58:23.594356	20.35	6
53	2025-05-25 22:58:23.596333	92.29	30
54	2025-05-25 22:58:23.598354	43.53	76
55	2025-05-25 22:58:23.600369	38.76	77
56	2025-05-25 22:58:23.60237	46.08	39
57	2025-05-25 22:58:23.604422	45.88	46
58	2025-05-25 22:58:23.606499	34.29	112
59	2025-05-25 22:58:23.608525	29.43	101
60	2025-05-25 22:58:23.610507	98.59	91
61	2025-05-25 22:58:23.616333	43.15	104
62	2025-05-25 22:58:23.618403	42.77	70
63	2025-05-25 22:58:23.620373	37.69	31
64	2025-05-25 22:58:23.622419	28.57	17
65	2025-05-25 22:58:23.624453	14.99	98
66	2025-05-25 22:58:23.626409	15.88	14
67	2025-05-25 22:58:23.63215	94.12	85
68	2025-05-25 22:58:23.634252	47.19	83
69	2025-05-25 22:58:23.63631	64.87	51
70	2025-05-25 22:58:23.638339	17.4	53
71	2025-05-25 22:58:23.640382	14.39	1
72	2025-05-25 22:58:23.642379	44.72	20
73	2025-05-25 22:58:23.648229	46.96	53
74	2025-05-25 22:58:23.650442	33.29	69
75	2025-05-25 22:58:23.652735	52.64	104
76	2025-05-25 22:58:23.655002	42.55	44
77	2025-05-25 22:58:23.657146	57.87	95
78	2025-05-25 22:58:23.659508	75.26	29
79	2025-05-25 22:58:23.661562	64.44	40
80	2025-05-25 22:58:23.66352	94.0	29
81	2025-05-25 22:58:23.665526	77.86	103
82	2025-05-25 22:58:23.667466	46.92	11
83	2025-05-25 22:58:23.66944	31.48	17
84	2025-05-25 22:58:23.671404	56.88	91
85	2025-05-25 22:58:23.673425	49.12	63
86	2025-05-25 22:58:23.675452	83.23	30
87	2025-05-25 22:58:23.677573	56.67	2
88	2025-05-25 22:58:23.679544	23.75	93
89	2025-05-25 22:58:23.681553	20.24	100
90	2025-05-25 22:58:23.683559	28.88	86
91	2025-05-25 22:58:23.689114	12.54	105
92	2025-05-25 22:58:23.69163	48.78	78
93	2025-05-25 22:58:23.693707	37.68	112
94	2025-05-25 22:58:23.695872	25.09	91
95	2025-05-25 22:58:23.698335	85.31	42
96	2025-05-25 22:58:23.704678	22.31	1
97	2025-05-25 22:58:23.707848	84.16	117
98	2025-05-25 22:58:23.710387	23.97	102
99	2025-05-25 22:58:23.71269	85.66	87
100	2025-05-25 22:58:23.718429	93.42	100
101	2025-05-25 22:58:23.721278	83.18	25
102	2025-05-25 22:58:23.724352	96.06	26
103	2025-05-25 22:58:23.726423	39.34	115
104	2025-05-25 22:58:23.728588	25.68	110
105	2025-05-25 22:58:23.730645	95.43	2
106	2025-05-25 22:58:23.732702	45.63	28
107	2025-05-25 22:58:23.734827	34.3	40
108	2025-05-25 22:58:23.736899	49.64	91
109	2025-05-25 22:58:23.738955	39.94	62
110	2025-05-25 22:58:23.740984	75.28	13
111	2025-05-25 22:58:23.743038	59.84	113
112	2025-05-25 22:58:23.745126	22.01	50
113	2025-05-25 22:58:23.747196	87.46	5
114	2025-05-25 22:58:23.749258	65.07	86
115	2025-05-25 22:58:23.751337	48.54	40
116	2025-05-25 22:58:23.757213	21.39	56
117	2025-05-25 22:58:23.759675	57.29	51
118	2025-05-25 22:58:23.761666	60.26	91
119	2025-05-25 22:58:23.763769	79.11	118
120	2025-05-25 22:58:23.765791	45.97	70
121	2025-05-25 22:58:23.767948	16.35	108
122	2025-05-25 22:58:23.77297	12.79	59
123	2025-05-25 22:58:23.775724	70.24	42
124	2025-05-25 22:58:23.777785	40.19	116
125	2025-05-25 22:58:23.779876	47.17	8
126	2025-05-25 22:58:23.781886	93.44	117
127	2025-05-25 22:58:23.78395	88.07	2
128	2025-05-25 22:58:23.788823	20.23	49
129	2025-05-25 22:58:23.791548	75.37	30
130	2025-05-25 22:58:23.793884	41.65	97
131	2025-05-25 22:58:23.796042	51.71	106
132	2025-05-25 22:58:23.798356	62.79	56
133	2025-05-25 22:58:23.800499	74.08	46
134	2025-05-25 22:58:23.802693	45.65	107
135	2025-05-25 22:58:23.804715	35.83	39
136	2025-05-25 22:58:23.806792	79.61	53
137	2025-05-25 22:58:23.808792	58.04	86
139	2025-05-25 22:58:23.813012	46.91	76
141	2025-05-25 22:58:23.817037	48.11	41
143	2025-05-25 22:58:23.821103	63.31	69
145	2025-05-25 22:58:23.82889	48.22	115
147	2025-05-25 22:58:23.832892	49.36	32
149	2025-05-25 22:58:23.836807	60.86	24
151	2025-05-25 22:58:23.840773	27.21	119
153	2025-05-25 22:58:23.847715	42.65	65
155	2025-05-25 22:58:23.851602	87.0	68
157	2025-05-25 22:58:23.855725	84.65	120
159	2025-05-25 22:58:23.863367	52.72	35
161	2025-05-25 22:58:23.867311	50.18	41
163	2025-05-25 22:58:23.871346	81.54	114
165	2025-05-25 22:58:23.87535	17.79	15
167	2025-05-25 22:58:23.879274	11.01	77
169	2025-05-25 22:58:23.883263	42.83	27
171	2025-05-25 22:58:23.887233	75.53	52
173	2025-05-25 22:58:23.89149	97.84	50
175	2025-05-25 22:58:23.895571	83.66	106
177	2025-05-25 22:58:23.903595	96.15	52
179	2025-05-25 22:58:23.907883	72.93	23
181	2025-05-25 22:58:23.911817	40.96	43
183	2025-05-25 22:58:23.919341	32.78	78
185	2025-05-25 22:58:23.923406	61.38	111
187	2025-05-25 22:58:23.927395	87.0	92
189	2025-05-25 22:58:23.935183	99.25	23
191	2025-05-25 22:58:23.939174	52.58	73
193	2025-05-25 22:58:23.94301	58.23	90
195	2025-05-25 22:58:23.947039	64.09	82
197	2025-05-25 22:58:23.951454	75.05	13
199	2025-05-25 22:58:23.956839	58.94	67
201	2025-05-25 22:58:23.961477	53.16	11
203	2025-05-25 22:58:23.966494	73.12	7
205	2025-05-25 22:58:23.971774	30.43	27
207	2025-05-25 22:58:23.975956	71.9	64
209	2025-05-25 22:58:23.979999	52.96	112
211	2025-05-25 22:58:23.987572	73.86	56
213	2025-05-25 22:58:23.991695	53.48	104
215	2025-05-25 22:58:23.995709	94.8	74
217	2025-05-25 22:58:24.004416	55.17	52
219	2025-05-25 22:58:24.009001	17.36	25
221	2025-05-25 22:58:24.01648	68.06	2
223	2025-05-25 22:58:24.021282	83.86	71
225	2025-05-25 22:58:24.025633	33.73	85
227	2025-05-25 22:58:24.030522	17.31	69
229	2025-05-25 22:58:24.035327	35.01	58
231	2025-05-25 22:58:24.039983	86.8	72
233	2025-05-25 22:58:24.044356	13.17	22
235	2025-05-25 22:58:24.048353	25.85	93
237	2025-05-25 22:58:24.052311	74.07	114
239	2025-05-25 22:58:24.056229	33.5	7
241	2025-05-25 22:58:24.060911	18.76	96
243	2025-05-25 22:58:24.069542	75.76	78
245	2025-05-25 22:58:24.074392	46.95	114
247	2025-05-25 22:58:24.0814	61.35	46
249	2025-05-25 22:58:24.085544	48.25	69
251	2025-05-25 22:58:24.09025	53.1	98
253	2025-05-25 22:58:24.097258	99.2	28
255	2025-05-25 22:58:24.101504	15.09	95
257	2025-05-25 22:58:24.110496	31.66	106
259	2025-05-25 22:58:24.114806	30.29	19
261	2025-05-25 22:58:24.119259	90.25	69
263	2025-05-25 22:58:24.123336	48.56	96
265	2025-05-25 22:58:24.127404	68.4	11
267	2025-05-25 22:58:24.13137	46.26	23
269	2025-05-25 22:58:24.135245	96.37	27
271	2025-05-25 22:58:24.143077	10.39	114
273	2025-05-25 22:58:24.147491	70.08	5
275	2025-05-25 22:58:24.151498	20.3	104
277	2025-05-25 22:58:24.158753	72.4	9
279	2025-05-25 22:58:24.162913	14.52	43
281	2025-05-25 22:58:24.166907	66.74	57
283	2025-05-25 22:58:24.174425	78.04	20
285	2025-05-25 22:58:24.178398	57.9	27
287	2025-05-25 22:58:24.182362	69.12	76
289	2025-05-25 22:58:24.186484	43.21	13
291	2025-05-25 22:58:24.190307	29.74	116
293	2025-05-25 22:58:24.19438	72.58	109
295	2025-05-25 22:58:24.198302	94.67	61
297	2025-05-25 22:58:24.202754	57.26	77
299	2025-05-25 22:58:24.207071	69.05	5
138	2025-05-25 22:58:23.810951	16.46	77
140	2025-05-25 22:58:23.815018	89.05	27
142	2025-05-25 22:58:23.819103	81.83	7
144	2025-05-25 22:58:23.823194	44.87	24
146	2025-05-25 22:58:23.830917	87.88	52
148	2025-05-25 22:58:23.834854	55.68	64
150	2025-05-25 22:58:23.838756	59.95	57
152	2025-05-25 22:58:23.845657	93.09	9
154	2025-05-25 22:58:23.849659	41.75	118
156	2025-05-25 22:58:23.853668	96.11	5
158	2025-05-25 22:58:23.861451	24.54	60
160	2025-05-25 22:58:23.86533	26.62	39
162	2025-05-25 22:58:23.86933	63.52	25
164	2025-05-25 22:58:23.873326	45.73	88
166	2025-05-25 22:58:23.877304	83.53	87
168	2025-05-25 22:58:23.881261	90.68	41
170	2025-05-25 22:58:23.885239	30.68	12
172	2025-05-25 22:58:23.889212	14.88	20
174	2025-05-25 22:58:23.893497	94.76	101
176	2025-05-25 22:58:23.89756	24.21	81
178	2025-05-25 22:58:23.905884	89.41	44
180	2025-05-25 22:58:23.909863	79.84	65
182	2025-05-25 22:58:23.91386	25.87	6
184	2025-05-25 22:58:23.921379	55.25	86
186	2025-05-25 22:58:23.925387	99.34	50
188	2025-05-25 22:58:23.929399	12.5	58
190	2025-05-25 22:58:23.937216	43.53	84
192	2025-05-25 22:58:23.941092	57.24	62
194	2025-05-25 22:58:23.944911	77.22	57
196	2025-05-25 22:58:23.949248	85.63	95
198	2025-05-25 22:58:23.954434	67.89	51
200	2025-05-25 22:58:23.95913	52.79	111
202	2025-05-25 22:58:23.963801	69.86	14
204	2025-05-25 22:58:23.968891	47.73	61
206	2025-05-25 22:58:23.973913	76.62	6
208	2025-05-25 22:58:23.977988	52.54	64
210	2025-05-25 22:58:23.985508	64.11	39
212	2025-05-25 22:58:23.989699	42.16	76
214	2025-05-25 22:58:23.993703	85.87	111
216	2025-05-25 22:58:24.001511	86.04	78
218	2025-05-25 22:58:24.006592	13.06	54
220	2025-05-25 22:58:24.011244	54.0	81
222	2025-05-25 22:58:24.018669	51.98	35
224	2025-05-25 22:58:24.023408	87.79	10
226	2025-05-25 22:58:24.027747	34.28	95
228	2025-05-25 22:58:24.03296	89.77	102
230	2025-05-25 22:58:24.037494	38.2	71
232	2025-05-25 22:58:24.042167	92.29	48
234	2025-05-25 22:58:24.046339	59.39	94
236	2025-05-25 22:58:24.050308	93.05	116
238	2025-05-25 22:58:24.054259	80.08	117
240	2025-05-25 22:58:24.058645	94.4	77
242	2025-05-25 22:58:24.066712	92.38	58
244	2025-05-25 22:58:24.072213	67.07	23
246	2025-05-25 22:58:24.07662	58.74	100
248	2025-05-25 22:58:24.083563	84.52	95
250	2025-05-25 22:58:24.088279	91.49	33
252	2025-05-25 22:58:24.092393	41.48	36
254	2025-05-25 22:58:24.09949	66.15	86
256	2025-05-25 22:58:24.104524	92.43	61
258	2025-05-25 22:58:24.112744	47.59	4
260	2025-05-25 22:58:24.117233	11.53	39
262	2025-05-25 22:58:24.121374	62.6	60
264	2025-05-25 22:58:24.125461	34.1	7
266	2025-05-25 22:58:24.129453	99.02	74
268	2025-05-25 22:58:24.133317	29.58	85
270	2025-05-25 22:58:24.140922	68.84	43
272	2025-05-25 22:58:24.145357	96.48	37
274	2025-05-25 22:58:24.149515	89.3	77
276	2025-05-25 22:58:24.15669	75.11	42
278	2025-05-25 22:58:24.160907	15.53	19
280	2025-05-25 22:58:24.164909	11.71	3
282	2025-05-25 22:58:24.172372	12.47	36
284	2025-05-25 22:58:24.176421	14.26	90
286	2025-05-25 22:58:24.180392	87.38	14
288	2025-05-25 22:58:24.184553	99.49	111
290	2025-05-25 22:58:24.188353	29.55	11
292	2025-05-25 22:58:24.192345	37.61	41
294	2025-05-25 22:58:24.196325	76.98	92
296	2025-05-25 22:58:24.200383	63.37	104
298	2025-05-25 22:58:24.204907	36.03	50
300	2025-05-25 22:58:24.212868	38.87	80
\.


--
-- Data for Name: logs_estado_dispositivo; Type: TABLE DATA; Schema: public; Owner: ariel
--

COPY public.logs_estado_dispositivo (id, "timestamp", estado, mensaje_opcional, dispositivo_id) FROM stdin;
1	2025-05-25 22:58:24.217727	reiniciado	Worry they white leave page.	23
2	2025-05-25 22:58:24.221397	bajo batería	Teacher young control else power no company.	17
3	2025-05-25 22:58:24.226609	bajo batería	Site adult answer conference scientist industry side pull.	62
4	2025-05-25 22:58:24.229475	bajo batería	College smile from film.	34
5	2025-05-25 22:58:24.232112	error	Financial pay focus wonder church.	5
6	2025-05-25 22:58:24.235336	bajo batería	Main degree financial when treat.	61
7	2025-05-25 22:58:24.240875	activo	Action all voice expect action.	40
8	2025-05-25 22:58:24.243655	inactivo	Eat give during than culture soldier production soldier.	48
9	2025-05-25 22:58:24.246337	inactivo	Price whether fly.	17
10	2025-05-25 22:58:24.24905	en mantenimiento	Should true ever later.	7
11	2025-05-25 22:58:24.251852	en espera	Leg those pretty.	40
12	2025-05-25 22:58:24.254541	activo	Bad three data million investment.	21
13	2025-05-25 22:58:24.25715	apagado	Set box leave.	20
14	2025-05-25 22:58:24.259758	error	Mean different member on type finish knowledge lead.	23
15	2025-05-25 22:58:24.262208	firmware update	Far pressure local leave subject.	49
16	2025-05-25 22:58:24.264833	en espera	Skin apply do trouble book.	19
17	2025-05-25 22:58:24.267332	apagado	Decision great nearly serve why already.	47
18	2025-05-25 22:58:24.269871	sin conexión	Trade claim group let.	78
19	2025-05-25 22:58:24.272375	en espera	Learn force focus could wish song.	14
20	2025-05-25 22:58:24.274981	en espera	Almost organization decide claim truth.	36
21	2025-05-25 22:58:24.27757	bajo batería	High wrong close wind knowledge detail one.	56
22	2025-05-25 22:58:24.280258	reiniciado	Audience should race pretty example walk.	56
23	2025-05-25 22:58:24.286185	sin conexión	Network medical carry.	39
24	2025-05-25 22:58:24.288715	firmware update	Medical pick beyond note until.	65
25	2025-05-25 22:58:24.291129	en mantenimiento	Upon idea new address end.	35
26	2025-05-25 22:58:24.293714	reiniciado	Side admit behind off.	23
27	2025-05-25 22:58:24.299876	sin conexión	Order work piece take vote cost sing.	36
28	2025-05-25 22:58:24.30424	en mantenimiento	Live stage summer imagine wind item actually.	64
29	2025-05-25 22:58:24.307049	reiniciado	Option wind sing answer property around staff method.	26
30	2025-05-25 22:58:24.312709	en mantenimiento	Theory account figure minute.	42
31	2025-05-25 22:58:24.315493	error	Recent significant skin something threat thank four.	48
32	2025-05-25 22:58:24.319306	bajo batería	Agreement key partner drive third.	46
33	2025-05-25 22:58:24.322779	error	Fish reflect character list number back.	54
34	2025-05-25 22:58:24.325344	sin conexión	Business color produce Mr.	73
35	2025-05-25 22:58:24.328119	bajo batería	Right nothing under major which game.	24
36	2025-05-25 22:58:24.330986	error	Image answer best team mother available.	45
37	2025-05-25 22:58:24.333728	error	Score argue amount.	50
38	2025-05-25 22:58:24.336231	sin conexión	Result while simply little although.	59
39	2025-05-25 22:58:24.338771	bajo batería	Feeling boy blue church.	41
40	2025-05-25 22:58:24.341316	reiniciado	Office reach beautiful outside realize.	35
41	2025-05-25 22:58:24.344108	en espera	Dream when usually media meeting radio.	74
42	2025-05-25 22:58:24.346716	en espera	Upon first resource candidate.	23
43	2025-05-25 22:58:24.34949	en espera	Matter listen bar detail Mr war.	67
44	2025-05-25 22:58:24.357399	error	Inside event conference mention professor drop.	18
45	2025-05-25 22:58:24.361098	reiniciado	Occur one by later day there.	57
46	2025-05-25 22:58:24.364516	apagado	Southern show data physical ball only manager quality.	69
47	2025-05-25 22:58:24.369982	error	Behavior listen those card often.	28
48	2025-05-25 22:58:24.373794	apagado	Consumer town newspaper let nature prove.	22
49	2025-05-25 22:58:24.3764	reiniciado	Recognize woman less parent line.	43
50	2025-05-25 22:58:24.382736	activo	Message sister must strong impact continue debate.	80
51	2025-05-25 22:58:24.38525	inactivo	Continue population economic chair task.	9
52	2025-05-25 22:58:24.387817	activo	Authority long than learn check generation me result.	26
53	2025-05-25 22:58:24.39067	activo	Pay author start yeah keep across drive.	15
54	2025-05-25 22:58:24.393368	en espera	Group decide participant couple scientist about.	44
55	2025-05-25 22:58:24.396819	inactivo	Half even dark management control.	44
56	2025-05-25 22:58:24.399982	apagado	Top economic cost most.	4
57	2025-05-25 22:58:24.402832	error	Section draw so middle too sort.	47
58	2025-05-25 22:58:24.405779	activo	Baby final finally serve several wait.	43
59	2025-05-25 22:58:24.408441	en espera	Indeed citizen teacher should poor simply response door.	22
60	2025-05-25 22:58:24.411388	sin conexión	Eight item cultural do research management hold.	60
61	2025-05-25 22:58:24.414973	inactivo	Deep close save many before set.	7
62	2025-05-25 22:58:24.418059	bajo batería	Offer conference someone poor.	25
63	2025-05-25 22:58:24.425843	bajo batería	Rather property decision share woman nice describe.	48
64	2025-05-25 22:58:24.428564	bajo batería	Activity specific huge behavior since performance paper.	26
65	2025-05-25 22:58:24.431333	error	Enter indeed huge fly environmental game marriage.	30
66	2025-05-25 22:58:24.437695	activo	Radio take actually late.	47
67	2025-05-25 22:58:24.4407	firmware update	Cause son test hour.	53
68	2025-05-25 22:58:24.443446	apagado	Face loss something under most.	15
69	2025-05-25 22:58:24.44642	reiniciado	Simply join history special huge simple.	20
70	2025-05-25 22:58:24.451684	reiniciado	Put analysis later data.	76
71	2025-05-25 22:58:24.45461	activo	Film well say cover purpose right.	68
72	2025-05-25 22:58:24.45757	error	Phone fly change themselves participant.	31
73	2025-05-25 22:58:24.460376	reiniciado	Money campaign responsibility.	2
74	2025-05-25 22:58:24.463057	error	Evening himself make stay.	42
75	2025-05-25 22:58:24.465822	en espera	Behavior letter power Mrs might kid.	15
76	2025-05-25 22:58:24.46854	activo	Season least center table recognize want.	3
77	2025-05-25 22:58:24.471153	en mantenimiento	Forward close local positive.	9
78	2025-05-25 22:58:24.473639	en espera	Reduce off their part.	75
79	2025-05-25 22:58:24.476233	en espera	Million hair break mouth black into.	20
80	2025-05-25 22:58:24.47863	en mantenimiento	Can imagine especially itself sort see service themselves.	71
81	2025-05-25 22:58:24.481783	en mantenimiento	Summer really nature relationship nature create himself.	21
82	2025-05-25 22:58:24.484367	reiniciado	Environment happen decision house better growth.	52
83	2025-05-25 22:58:24.486982	sin conexión	Open six sound sister debate.	18
85	2025-05-25 22:58:24.496502	sin conexión	Professional into shoulder ready travel.	27
87	2025-05-25 22:58:24.502362	apagado	Watch card reason itself language.	14
89	2025-05-25 22:58:24.510403	activo	Serve machine behavior describe.	57
91	2025-05-25 22:58:24.516224	bajo batería	They avoid leader authority indicate.	38
93	2025-05-25 22:58:24.524146	reiniciado	Military born list fly relate part upon.	47
95	2025-05-25 22:58:24.529921	inactivo	Year want where.	23
97	2025-05-25 22:58:24.535638	en espera	Never feel its machine just huge.	23
99	2025-05-25 22:58:24.541623	apagado	Partner base choose could professor choice husband.	23
101	2025-05-25 22:58:24.546823	reiniciado	Just study action others record out upon catch.	6
105	2025-05-25 22:58:24.559375	reiniciado	Often energy physical month window so.	68
107	2025-05-25 22:58:24.567659	firmware update	Behind name develop plant early how.	65
109	2025-05-25 22:58:24.572722	firmware update	Center rest strategy.	54
112	2025-05-25 22:58:24.585104	sin conexión	Face economy either budget usually.	65
114	2025-05-25 22:58:24.590487	bajo batería	Management growth trial.	2
116	2025-05-25 22:58:24.597877	firmware update	Oil care blue blue common none.	31
118	2025-05-25 22:58:24.603053	reiniciado	Week line light business billion provide image.	79
120	2025-05-25 22:58:24.608416	sin conexión	Tend organization information near tell.	22
122	2025-05-25 22:58:24.613612	firmware update	Real will individual world.	56
124	2025-05-25 22:58:24.618709	en mantenimiento	Opportunity window day history.	19
126	2025-05-25 22:58:24.623721	reiniciado	His measure on thus thought.	51
129	2025-05-25 22:58:24.632693	en mantenimiento	Oil someone industry expect lose water whatever.	53
130	2025-05-25 22:58:24.636171	sin conexión	Well another painting plant attention community citizen.	16
132	2025-05-25 22:58:24.643717	error	Accept forward third amount.	75
133	2025-05-25 22:58:24.647045	sin conexión	Suffer operation foreign leader mention.	63
135	2025-05-25 22:58:24.654671	bajo batería	Why note reveal part.	13
136	2025-05-25 22:58:24.657964	firmware update	Affect institution character face former return production.	57
138	2025-05-25 22:58:24.663167	apagado	Fire current economy about lawyer catch.	33
141	2025-05-25 22:58:24.675651	error	Others old could spend rise window catch.	23
143	2025-05-25 22:58:24.682007	error	Expect gun much right capital subject.	1
145	2025-05-25 22:58:24.686954	activo	Gun exactly sure perform.	63
146	2025-05-25 22:58:24.690132	bajo batería	True resource would my.	10
148	2025-05-25 22:58:24.695072	inactivo	Significant Congress couple hair any.	62
150	2025-05-25 22:58:24.700174	activo	Leave magazine thought maintain represent fire election.	67
152	2025-05-25 22:58:24.70528	en mantenimiento	Health team prevent.	37
154	2025-05-25 22:58:24.713292	error	Lot between argue account.	43
155	2025-05-25 22:58:24.716633	apagado	Popular situation when common year deal.	34
158	2025-05-25 22:58:24.726949	en espera	Race mention change bank always want meet wide.	33
160	2025-05-25 22:58:24.732392	firmware update	Cold once garden lead while.	60
162	2025-05-25 22:58:24.741003	inactivo	There herself personal continue.	52
164	2025-05-25 22:58:24.745818	activo	Growth imagine wish field involve myself.	61
167	2025-05-25 22:58:24.753453	inactivo	Time stop difference without nearly direction provide.	31
169	2025-05-25 22:58:24.757904	firmware update	One wall tell work opportunity another.	5
171	2025-05-25 22:58:24.762913	apagado	Treatment interview others.	11
173	2025-05-25 22:58:24.767989	sin conexión	You area protect fear security model fact.	68
175	2025-05-25 22:58:24.773033	inactivo	Local glass watch history.	56
177	2025-05-25 22:58:24.778451	error	Investment article list inside.	3
179	2025-05-25 22:58:24.787551	reiniciado	Message husband alone serve.	22
181	2025-05-25 22:58:24.793436	reiniciado	Experience yeah local lose health thus.	58
183	2025-05-25 22:58:24.801164	en espera	Character himself coach bag people pressure message.	1
185	2025-05-25 22:58:24.806806	inactivo	South gas both compare huge.	79
187	2025-05-25 22:58:24.814978	inactivo	Any tree may much science fund relationship.	4
189	2025-05-25 22:58:24.820071	reiniciado	Model movie specific.	11
191	2025-05-25 22:58:24.825404	en espera	Standard measure million decide get beat certain.	3
193	2025-05-25 22:58:24.830674	error	Police product home our build kitchen president that.	62
195	2025-05-25 22:58:24.83567	en mantenimiento	Dinner remain apply they modern court.	61
197	2025-05-25 22:58:24.84074	reiniciado	Exactly growth size technology.	46
199	2025-05-25 22:58:24.845941	sin conexión	Behavior include environment moment say.	56
201	2025-05-25 22:58:24.851091	inactivo	Follow although physical role song.	20
203	2025-05-25 22:58:24.860674	apagado	Medical partner fall member other suggest.	77
205	2025-05-25 22:58:24.865847	apagado	Tonight specific stand involve thing avoid a level.	22
208	2025-05-25 22:58:24.87733	en espera	Think page company international discuss.	54
210	2025-05-25 22:58:24.882512	en mantenimiento	Eat blood surface face pull building.	6
212	2025-05-25 22:58:24.890588	en mantenimiento	Life group add so.	73
214	2025-05-25 22:58:24.895761	apagado	Day thought story official fish man always.	11
216	2025-05-25 22:58:24.901108	bajo batería	Office trade collection music top business.	17
218	2025-05-25 22:58:24.906259	firmware update	Wind story successful worker line wait similar.	62
220	2025-05-25 22:58:24.911365	reiniciado	Land this project catch involve impact.	45
222	2025-05-25 22:58:24.916477	error	Fast play top feeling season common.	15
224	2025-05-25 22:58:24.921847	activo	Bag story together indeed scene evidence.	14
225	2025-05-25 22:58:24.925424	error	Late box military assume chance.	80
228	2025-05-25 22:58:24.93698	reiniciado	Product summer purpose.	3
229	2025-05-25 22:58:24.940384	bajo batería	Soon able election option ever.	63
231	2025-05-25 22:58:24.948982	sin conexión	Specific pick compare group.	47
233	2025-05-25 22:58:24.954022	activo	Avoid action condition deal actually specific business.	25
235	2025-05-25 22:58:24.963556	error	Herself space that conference about animal present concern.	56
237	2025-05-25 22:58:24.969205	firmware update	Run even bill try none perform.	70
241	2025-05-25 22:58:24.981207	bajo batería	Step share fill name law.	62
242	2025-05-25 22:58:24.984696	sin conexión	Own toward factor call truth ball add.	55
244	2025-05-25 22:58:24.989962	firmware update	And fear management.	17
246	2025-05-25 22:58:24.995015	reiniciado	Become allow head kind cause choice these.	56
84	2025-05-25 22:58:24.489644	apagado	Even success very guy director in.	51
86	2025-05-25 22:58:24.499613	en mantenimiento	Scientist home toward nature several.	45
88	2025-05-25 22:58:24.504851	apagado	Reduce expert military raise word.	72
90	2025-05-25 22:58:24.513377	activo	Opportunity window will realize.	79
92	2025-05-25 22:58:24.519147	error	Both rule local interesting hear.	57
94	2025-05-25 22:58:24.526963	error	Game even former.	74
96	2025-05-25 22:58:24.532606	en mantenimiento	Something easy street effect who.	65
98	2025-05-25 22:58:24.538372	en mantenimiento	Realize call sing box most never position.	58
100	2025-05-25 22:58:24.544334	bajo batería	Take manager idea cover remain democratic work.	73
102	2025-05-25 22:58:24.550626	inactivo	Bar military thus participant what season.	72
103	2025-05-25 22:58:24.553734	inactivo	Human grow against whom.	77
104	2025-05-25 22:58:24.556821	en espera	Land quality growth case gun.	16
106	2025-05-25 22:58:24.561919	bajo batería	Head house son party leader none.	36
108	2025-05-25 22:58:24.570199	bajo batería	Town probably recognize.	18
110	2025-05-25 22:58:24.575241	error	Difference clearly college ten your reveal friend.	21
111	2025-05-25 22:58:24.582531	error	Wrong certainly process.	47
113	2025-05-25 22:58:24.58782	en mantenimiento	Other song people financial.	50
115	2025-05-25 22:58:24.595374	apagado	Run production treat child close down theory population.	24
117	2025-05-25 22:58:24.600519	firmware update	School bill hit.	67
119	2025-05-25 22:58:24.605859	bajo batería	Me finally yet seek last power.	29
121	2025-05-25 22:58:24.61098	firmware update	Right stock mother whole.	6
123	2025-05-25 22:58:24.616114	error	Reality bit often phone watch.	77
125	2025-05-25 22:58:24.621156	en mantenimiento	Remember relationship behavior.	8
127	2025-05-25 22:58:24.626214	sin conexión	Of sound usually material foot bag.	42
128	2025-05-25 22:58:24.630114	en espera	Whose near letter.	25
131	2025-05-25 22:58:24.640775	apagado	Now against support past from their.	76
134	2025-05-25 22:58:24.649617	firmware update	Red stand matter where military.	71
137	2025-05-25 22:58:24.660638	sin conexión	Human above now opportunity before federal it.	36
139	2025-05-25 22:58:24.66919	inactivo	Paper travel keep her.	8
140	2025-05-25 22:58:24.672849	apagado	Edge onto old difference new.	37
142	2025-05-25 22:58:24.67829	firmware update	Respond sister fill debate onto black.	35
144	2025-05-25 22:58:24.684506	en espera	Share item simply if issue something.	53
147	2025-05-25 22:58:24.692691	en espera	If however person contain air.	42
149	2025-05-25 22:58:24.697705	en espera	Simple section a require building reduce often region.	31
151	2025-05-25 22:58:24.702773	en mantenimiento	International piece for government idea.	40
153	2025-05-25 22:58:24.707891	error	No fall from according soldier artist defense.	78
156	2025-05-25 22:58:24.719154	en espera	Glass attack almost vote serve gun during.	62
157	2025-05-25 22:58:24.722548	inactivo	Focus garden move goal under likely window.	33
159	2025-05-25 22:58:24.729734	en mantenimiento	Arrive than focus they where.	69
161	2025-05-25 22:58:24.735041	apagado	Marriage politics move fast.	20
163	2025-05-25 22:58:24.743494	sin conexión	Paper kitchen around teacher.	48
165	2025-05-25 22:58:24.748037	apagado	Discover note town food budget class standard world.	48
166	2025-05-25 22:58:24.751214	firmware update	Couple high blue sometimes.	40
168	2025-05-25 22:58:24.755739	inactivo	Personal law mind each sometimes think majority.	5
170	2025-05-25 22:58:24.760311	bajo batería	Could of why environment send me Mrs.	79
172	2025-05-25 22:58:24.765516	activo	Although occur region home court exactly.	66
174	2025-05-25 22:58:24.770513	apagado	Compare throw cell including police unit let.	15
176	2025-05-25 22:58:24.775825	error	Seven employee necessary sure prevent.	29
178	2025-05-25 22:58:24.781072	sin conexión	Exist environment fish practice share pretty maintain.	41
180	2025-05-25 22:58:24.790369	error	Voice television necessary full start land throughout.	50
182	2025-05-25 22:58:24.796145	bajo batería	Say court happy past structure goal make.	1
184	2025-05-25 22:58:24.804108	bajo batería	Speak level public environmental full expert.	22
186	2025-05-25 22:58:24.809443	error	Raise customer organization side partner strong.	48
188	2025-05-25 22:58:24.817567	sin conexión	During move type.	48
190	2025-05-25 22:58:24.822578	inactivo	Three either way scientist physical record.	59
192	2025-05-25 22:58:24.82799	bajo batería	Sport other next decade stage.	58
194	2025-05-25 22:58:24.833132	en mantenimiento	Job available in imagine respond wish.	48
196	2025-05-25 22:58:24.838215	en mantenimiento	Them response ground ago truth develop grow.	2
198	2025-05-25 22:58:24.843342	en mantenimiento	About sport federal food.	46
200	2025-05-25 22:58:24.848496	activo	Board source defense dream head beautiful.	47
202	2025-05-25 22:58:24.853628	en mantenimiento	Baby book continue shoulder either budget father.	30
204	2025-05-25 22:58:24.863166	sin conexión	Strong should full certainly beautiful when.	6
206	2025-05-25 22:58:24.868328	apagado	Yourself father sport happy because budget challenge.	1
207	2025-05-25 22:58:24.87491	sin conexión	Less risk rate technology size teacher.	5
209	2025-05-25 22:58:24.879993	inactivo	Deal thus continue avoid vote message.	28
211	2025-05-25 22:58:24.888094	en espera	Sort property gas you may outside stand.	45
213	2025-05-25 22:58:24.893217	sin conexión	Shoulder north high too this rich.	73
215	2025-05-25 22:58:24.898506	en espera	Financial firm challenge sure over response.	78
217	2025-05-25 22:58:24.903636	apagado	Discuss paper most cost policy dream.	8
219	2025-05-25 22:58:24.908833	en mantenimiento	Yet arm picture over particularly.	38
221	2025-05-25 22:58:24.913913	en mantenimiento	Administration somebody respond college would support ground.	33
223	2025-05-25 22:58:24.919244	activo	Present always traditional defense plant by you check.	40
226	2025-05-25 22:58:24.928519	firmware update	Million blue if article table.	73
227	2025-05-25 22:58:24.93433	sin conexión	Prevent win develop everyone commercial consider lawyer.	70
230	2025-05-25 22:58:24.946464	apagado	From husband change administration industry lot.	62
232	2025-05-25 22:58:24.951474	activo	Bag true character leader.	4
234	2025-05-25 22:58:24.960878	activo	Second hear nor forget where color.	56
236	2025-05-25 22:58:24.966222	en espera	Number partner able painting.	49
238	2025-05-25 22:58:24.971946	sin conexión	Game else room challenge husband memory.	66
239	2025-05-25 22:58:24.97513	sin conexión	Which bank hour century animal stand.	71
240	2025-05-25 22:58:24.97837	activo	Recently build knowledge work direction close.	60
243	2025-05-25 22:58:24.987391	activo	Return bring interest agent number since course.	73
245	2025-05-25 22:58:24.992507	activo	Bad no enjoy fast exactly.	59
248	2025-05-25 22:58:25.003915	inactivo	Color my some strategy follow.	37
250	2025-05-25 22:58:25.008948	firmware update	Writer reality sell without.	3
253	2025-05-25 22:58:25.021997	error	Among carry certainly after lay attention.	13
255	2025-05-25 22:58:25.030919	en mantenimiento	Sort base interview I house general.	80
257	2025-05-25 22:58:25.036345	sin conexión	Feeling compare authority south law concern role like.	23
259	2025-05-25 22:58:25.041459	reiniciado	Child send generation effort commercial table.	69
261	2025-05-25 22:58:25.046664	error	Even store rise seat how election.	33
263	2025-05-25 22:58:25.052376	en mantenimiento	Finally maybe continue billion once.	57
265	2025-05-25 22:58:25.058408	apagado	Manage call alone central less recognize.	37
267	2025-05-25 22:58:25.063809	en espera	Mr meet machine new later avoid bar plant.	23
269	2025-05-25 22:58:25.069664	en mantenimiento	Generation their pass who.	35
247	2025-05-25 22:58:24.998343	inactivo	Item alone off concern fly.	6
249	2025-05-25 22:58:25.006394	activo	Story maybe notice cause style vote game despite.	38
251	2025-05-25 22:58:25.011424	en mantenimiento	Choice measure near end boy car.	54
252	2025-05-25 22:58:25.018642	en espera	Him at strong movie he health nothing.	63
254	2025-05-25 22:58:25.024672	reiniciado	Radio evening room whatever cell various shoulder.	5
256	2025-05-25 22:58:25.033721	en mantenimiento	Thus student evening green bed level language.	55
258	2025-05-25 22:58:25.038945	firmware update	Color difficult deep.	36
260	2025-05-25 22:58:25.043933	firmware update	Well old meeting pick whole little give authority.	23
262	2025-05-25 22:58:25.049258	firmware update	Federal employee table middle woman process southern.	25
264	2025-05-25 22:58:25.055428	error	Peace probably personal operation.	16
266	2025-05-25 22:58:25.060958	error	Card cultural forward not employee sense also Republican.	70
268	2025-05-25 22:58:25.066773	firmware update	Have hotel voice analysis will across sport central.	79
270	2025-05-25 22:58:25.075254	error	Kid rest important memory.	24
\.


--
-- Data for Name: sensores; Type: TABLE DATA; Schema: public; Owner: ariel
--

COPY public.sensores (id, tipo_sensor, unidad_medida, dispositivo_id, umbral_alerta) FROM stdin;
1	PIR Motion Sensor	Hz	25	\N
2	GY-521 (MPU6050)	J/s	15	\N
3	PIR Motion Sensor	Primes	57	\N
4	HX711	m/s	25	\N
5	LM35	Ω	5	\N
6	INA219	ppm	5	\N
7	DHT11	Lux	34	\N
8	ESP8266	g	34	\N
9	VL53L0X	V	48	\N
10	BMP180	PSI	44	\N
11	RC522	V	18	\N
12	ESP32	N/m²	73	\N
13	ACS712	%	62	\N
14	ESP32-CAM	Lux	48	\N
15	MQ-135	Hz	47	\N
16	NodeMCU	mol/m²/s	54	\N
17	MQ-135	kPa	45	\N
18	GY-521 (MPU6050)	kPa	12	\N
19	MQ-2	Pa	6	\N
20	PIR Motion Sensor	Primes	46	\N
21	LDR	V	32	\N
22	BMP280	Primes	34	\N
23	ESP32	Lux	67	\N
24	BMP180	°K	77	\N
25	INA219	m/s	25	\N
26	MQ-2	dB	69	\N
27	DHT11	Lux	77	\N
28	MQ-2	Primes	22	\N
29	DHT11	g/m³	45	\N
30	TCS34725	J/s	77	\N
31	HX711	Hz	46	\N
32	BMP280	°K	7	\N
33	ESP32	V	42	\N
34	ESP32	mmHg	41	\N
35	BME280	°C	16	\N
36	ESP8266	g/m³	51	\N
37	MQ-135	°C	29	\N
38	BMP280	Primes	46	\N
39	NodeMCU	%	36	\N
40	ESP32	°F	52	\N
41	BMP280	kPa	32	\N
42	VL53L0X	N/m²	25	\N
43	RC522	°F	51	\N
44	HX711	Lux	45	\N
45	DHT22	Pa	61	\N
46	INA219	Ω	25	\N
47	BMP180	V	43	\N
48	DHT22	g/m³	49	\N
49	ESP32-CAM	mA	16	\N
50	RC522	Primes	67	\N
51	ESP32	mA	22	\N
52	ESP32-CAM	kPa	11	\N
53	DS18B20	°K	74	\N
54	LM35	m/s	80	\N
55	LM35	Hz	67	\N
56	VL53L0X	dB	38	\N
57	LDR	°C	17	\N
58	ESP32	m/s	42	\N
59	PIR Motion Sensor	°C	42	\N
60	ESP32-CAM	dB	29	\N
61	HX711	mA	72	\N
62	BME280	kPa	54	\N
63	BMP180	Ω	75	\N
64	LDR	ppm	77	\N
65	HC-SR04	°C	10	\N
66	NodeMCU	%	59	\N
67	BMP180	Lux	12	\N
68	PIR Motion Sensor	V	63	\N
69	ACS712	V	36	\N
70	MQ-2	dB	15	\N
71	MQ-135	mmHg	49	\N
72	MAX30100	kPa	52	\N
73	MQ-135	Primes	38	\N
74	MQ-2	mmHg	2	\N
75	INA219	kPa	5	\N
76	NodeMCU	Lux	69	\N
77	ESP32-CAM	mol/m²/s	7	\N
78	MQ-135	%	27	\N
79	HC-SR04	Pa	10	\N
80	MAX30100	Primes	6	\N
81	RC522	°C	46	\N
82	INA219	°C	75	\N
83	DHT22	Primes	9	\N
84	TCS34725	N/m²	40	\N
85	DHT11	Ω	64	\N
86	BMP180	mol/m²/s	63	\N
87	DHT11	mmHg	69	\N
88	DHT22	mol/m²/s	58	\N
89	DHT11	J/s	8	\N
90	TCS34725	Primes	80	\N
91	ESP8266	Primes	79	\N
92	MQ-135	V	64	\N
93	BME280	J/s	22	\N
94	ESP32	Lux	11	\N
95	BMP280	mol/m²/s	48	\N
96	HC-SR04	PSI	50	\N
97	VL53L0X	mol/m²/s	8	\N
98	MAX30100	Ω	27	\N
99	DHT22	mmHg	42	\N
100	LDR	dB	75	\N
101	MQ-135	°F	31	\N
102	BMP280	V	22	\N
103	MAX30100	Pa	39	\N
104	ESP32-WROOM	mmHg	1	\N
105	DHT11	mol/m²/s	46	\N
106	TCS34725	PSI	28	\N
107	LDR	N/m²	10	\N
108	DHT11	mmHg	67	\N
109	DHT11	mol/m²/s	69	\N
110	MAX30100	Pa	78	\N
111	ESP8266	m/s	10	\N
112	MAX30100	Lux	21	\N
113	INA219	dB	15	\N
114	NodeMCU	m/s	28	\N
115	BMP280	%	65	\N
116	ESP32-WROOM	kPa	51	\N
117	DS18B20	°F	65	\N
118	BMP180	°K	23	\N
119	BME280	Hz	56	\N
120	LDR	g	31	\N
\.


--
-- Data for Name: tipos_dispositivos; Type: TABLE DATA; Schema: public; Owner: ariel
--

COPY public.tipos_dispositivos (id, fabricante, modelo, descripcion) FROM stdin;
1	Wood, Hicks and Rhodes PLC	Employee-271T	Parent maybe early they despite base fact. House relate energy score dinner world majority.
2	Martin, Morales and Powell Ltd	Modern-659V	You research finish forward travel. Candidate month keep. Goal common exactly maintain.
3	Villanueva, Rodriguez and Garcia LLC	Age-889V	Risk room someone lay. Position chance consumer president Mr case hear weight. Dark wonder arrive sound stage way career its.
4	Wilson-Davenport and Sons	Dinner-381P	Discuss describe theory bag million money management. Discuss popular cut this writer break.
5	Clark, Gutierrez and Velasquez LLC	Focus-151N	Trial society evidence public whether just wall. Floor thousand point nature.
6	Perry LLC Inc	Process-280I	Kid table national law speak author after. Prepare sit who test.
7	Novak Ltd LLC	Current-992O	Specific audience process out figure answer. Because same phone allow someone green fall.
8	Callahan Group and Sons	Sea-811M	Institution act school loss television economy. Once new season speak. Program adult arrive book.
9	Whitehead PLC Group	Necessary-697F	Law sign any throughout debate central ground. Student determine its door eat section drug they.
10	Dalton-Dixon LLC	Sometimes-238Y	Finish religious local soldier structure. Commercial ago ago charge significant outside.
11	Greer, Acosta and Harris LLC	Traditional-615A	Others beat fill although card add from assume. Present international once buy must.
12	Duran, Mclaughlin and Jones and Sons	Set-123B	Foot PM could sure. Service station statement experience president history question.
13	Osborne Group LLC	Level-689S	Hit not good under choice race. Pm which event it scientist happen.
14	Smith, Collins and Hatfield Ltd	Dog-739U	Sign past ahead color. Hit course quickly natural expert. Vote American claim.
15	Sharp Group Group	Mrs-844P	Fish yet science test matter PM way. Science see yeah card.
16	Suarez-Miller LLC	Something-952S	Right still later line place cover maintain. During already take make important. Off simple put.
17	Oconnor-Nielsen Ltd	Population-446Q	Law allow evening even. Simple loss raise event PM share. Everybody animal mother us table back remain.
18	Becker, James and Wise Ltd	Tough-700R	Card next total goal choose. Person window Congress hard water.
19	Thomas-Lutz PLC	Financial-202I	Ahead summer carry customer mean attack case. Law here health word machine stay whole. Politics ready way cut responsibility.
20	Miller-Simpson LLC	Least-223A	Health start expert bed poor hundred. Responsibility what none claim also child near. Sort marriage capital human pretty chair spend.
21	Adams Group and Sons	Strong-992R	West wife government interest itself star catch. Wait before good box must rise collection. Shoulder even produce scene respond hand sometimes.
22	Fletcher Inc Ltd	Part-269P	Month compare list discussion also smile. Institution rise hear than new. Yet enjoy wonder road.
23	Baker, Mosley and Rivera Group	Age-667P	Recognize remember weight. Hundred share benefit movement task begin industry could.
24	Carter and Sons Group	More-277W	Scientist food small bag there smile. Father detail theory attorney market baby movie.
25	Cole, Delgado and Phillips Group	Wonder-192V	Organization evidence Mrs onto. Father media dream cold where.
\.


--
-- Name: dispositivos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ariel
--

SELECT pg_catalog.setval('public.dispositivos_id_seq', 80, true);


--
-- Name: grupos_dispositivos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ariel
--

SELECT pg_catalog.setval('public.grupos_dispositivos_id_seq', 10, true);


--
-- Name: lecturas_datos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ariel
--

SELECT pg_catalog.setval('public.lecturas_datos_id_seq', 300, true);


--
-- Name: logs_estado_dispositivo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ariel
--

SELECT pg_catalog.setval('public.logs_estado_dispositivo_id_seq', 270, true);


--
-- Name: sensores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ariel
--

SELECT pg_catalog.setval('public.sensores_id_seq', 120, true);


--
-- Name: tipos_dispositivos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ariel
--

SELECT pg_catalog.setval('public.tipos_dispositivos_id_seq', 25, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: dispositivos_agrupados dispositivos_agrupados_pkey; Type: CONSTRAINT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.dispositivos_agrupados
    ADD CONSTRAINT dispositivos_agrupados_pkey PRIMARY KEY (dispositivo_id, grupo_dispositivo_id);


--
-- Name: dispositivos dispositivos_mac_address_key; Type: CONSTRAINT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.dispositivos
    ADD CONSTRAINT dispositivos_mac_address_key UNIQUE (mac_address);


--
-- Name: dispositivos dispositivos_numero_serie_key; Type: CONSTRAINT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.dispositivos
    ADD CONSTRAINT dispositivos_numero_serie_key UNIQUE (numero_serie);


--
-- Name: dispositivos dispositivos_pkey; Type: CONSTRAINT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.dispositivos
    ADD CONSTRAINT dispositivos_pkey PRIMARY KEY (id);


--
-- Name: grupos_dispositivos grupos_dispositivos_nombre_key; Type: CONSTRAINT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.grupos_dispositivos
    ADD CONSTRAINT grupos_dispositivos_nombre_key UNIQUE (nombre);


--
-- Name: grupos_dispositivos grupos_dispositivos_pkey; Type: CONSTRAINT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.grupos_dispositivos
    ADD CONSTRAINT grupos_dispositivos_pkey PRIMARY KEY (id);


--
-- Name: lecturas_datos lecturas_datos_pkey; Type: CONSTRAINT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.lecturas_datos
    ADD CONSTRAINT lecturas_datos_pkey PRIMARY KEY (id);


--
-- Name: logs_estado_dispositivo logs_estado_dispositivo_pkey; Type: CONSTRAINT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.logs_estado_dispositivo
    ADD CONSTRAINT logs_estado_dispositivo_pkey PRIMARY KEY (id);


--
-- Name: sensores sensores_pkey; Type: CONSTRAINT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.sensores
    ADD CONSTRAINT sensores_pkey PRIMARY KEY (id);


--
-- Name: tipos_dispositivos tipos_dispositivos_modelo_key; Type: CONSTRAINT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.tipos_dispositivos
    ADD CONSTRAINT tipos_dispositivos_modelo_key UNIQUE (modelo);


--
-- Name: tipos_dispositivos tipos_dispositivos_pkey; Type: CONSTRAINT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.tipos_dispositivos
    ADD CONSTRAINT tipos_dispositivos_pkey PRIMARY KEY (id);


--
-- Name: dispositivos_agrupados dispositivos_agrupados_dispositivo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.dispositivos_agrupados
    ADD CONSTRAINT dispositivos_agrupados_dispositivo_id_fkey FOREIGN KEY (dispositivo_id) REFERENCES public.dispositivos(id);


--
-- Name: dispositivos_agrupados dispositivos_agrupados_grupo_dispositivo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.dispositivos_agrupados
    ADD CONSTRAINT dispositivos_agrupados_grupo_dispositivo_id_fkey FOREIGN KEY (grupo_dispositivo_id) REFERENCES public.grupos_dispositivos(id);


--
-- Name: dispositivos dispositivos_tipo_dispositivo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.dispositivos
    ADD CONSTRAINT dispositivos_tipo_dispositivo_id_fkey FOREIGN KEY (tipo_dispositivo_id) REFERENCES public.tipos_dispositivos(id);


--
-- Name: lecturas_datos lecturas_datos_sensor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.lecturas_datos
    ADD CONSTRAINT lecturas_datos_sensor_id_fkey FOREIGN KEY (sensor_id) REFERENCES public.sensores(id);


--
-- Name: logs_estado_dispositivo logs_estado_dispositivo_dispositivo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.logs_estado_dispositivo
    ADD CONSTRAINT logs_estado_dispositivo_dispositivo_id_fkey FOREIGN KEY (dispositivo_id) REFERENCES public.dispositivos(id);


--
-- Name: sensores sensores_dispositivo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ariel
--

ALTER TABLE ONLY public.sensores
    ADD CONSTRAINT sensores_dispositivo_id_fkey FOREIGN KEY (dispositivo_id) REFERENCES public.dispositivos(id);


--
-- PostgreSQL database dump complete
--

