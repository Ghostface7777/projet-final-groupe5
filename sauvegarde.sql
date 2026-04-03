-- LES SAUVEGARDES
--a. Sauvegarde a chaud "En tant que SYSTEME avec le DOMAINE XEPDB1"
--CREATE OR REPLACE DIRECTORY backup_dir AS 'C:\BackupOracle';
--GRANT READ, WRITE ON DIRECTORY backup_dir TO projetfinal;
--Apres créer un ficier .bat ayant pour contenu ci-dessous

@echo off
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
pause

--b. Sauvegarde à froid
-- Créer les fichier stopdb_temp.sql contenant SHUTDOWN IMMEDIATE; EXIT; ET startdb_temp.sql contenant STARTUP; EXIT;
-- ET backup_cold_complete.bat le tout dans le repertoire OracleBackup dans le disque local
--Apres


@echo off
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

pause