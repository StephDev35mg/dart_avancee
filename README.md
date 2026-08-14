# Gestion de tâches en Dart

Petit projet réalisé en Dart pour pratiquer la programmation orientée objet et la gestion de données locales.

L'application fonctionne dans le terminal et permet de créer, consulter et gérer des tâches. Les tâches sont enregistrées dans un fichier JSON afin de conserver les données localement.

## Fonctionnalités

- Ajouter une tâche
- Afficher toutes les tâches
- Modifier une tâche
- Marquer une tâche comme terminée
- Supprimer une tâche
- Trier les tâches par priorité
- Trier les tâches par date limite
- Sauvegarder les tâches dans un fichier JSON
- Charger les tâches depuis le fichier JSON
- Gérer les erreurs avec des exceptions personnalisées

## Technologies utilisées

- Dart
- JSON
- Package `test` pour les tests unitaires

## Concepts utilisés

Le projet m'a permis de pratiquer plusieurs notions de Dart :

- Classe abstraite
- Héritage
- Interface
- Génériques
- Encapsulation
- Getters et setters
- Exceptions personnalisées
- Lecture et écriture de fichiers
- Sérialisation et désérialisation JSON
- Tests unitaires

## Organisation du projet

```text
libs/
├── models/
│   ├── tache.dart
│   ├── tache_normale.dart
│   └── tache_urgente.dart
├── interfaces/
│   └── terminable.dart
├── repositories/
│   └── repository.dart
├── exceptions/
│   └── tache_exceptions.dart
├── services/
│   └── tache_service.dart
└── main.dart

test/
└── tache_test.dart

data/
└── taches.json

pubspec.yaml
README.md