--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Debian 15.1-1.pgdg110+1)
-- Dumped by pg_dump version 15.1 (Debian 15.1-1.pgdg110+1)

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
-- Name: pg_net; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_net; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_net IS 'Async HTTP';

--
-- Name: pgsodium; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgsodium WITH SCHEMA pgsodium;


--
-- Name: EXTENSION pgsodium; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgsodium IS 'Pgsodium is a modern cryptography library for Postgres.';


--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;


--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
  insert into public.profiles (id, full_name, avatar_url)
  values (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url');
  return new;
end;
$$;


ALTER FUNCTION public.handle_new_user() OWNER TO postgres;

--
-- Name: chat_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_user (
    created_at timestamp with time zone DEFAULT now(),
    chat_id uuid NOT NULL,
    user_id uuid NOT NULL
);


ALTER TABLE public.chat_user OWNER TO postgres;

--
-- Name: chats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chats (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    last_message_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.chats OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    chat_id uuid,
    user_id uuid,
    content text,
    type text
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    username text,
    full_name text,
    avatar text DEFAULT 'default-avatar'::text,
    role text DEFAULT 'user'::text,
    CONSTRAINT username_length CHECK ((char_length(username) >= 3))
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

--ALTER TABLE storage.buckets ADD COLUMN public boolean DEFAULT false;
ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

-- --
-- --
-- -- Data for Name: chat_user; Type: TABLE DATA; Schema: public; Owner: postgres
-- --

-- COPY public.chat_user (created_at, chat_id, user_id) FROM stdin;
-- 2023-04-29 17:52:38.620687+00	b4a15dd2-eadf-40f0-8b6b-5158c0809971	270dd574-0ea3-455d-b0e6-2cffee03ee8c
-- 2023-04-29 17:52:38.620687+00	b4a15dd2-eadf-40f0-8b6b-5158c0809971	ccf2122e-261e-4acf-9d22-f1c1751d3bdb
-- 2023-04-25 09:49:32.648107+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	07ea4156-8f7a-43bd-a472-f5c42ad3e648
-- 2023-04-25 09:49:32.648107+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb
-- \.


-- --
-- -- Data for Name: chats; Type: TABLE DATA; Schema: public; Owner: postgres
-- --

-- COPY public.chats (id, created_at) FROM stdin;
-- 9f8acbcb-6a86-48d4-86bd-124fc07b5f28	2023-04-25 09:49:32.615941+00
-- b4a15dd2-eadf-40f0-8b6b-5158c0809971	2023-04-29 17:52:38.594327+00
-- \.


-- --
-- -- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
-- --

-- COPY public.messages (id, created_at, chat_id, user_id, content, type) FROM stdin;
-- a9b8e658-7d30-4cd4-b73d-725121d61522	2023-04-25 09:49:38.957604+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	a	text
-- 0911819f-09a2-45eb-9c1e-b5b24c4563ee	2023-04-25 09:50:27.345816+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	07ea4156-8f7a-43bd-a472-f5c42ad3e648	a	text
-- f11c1ed8-46c1-4eb6-8f06-f50bc9858817	2023-04-25 10:45:21.75994+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	07ea4156-8f7a-43bd-a472-f5c42ad3e648	f	text
-- feb29789-9cb2-4038-8978-c1a20bc7c243	2023-04-25 10:45:24.920758+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	a	text
-- 438d5f3a-df98-456f-a074-e97309d61539	2023-04-25 16:12:29.2153+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	s	text
-- c816ff0f-6726-4fcb-90b1-ed68c9eb7430	2023-04-26 17:02:15.312338+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	a	text
-- 46897935-50aa-4ef3-9d8e-1df4316c50eb	2023-04-26 17:03:07.781215+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	v	text
-- 0f304f6f-45aa-47b7-8fa6-314dcabcae25	2023-04-26 17:05:58.161693+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	b	text
-- a8bd51d6-d391-4d90-8cdb-48a06e77119b	2023-04-26 17:06:06.548653+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	n	text
-- c8171684-6388-4265-b348-638b6f04267e	2023-04-29 11:42:34.687365+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	ad	text
-- 25daa498-b7c0-4372-a3c9-b4271ce29e54	2023-05-02 09:31:00.177288+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	🤩😘😗	text
-- 1ddcdea1-2e79-42a4-889f-ede31dfb10aa	2023-05-02 10:08:49.497502+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	😀	text
-- 981936a9-a851-458e-bac4-75f8ac81b575	2023-05-02 11:18:58.801373+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	ss😭	text
-- ad247eba-8578-40a0-8c9e-015c5e10cf98	2023-05-02 14:18:11.191965+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	9f8acbcb-6a86-48d4-86bd-124fc07b5f28/chat-1683037091038	image
-- 2f2997fe-4505-4b78-bfb3-600b9fa6f79e	2023-05-02 14:30:53.291703+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	9f8acbcb-6a86-48d4-86bd-124fc07b5f28/chat-1683037853154	image
-- 585b7281-a832-4f14-9c40-d19c886aeac4	2023-05-02 14:31:09.605283+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	a	text
-- 66264331-9a05-402c-a2d4-38797b292d67	2023-05-02 14:33:31.098734+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	a	text
-- dc67a774-999c-443a-a720-25b16c4aff59	2023-05-02 14:33:48.892556+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	c	text
-- 02288d2b-1301-4dc5-b2a0-7939fbacf073	2023-05-02 14:33:55.545096+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	9f8acbcb-6a86-48d4-86bd-124fc07b5f28/chat-1683038035283	image
-- 618dfcfc-3f68-40c7-a73a-5041b0dc1893	2023-05-02 14:49:47.127848+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	9f8acbcb-6a86-48d4-86bd-124fc07b5f28/chat-1683038987005	image
-- a2606b35-0bfd-4a66-aebf-d893a7aa0416	2023-05-02 14:56:00.793402+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	a	text
-- 8ddd3e8a-ce1e-4e44-ba64-d7398563be6b	2023-05-02 14:56:13.377791+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	9f8acbcb-6a86-48d4-86bd-124fc07b5f28/chat-1683039373256	image
-- e6ae616b-a26a-41c3-b8aa-56df56655419	2023-05-02 14:56:29.596261+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	9f8acbcb-6a86-48d4-86bd-124fc07b5f28/chat-1683039389448	image
-- 195283cb-de5b-4c57-870a-cc33e4e4145e	2023-05-02 15:00:23.679424+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	9f8acbcb-6a86-48d4-86bd-124fc07b5f28/chat-1683039623543	image
-- 1cc511c0-59e3-48f2-b64d-30d47b2f4413	2023-05-02 15:01:51.649147+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	😄	text
-- 4ea5d52b-3ba8-453f-b1f0-6e857a6d8774	2023-05-02 15:02:08.60658+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	9f8acbcb-6a86-48d4-86bd-124fc07b5f28/chat-1683039728474	image
-- 89e807e1-f2c8-4f9d-b944-d816eac78290	2023-05-02 15:02:42.761712+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	9f8acbcb-6a86-48d4-86bd-124fc07b5f28/chat-1683039762649	image
-- e9cb9142-084f-4599-a685-e55fa8c4326d	2023-05-02 15:04:18.317082+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	07ea4156-8f7a-43bd-a472-f5c42ad3e648	9f8acbcb-6a86-48d4-86bd-124fc07b5f28/chat-1683039858256	image
-- a9905abd-b559-4ee2-ad41-ffea234b275c	2023-05-02 15:05:57.442555+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	😠	text
-- b47af508-65fd-4d02-8cb5-c50b3bb3e593	2023-05-02 15:09:14.827698+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	a	text
-- 87e18552-9db3-4961-bde2-5404d62d8924	2023-05-02 15:18:42.755033+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	9f8acbcb-6a86-48d4-86bd-124fc07b5f28/chat-1683040722647	image
-- 41a07639-9a2d-45aa-a0a8-677f06a0a02f	2023-05-02 15:21:32.510987+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	😠	text
-- 65af9d1e-b5b1-46f4-84db-364ea34487dd	2023-05-02 15:21:35.919116+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	9f8acbcb-6a86-48d4-86bd-124fc07b5f28/chat-1683040895812	image
-- a46487df-0dab-49a3-8e27-287ea94ced0a	2023-05-02 15:21:57.536671+00	9f8acbcb-6a86-48d4-86bd-124fc07b5f28	ccf2122e-261e-4acf-9d22-f1c1751d3bdb	9f8acbcb-6a86-48d4-86bd-124fc07b5f28/chat-1683040917417	image
-- \.


-- --
-- -- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
-- --

-- COPY public.profiles (id, created_at, username, full_name, avatar, role) FROM stdin;
-- 270dd574-0ea3-455d-b0e6-2cffee03ee8c	2023-04-07 10:17:18.45857+00	test2	tester2	default-avatar	user
-- ccf2122e-261e-4acf-9d22-f1c1751d3bdb	2023-04-07 10:15:12.119687+00	test1	tester1	ccf2122e-261e-4acf-9d22-f1c1751d3bdb/1683049229125	admin
-- 07ea4156-8f7a-43bd-a472-f5c42ad3e648	2023-04-07 18:50:56.972902+00	test3	tester3	07ea4156-8f7a-43bd-a472-f5c42ad3e648/1683049542084	user
-- \.



--
-- Name: chat_user chat_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_user
    ADD CONSTRAINT chat_user_pkey PRIMARY KEY (chat_id, user_id);


--
-- Name: chats chats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_username_key UNIQUE (username);


--
-- Name: chat_user chat_user_chat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_user
    ADD CONSTRAINT chat_user_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES public.chats(id) ON DELETE CASCADE;


--
-- Name: chat_user chat_user_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_user
    ADD CONSTRAINT chat_user_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: messages messages_chat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES public.chats(id) ON DELETE CASCADE;


--
-- Name: messages messages_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- Set up Storage
insert into storage.buckets (id, name)
values ('avatars', 'avatars'),
       ('chats', 'chats');

CREATE POLICY "ALL for authenticated" ON public.chat_user TO authenticated USING (true) WITH CHECK (true);


--
-- Name: chats ALL for authenticated; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "ALL for authenticated" ON public.chats TO authenticated USING (true) WITH CHECK (true);


--
-- Name: messages ALL for authenticated; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "ALL for authenticated" ON public.messages TO authenticated USING (true) WITH CHECK (true);


--
-- Name: profiles Public profiles are viewable by everyone.; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Public profiles are viewable by everyone." ON public.profiles FOR SELECT USING (true);


--
-- Name: profiles Users can insert their own profile.; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own profile." ON public.profiles FOR INSERT WITH CHECK ((auth.uid() = id));


--
-- Name: profiles Users can update own profile.; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update own profile." ON public.profiles FOR UPDATE USING ((auth.uid() = id));


--
-- Name: chat_user; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.chat_user ENABLE ROW LEVEL SECURITY;

--
-- Name: chats; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.chats ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: objects all 1oj01fe_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "all 1oj01fe_0" ON storage.objects FOR SELECT TO authenticated USING ((bucket_id = 'avatars'::text));


--
-- Name: objects all 1oj01fe_1; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "all 1oj01fe_1" ON storage.objects FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'avatars'::text));


