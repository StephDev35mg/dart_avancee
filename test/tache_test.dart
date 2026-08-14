import 'dart:io';

import 'package:test/test.dart';

import '../lib/exceptions/tache_exceptions.dart';
import '../lib/models/tache.dart';
import '../lib/models/tache_normale.dart';
import '../lib/models/tache_urgente.dart';
import '../lib/services/tache_service.dart';

void main() {
  late Directory tempDirectory;
  late TacheService service;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp(
      'tache_test_',
    );

    service = TacheService(
      '${tempDirectory.path}/taches.json',
    );
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(
        recursive: true,
      );
    }
  });

  test('Créer une tâche normale', () {
    final tache = TacheNormale(
      'Apprendre Dart',
      Priorite.medium,
    );

    expect(tache.titre, equals('Apprendre Dart'));
    expect(tache.priorite, equals(Priorite.medium));
    expect(tache.terminee, isFalse);
  });

  test('Créer une tâche urgente', () {
    final tache = UrgentTask(
      'Terminer le projet',
    );

    expect(tache.priorite, equals(Priorite.high));
    expect(tache.titre, equals('Terminer le projet'));
    expect(tache.terminee, isFalse);
  });

  test('Marquer une tâche comme terminée', () {
    final tache = TacheNormale(
      'Faire les exercices',
      Priorite.low,
    );

    expect(tache.terminee, isFalse);

    tache.marquerTerminee();

    expect(tache.terminee, isTrue);
  });

  test('Ajouter une tâche dans le repository', () async {
    final tache = TacheNormale(
      'Test repository',
      Priorite.medium,
    );

    await service.save(tache);

    final taches = await service.getAll();

    expect(taches.length, equals(1));
    expect(taches.first.titre, equals('Test repository'));
    expect(taches.first.priorite, equals(Priorite.medium));
  });

  test('Supprimer une tâche', () async {
    await service.save(
      TacheNormale(
        'Tâche à supprimer',
        Priorite.low,
      ),
    );

    await service.delete(0);

    final taches = await service.getAll();

    expect(taches, isEmpty);
  });

  test("Lever une exception si la tâche n'existe pas", () async {
    expect(
      () => service.delete(100),
      throwsA(
        isA<TacheNotFoundException>(),
      ),
    );
  });

  test('Persister les tâches dans JSON', () async {
    final tache = TacheNormale(
      'Persistance JSON',
      Priorite.high,
      dateLimit: '2026-08-30',
    );

    await service.save(tache);

    final file = File(
      '${tempDirectory.path}/taches.json',
    );

    expect(await file.exists(), isTrue);

    final taches = await service.getAll();

    expect(taches.length, equals(1));
    expect(taches.first.titre, equals('Persistance JSON'));
    expect(taches.first.priorite, equals(Priorite.high));
    expect(taches.first.dateLimit, equals('2026-08-30'));
  });

  test('Trier les tâches par priorité', () async {
    await service.save(
      TacheNormale(
        'Tâche basse',
        Priorite.low,
      ),
    );

    await service.save(
      TacheNormale(
        'Tâche haute',
        Priorite.high,
      ),
    );

    await service.save(
      TacheNormale(
        'Tâche moyenne',
        Priorite.medium,
      ),
    );

    final taches = await service.trierParPriorite();

    expect(taches.length, equals(3));
    expect(taches[0].priorite, equals(Priorite.high));
    expect(taches[1].priorite, equals(Priorite.medium));
    expect(taches[2].priorite, equals(Priorite.low));
  });

  test('Trier les tâches par date', () async {
    await service.save(
      TacheNormale(
        'Tâche du 20',
        Priorite.medium,
        dateLimit: '2026-08-20',
      ),
    );

    await service.save(
      TacheNormale(
        'Tâche du 15',
        Priorite.high,
        dateLimit: '2026-08-15',
      ),
    );

    await service.save(
      TacheNormale(
        'Tâche du 25',
        Priorite.low,
        dateLimit: '2026-08-25',
      ),
    );

    final taches = await service.trierParDate();

    expect(taches.length, equals(3));
    expect(taches[0].dateLimit, equals('2026-08-15'));
    expect(taches[1].dateLimit, equals('2026-08-20'));
    expect(taches[2].dateLimit, equals('2026-08-25'));
  });
}
