SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- \restrict lanVJMTRg8vS27T4UGpQFGctOvpEwOGGe3FvyVCpCdOVz2XgVHA12gEE3cxvTSa

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

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

--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."flow_state" ("id", "user_id", "auth_code", "code_challenge_method", "code_challenge", "provider_type", "provider_access_token", "provider_refresh_token", "created_at", "updated_at", "authentication_method", "auth_code_issued_at", "invite_token", "referrer", "oauth_client_state_id", "linking_target_id", "email_optional") VALUES
	('fc3551e3-66a9-4f10-9af6-887a01458431', '0ed80282-8d12-404e-9ab8-1ef1454747e0', '766a5061-abd5-4cf0-b470-562e6e6a6847', 's256', 'CbMeOz6bxs2coLIMGu2F6vH-OjznyJOWGlW6Cb6iJzg', 'email', '', '', '2026-03-08 12:17:30.551999+00', '2026-03-08 12:18:40.609822+00', 'email/signup', '2026-03-08 12:18:40.609766+00', NULL, NULL, NULL, NULL, false),
	('1be4aa87-5044-4d4d-89a1-a90f445ac1ab', '827bce72-d351-495d-9cdd-c8e1587cf418', '5568e828-abc5-4d6c-ada6-d66a8f8008f7', 's256', 'GwdKZRTT8seKXfr5LZeUwW4BaznXSktmdYcOvuzcVYk', 'email', '', '', '2026-03-14 11:44:52.951291+00', '2026-03-14 11:45:40.842267+00', 'email/signup', '2026-03-14 11:45:40.842219+00', NULL, NULL, NULL, NULL, false),
	('a4e214db-d075-40d5-ba13-31fecc1f05a8', '294e7351-d1ee-44a0-b9c3-0213c9ac70d8', 'd549216a-0167-4cc3-b31b-da76401bf245', 's256', 'ZqCHDs8lk-ZniC3ML-UN_cN7CX8e2P7m7laaxY6SyK4', 'email', '', '', '2026-04-18 16:05:42.719275+00', '2026-04-18 16:05:48.692985+00', 'email/signup', '2026-04-18 16:05:48.692194+00', NULL, NULL, NULL, NULL, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") VALUES
	('00000000-0000-0000-0000-000000000000', '76bb69bb-59d7-40ca-abeb-4faa2b706f7a', 'authenticated', 'authenticated', 'fisiodemo1@example.com', '$2a$10$Ug09Z89olrz45RqJKsQI5unq4H4RbZouWrR55tNsAnUWpiuJZypTK', '2026-05-01 18:02:06.428312+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-05-01 18:02:49.172667+00', '{"provider": "email", "providers": ["email"]}', '{"email_verified": true}', NULL, '2026-05-01 18:02:06.425101+00', '2026-05-01 18:02:49.191577+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") VALUES
	('76bb69bb-59d7-40ca-abeb-4faa2b706f7a', '76bb69bb-59d7-40ca-abeb-4faa2b706f7a', '{"sub": "76bb69bb-59d7-40ca-abeb-4faa2b706f7a", "email": "fisiodemo1@example.com", "email_verified": false, "phone_verified": false}', 'email', '2026-05-01 18:02:06.426727+00', '2026-05-01 18:02:06.426781+00', '2026-05-01 18:02:06.426781+00', '888ad376-b1e2-4044-a2d4-99570d4ac1eb');


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."sessions" ("id", "user_id", "created_at", "updated_at", "factor_id", "aal", "not_after", "refreshed_at", "user_agent", "ip", "tag", "oauth_client_id", "refresh_token_hmac_key", "refresh_token_counter", "scopes") VALUES
	('cc9e2427-3c7d-4910-aa2d-10e7c4858408', '76bb69bb-59d7-40ca-abeb-4faa2b706f7a', '2026-05-01 18:02:49.173905+00', '2026-05-01 18:02:49.173905+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '188.86.123.95', NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."mfa_amr_claims" ("session_id", "created_at", "updated_at", "authentication_method", "id") VALUES
	('cc9e2427-3c7d-4910-aa2d-10e7c4858408', '2026-05-01 18:02:49.192259+00', '2026-05-01 18:02:49.192259+00', 'password', '42c5b71b-b948-4b4c-a2df-a61d8a037e6b');


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."refresh_tokens" ("instance_id", "id", "token", "user_id", "revoked", "created_at", "updated_at", "parent", "session_id") VALUES
	('00000000-0000-0000-0000-000000000000', 27, 'hm5vzqjbkcwl', '76bb69bb-59d7-40ca-abeb-4faa2b706f7a', false, '2026-05-01 18:02:49.178366+00', '2026-05-01 18:02:49.178366+00', NULL, 'cc9e2427-3c7d-4910-aa2d-10e7c4858408');


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."patients" ("id", "name", "email", "phone", "birth_date", "notes", "created_at", "user_id") VALUES
	('7f7ff6c4-a5c8-444d-a3d7-31836a7353d4', 'pepito', 'pepito@example.com', '6767676767', '1990-01-01', NULL, '2026-05-01 18:03:34.191269', '76bb69bb-59d7-40ca-abeb-4faa2b706f7a'),
	('2ab7e0bd-04dd-4335-a1be-fa218b82c533', 'paquita', 'paquita@example.com', NULL, '1985-01-24', NULL, '2026-05-01 18:06:56.486757', '76bb69bb-59d7-40ca-abeb-4faa2b706f7a');


--
-- Data for Name: injuries; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."injuries" ("id", "patient_id", "muscle_group", "muscle", "description", "severity", "status", "injury_date", "created_at") VALUES
	('b5a2eb75-6b83-4631-8bb2-408f335c16b9', '7f7ff6c4-a5c8-444d-a3d7-31836a7353d4', 'chest', 'Pectoral mayor', 'Dolor agudo', 'severe', 'active', '2026-04-06', '2026-05-01 18:05:11.903567+00'),
	('a4f77498-8d48-413a-909d-98b14910c426', '7f7ff6c4-a5c8-444d-a3d7-31836a7353d4', 'calves', 'Gemelo', 'Contractura', 'mild', 'active', '2026-03-10', '2026-05-01 18:05:47.551785+00'),
	('7f38f8d2-cdef-4ad9-a114-10f5c0c2a8f6', '7f7ff6c4-a5c8-444d-a3d7-31836a7353d4', 'quadriceps', NULL, 'Rotura fibrilar grado 2', 'severe', 'recovered', '2026-05-01', '2026-05-01 18:05:28.521817+00'),
	('e2c3de0e-c8c3-4ea9-bb54-10a97a1f2656', '2ab7e0bd-04dd-4335-a1be-fa218b82c533', 'handsFront', NULL, 'Tendinitis', 'moderate', 'active', '2026-04-07', '2026-05-01 18:07:17.431044+00');


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 27, true);


--
-- PostgreSQL database dump complete
--

-- \unrestrict lanVJMTRg8vS27T4UGpQFGctOvpEwOGGe3FvyVCpCdOVz2XgVHA12gEE3cxvTSa

RESET ALL;