--
-- Name: objects all 1oj01fe_2; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "all 1oj01fe_2" ON storage.objects FOR UPDATE TO authenticated USING ((bucket_id = 'avatars'::text));


--
-- Name: objects all 1oj01fe_3; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "all 1oj01fe_3" ON storage.objects FOR DELETE TO authenticated USING ((bucket_id = 'avatars'::text));


--
-- Name: objects allow all 1kc463_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "allow all 1kc463_0" ON storage.objects FOR SELECT TO authenticated USING ((bucket_id = 'chats'::text));


--
-- Name: objects allow all 1kc463_1; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "allow all 1kc463_1" ON storage.objects FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'chats'::text));


--
-- Name: objects allow all 1kc463_2; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "allow all 1kc463_2" ON storage.objects FOR UPDATE TO authenticated USING ((bucket_id = 'chats'::text));


--
-- Name: objects allow all 1kc463_3; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "allow all 1kc463_3" ON storage.objects FOR DELETE TO authenticated USING ((bucket_id = 'chats'::text));

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT ALL ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA graphql_public; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA graphql_public TO postgres;
GRANT USAGE ON SCHEMA graphql_public TO anon;
GRANT USAGE ON SCHEMA graphql_public TO authenticated;
GRANT USAGE ON SCHEMA graphql_public TO service_role;


