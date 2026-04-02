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
--5generer des données aleatoire pour chaque table
--client
BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO client (id_client, nom, prenom, email, telephone)
        VALUES (
            seq_client.NEXTVAL,
            DBMS_RANDOM.STRING('U', 5),
            DBMS_RANDOM.STRING('U', 7),
            LOWER(DBMS_RANDOM.STRING('U', 5)) || '@gmail.com',
            '62' || TO_CHAR(ROUND(DBMS_RANDOM.VALUE(1000000, 9999999)))
        );
    END LOOP;
    COMMIT;
END;
/
 select *from client;
 --compte
 BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO compte (id_compte, id_client, solde, statut)
        VALUES (
            seq_compte.NEXTVAL,
            i,
            ROUND(DBMS_RANDOM.VALUE(1000, 10000), 2),
            CASE 
                WHEN MOD(i,2) = 0 THEN 'actif'
                ELSE 'inactif'
            END
        );
    END LOOP;
    COMMIT;
END;
/
--transaction
BEGIN
    FOR i IN 1..20 LOOP
        INSERT INTO transaction 
        (id_transaction, id_compte, type_transaction, montant, date_transaction)
        VALUES (
            seq_transaction.NEXTVAL,
            MOD(i,10)+1,
            CASE 
                WHEN MOD(i,2)=0 THEN 'DEPOT'
                ELSE 'RETRAIT'
            END,
            ROUND(DBMS_RANDOM.VALUE(100, 1000), 2),
            SYSDATE
        );
    END LOOP;
    COMMIT;
END;
--utilisateur
BEGIN
    FOR i IN 1..5 LOOP
        INSERT INTO utilisateur (id_user, nom, role)
        VALUES (
            seq_utilisateur.NEXTVAL,
            DBMS_RANDOM.STRING('U', 6),
            CASE 
                WHEN i <= 2 THEN 'admin'
                ELSE 'agent'
            END
        );
    END LOOP;
    COMMIT;
END;
/
--historique
BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO historique (id_historique, action, date_action, utilisateur)
        VALUES (
            seq_historique.NEXTVAL,
            'Operation ' || i,
            SYSDATE,
            MOD(i,5)+1
        );
    END LOOP;
    COMMIT;
END;
/
select * from utilisateur;
select * from client;
select * from transaction;
select * from historique;
select *from compte;
-- 6 import
create or replace  directory data_dir as 'C:\oraclep\data';
grant read,write on directory data_dir to public;
-- creation d'une table externe
drop table client_ext;
CREATE TABLE client_ext (
    id_client NUMBER,
    nom VARCHAR2(50),
    prenom VARCHAR2(50),
    email VARCHAR2(100),
    telephone VARCHAR2(20)
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY data_dir
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE SKIP 1
        FIELDS TERMINATED BY ';'
    )
    LOCATION ('data.csv')
)
REJECT LIMIT UNLIMITED;
select *from client_ext;
insert into client
select * from client_ext;

-- insertion des données via un fichier csv
INSERT INTO client (id_client, nom, prenom, email, telephone)
SELECT 
    seq_client.NEXTVAL,  -- auto ID
    nom, prenom, email, telephone
FROM client_ext;
select * from client;
--4 sauvegarde et restauration
--1 sauvergarde a chaud


--view et jointure

--transaction complete
CREATE OR REPLACE VIEW vue_transactions AS
SELECT 
    t.id_transaction,
    c.id_client,
    c.nom,
    c.prenom,
    cp.id_compte,
    t.type_transaction,
    t.montant,
    t.date_transaction
FROM transaction t
JOIN compte cp ON t.id_compte = cp.id_compte
JOIN client c ON cp.id_client = c.id_client;
select * from vue_transactions;
--stastique depot retrait
CREATE OR REPLACE VIEW vue_stats AS
SELECT 
    type_transaction,
    COUNT(*) AS nb_transactions,
    SUM(montant) AS total
