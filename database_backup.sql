--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

-- Started on 2024-06-12 15:38:54

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

DROP DATABASE IF EXISTS "CPEN208PROJECT";
--
-- TOC entry 4912 (class 1262 OID 16398)
-- Name: CPEN208PROJECT; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "CPEN208PROJECT" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';


ALTER DATABASE "CPEN208PROJECT" OWNER TO postgres;

\connect "CPEN208PROJECT"

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
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 228 (class 1255 OID 16482)
-- Name: calculate_outstanding_fees(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calculate_outstanding_fees() RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    result JSON;
BEGIN
    SELECT JSON_AGG(
        JSON_BUILD_OBJECT(
            'student_id', s.student_id,
            'name', s.name,
            'total_fee', f.total_fee,
            'amount_paid', COALESCE(SUM(f.amount), 0),
            'outstanding_fee', f.total_fee - COALESCE(SUM(f.amount), 0)
        )
    ) INTO result
    FROM students s
    LEFT JOIN fees f ON s.student_id = f.student_id
    GROUP BY s.student_id, s.name, f.total_fee;

    RETURN result;
END;
$$;


ALTER FUNCTION public.calculate_outstanding_fees() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 224 (class 1259 OID 16605)
-- Name: course_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_assignments (
    assignment_id integer NOT NULL,
    course_code character varying(20) NOT NULL,
    lecturer_name character varying(100) NOT NULL
);


ALTER TABLE public.course_assignments OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16604)
-- Name: course_assignments_assignment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.course_assignments_assignment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.course_assignments_assignment_id_seq OWNER TO postgres;

--
-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 223
-- Name: course_assignments_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.course_assignments_assignment_id_seq OWNED BY public.course_assignments.assignment_id;


--
-- TOC entry 219 (class 1259 OID 16524)
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
    course_code character varying(20) NOT NULL,
    course_name character varying(100) NOT NULL
);


ALTER TABLE public.courses OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16530)
-- Name: enrollment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enrollment (
    enrollment_id integer NOT NULL,
    student_number character varying(20) NOT NULL,
    course_code character varying(20) NOT NULL,
    enrollment_date date
);


ALTER TABLE public.enrollment OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16529)
-- Name: enrollment_enrollment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.enrollment_enrollment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.enrollment_enrollment_id_seq OWNER TO postgres;

--
-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 220
-- Name: enrollment_enrollment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.enrollment_enrollment_id_seq OWNED BY public.enrollment.enrollment_id;


--
-- TOC entry 218 (class 1259 OID 16496)
-- Name: fees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fees (
    id integer NOT NULL,
    student_number character varying(20) NOT NULL,
    amount numeric(10,2) NOT NULL,
    date_paid date,
    total_fee numeric(10,2) NOT NULL,
    status character varying(20)
);


ALTER TABLE public.fees OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16495)
-- Name: fees_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fees_id_seq OWNER TO postgres;

--
-- TOC entry 4916 (class 0 OID 0)
-- Dependencies: 217
-- Name: fees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fees_id_seq OWNED BY public.fees.id;


--
-- TOC entry 222 (class 1259 OID 16599)
-- Name: lecturers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lecturers (
    lecturer_name character varying(100) NOT NULL
);


ALTER TABLE public.lecturers OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16628)
-- Name: lectures_to_ta_assignment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lectures_to_ta_assignment (
    assignment_id integer NOT NULL,
    course_code character varying(20) NOT NULL,
    ta_name character varying(100) NOT NULL
);


ALTER TABLE public.lectures_to_ta_assignment OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16627)
-- Name: lectures_to_ta_assignment_assignment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lectures_to_ta_assignment_assignment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lectures_to_ta_assignment_assignment_id_seq OWNER TO postgres;

--
-- TOC entry 4917 (class 0 OID 0)
-- Dependencies: 226
-- Name: lectures_to_ta_assignment_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lectures_to_ta_assignment_assignment_id_seq OWNED BY public.lectures_to_ta_assignment.assignment_id;


--
-- TOC entry 216 (class 1259 OID 16400)
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    student_id integer NOT NULL,
    name character varying(100),
    student_number character varying(10),
    email character varying(255)
);


ALTER TABLE public.students OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16399)
-- Name: students_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.students_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.students_student_id_seq OWNER TO postgres;

