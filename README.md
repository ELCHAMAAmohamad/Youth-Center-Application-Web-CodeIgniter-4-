# Youth Center — Application Web (CodeIgniter 4)

## Présentation

Youth Center est une application web développée en PHP avec le framework CodeIgniter 4.  
Le projet a été réalisé dans le cadre de la Licence 3 Informatique – RESAWEB 2025 à l’Université de Bretagne Occidentale (UBO Brest).

L’application permet à une association de jeunesse de gérer :

- les demandes de contact,
- le suivi des messages,
- les comptes utilisateurs,
- les réservations de ressources.

Le système propose des espaces distincts pour les visiteurs, les membres et les administrateurs.

---

# Technologies utilisées

- PHP
- CodeIgniter 4
- MySQL
- phpMyAdmin
- SQL (tables, vues, fonctions, procédures stockées, triggers)
- HTML
- CSS
- JavaScript
- Visual Studio Code

---

# Méthodologie

Le projet a été développé selon la méthodologie Agile Scrum avec :

- un découpage en sprints,
- un backlog produit,
- des livraisons progressives,
- une amélioration continue.

---

# Fonctionnalités principales

## Visiteur

- Accès à la partie publique
- Consultation des actualités
- Formulaire de contact avec validation
- Suivi des demandes via un code unique

## Membre

- Connexion sécurisée
- Consultation des réservations
- Réservation de ressources selon les créneaux disponibles
- Visualisation de l’état des réservations

## Administrateur

- Gestion des messages de contact
- Gestion des ressources
- Consultation des réservations par date et par ressource
- Accès aux statistiques

---

# Architecture MVC

L’application respecte le pattern MVC (Model – View – Controller).

- **Controllers** : gestion des routes et de la logique applicative
- **Models** : accès à la base de données et règles métier
- **Views** : interface utilisateur (HTML / CSS)

CodeIgniter assure la séparation des responsabilités et l’organisation globale du projet.

---

# Base de données

La base de données MySQL comprend :

- des tables relationnelles,
- des vues SQL,
- des fonctions,
- des procédures stockées,
- des triggers.

---

# Installation locale

## 1. Cloner le dépôt GitHub

```bash
git clone https://github.com/ELCHAMAAmohamad/Youth-Center-Web.git