FROM transaction
GROUP BY type_transaction;
select * from vue_stats;
-- view materialized pour l'affichage du solde de depot et retrait
drop  MATERIALIZED VIEW mv_solde;
CREATE  MATERIALIZED VIEW mv_solde
BUILD IMMEDIATE
REFRESH COMPLETE
AS
SELECT 
    id_compte,
    SUM(
        CASE 
            WHEN type_transaction = 'DEPOT' THEN montant
            ELSE -montant
        END
    ) AS solde
FROM transaction
GROUP BY id_compte;
select * from mv_solde;
-- trigger 
--1  pour verifier le solde

CREATE OR REPLACE TRIGGER trg_verif_solde
BEFORE INSERT ON transaction
FOR EACH ROW
DECLARE
    solde NUMBER;
BEGIN
    SELECT NVL(SUM(
        CASE 
            WHEN type_transaction = 'DEPOT' THEN montant
            ELSE -montant
        END
    ),0)
    INTO solde
    FROM transaction
    WHERE id_compte = :NEW.id_compte;

    IF :NEW.type_transaction = 'RETRAIT' AND solde < :NEW.montant THEN
        RAISE_APPLICATION_ERROR(-20001, 'Solde insuffisant');
    END IF;
END;
/
--2 metre a jour le solde automatiquement
CREATE OR REPLACE TRIGGER trg_update_solde
AFTER INSERT ON transaction
FOR EACH ROW
BEGIN
    IF :NEW.type_transaction = 'DEPOT' THEN
        UPDATE compte
        SET solde = solde + :NEW.montant
        WHERE id_compte = :NEW.id_compte;
    ELSE
        UPDATE compte
        SET solde = solde - :NEW.montant
        WHERE id_compte = :NEW.id_compte;
    END IF;
END;
/
--3 historique des transactions
CREATE OR REPLACE TRIGGER trg_historique
AFTER INSERT ON transaction
FOR EACH ROW
DECLARE
    v_nom utilisateur.nom%TYPE;
BEGIN
    -- récupérer le nom de l'utilisateur
    SELECT u.nom
    INTO v_nom
    FROM compte c
    JOIN client cl ON c.id_client = cl.id_client
    JOIN utilisateur u ON cl.id_client = u.id_user
    WHERE c.id_compte = :NEW.id_compte;

    -- insertion dans historique
    INSERT INTO historique
    (id_historique, action, date_action, utilisateur)
    VALUES (
        seq_historique.NEXTVAL,
        'Opération par ' || v_nom || 
        ' : ' || :NEW.type_transaction || 
        ' montant = ' || :NEW.montant,
        SYSDATE,
        v_nom
    );
END;
/
--TEST des trigger
INSERT INTO transaction 
VALUES (seq_transaction.NEXTVAL, 2, 'DEPOT', 500, SYSDATE);
select *from historique;
select * from transaction;
--Requete merge
CREATE TABLE utilisateur_ext (
    id_user NUMBER,
    nom VARCHAR2(100),
    email VARCHAR2(100),
    role varchar2(100)
);
CREATE TABLE compte_ext (
    id_compte NUMBER,
    id_client NUMBER,
    solde NUMBER,
    statut VARCHAR2(50)
);
CREATE TABLE transaction_ext (
    id_transaction NUMBER,
    id_compte NUMBER,
    type_transaction VARCHAR2(50),
    montant NUMBER,
    date_transaction DATE
);
--test
MERGE INTO client c
USING client_ext e
ON (c.id_client = e.id_client)

WHEN MATCHED THEN
    UPDATE SET
        c.nom = e.nom,
        c.prenom = e.prenom

WHEN NOT MATCHED THEN
    INSERT (id_client, nom, prenom)
    VALUES (e.id_client, e.nom, e.prenom);
    select *from client;
  ----  

MERGE INTO client c
USING client_ext e
ON (c.id_client = e.id_client)

WHEN MATCHED THEN
    UPDATE SET
        c.nom = e.nom,
        c.prenom = e.prenom
    WHERE c.nom != e.nom 
       OR c.prenom != e.prenom

WHEN NOT MATCHED THEN
    INSERT (id_client, nom, prenom)
    VALUES (e.id_client, e.nom, e.prenom);
--trigger pour tracer ce qui se passe 
MERGE INTO client c
USING client_ext e
ON (c.id_client = e.id_client)

