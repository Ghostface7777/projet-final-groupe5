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