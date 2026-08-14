import 'dart:io';

import 'package:test/test.dart';

import '../lib/exceptions/tache_exceptions.dart';
import '../lib/models/tache_normale.dart';
import '../lib/models/tache_urgente.dart';
import '../lib/services/tache_service.dart';
import '../lib/models/tache.dart';

void main() {
  late Directory tempDirectory;
  late TacheService service;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp("tache_test_");

    service = TacheService("${tempDirectory.path}/taches.json");
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test("Créer une tâche normale", () {
    final tache = TacheNormale("Apprendre Dart", Priorite.medium);

    expect(tache.titre, equals("Apprendre Dart"));

    expect(tache.priorite, equals(Priorite.medium));

    expect(tache.terminee, isFalse);
  });

  test("Créer une tâche urgente", () {
    final tache = UrgentTask("Terminer le projet");

    expect(tache.priorite, equals(Priorite.high));

    expect(tache.titre, equals("Terminer le projet"));
  });

  test("Marquer une tâche comme terminée", () {
    final tache = TacheNormale("Faire les exercices", Priorite.low);

    expect(tache.terminee, isFalse);

    tache.marquerTerminee();

    expect(tache.terminee, isTrue);
  });

  test("Ajouter une tâche dans le repository", () async {
    final tache = TacheNormale("Test repository", Priorite.medium);

    await service.save(tache);

    final taches = await service.getAll();

    expect(taches.length, equals(1));

    expect(taches.first.titre, equals("Test repository"));
  });

  test("Supprimer une tâche", () async {
    await service.save(TacheNormale("Tâche à supprimer", Priorite.low));

    await service.delete(0);

    final taches = await service.getAll();

    expect(taches, isEmpty);
  });

  test("Lever une exception si la tâche n'existe pas", () async {
    expect(() => service.delete(100), throwsA(isA<TacheNotFoundException>()));
  });

  test("Persister les tâches dans JSON", () async {
    final tache = TacheNormale(
      "Persistance JSON",
      Priorite.high,
      dateLimit: "2026-08-30",
    );

    await service.save(tache);

    final file = File("${tempDirectory.path}/taches.json");

    expect(await file.exists(), isTrue);

    final taches = await service.getAll();

    expect(taches.first.titre, equals("Persistance JSON"));

    expect(taches.first.priorite, equals(Priorite.high));
  });
}
