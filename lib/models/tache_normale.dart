import 'tache.dart';

class TacheNormale extends Tache {
  TacheNormale(
    String titre,
    Priorite priorite, {
    String? dateLimit,
    bool terminee = false,
  }) : super(titre, priorite, dateLimit: dateLimit, terminee: terminee);

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "normal",
      "titre": titre,
      "priorite": priorite.name,
      "dateLimit": dateLimit,
      "terminee": terminee,
    };
  }

  factory TacheNormale.fromJson(Map<String, dynamic> json) {
    return TacheNormale(
      json["titre"] as String,
      Priorite.values.byName(json["priorite"] as String),
      dateLimit: json["dateLimit"] as String?,
      terminee: json["terminee"] as bool? ?? false,
    );
  }
}
