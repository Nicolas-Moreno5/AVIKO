--
-- PostgreSQL database dump
--

\restrict fpqgPiLhjSCENiOekestJY9kcxmJWFuUJWjM8prdxOWDhhcx8caUjKTm5yEyA0T

-- Dumped from database version 18.7
-- Dumped by pg_dump version 18.7

-- Started on 2026-11-24 21:42:36

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
-- TOC entry 222 (class 1259 OID 16407)
-- Name: autorizacion_datos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.autorizacion_datos (
    codigo_autorizacion integer NOT NULL,
    codigo_cliente integer,
    numero_contacto character varying(20) NOT NULL,
    estado character varying(20) NOT NULL,
    fecha_hora timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    canal character varying(20) NOT NULL,
    finalidad text NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 16406)
-- Name: autorizacion_datos_codigo_autorizacion_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.autorizacion_datos_codigo_autorizacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5004 (class 0 OID 0)
-- Dependencies: 221
-- Name: autorizacion_datos_codigo_autorizacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.autorizacion_datos_codigo_autorizacion_seq OWNED BY public.autorizacion_datos.codigo_autorizacion;


--
-- TOC entry 226 (class 1259 OID 16441)
-- Name: cita; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cita (
    codigo integer NOT NULL,
    cod_cli integer,
    fecha date,
    hora time without time zone,
    direccion character varying(150)
);


--
-- TOC entry 225 (class 1259 OID 16440)
-- Name: cita_codigo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cita_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5005 (class 0 OID 0)
-- Dependencies: 225
-- Name: cita_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cita_codigo_seq OWNED BY public.cita.codigo;


