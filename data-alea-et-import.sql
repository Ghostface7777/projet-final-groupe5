
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
