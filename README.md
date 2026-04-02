# Projet Final Banque (Oracle)

Ce projet contient un script SQL Oracle complet pour simuler un mini système bancaire : création de schéma, insertion de données, vues, vues matérialisées, triggers, import CSV, opérations `MERGE` et indications de sauvegarde (chaud/froid).

## Contenu du projet

- `PROJET_ORACLE_FINAL.sql` : script principal.

## Fonctionnalités incluses

- Suppression/recréation des tables principales :
  - `client`
  - `compte`
  - `transaction`
  - `utilisateur`
  - `historique`
- Création des séquences Oracle associées.
- Création d’utilisateurs Oracle et rôles (`data_analyst`, `data_integration`).
- Génération de données aléatoires avec `DBMS_RANDOM`.
- Import de données via table externe Oracle (`client_ext`) depuis un CSV.
- Vues analytiques :
  - `vue_transactions`
  - `vue_stats`
- Vue matérialisée : `mv_solde`.
- Triggers métier :
  - Vérification du solde avant retrait.
  - Mise à jour automatique du solde du compte.
  - Journalisation des opérations dans `historique`.
- Exemples de requêtes `MERGE`.
- Notes/commentaires pour sauvegarde Oracle à chaud et à froid.

## Prérequis

- Oracle Database (XE/Standard/Enterprise) avec un schéma disposant des droits nécessaires.
- Un outil d’exécution SQL Oracle :
  - SQL*Plus, ou
  - Oracle SQL Developer.
- (Optionnel) Dossier d’import CSV : `C:\oraclep\data` avec un fichier `data.csv`.

## Attention avant exécution

Le script contient des opérations destructives et administratives :

- `DROP TABLE ...`
- `DROP SEQUENCE ...`
- `DROP USER ... CASCADE`
- `DROP ROLE ...`
- `GRANT ...`

Exécuter ce script uniquement dans un environnement de test/projet (pas en production).

## Exécution du script

### Option 1 — SQL*Plus

```sql
sqlplus utilisateur/motdepasse@XEPDB1
@PROJET_ORACLE_FINAL.sql
```

### Option 2 — SQL Developer

1. Ouvrir le fichier `PROJET_ORACLE_FINAL.sql`.
2. Se connecter à la base cible.
3. Exécuter le script en mode *Run Script* (F5).

## Import CSV (table externe)

Le script crée :

```sql
CREATE OR REPLACE DIRECTORY data_dir AS 'C:\oraclep\data';
```

Puis une table externe basée sur `data.csv` avec séparateur `;` et saut de l’en-tête (`SKIP 1`).

Format attendu minimal du fichier CSV :

```text
id_client;nom;prenom;email;telephone
1;Diallo;Tahir;tahir@gmail.com;620000000
```

## Vérifications rapides après exécution

Vous pouvez contrôler les données avec :

```sql
SELECT * FROM client;
SELECT * FROM compte;
SELECT * FROM transaction;
SELECT * FROM utilisateur;
SELECT * FROM historique;
SELECT * FROM vue_transactions;
SELECT * FROM vue_stats;
SELECT * FROM mv_solde;
```

## Sauvegarde et restauration

Le script contient des blocs commentés expliquant :

- Sauvegarde à chaud via `expdp` (Data Pump).
- Sauvegarde à froid via arrêt de la base, copie des fichiers `.dbf/.ctl/.log`, puis redémarrage.

Adapter les chemins, SID, utilisateurs et mots de passe à votre installation Oracle.

## Auteur

Projet académique — Banque (Oracle SQL).
