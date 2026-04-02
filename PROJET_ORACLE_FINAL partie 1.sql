--suppression des tables

BEGIN EXECUTE IMMEDIATE 'DROP TABLE transaction CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE compte CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE client CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE utilisateur CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE historique CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
--creation des tables
CREATE TABLE client (
    id_client NUMBER PRIMARY KEY,
    nom VARCHAR2(50),
    prenom VARCHAR2(50),
    email VARCHAR2(100),
    telephone VARCHAR2(20)
);

CREATE TABLE compte (
    id_compte NUMBER PRIMARY KEY,
    id_client NUMBER,
    solde NUMBER DEFAULT 0,
    statut VARCHAR2(20),
    FOREIGN KEY (id_client) REFERENCES client(id_client)
);
CREATE TABLE transaction (
    id_transaction NUMBER PRIMARY KEY,
    id_compte NUMBER,
    type_transaction VARCHAR2(20),
    montant NUMBER,
    date_transaction DATE,
    FOREIGN KEY (id_compte) REFERENCES compte(id_compte)
);

CREATE TABLE utilisateur (
    id_user NUMBER PRIMARY KEY,
    nom VARCHAR2(50),
    role VARCHAR2(20)
);
CREATE TABLE historique (
    id_historique NUMBER PRIMARY KEY,
    action VARCHAR2(100),
    date_action DATE,
    utilisateur VARCHAR2(50)
);
--creation des sequences
BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE seq_client';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -2289 THEN NULL; END IF;
END;
/
CREATE SEQUENCE seq_client START WITH 1 INCREMENT BY 1;

BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE seq_compte';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -2289 THEN NULL; END IF;
END;
/
CREATE SEQUENCE seq_compte START WITH 1 INCREMENT BY 1;

BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE seq_transaction';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -2289 THEN NULL; END IF;
END;
/
CREATE SEQUENCE seq_transaction START WITH 1 INCREMENT BY 1;

BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE seq_historique';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -2289 THEN NULL; END IF;
END;
/
CREATE SEQUENCE seq_historique START WITH 1 INCREMENT BY 1;

BEGIN
   EXECUTE IMMEDIATE 'DROP SEQUENCE seq_utilisateur';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -2289 THEN NULL; END IF;
END;
/
CREATE SEQUENCE seq_utilisateur START WITH 1 INCREMENT BY 1;
--creation des utilisateurs
drop user Tahirou CASCADE;
create user Tahirou identified by "12345" default TABLESPACE users temporary TABLESPACE temp;
grant create session to Tahirou; 
drop user Marlyatou CASCADE;
create user Marlyatou identified by "12345" default TABLESPACE users temporary TABLESPACE temp;
grant create session to Marlyatou;
drop user Rabi CASCADE;
create user Rabi identified by "12345" default TABLESPACE users temporary TABLESPACE temp;
grant create session to Rabi;
drop user Foromo CASCADE;
create user Foromo identified by "12345" default TABLESPACE users temporary TABLESPACE temp;
grant create session to Foromo;
--creation et attribution des roles
drop role data_analyst ;
create role data_analyst ;
grant select any table to data_analyst;
set role data_analyst;
grant data_analyst to Tahirou;
grant data_analyst to Marlyatou;
grant data_analyst to Rabi;
grant data_analyst to Foromo;
--creation du role data_integration
drop role data_integration;
create role data_integration;
grant select   any table to data_integration;
grant insert any table to data_integration;
grant update any table to data_integration;
set role data_integration;