--
-- TOC entry 4918 (class 0 OID 0)
-- Dependencies: 215
-- Name: students_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_student_id_seq OWNED BY public.students.student_id;


--
-- TOC entry 225 (class 1259 OID 16622)
-- Name: teaching_assistants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teaching_assistants (
    ta_name character varying(100) NOT NULL
);


ALTER TABLE public.teaching_assistants OWNER TO postgres;

--
-- TOC entry 4724 (class 2604 OID 16608)
-- Name: course_assignments assignment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_assignments ALTER COLUMN assignment_id SET DEFAULT nextval('public.course_assignments_assignment_id_seq'::regclass);


--
-- TOC entry 4723 (class 2604 OID 16533)
-- Name: enrollment enrollment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment ALTER COLUMN enrollment_id SET DEFAULT nextval('public.enrollment_enrollment_id_seq'::regclass);


--
-- TOC entry 4722 (class 2604 OID 16499)
-- Name: fees id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fees ALTER COLUMN id SET DEFAULT nextval('public.fees_id_seq'::regclass);


--
-- TOC entry 4725 (class 2604 OID 16631)
-- Name: lectures_to_ta_assignment assignment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lectures_to_ta_assignment ALTER COLUMN assignment_id SET DEFAULT nextval('public.lectures_to_ta_assignment_assignment_id_seq'::regclass);


--
-- TOC entry 4721 (class 2604 OID 16403)
-- Name: students student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN student_id SET DEFAULT nextval('public.students_student_id_seq'::regclass);


--
-- TOC entry 4903 (class 0 OID 16605)
-- Dependencies: 224
-- Data for Name: course_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.course_assignments (assignment_id, course_code, lecturer_name) VALUES (1, 'CPEN 202', 'Agyare Debrah') ON CONFLICT DO NOTHING;
INSERT INTO public.course_assignments (assignment_id, course_code, lecturer_name) VALUES (2, 'CPEN 204', 'Dr. Margaret Ansah Richardson') ON CONFLICT DO NOTHING;
INSERT INTO public.course_assignments (assignment_id, course_code, lecturer_name) VALUES (3, 'CPEN 206', 'Dr. Godfrey Augustus Mills') ON CONFLICT DO NOTHING;
INSERT INTO public.course_assignments (assignment_id, course_code, lecturer_name) VALUES (4, 'CPEN 208', 'Mr. John Asiammah') ON CONFLICT DO NOTHING;
INSERT INTO public.course_assignments (assignment_id, course_code, lecturer_name) VALUES (5, 'CPEN 212', 'Dr. Isaac Adjaye Aboagye') ON CONFLICT DO NOTHING;
INSERT INTO public.course_assignments (assignment_id, course_code, lecturer_name) VALUES (6, 'SENG202', 'Dr. John Kutor') ON CONFLICT DO NOTHING;
INSERT INTO public.course_assignments (assignment_id, course_code, lecturer_name) VALUES (7, 'CBAS210', 'Dr. Percy Okae') ON CONFLICT DO NOTHING;


--
-- TOC entry 4898 (class 0 OID 16524)
-- Dependencies: 219
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.courses (course_code, course_name) VALUES ('CPEN 202', 'Computer system design') ON CONFLICT DO NOTHING;
INSERT INTO public.courses (course_code, course_name) VALUES ('CPEN 204', 'Data structures and Algorithms') ON CONFLICT DO NOTHING;
INSERT INTO public.courses (course_code, course_name) VALUES ('CPEN 206', 'Linear circuits') ON CONFLICT DO NOTHING;
INSERT INTO public.courses (course_code, course_name) VALUES ('CPEN 208', 'Software Engineering') ON CONFLICT DO NOTHING;
INSERT INTO public.courses (course_code, course_name) VALUES ('CPEN 212', 'Data Communications') ON CONFLICT DO NOTHING;
INSERT INTO public.courses (course_code, course_name) VALUES ('SENG202', 'Differential equations') ON CONFLICT DO NOTHING;
INSERT INTO public.courses (course_code, course_name) VALUES ('CBAS210', 'Academic Writing II') ON CONFLICT DO NOTHING;