WHEN MATCHED THEN
    UPDATE SET
        c.nom = e.nom,
        c.prenom = e.prenom

WHEN NOT MATCHED THEN
    INSERT (id_client, nom, prenom)
    VALUES (e.id_client, e.nom, e.prenom);
   -------
--============================================
-- LES SAUVEGARDES
--a. Sauvegarde a chaud "En tant que SYSTEME avec le DOMAINE XEPDB1"
--CREATE OR REPLACE DIRECTORY backup_dir AS 'C:\BackupOracle';
--GRANT READ, WRITE ON DIRECTORY backup_dir TO projetfinal;
--Apres créer un ficier .bat ayant pour contenu ci-dessous

/*@echo off
title Script de Sauvegarde Oracle - Projet IST Mamou
echo ============================================================
echo   SYSTEME DE SAUVEGARDE A CHAUD (DATA PUMP) - PROJET ORACLE
echo ============================================================

:: 1. Définition des variables d'environnement (si nécessaire)
:: set ORACLE_SID=xe

:: 2. Création du dossier physique s'il n'existe pas encore
if not exist C:\BackupOracle mkdir C:\BackupOracle

echo.
echo Exportation du schema projetfinal en cours...
echo.

:: 3. Commande EXPORT DATA PUMP (expdp)
:: On utilise l'utilisateur projetfinal pour sauvegarder ses propres tables
expdp WILL_ADMIN/will2026@localhost/XEPDB1 ^
DIRECTORY=backup_dir ^
DUMPFILE=sauvegarde_ist_%date:~-4%%date:~3,2%%date:~0,2%.dmp ^
LOGFILE=sauvegarde_log.log ^
SCHEMAS=projetfinal

echo.
echo ============================================================
echo Sauvegarde terminee ! Verifiez le dossier C:\BackupOracle
echo ============================================================
pause*/

--b. Sauvegarde à froid
-- Créer les fichier stopdb_temp.sql contenant SHUTDOWN IMMEDIATE; EXIT; ET startdb_temp.sql contenant STARTUP; EXIT;
-- ET backup_cold_complete.bat le tout dans le repertoire OracleBackup dans le disque local
--Apres


/*@echo off
REM ======================================================
REM SAUVEGARDE A FROID COMPLETE ORACLE
REM ======================================================

REM ======== CONFIGURATION ========
set ORACLE_SID=XE
set ORACLE_HOME=C:\ORACLE_WILL\dbhomeXE
set PATH=%ORACLE_HOME%\bin;%PATH%
set ORADATA_DIR=C:\ORACLE_WILL\oradata\XE
set BACKUP_DIR=C:\backup

echo ======================================================
echo VERIFICATION DU DOSSIER DE SAUVEGARDE
echo ======================================================
if not exist %BACKUP_DIR% (
    mkdir %BACKUP_DIR%
    echo Dossier %BACKUP_DIR% créé.
) else (
    echo Dossier %BACKUP_DIR% existe deja.
)

REM ======== ARRET DE LA BASE ========
echo ======================================================
echo ARRET DE LA BASE DE DONNEES
echo ======================================================
sqlplus / as sysdba @stopdb_temp.sql

REM ======== COPIE DES FICHIERS ========
echo ======================================================
echo COPIE DES DATAFILES
echo ======================================================
copy "%ORADATA_DIR%\*.dbf" "%BACKUP_DIR%\" /Y

echo ======================================================
echo COPIE DES CONTROLFILES
echo ======================================================
copy "%ORADATA_DIR%\control*.ctl" "%BACKUP_DIR%\" /Y

echo ======================================================
echo COPIE DES REDO LOGS
echo ======================================================
copy "%ORADATA_DIR%\redo*.log" "%BACKUP_DIR%\" /Y

echo ======================================================
echo SAUVEGARDE TERMINEE
echo ======================================================

REM ======== DEMARRAGE DE LA BASE ========
echo ======================================================
echo DEMARRAGE DE LA BASE DE DONNEES
echo ======================================================
sqlplus / as sysdba @startdb_temp.sql

pause*/


--============================================