--
-- TOC entry 220 (class 1259 OID 16390)
-- Name: clientes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clientes (
    codigo integer NOT NULL,
    nombre character varying(100) NOT NULL,
    numero_contacto character varying(20) NOT NULL,
    ubicacion character varying(100) NOT NULL,
    direccion character varying(150) NOT NULL,
    tipo_inmueble character varying(50) NOT NULL,
    tipo_cliente character varying(30) NOT NULL,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 219 (class 1259 OID 16389)
-- Name: clientes_codigo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clientes_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 219
-- Name: clientes_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clientes_codigo_seq OWNED BY public.clientes.codigo;


--
-- TOC entry 230 (class 1259 OID 24577)
-- Name: cobertura; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cobertura (
    id integer NOT NULL,
    zona character varying(100) NOT NULL,
    tipo character varying(50) NOT NULL
);


--
-- TOC entry 229 (class 1259 OID 24576)
-- Name: cobertura_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cobertura_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 229
-- Name: cobertura_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cobertura_id_seq OWNED BY public.cobertura.id;


--
-- TOC entry 224 (class 1259 OID 16427)
-- Name: cotizacion; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cotizacion (
    codigo integer NOT NULL,
    cod_cli integer,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    tipo_plaga character varying(50),
    estado character varying(30)
);


--
-- TOC entry 223 (class 1259 OID 16426)
-- Name: cotizacion_codigo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cotizacion_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 223
-- Name: cotizacion_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cotizacion_codigo_seq OWNED BY public.cotizacion.codigo;


--
-- TOC entry 232 (class 1259 OID 24587)
-- Name: plagas_protocolos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plagas_protocolos (
    id integer NOT NULL,
    plaga character varying(100) NOT NULL,
    servicio_asociado character varying(150) NOT NULL,
    protocolo_previo text NOT NULL,
    protocolo_posterior text NOT NULL
);


--
-- TOC entry 231 (class 1259 OID 24586)
-- Name: plagas_protocolos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.plagas_protocolos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 231
-- Name: plagas_protocolos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.plagas_protocolos_id_seq OWNED BY public.plagas_protocolos.id;


--
-- TOC entry 228 (class 1259 OID 16454)
-- Name: servicio; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.servicio (
    codigo integer NOT NULL,
    cod_cli integer,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    tipo character varying(80),
    estado character varying(30)
);


--
-- TOC entry 227 (class 1259 OID 16453)
-- Name: servicio_codigo_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.servicio_codigo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 227
-- Name: servicio_codigo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.servicio_codigo_seq OWNED BY public.servicio.codigo;


--
-- TOC entry 234 (class 1259 OID 24601)
-- Name: tecnicos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tecnicos (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    especialidad character varying(150) NOT NULL,
    zona_asignada character varying(150) NOT NULL,
    disponibilidad character varying(100) NOT NULL
);


--
-- TOC entry 233 (class 1259 OID 24600)
-- Name: tecnicos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tecnicos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 233
-- Name: tecnicos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tecnicos_id_seq OWNED BY public.tecnicos.id;


--
-- TOC entry 236 (class 1259 OID 24615)
-- Name: visitas_tecnicas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.visitas_tecnicas (
    id integer NOT NULL,
    telefono_cliente character varying(20) NOT NULL,
    ubicacion character varying(150) NOT NULL,
    direccion character varying(200) NOT NULL,
    tipo_plaga character varying(100) NOT NULL,
    tecnico_asignado character varying(100) NOT NULL,
    fecha_hora_programada character varying(100) NOT NULL,
    estado character varying(50) DEFAULT 'Agendada'::character varying,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 235 (class 1259 OID 24614)
-- Name: visitas_tecnicas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.visitas_tecnicas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 235
-- Name: visitas_tecnicas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.visitas_tecnicas_id_seq OWNED BY public.visitas_tecnicas.id;


--
-- TOC entry 4797 (class 2604 OID 16410)
-- Name: autorizacion_datos codigo_autorizacion; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autorizacion_datos ALTER COLUMN codigo_autorizacion SET DEFAULT nextval('public.autorizacion_datos_codigo_autorizacion_seq'::regclass);


--
-- TOC entry 4801 (class 2604 OID 16444)
-- Name: cita codigo; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cita ALTER COLUMN codigo SET DEFAULT nextval('public.cita_codigo_seq'::regclass);


--
-- TOC entry 4795 (class 2604 OID 16393)
-- Name: clientes codigo; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes ALTER COLUMN codigo SET DEFAULT nextval('public.clientes_codigo_seq'::regclass);


--
-- TOC entry 4804 (class 2604 OID 24580)
-- Name: cobertura id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cobertura ALTER COLUMN id SET DEFAULT nextval('public.cobertura_id_seq'::regclass);


--
-- TOC entry 4799 (class 2604 OID 16430)
-- Name: cotizacion codigo; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cotizacion ALTER COLUMN codigo SET DEFAULT nextval('public.cotizacion_codigo_seq'::regclass);


--
-- TOC entry 4805 (class 2604 OID 24590)
-- Name: plagas_protocolos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plagas_protocolos ALTER COLUMN id SET DEFAULT nextval('public.plagas_protocolos_id_seq'::regclass);


--
-- TOC entry 4802 (class 2604 OID 16457)
-- Name: servicio codigo; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servicio ALTER COLUMN codigo SET DEFAULT nextval('public.servicio_codigo_seq'::regclass);


--
-- TOC entry 4806 (class 2604 OID 24604)
-- Name: tecnicos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tecnicos ALTER COLUMN id SET DEFAULT nextval('public.tecnicos_id_seq'::regclass);


--
-- TOC entry 4807 (class 2604 OID 24618)
-- Name: visitas_tecnicas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.visitas_tecnicas ALTER COLUMN id SET DEFAULT nextval('public.visitas_tecnicas_id_seq'::regclass);


--
-- TOC entry 4984 (class 0 OID 16407)
-- Dependencies: 222
-- Data for Name: autorizacion_datos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.autorizacion_datos (codigo_autorizacion, codigo_cliente, numero_contacto, estado, fecha_hora, canal, finalidad) FROM stdin;
\.


--
-- TOC entry 4988 (class 0 OID 16441)
-- Dependencies: 226
-- Data for Name: cita; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cita (codigo, cod_cli, fecha, hora, direccion) FROM stdin;
\.


--
-- TOC entry 4982 (class 0 OID 16390)
-- Dependencies: 220
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.clientes (codigo, nombre, numero_contacto, ubicacion, direccion, tipo_inmueble, tipo_cliente, fecha_actualizacion) FROM stdin;
1	Sain Garzon	261748342968517@lid	Pendiente	Pendiente	Pendiente	Nuevo Prospecto	2026-11-21 18:31:56.790198
2	Usuario Web	XK-GgzrPN8rqmS_	Pendiente	Pendiente	Pendiente	Nuevo Prospecto	2026-11-22 21:06:48.91201
5	Joseph Romero Porras	3106776624	Pendiente	Pendiente	Pendiente	Nuevo Prospecto (Web)	2026-11-23 21:48:09.833051
6	Ani  Arango 	3227106912	Pendiente	Pendiente	Pendiente	Nuevo Prospecto (Web)	2026-11-23 21:48:42.793393
7	camila palacio	3014866787	San Cristóbal	CR 7 ·36f -33	hogar	Nuevo Prospecto (Web)	2026-11-23 21:48:52.650128
8	asas asasa	2231321231231	USME	Calle 45-55 sur	restaurante	Nuevo Prospecto (Web)	2026-11-23 22:32:39.219622
3	Juan Casas	3176785958	Suba	Cra 6c este #90A 58 sur	Pendiente	Nuevo Prospecto (Web)	2026-11-22 21:38:44.558364
4	nicolasmoreno	3202408366	usme	calle 71 d sur	Hogar	Nuevo Prospecto (Web)	2026-11-23 20:55:55.423441
\.


--
-- TOC entry 4992 (class 0 OID 24577)
-- Dependencies: 230
-- Data for Name: cobertura; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cobertura (id, zona, tipo) FROM stdin;
1	Chapinero	Localidad Bogotá
2	Usaquén	Localidad Bogotá
3	Suba	Localidad Bogotá
4	Engativá	Localidad Bogotá
5	Fontibón	Localidad Bogotá
6	Kennedy	Localidad Bogotá
7	Teusaquillo	Localidad Bogotá
8	Barrios Unidos	Localidad Bogotá
9	Puente Aranda	Localidad Bogotá
10	Bosa	Localidad Bogotá
11	Ciudad Bolívar	Localidad Bogotá
12	San Cristóbal	Localidad Bogotá
13	Chía	Municipio Cundinamarca
14	Cajicá	Municipio Cundinamarca
15	Zipaquirá	Municipio Cundinamarca
16	Cota	Municipio Cundinamarca
17	Soacha	Municipio Cundinamarca
18	Mosquera	Municipio Cundinamarca
19	Funza	Municipio Cundinamarca
20	Madrid	Municipio Cundinamarca
21	La Calera	Municipio Cundinamarca
22	Tocancipá	Municipio Cundinamarca
23	Sopó	Municipio Cundinamarca
24	Tenjo	Municipio Cundinamarca
\.


--
-- TOC entry 4986 (class 0 OID 16427)
-- Dependencies: 224
-- Data for Name: cotizacion; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cotizacion (codigo, cod_cli, fecha, tipo_plaga, estado) FROM stdin;
\.


--
-- TOC entry 4994 (class 0 OID 24587)
-- Dependencies: 232
-- Data for Name: plagas_protocolos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.plagas_protocolos (id, plaga, servicio_asociado, protocolo_previo, protocolo_posterior) FROM stdin;
1	Cucarachas	Fumigación de Cucarachas	Guardar y sellar alimentos, despejar gabinetes de cocina y baños, retirar mascotas.	Ventilar el área de 2 a 4 horas antes de reingresar. No trapear con cloro durante 24 horas.
2	Roedores (Ratas y Ratones)	Control de Roedores	No tocar ni mover posibles madrigueras, resguardar alimentos y mantener mascotas alejadas de la zona.	No manipular las estaciones de cebado instaladas. Mantener el área limpia y reportar actividad en el monitoreo.
3	Insectos (Hormigas, Zancudos, Moscas, Pulgas, Chinches, Garrapatas)	Fumigación de Insectos	Guardar alimentos y utensilios, lavar ropa de cama si son chinches o pulgas, retirar personas y mascotas.	Ventilar de 2 a 4 horas. Limpiar superficies de contacto con alimentos antes de usarlas.
4	Prevención / Auditoría	Control Preventivo de Plagas	Facilitar acceso a zonas de almacenamiento, cocinas y puntos críticos del inmueble.	Seguir las recomendaciones del reporte técnico y agendar visitas mensuales o trimestrales.
\.


--
-- TOC entry 4990 (class 0 OID 16454)
-- Dependencies: 228
-- Data for Name: servicio; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.servicio (codigo, cod_cli, fecha, tipo, estado) FROM stdin;
\.


--
-- TOC entry 4996 (class 0 OID 24601)
-- Dependencies: 234
-- Data for Name: tecnicos; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tecnicos (id, nombre, especialidad, zona_asignada, disponibilidad) FROM stdin;
1	Ing. Carlos Mendoza	Control de Roedores y Mapeo de Madrigueras	Bogotá Norte (Usaquén, Suba, Chapinero) y Sabana Norte (Chía, Cajicá, Zipaquirá)	Lunes a Sábado: 8:00 a.m. - 12:00 m.
2	Téc. Laura Rodríguez	Fumigación de Cucarachas e Insectos (Eco-amigable)	Bogotá Occidente y Centro (Engativá, Fontibón, Kennedy, Teusaquillo, Barrios Unidos)	Lunes a Sábado: 1:00 p.m. - 6:00 p.m.
3	Téc. Andrés Silva	Control Preventivo, Restaurantes y Desinfección de Tanques	Bogotá Sur (Bosa, Ciudad Bolívar, Puente Aranda, San Cristóbal) y Soacha/Mosquera/Funza/Madrid	Lunes a Sábado: 8:00 a.m. - 6:00 p.m.
\.


--
-- TOC entry 4998 (class 0 OID 24615)
-- Dependencies: 236
-- Data for Name: visitas_tecnicas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.visitas_tecnicas (id, telefono_cliente, ubicacion, direccion, tipo_plaga, tecnico_asignado, fecha_hora_programada, estado, fecha_registro) FROM stdin;
1	3014866787	San Cristóbal	cr 7 · 36f - 33	Cucarachas	Téc. Andrés Silva	2026-11-24 12:00	Agendada	2026-11-23 22:28:58.962639
\.


--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 221
-- Name: autorizacion_datos_codigo_autorizacion_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.autorizacion_datos_codigo_autorizacion_seq', 1, false);


--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 225
-- Name: cita_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cita_codigo_seq', 1, false);


--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 219
-- Name: clientes_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.clientes_codigo_seq', 8, true);


--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 229
-- Name: cobertura_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cobertura_id_seq', 72, true);


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 223
-- Name: cotizacion_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cotizacion_codigo_seq', 1, false);


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 231
-- Name: plagas_protocolos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.plagas_protocolos_id_seq', 12, true);


--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 227
-- Name: servicio_codigo_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.servicio_codigo_seq', 1, false);


--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 233
-- Name: tecnicos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tecnicos_id_seq', 9, true);


--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 235
-- Name: visitas_tecnicas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.visitas_tecnicas_id_seq', 1, true);


--
-- TOC entry 4815 (class 2606 OID 16420)
-- Name: autorizacion_datos autorizacion_datos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autorizacion_datos
    ADD CONSTRAINT autorizacion_datos_pkey PRIMARY KEY (codigo_autorizacion);


--
-- TOC entry 4819 (class 2606 OID 16447)
-- Name: cita cita_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cita
    ADD CONSTRAINT cita_pkey PRIMARY KEY (codigo);


--
-- TOC entry 4811 (class 2606 OID 16405)
-- Name: clientes clientes_numero_contacto_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_numero_contacto_key UNIQUE (numero_contacto);


--
-- TOC entry 4813 (class 2606 OID 16403)
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (codigo);


--
-- TOC entry 4823 (class 2606 OID 24585)
-- Name: cobertura cobertura_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cobertura
    ADD CONSTRAINT cobertura_pkey PRIMARY KEY (id);


--
-- TOC entry 4817 (class 2606 OID 16434)
-- Name: cotizacion cotizacion_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cotizacion
    ADD CONSTRAINT cotizacion_pkey PRIMARY KEY (codigo);


--
-- TOC entry 4825 (class 2606 OID 24599)
-- Name: plagas_protocolos plagas_protocolos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plagas_protocolos
    ADD CONSTRAINT plagas_protocolos_pkey PRIMARY KEY (id);


--
-- TOC entry 4821 (class 2606 OID 16461)
-- Name: servicio servicio_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servicio
    ADD CONSTRAINT servicio_pkey PRIMARY KEY (codigo);


--
-- TOC entry 4827 (class 2606 OID 24613)
-- Name: tecnicos tecnicos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tecnicos
    ADD CONSTRAINT tecnicos_pkey PRIMARY KEY (id);


--
-- TOC entry 4829 (class 2606 OID 24631)
-- Name: visitas_tecnicas visitas_tecnicas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.visitas_tecnicas
    ADD CONSTRAINT visitas_tecnicas_pkey PRIMARY KEY (id);


--
-- TOC entry 4830 (class 2606 OID 16421)
-- Name: autorizacion_datos autorizacion_datos_codigo_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.autorizacion_datos
    ADD CONSTRAINT autorizacion_datos_codigo_cliente_fkey FOREIGN KEY (codigo_cliente) REFERENCES public.clientes(codigo);


--
-- TOC entry 4832 (class 2606 OID 16448)
-- Name: cita cita_cod_cli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cita
    ADD CONSTRAINT cita_cod_cli_fkey FOREIGN KEY (cod_cli) REFERENCES public.clientes(codigo);


--
-- TOC entry 4831 (class 2606 OID 16435)
-- Name: cotizacion cotizacion_cod_cli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cotizacion
    ADD CONSTRAINT cotizacion_cod_cli_fkey FOREIGN KEY (cod_cli) REFERENCES public.clientes(codigo);


--
-- TOC entry 4833 (class 2606 OID 16462)
-- Name: servicio servicio_cod_cli_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.servicio
    ADD CONSTRAINT servicio_cod_cli_fkey FOREIGN KEY (cod_cli) REFERENCES public.clientes(codigo);


-- Completed on 2026-11-24 21:42:37

--
-- PostgreSQL database dump complete
--

\unrestrict fpqgPiLhjSCENiOekestJY9kcxmJWFuUJWjM8prdxOWDhhcx8caUjKTm5yEyA0T

