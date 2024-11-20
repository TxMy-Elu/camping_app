# Application de Gestion de Camping

## Table des Matières

1. [Introduction](#introduction)
2. [Fonctionnalités](#fonctionnalités)
3. [Installation](#installation)
4. [Utilisation](#utilisation)
5. [Arborescence](#arborescence-de-lapplication)
6. [Controller](#controller)


## Introduction

L'Application de Gestion de Camping est une application basée sur Java conçue pour gérer divers aspects d'un site de
camping, y compris la planification des activités, la gestion des animateurs et la gestion de l'authentification des
utilisateurs. L'application utilise JavaFX pour l'interface graphique et MaterialFX pour des composants d'interface
utilisateur améliorés.

## Fonctionnalités

- **Authentification des Utilisateurs**: Système de connexion sécurisé pour les utilisateurs autorisés.
- **Planification des Activités**: Planifier et gérer les activités avec des détails tels que l'animation, l'animateur,
  le lieu, la durée, la date et l'heure.
- **Gestion des Animateurs**: Ajouter, modifier et supprimer des animateurs avec des détails comme le nom, l'email, etc.
- **Gestion des Activités**: Ajouter, modifier et supprimer des activités avec des descriptions.
- **Planification Hebdomadaire**: Visualiser et gérer les activités sur une base hebdomadaire.

## Installation

Pour installer et exécuter l'application, suivez ces étapes :

1. **Prérequis**:
    - Java Development Kit (JDK) 11 ou supérieur.
    - Apache Maven (pour la gestion des dépendances).
    - Serveur MySQL (pour la base de données).

2. **Cloner le Dépôt**:
   ```bash
   git clone https://github.com/votre-utilisateur/votre-depot.git
   cd votre-depot

3. **Installer les Dépendances**:
   ```bash
   mvn install

4. **Exécuter l'Application**:
   ```bash
    mvn javafx:run
   
5. **Configuration de la Base de Données**:
    - Créez une base de données MySQL nommée `camping`.
    - Exécutez le script SQL `camping_bdd.sql` pour créer les tables nécessaires. (Vous pouvez utiliser phpMyAdmin ou
      un autre outil de gestion de base de données pour exécuter le script).
    - Modifiez le fichier `src/main/java/com/example/camping/ConnexionBDD.java` pour configurer les paramètres de connexion à
      la base de données.

## Utilisation

### Connexion

Ouvrez l'application et connectez-vous avec vos identifiants.

```bash
- Utilisateur: admin
- Mot de Passe: &$SWjqUK8$2w
```


### Accueil

Après la connexion, vous serez redirigé vers la page d'accueil où vous pouvez naviguer vers différentes sections de l'
application.

### Planification des Activités

Allez dans la section "Activité" pour planifier de nouvelles activités.
Remplissez les détails de l'activité et cliquez sur "Ajout" pour enregistrer.

### Gestion des Animateurs

Allez dans la section "Animateur" pour gérer les animateurs.
Vous pouvez ajouter, modifier ou supprimer des animateurs.

### Gestion des Activités

Allez dans la section "Activité" pour gérer les activités existantes.
Vous pouvez ajouter, modifier ou supprimer des activités.

### Planification Hebdomadaire

Allez dans la section "Accueil" pour visualiser et gérer les activités sur une base hebdomadaire.
Utilisez les boutons "<<" et ">>" pour naviguer entre les semaines.

## Arborescence de l'application
```
Camping
├── idea
│ 
├── src     
│    ├── main
│    │     └── java
│    │         ├── com.exemple.caming
│    │         │   ├── Act.java
│    │         │   ├── Animateur.java
│    │         │   ├── ConnexionBDD.java
│    │         │   ├── Creneaux.java
│    │         │   ├── CustomException.java
│    │         │   ├── DatabaseHelper.java
│    │         │   ├── EmailSender.java
│    │         │   ├── ErrorViewer.java
│    │         │   ├── HelloApplication.java
│    │         │   ├── Lieu.java
│    │         │   ├── LoaController.java
│    │         │   └── LogController.java
│    │         │
│    │         └── module-info.java
│    │ 
│    │ 
│    │ 
│    ├──ressources
│    │  ├──com.example.camping
│    │  │  ├───── Acceuil.fxml
│    │  │  ├───── Activite.fxml
│    │  │  ├───── Animateur.fxml
│    │  │  ├───── Log.fxml
│    │  │  └───── Planning.fxml
│    │  ├──images
│    │  │  ├───── accueil.png
│    │  │  ├───── fond.png
│    │  │  ├───── logo.png
│    │  │  ├───── planning.png
│    │  │  ├───── sports.png
│    │  │  └───── users.png
│    │  │ 
│    │  └── styles
│    │      └──────styles.css
│    │
│    │
│    │
│    └── test        
└── target
```

## Controller

1. **LogController**:
   - Gère le bouton de connexion à l'application.
   - Génère une nouvelle fenêtre et ferme l'ancienne.
   - Valide que le login et le mot de passe sont corrects.

2. **LoadController**:
   - Initialise les tables Views, les boutons, les choices Boxes et Calendar.
   - Gère les événements des Choices Boxes.
   - Actualise les tables Views et configure les colonnes des tables.
   - Gère les événements des boutons de chaque fenêtre.
   - Met à jour le calendrier.
