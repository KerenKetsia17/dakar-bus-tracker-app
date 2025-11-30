
# Blueprint du Projet : Dakar Dem Dikk Geo-Tracking

Ce document sert de cahier des charges et de journal de bord pour le développement de l'application de géolocalisation des bus de Dakar Dem Dikk.

## 1. Vue d'Ensemble

**Libellé du Sujet :** Conception et réalisation d'une application mobile de géolocalisation pour les transports en commun : cas de Dakar Dem Dikk.

**Objectif :** Permettre aux usagers de visualiser en temps réel la position des bus, de rechercher des itinéraires et de réduire leur temps d'attente. Fournir une interface d'administration pour la gestion des données de transport.

**Étudiant :** ABANG ABGHE Kéren Ketsia
**Encadreur :** M GAYE Abdoulaye

## 2. Architecture Technique

- **Frontend (Client Mobile) :**
  - **Framework :** Flutter
  - **Objectif :** Fournir une interface utilisateur intuitive pour les passagers, les conducteurs et les administrateurs.
  - **Fonctionnalités Clés :** Carte interactive, recherche de lignes, planification d'itinéraire, tableau de bord admin.

- **Backend (Serveur) :**
  - **Framework :** Node.js avec Express.js
  - **Objectif :** Servir de pont sécurisé entre l'application Flutter et la base de données Firebase. Gérer la logique métier et les opérations CRUD.
  - **Communication :** API RESTful.

- **Base de Données :**
  - **Service :** Firebase
  - **Utilisation :**
    - **Realtime Database :** Pour le stockage et la synchronisation en temps réel des positions des bus.
    - **Firestore/Realtime Database :** Pour le stockage des données métier (Lignes, Bus, Utilisateurs, Incidents).

- **Géolocalisation & Cartographie :**
  - **API de Carte :** OpenStreetMap (via `flutter_map`).
  - **Suivi GPS :** Simulation de la position GPS des conducteurs envoyée à la Realtime Database.

## 3. Fonctionnalités Implémentées

### Version Actuelle

#### Passager :
- **Visualisation sur Carte :**
  - Affiche la position de l'utilisateur.
  - Affiche les bus en mouvement en temps réel, récupérés depuis Firebase.
  - Dessine les itinéraires de toutes les lignes sur la carte.
- **Liste des Lignes :**
  - Affiche toutes les lignes de bus disponibles avec leur numéro, trajet et couleur distinctive.
- **Recherche (à implémenter) :**
  - Barre de recherche pour filtrer les lignes.
  - Fonctionnalité pour trouver des lignes proches de la position de l'utilisateur.
  - Planificateur d'itinéraire ("Comment aller à... ?").

#### Administrateur :
- **Tableau de Bord Centralisé (en cours de refonte) :**
  - Authentification simple basée sur l'email.
  - Interface avec onglets pour gérer :
    - **Lignes :** CRUD complet (Créer, Lire, Mettre à jour, Supprimer).
    - **Bus :** CRUD complet.
    - **Incidents :** CRUD complet.
    - **Utilisateurs :** CRUD complet.
  - Toutes les opérations passent par le backend Node.js pour la sécurité et la validation.

#### Conducteur :
- **Simulation de Position :**
  - Un écran simple qui, une fois activé, simule le parcours d'un bus le long d'un itinéraire prédéfini.
  - Envoie des mises à jour de coordonnées à la Firebase Realtime Database toutes les 5 secondes.

## 4. Plan de Développement Actuel

**Étape en cours : Mise en place de l'architecture Client-Serveur.**

1.  **[Terminé]** Initialisation du projet Flutter avec les dépendances Firebase et `go_router`.
2.  **[Terminé]** Création des modèles de données initiaux (`models.dart`).
3.  **[Terminé]** Prototypage rapide avec communication directe Flutter -> Firebase.
4.  **[En cours] Création du Backend Node.js :**
    -   Créer le répertoire `server`.
    -   Initialiser un projet Node.js avec Express.
    -   Configurer la connexion au SDK Admin de Firebase.
    -   Développer les routes de l'API RESTful pour le CRUD des Lignes.
5.  **[Prochaine étape] Refonte du Frontend Admin :**
    -   Ajouter le package `http` à Flutter.
    -   Créer un `ApiService` pour communiquer avec le backend Node.js.
    -   Mettre à jour l'écran `admin_screen.dart` pour utiliser une `TabBar` et appeler l'`ApiService`.
