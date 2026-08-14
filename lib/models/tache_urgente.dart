import 'tache.dart';

class UrgentTask extends Tache {
  UrgentTask(String titre, {String? dateLimit, bool terminee = false})
    : super(titre, Priorite.high, dateLimit: dateLimit, terminee: terminee);

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "urgent",
      "titre": titre,
      "priorite": priorite.name,
      "dateLimit": dateLimit,
      "terminee": terminee,
    };
  }

  factory UrgentTask.fromJson(Map<String, dynamic> json) {
    return UrgentTask(
      json["titre"] as String,
      dateLimit: json["dateLimit"] as String?,
      terminee: json["terminee"] as bool? ?? false,
    );
  }
}
