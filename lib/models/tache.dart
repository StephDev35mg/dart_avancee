import '../interfaces/terminable.dart';
import '../exceptions/tache_exceptions.dart';
import 'tache_normale.dart';
import 'tache_urgente.dart';

enum Priorite {
  low,
  medium,
  high,
}

abstract class Tache implements Terminable {
  String _titre;
  Priorite _priorite;
  String? _dateLimit;
  bool _terminee;

  Tache(
    String titre,
    Priorite priorite, {
    String? dateLimit,
    bool terminee = false,
  })  : _titre = titre,
        _priorite = priorite,
        _dateLimit = dateLimit,
        _terminee = terminee {
    if (titre.trim().isEmpty) {
      throw TacheValidationException("Le titre ne peut pas être vide.");
    }
  }

  String get titre => _titre;

  Priorite get priorite => _priorite;

  String? get dateLimit => _dateLimit;

  bool get terminee => _terminee;

  set titre(String titre) {
    if (titre.trim().isEmpty) {
      throw TacheValidationException("Le titre ne peut pas être vide.");
    }

    _titre = titre;
  }

  set priorite(Priorite priorite) {
    _priorite = priorite;
  }

  set dateLimit(String? dateLimit) {
    _dateLimit = dateLimit;
  }

  @override
  void marquerTerminee() {
    _terminee = true;
  }

  Map<String, dynamic> toJson();

  factory Tache.fromJson(Map<String, dynamic> json) {
    final type = json["type"];

    switch (type) {
      case "normal":
        return TacheNormale.fromJson(json);

      case "urgent":
        return UrgentTask.fromJson(json);

      default:
        throw TacheValidationException("Type de tâche inconnu : $type");
    }
  }
}