--
-- TOC entry 4900 (class 0 OID 16530)
-- Dependencies: 221
-- Data for Name: enrollment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (1, '10975105', 'CPEN 202', '2024-01-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (2, '11004272', 'CPEN 202', '2024-01-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (3, '11010910', 'CPEN 202', '2024-01-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (4, '11053386', 'CPEN 202', '2024-01-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (5, '11105235', 'CPEN 202', '2024-01-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (6, '11208328', 'CPEN 202', '2024-01-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (7, '11209640', 'CPEN 202', '2024-01-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (8, '11275876', 'CPEN 202', '2024-01-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (9, '11285635', 'CPEN 202', '2024-01-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (10, '11348310', 'CPEN 202', '2024-01-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (11, '11353826', 'CPEN 202', '2024-01-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (12, '11012330', 'CPEN 204', '2024-02-15') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (13, '11012343', 'CPEN 204', '2024-02-15') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (14, '11112276', 'CPEN 204', '2024-02-15') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (15, '11116537', 'CPEN 204', '2024-02-15') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (16, '11213307', 'CPEN 204', '2024-02-15') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (17, '11218951', 'CPEN 204', '2024-02-15') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (18, '11292620', 'CPEN 204', '2024-02-15') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (19, '11293871', 'CPEN 204', '2024-02-15') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (20, '11356825', 'CPEN 204', '2024-02-15') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (21, '11014727', 'CPEN 206', '2024-03-20') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (22, '11014977', 'CPEN 206', '2024-03-20') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (23, '11116737', 'CPEN 206', '2024-03-20') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (24, '11116804', 'CPEN 206', '2024-03-20') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (25, '11238291', 'CPEN 206', '2024-03-20') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (26, '11246366', 'CPEN 206', '2024-03-20') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (27, '11296641', 'CPEN 206', '2024-03-20') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (28, '11296662', 'CPEN 206', '2024-03-20') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (29, '11015506', 'CPEN 208', '2024-04-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (30, '11018690', 'CPEN 208', '2024-04-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (31, '11117318', 'CPEN 208', '2024-04-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (32, '11117536', 'CPEN 208', '2024-04-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (33, '11252855', 'CPEN 208', '2024-04-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (34, '11252857', 'CPEN 208', '2024-04-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (35, '11297849', 'CPEN 208', '2024-04-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (36, '11305528', 'CPEN 208', '2024-04-10') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (37, '11021544', 'CPEN 212', '2024-05-15') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (38, '11023595', 'CPEN 212', '2024-05-15') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (39, '11123762', 'CPEN 212', '2024-05-15') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (40, '11139245', 'CPEN 212', '2024-05-15') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (41, '11253931', 'CPEN 212', '2024-05-15') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (42, '11254079', 'CPEN 212', '2024-05-15') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (43, '11330446', 'CPEN 212', '2024-05-15') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (44, '11332163', 'CPEN 212', '2024-05-15') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (45, '11025159', 'SENG202', '2024-01-20') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (46, '11038081', 'SENG202', '2024-01-20') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (47, '11139828', 'SENG202', '2024-01-20') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (48, '11164744', 'SENG202', '2024-01-20') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (49, '11254301', 'SENG202', '2024-01-20') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (50, '11254405', 'SENG202', '2024-01-20') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (51, '11333321', 'SENG202', '2024-01-20') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (52, '11334401', 'SENG202', '2024-01-20') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (53, '11049492', 'CBAS210', '2024-02-25') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (54, '11049523', 'CBAS210', '2024-02-25') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (55, '11170350', 'CBAS210', '2024-02-25') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (56, '11172376', 'CBAS210', '2024-02-25') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (57, '11262592', 'CBAS210', '2024-02-25') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (58, '11264010', 'CBAS210', '2024-02-25') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (59, '11338323', 'CBAS210', '2024-02-25') ON CONFLICT DO NOTHING;
INSERT INTO public.enrollment (enrollment_id, student_number, course_code, enrollment_date) VALUES (60, '11347946', 'CBAS210', '2024-02-25') ON CONFLICT DO NOTHING;


--
-- TOC entry 4897 (class 0 OID 16496)
-- Dependencies: 218
-- Data for Name: fees; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (1, '10975105', 500.00, '2024-01-10', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (2, '11004272', 300.00, '2024-02-15', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (3, '11010910', 200.00, '2024-03-20', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (4, '11012330', 400.00, '2024-04-10', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (5, '11012343', 600.00, '2024-05-15', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (6, '11014727', 450.00, '2024-01-20', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (7, '11014977', 350.00, '2024-02-25', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (8, '11015506', 500.00, '2024-03-30', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (9, '11018690', 250.00, '2024-04-05', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (10, '11021544', 300.00, '2024-05-10', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (11, '11023595', 700.00, '2024-01-15', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (12, '11025159', 200.00, '2024-02-20', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (13, '11038081', 400.00, '2024-03-25', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (14, '11049492', 600.00, '2024-04-30', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (15, '11049523', 500.00, '2024-05-05', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (16, '11053386', 300.00, '2024-01-18', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (17, '11105235', 200.00, '2024-02-22', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (18, '11112276', 400.00, '2024-03-28', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (19, '11116537', 600.00, '2024-04-02', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (20, '11116737', 500.00, '2024-05-07', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (21, '11116804', 300.00, '2024-01-20', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (22, '11117318', 200.00, '2024-02-25', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (23, '11117536', 400.00, '2024-03-30', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (24, '11123762', 600.00, '2024-04-05', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (25, '11139245', 500.00, '2024-05-10', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (26, '11139828', 300.00, '2024-01-22', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (27, '11164744', 200.00, '2024-02-27', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (28, '11170350', 400.00, '2024-03-05', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (29, '11172376', 600.00, '2024-04-10', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (30, '11208328', 500.00, '2024-05-15', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (31, '11209640', 300.00, '2024-01-25', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (32, '11213307', 200.00, '2024-02-28', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (33, '11218951', 400.00, '2024-03-10', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (34, '11238291', 600.00, '2024-04-15', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (35, '11246366', 500.00, '2024-05-20', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (36, '11252855', 300.00, '2024-01-28', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (37, '11252857', 200.00, '2024-02-29', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (38, '11253931', 400.00, '2024-03-15', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (39, '11254079', 600.00, '2024-04-20', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (40, '11254301', 500.00, '2024-05-25', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (41, '11254405', 300.00, '2024-01-30', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (42, '11262592', 200.00, '2024-03-02', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (43, '11264010', 400.00, '2024-03-17', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (44, '11275876', 600.00, '2024-04-22', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (45, '11285635', 500.00, '2024-05-27', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (46, '11292620', 300.00, '2024-02-02', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (47, '11293871', 200.00, '2024-03-04', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (48, '11296641', 400.00, '2024-03-19', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (49, '11296662', 600.00, '2024-04-24', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (50, '11297849', 500.00, '2024-05-29', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (51, '11305528', 300.00, '2024-02-04', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (52, '11330446', 200.00, '2024-03-06', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (53, '11332163', 400.00, '2024-03-21', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (54, '11333321', 600.00, '2024-04-26', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (55, '11334401', 500.00, '2024-05-31', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (56, '11338323', 300.00, '2024-02-06', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (57, '11347946', 200.00, '2024-03-08', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (58, '11348310', 400.00, '2024-03-23', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (59, '11353826', 600.00, '2024-04-28', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (60, '11356825', 750.00, '2024-03-20', 1000.00, 'paid') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (61, '11025159', 200.00, '2024-02-20', 1000.00, 'pending') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (62, '11170350', 400.00, '2024-03-05', 1000.00, 'pending') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (63, '11252855', 300.00, '2024-01-28', 1000.00, 'pending') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (64, '11254301', 500.00, '2024-05-25', 1000.00, 'pending') ON CONFLICT DO NOTHING;
INSERT INTO public.fees (id, student_number, amount, date_paid, total_fee, status) VALUES (65, '11305528', 300.00, '2024-02-04', 1000.00, 'pending') ON CONFLICT DO NOTHING;


--
-- TOC entry 4901 (class 0 OID 16599)
-- Dependencies: 222
-- Data for Name: lecturers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.lecturers (lecturer_name) VALUES ('Agyare Debrah') ON CONFLICT DO NOTHING;
INSERT INTO public.lecturers (lecturer_name) VALUES ('Dr. Margaret Ansah Richardson') ON CONFLICT DO NOTHING;
INSERT INTO public.lecturers (lecturer_name) VALUES ('Dr. Godfrey Augustus Mills') ON CONFLICT DO NOTHING;
INSERT INTO public.lecturers (lecturer_name) VALUES ('Mr. John Asiammah') ON CONFLICT DO NOTHING;
INSERT INTO public.lecturers (lecturer_name) VALUES ('Dr. Isaac Adjaye Aboagye') ON CONFLICT DO NOTHING;
INSERT INTO public.lecturers (lecturer_name) VALUES ('Dr. John Kutor') ON CONFLICT DO NOTHING;
INSERT INTO public.lecturers (lecturer_name) VALUES ('Dr. Percy Okae') ON CONFLICT DO NOTHING;


--
-- TOC entry 4906 (class 0 OID 16628)
-- Dependencies: 227
-- Data for Name: lectures_to_ta_assignment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.lectures_to_ta_assignment (assignment_id, course_code, ta_name) VALUES (1, 'CPEN 202', 'Bamzy') ON CONFLICT DO NOTHING;
INSERT INTO public.lectures_to_ta_assignment (assignment_id, course_code, ta_name) VALUES (2, 'CPEN 204', 'Foster') ON CONFLICT DO NOTHING;
INSERT INTO public.lectures_to_ta_assignment (assignment_id, course_code, ta_name) VALUES (3, 'CPEN 206', 'Hakeem') ON CONFLICT DO NOTHING;
INSERT INTO public.lectures_to_ta_assignment (assignment_id, course_code, ta_name) VALUES (4, 'CPEN 208', 'Foster') ON CONFLICT DO NOTHING;
INSERT INTO public.lectures_to_ta_assignment (assignment_id, course_code, ta_name) VALUES (5, 'CPEN 212', 'Samed') ON CONFLICT DO NOTHING;
INSERT INTO public.lectures_to_ta_assignment (assignment_id, course_code, ta_name) VALUES (6, 'SENG202', 'Ben') ON CONFLICT DO NOTHING;
INSERT INTO public.lectures_to_ta_assignment (assignment_id, course_code, ta_name) VALUES (7, 'CBAS210', 'Kevin') ON CONFLICT DO NOTHING;


--
-- TOC entry 4895 (class 0 OID 16400)
-- Dependencies: 216
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.students (student_id, name, student_number, email) VALUES (1, 'Daniel Akwetey Akunyumu-Tetteh', '10975105', 'edward.opokuagyemang@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (2, 'Ishaan Bhardwaj', '11004272', 'ishaan.bhardwaj@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (3, 'Samia Soleimani', '11010910', 'samia.soleiman@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (4, 'Arthur Ebenezer', '11012330', 'ebenezer.haydenarthur@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (5, 'Kumi Kelvin Gyabaah', '11012343', 'kumi.kelvingyabaah@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (7, 'Mohammed Salihu Hamisu', '11014977', 'mohammed.salihuhamisu@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (8, 'Daniel Agyin Manford', '11015506', 'daniel.agyinmanford@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (9, 'Pius Oblie', '11018690', 'pius.oblie@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (10, 'Iddrisu Tahiru', '11021544', 'iddrisu.tahiru@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (11, 'Nyavor Cyril Etornam', '11023595', 'nyavor.cyrilmorkporkpor@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (12, 'David Kwaku Ntow Anno', '11025159', 'david.ntowanno@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (13, 'Agyepong Kwesi', '11038081', 'agyepong.kwesi_asante@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (14, 'Asare Marvin', '11049492', 'asare.marvin@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (15, 'Peggy Esinam Somuah', '11049523', 'peggy.esinamsomuah@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (16, 'Ampomah Samuel', '11053386', 'ampomah.samuel@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (17, 'Andrews Kwarteng Twum', '11105235', 'kwarteng.andrewstwum@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (18, 'Fiavor Isaac Sedem', '11112276', 'fiavor.isaacsedem@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (19, 'Yakubu Tanko Mohammed-Awal', '11116537', 'mohammed.awaltanko@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (20, 'Eririe Jeffery', '11116737', 'jeffrey.eririe@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (21, 'Kafu Kwame Kemeh', '11116804', 'kafu.kemeh@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (22, 'Nyarko Steven Abrokwah', '11117318', 'steven.nyarkoabronkwah@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (23, 'Muhammad Nurul Haqq Munagah', '11117536', 'muhammed.nhaqq@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (24, 'Bernardine Adusei-Okrah', '11123762', 'bernadine.aduseiokrah@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (25, 'Maame Afua Ayisibea Ayisi', '11139245', 'maame.afuaayisibeaayisi@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (26, 'Ansiogya Philemon Kwabena', '11139828', 'ansrogya.philemon@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (27, 'Antwi Samuel Kojo Anafi', '11164744', 'antwi.samuelkojoanafi@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (28, 'Nkansah Boadu Tabi', '11170350', 'nkansah.boadutabi@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (29, 'Wenide Isaac Atta', '11172376', 'wenide.isaacatta@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (30, 'John Tenkorang Anim', '11208328', 'john.animtenkorang@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (31, 'Abubakar Latifah', '11209640', 'abubakar.latifah@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (32, 'Attu Samuel Idana', '11213307', 'attu.samuelidana@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (33, 'Adorboe Prince Philips', '11218951', 'adorboe.princephilips@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (34, 'Ninson Obed', '11238291', 'ninson.obed@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (35, 'Anewah Vincent', '11246366', 'vincent.anewah@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (36, 'Quansah Jeffery', '11252855', 'quansah.jeffrey@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (37, 'Nuku-Tagbor Joshua', '11252857', 'nuku-tagbor.joshua@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (38, 'Desmond Afelete Kamasah', '11253931', 'desmond.afletekamasah@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (39, 'Fordjour Edward John', '11254079', 'john.edwardfodjour@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (40, 'Kudiabor Jonathan Kwabena Ewenam', '11254301', 'kudiabor.jonathanewenam@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (41, 'Abena Nhyira Nsaako', '11254405', 'abena.nhyiransaako@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (42, 'Dedoo Donatus Dodzi', '11262592', 'dedoo.donatusdodzi@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (43, 'Ayertey Vanessa Esinam', '11264010', 'ayertey.vanessaesinam@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (6, 'Annan Chioma Praise', '11014727', 'annan.chiomapraise@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (44, 'Nyayun Prince', '11275876', 'nyayun.prince@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (45, 'David Tetteh Ankrah', '11285635', 'david.tettehankrah@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (46, 'Sena Anyomi', '11292620', 'sena.delaseanyomi@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (47, 'Amponsah Jonathan Boadu', '11293871', 'amponsah.jonathanboadu@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (48, 'Asare Baffour King David', '11296641', 'asare.baffourkingdavid@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (49, 'Amevenku K. Mawuli', '11296662', 'mawuli.kwekuamevenku@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (50, 'Isaac Nii Nortey Barnor', '11297849', 'isaac.niinorteybarnor@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (51, 'Nana K. Fosu Asamoah', '11305528', 'nana.kwesiewadie@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (52, 'Yasmeen Xoladem Korkor Doku', '11330446', 'yasmeen.xolademdoku@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (53, 'Matthew Kotey Mensah', '11332163', 'matthew.koteymensah@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (54, 'Fall F. Galas', '11333321', 'fall.f.galas@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (55, 'Awal Mohammed', '11334401', 'awal.mohammed@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (56, 'Ahmed Fareed Opare', '11338323', 'ahmed.fareedopare@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (57, 'Derrick Amponsah Amponsah', '11347946', 'derrick.ampomahamponsah@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (58, 'Freda Elikplim Apetsi', '11348310', 'apetsi.fredaelikplim@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (59, 'Dabanka Hayet Maame Adwoa Gyasiwaa', '11353826', 'hayet.maamedabanka@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (60, 'Edward Opoku Agyemang', '11356825', 'edward.opokuagyemang@ug.st.edu.gh') ON CONFLICT DO NOTHING;
INSERT INTO public.students (student_id, name, student_number, email) VALUES (61, 'Nana Kwasi Kwakye', '11358243', 'nana.kwesiewadie@ug.st.edu.gh') ON CONFLICT DO NOTHING;


--
-- TOC entry 4904 (class 0 OID 16622)
-- Dependencies: 225
-- Data for Name: teaching_assistants; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.teaching_assistants (ta_name) VALUES ('Bamzy') ON CONFLICT DO NOTHING;
INSERT INTO public.teaching_assistants (ta_name) VALUES ('Foster') ON CONFLICT DO NOTHING;
INSERT INTO public.teaching_assistants (ta_name) VALUES ('Hakeem') ON CONFLICT DO NOTHING;
INSERT INTO public.teaching_assistants (ta_name) VALUES ('Samed') ON CONFLICT DO NOTHING;
INSERT INTO public.teaching_assistants (ta_name) VALUES ('Ben') ON CONFLICT DO NOTHING;
INSERT INTO public.teaching_assistants (ta_name) VALUES ('Kevin') ON CONFLICT DO NOTHING;


--
-- TOC entry 4919 (class 0 OID 0)
-- Dependencies: 223
-- Name: course_assignments_assignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_assignments_assignment_id_seq', 7, true);


--
-- TOC entry 4920 (class 0 OID 0)
-- Dependencies: 220
-- Name: enrollment_enrollment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.enrollment_enrollment_id_seq', 60, true);


--
-- TOC entry 4921 (class 0 OID 0)
-- Dependencies: 217
-- Name: fees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fees_id_seq', 65, true);


--
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 226
-- Name: lectures_to_ta_assignment_assignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lectures_to_ta_assignment_assignment_id_seq', 7, true);


--
-- TOC entry 4923 (class 0 OID 0)
-- Dependencies: 215
-- Name: students_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.students_student_id_seq', 63, true);


--
-- TOC entry 4739 (class 2606 OID 16610)
-- Name: course_assignments course_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_assignments
    ADD CONSTRAINT course_assignments_pkey PRIMARY KEY (assignment_id);


--
-- TOC entry 4733 (class 2606 OID 16528)
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_code);


--
-- TOC entry 4735 (class 2606 OID 16535)
-- Name: enrollment enrollment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment
    ADD CONSTRAINT enrollment_pkey PRIMARY KEY (enrollment_id);


--
-- TOC entry 4731 (class 2606 OID 16501)
-- Name: fees fees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fees
    ADD CONSTRAINT fees_pkey PRIMARY KEY (id);


--
-- TOC entry 4737 (class 2606 OID 16603)
-- Name: lecturers lecturers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lecturers
    ADD CONSTRAINT lecturers_pkey PRIMARY KEY (lecturer_name);


--
-- TOC entry 4743 (class 2606 OID 16633)
-- Name: lectures_to_ta_assignment lectures_to_ta_assignment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lectures_to_ta_assignment
    ADD CONSTRAINT lectures_to_ta_assignment_pkey PRIMARY KEY (assignment_id);


--
-- TOC entry 4727 (class 2606 OID 16405)
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- TOC entry 4729 (class 2606 OID 16407)
-- Name: students students_student_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_student_number_key UNIQUE (student_number);


--
-- TOC entry 4741 (class 2606 OID 16626)
-- Name: teaching_assistants teaching_assistants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teaching_assistants
    ADD CONSTRAINT teaching_assistants_pkey PRIMARY KEY (ta_name);


--
-- TOC entry 4747 (class 2606 OID 16611)
-- Name: course_assignments course_assignments_course_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_assignments
    ADD CONSTRAINT course_assignments_course_code_fkey FOREIGN KEY (course_code) REFERENCES public.courses(course_code);


--
-- TOC entry 4748 (class 2606 OID 16616)
-- Name: course_assignments course_assignments_lecturer_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_assignments
    ADD CONSTRAINT course_assignments_lecturer_name_fkey FOREIGN KEY (lecturer_name) REFERENCES public.lecturers(lecturer_name);


--
-- TOC entry 4745 (class 2606 OID 16541)
-- Name: enrollment enrollment_course_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment
    ADD CONSTRAINT enrollment_course_code_fkey FOREIGN KEY (course_code) REFERENCES public.courses(course_code);


--
-- TOC entry 4746 (class 2606 OID 16536)
-- Name: enrollment enrollment_student_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment
    ADD CONSTRAINT enrollment_student_number_fkey FOREIGN KEY (student_number) REFERENCES public.students(student_number);


--
-- TOC entry 4744 (class 2606 OID 16502)
-- Name: fees fees_student_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fees
    ADD CONSTRAINT fees_student_number_fkey FOREIGN KEY (student_number) REFERENCES public.students(student_number);


--
-- TOC entry 4749 (class 2606 OID 16634)
-- Name: lectures_to_ta_assignment lectures_to_ta_assignment_course_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lectures_to_ta_assignment
    ADD CONSTRAINT lectures_to_ta_assignment_course_code_fkey FOREIGN KEY (course_code) REFERENCES public.courses(course_code);


--
-- TOC entry 4750 (class 2606 OID 16639)
-- Name: lectures_to_ta_assignment lectures_to_ta_assignment_ta_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lectures_to_ta_assignment
    ADD CONSTRAINT lectures_to_ta_assignment_ta_name_fkey FOREIGN KEY (ta_name) REFERENCES public.teaching_assistants(ta_name);


-- Completed on 2024-06-12 15:38:54

--
-- PostgreSQL database dump complete
--