--
-- Name: SCHEMA net; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA net TO supabase_functions_admin;
GRANT USAGE ON SCHEMA net TO anon;
GRANT USAGE ON SCHEMA net TO authenticated;
GRANT USAGE ON SCHEMA net TO service_role;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT ALL ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA supabase_functions; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA supabase_functions TO postgres;
GRANT USAGE ON SCHEMA supabase_functions TO anon;
GRANT USAGE ON SCHEMA supabase_functions TO authenticated;
GRANT USAGE ON SCHEMA supabase_functions TO service_role;
GRANT ALL ON SCHEMA supabase_functions TO supabase_functions_admin;


--
-- Name: TABLE chat_user; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.chat_user TO anon;
GRANT ALL ON TABLE public.chat_user TO authenticated;
GRANT ALL ON TABLE public.chat_user TO service_role;


--
-- Name: TABLE chats; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.chats TO anon;
GRANT ALL ON TABLE public.chats TO authenticated;
GRANT ALL ON TABLE public.chats TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.messages TO anon;
GRANT ALL ON TABLE public.messages TO authenticated;
GRANT ALL ON TABLE public.messages TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: supabase_realtime chat_user; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.chat_user;


--
-- Name: supabase_realtime chats; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.chats;


--
-- Name: supabase_realtime messages; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.messages;
