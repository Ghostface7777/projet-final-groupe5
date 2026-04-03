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