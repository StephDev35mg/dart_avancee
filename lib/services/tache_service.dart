import 'dart:convert';
import 'dart:io';

import '../models/tache.dart';
import '../repositories/repository.dart';
import '../exceptions/tache_exceptions.dart';

class TacheService implements Repository<Tache> {
  final String filePath;

  TacheService(this.filePath);

  // ==========================================
  // Lire toutes les tâches
  // ==========================================

  @override
  Future<List<Tache>> getAll() async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        return [];
      }

      final content = await file.readAsString();

      if (content.trim().isEmpty) {
        return [];
      }

      final decoded = jsonDecode(content);

      if (decoded is! List) {
        throw TacheStorageException("Le fichier JSON doit contenir une liste.");
      }

      return decoded.map<Tache>((item) {
        return Tache.fromJson(Map<String, dynamic>.from(item));
      }).toList();
    } catch (e) {
      if (e is TacheException) {
        rethrow;
      }

      throw TacheStorageException("Impossible de lire les tâches : $e");
    }
  }

  // ==========================================
  // Récupérer une tâche par son ID
  // ==========================================

  @override
  Future<Tache?> getById(int id) async {
    final taches = await getAll();

    if (id < 0 || id >= taches.length) {
      return null;
    }

    return taches[id];
  }

  // ==========================================
  // Ajouter une tâche
  // ==========================================

  @override
  Future<void> save(Tache tache) async {
    final taches = await getAll();

    taches.add(tache);

    await _writeFile(taches);
  }

  // ==========================================
  // Modifier une tâche
  // ==========================================

  @override
  Future<void> update(int id, Tache tache) async {
    final taches = await getAll();

    _validateId(id, taches);

    taches[id] = tache;

    await _writeFile(taches);
  }

  // ==========================================
  // Marquer comme terminée
  // ==========================================

  Future<void> terminer(int id) async {
    final taches = await getAll();

    _validateId(id, taches);

    taches[id].marquerTerminee();

    await _writeFile(taches);
  }

  // ==========================================
  // Supprimer
  // ==========================================

  @override
  Future<void> delete(int id) async {
    final taches = await getAll();

    _validateId(id, taches);

    taches.removeAt(id);

    await _writeFile(taches);
  }

  // ==========================================
  // Tri par priorité
  // ==========================================

  Future<List<Tache>> trierParPriorite() async {
    final taches = await getAll();

    taches.sort((a, b) => b.priorite.index.compareTo(a.priorite.index));

    return taches;
  }

  // ==========================================
  // Tri par date
  // ==========================================

  Future<List<Tache>> trierParDate() async {
    final taches = await getAll();

    taches.sort((a, b) {
      final dateA = a.dateLimit ?? "9999-12-31";
      final dateB = b.dateLimit ?? "9999-12-31";

      return dateA.compareTo(dateB);
    });

    return taches;
  }

  // ==========================================
  // Vérifier l'ID
  // ==========================================

  void _validateId(int id, List<Tache> taches) {
    if (id < 0 || id >= taches.length) {
      throw TacheNotFoundException("La tâche avec l'ID $id n'existe pas.");
    }
  }

  // ==========================================
  // Écrire dans le fichier JSON
  // ==========================================

  Future<void> _writeFile(List<Tache> taches) async {
    try {
      final file = File(filePath);

      await file.parent.create(recursive: true);

      final data = taches.map((tache) => tache.toJson()).toList();

      await file.writeAsString(
        const JsonEncoder.withIndent("  ").convert(data),
      );
    } catch (e) {
      throw TacheStorageException("Impossible de sauvegarder les tâches : $e");
    }
  }
}
