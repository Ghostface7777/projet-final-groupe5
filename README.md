# Projet Final Banque (Oracle)

Ce projet contient un script SQL Oracle complet pour simuler un mini système bancaire : création de schéma, insertion de données, vues, vues matérialisées, triggers, import CSV, opérations `MERGE` et indications de sauvegarde (chaud/froid).

## Contenu du projet

- `PROJET_ORACLE_FINAL.sql` : script principal.

## Fonctionnalités incluses

- Suppression/recréation des tables principales :
   # Projet Final Banque Oracle

  Ce projet présente un mini système bancaire développé en SQL Oracle. Il regroupe la création du schéma, la gestion des comptes et transactions, l’import de données, des vues d’analyse, des triggers métier et des exemples de sauvegarde.

  ## Fichier principal

  - [PROJET_ORACLE_FINAL.sql](PROJET_ORACLE_FINAL.sql) : script complet du projet.

  ## Objectifs du projet

  - Créer les tables d’une base bancaire.
  - Gérer les clients, comptes, transactions, utilisateurs et historique.
  - Automatiser certaines règles métier avec des triggers.
  - Fournir des vues pour l’analyse des opérations.
  - Illustrer l’import de données externes et les opérations de fusion avec `MERGE`.

  ## Fonctionnalités

  ### 1. Création du schéma

  - Suppression puis recréation des tables :
    - `client`
    - `compte`
    - `transaction`
    - `utilisateur`
    - `historique`
  - Création des séquences Oracle associées.

  ### 2. Sécurité et droits

  - Création d’utilisateurs Oracle :
    - `Tahirou`
    - `Marlyatou`
    - `Rabi`
    - `Foromo`
  - Création des rôles :
    - `data_analyst`
    - `data_integration`

  ### 3. Données de test

  - Génération de données aléatoires avec `DBMS_RANDOM`.
  - Insertion automatique de clients, comptes, transactions, utilisateurs et historique.

  ### 4. Import de données

  - Création d’une table externe `client_ext`.
  - Lecture d’un fichier CSV via un répertoire Oracle.
  - Insertion des données importées dans la table `client`.

  ### 5. Analyse et reporting

  - Vue `vue_transactions` pour afficher les transactions avec les informations client.
  - Vue `vue_stats` pour obtenir le nombre et le total des transactions par type.
  - Vue matérialisée `mv_solde` pour le calcul du solde par compte.

  ### 6. Automatisation métier

  - Trigger de vérification du solde avant retrait.
  - Trigger de mise à jour automatique du solde du compte.
  - Trigger d’historisation des opérations.

  ### 7. Fusion de données

  - Exemples de requêtes `MERGE` pour synchroniser des données entre tables.

  ### 8. Sauvegarde

  - Notes sur la sauvegarde à chaud avec Data Pump.
  - Notes sur la sauvegarde à froid avec arrêt de la base et copie des fichiers Oracle.

  ## Prérequis

  - Oracle Database installé et accessible.
  - SQL*Plus ou Oracle SQL Developer.
  - Droits suffisants pour créer des tables, séquences, vues, triggers, rôles et utilisateurs.
  - Pour l’import CSV : un dossier local accessible par Oracle, par exemple `C:\oraclep\data`.

  ## Attention

  Le script contient des commandes destructives et administratives :

  - suppression de tables,
  - suppression de séquences,
  - suppression d’utilisateurs,
  - suppression de rôles,
  - attribution de privilèges.

  Il doit être exécuté uniquement dans un environnement de test ou de projet.

  ## Exécution

  ### Avec SQL*Plus

  ```sql
  sqlplus utilisateur/motdepasse@XEPDB1
  @PROJET_ORACLE_FINAL.sql
  ```

  ### Avec SQL Developer

  1. Ouvrir le fichier [PROJET_ORACLE_FINAL.sql](PROJET_ORACLE_FINAL.sql).
  2. Se connecter à la base Oracle.
  3. Lancer le script en mode exécution complète.

  ## Import CSV

  Le script utilise un répertoire Oracle nommé `data_dir` pointant vers :

  ```sql
  C:\oraclep\data
  ```

  Le fichier attendu est `data.csv` avec un séparateur `;` et une ligne d’en-tête.

  Exemple :

  ```text
  id_client;nom;prenom;email;telephone
  1;Diallo;Tahir;tahir@gmail.com;620000000
  ```

  ## Vérifications après exécution

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

  ## Résultat attendu

  Après exécution, la base doit contenir :

  - des clients générés ou importés,
  - des comptes liés aux clients,
  - des transactions de dépôt et de retrait,
  - un historique des opérations,
  - des vues prêtes pour l’analyse.

  ## Auteur

  Projet académique de gestion bancaire avec Oracle SQL.
