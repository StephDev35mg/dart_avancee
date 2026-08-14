import 'models/tache.dart';
import 'models/tache_normale.dart';
import 'models/tache_urgente.dart';
import 'services/tache_service.dart';

Future<void> main() async {
  final service = TacheService("data/taches.json");

  try {
    final tache1 = TacheNormale(
      "Apprendre Dart",
      Priorite.medium,
      dateLimit: "2026-08-20",
    );

    final tache2 = UrgentTask("Terminer le projet", dateLimit: "2026-08-15");

    final tache3 = TacheNormale("Lire le cours", Priorite.low);

    await service.save(tache1);
    await service.save(tache2);
    await service.save(tache3);

    print("Tâches ajoutées.\n");

    var taches = await service.getAll();

    afficherTaches(taches);

    await service.terminer(0);

    print("\nAprès avoir terminé la tâche 0 :");

    taches = await service.getAll();

    afficherTaches(taches);

    print("\nTri par priorité :");

    taches = await service.trierParPriorite();

    afficherTaches(taches);

    

    await service.delete(1);

    print("\nAprès suppression de la tâche 1 :");

    taches = await service.getAll();

    afficherTaches(taches);
  } catch (e) {
    print("Erreur : $e");
  }
}

void afficherTaches(List<Tache> taches) {
  for (int i = 0; i < taches.length; i++) {
    final tache = taches[i];

    print(
      "$i. ${tache.titre} | "
      "Priorité: ${tache.priorite.name} | "
      "Date: ${tache.dateLimit ?? 'Aucune'} | "
      "Terminée: ${tache.terminee}",
    );
  }
}
