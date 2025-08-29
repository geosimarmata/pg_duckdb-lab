--
-- PostgreSQL database cluster dump
--

-- Started on 2025-08-22 12:17:40 WIB

\restrict wKWpajGAuSMYtBssJ7AtBgfDnaEgdvDajSujg218giKgCMaGcMhjNIX96WKeHrZ

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:FpsCOas174cH9lo8CO4mSA==$kY2Mb+2iHMXAFKt4XbzZ8PbH9hkVSt/+FVS9y3GLre8=:uvk0cqis6cInaksb6bwR9CylfgB2wPLBPtTHl5SZ/7A=';

--
-- User Configurations
--








\unrestrict wKWpajGAuSMYtBssJ7AtBgfDnaEgdvDajSujg218giKgCMaGcMhjNIX96WKeHrZ

-- Completed on 2025-08-22 12:17:40 WIB

--
-- PostgreSQL database cluster dump complete
--

