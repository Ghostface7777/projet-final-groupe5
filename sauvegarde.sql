-- LES SAUVEGARDES ET LA RESTAURATION

--A. SAUVEGARDE A CHAUD
-- METHODE A SUIVRE (Dans cmd, tape ces commandes)
-- Il faut mettre la base en mode ARCHIVELOG pour permettre une sauvegarde en ligne.
1. sqlplus / as sysdba
2. SHUTDOWN IMMEDIATE;
3. STARTUP MOUNT;
4. ALTER DATABASE ARCHIVELOG;
5. ALTER DATABASE OPEN;
-- Vérification du mode d’archivage.
6. ARCHIVE LOG LIST;
-- On se connecte à RMAN pour lancer la sauvegarde en ligne.
7. rman target /
-- Sauvegarde complète de la base et des journaux.
8. BACKUP DATABASE PLUS ARCHIVELOG;
--+++++++++++++  FIN DE LA SAUVEGARDE A CHAUD +++++++++++++++++++

--A. SAUVEGARDE A FROID
-- METHODE A SUIVRE (Dans cmd, tape ces commandes)
--Il faut arreter la base de donnees
1. sqlplus / as sysdba
2. SHUTDOWN IMMEDIATE;
--La base étant fermée, on copie directement les fichiers vers un dossier de sauvegarde.
3. EXIT;
4. copy C:\ORACLE_WILL\oradata\XE\* C:\backup\
--+++++++++++++  FIN DE LA SAUVEGARDE A FROID +++++++++++++++++++

--C. RESTAURATION
-- On arrête la base avant toute restauration.
1. sqlplus / as sysdba
2. SHUTDOWN IMMEDIATE;
-- On démarre en mode MOUNT pour permettre la restauration.
3. STARTUP MOUNT;
-- On lance RMAN pour restaurer les fichiers.
4. rman target /
5. RESTORE DATABASE;
-- On applique les journaux pour rendre la base cohérente.
6. RECOVER DATABASE;
-- On ouvre la base pour l’utiliser.
7. ALTER DATABASE OPEN;
--+++++++++++++  FIN DE LA RESTAURATION  +++++++++++++++++++  

--========================INGE_WILL===========================