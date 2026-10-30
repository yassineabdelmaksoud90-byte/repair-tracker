class Intervention {
  final String numero;
  final String etat;
  final double prix;
  final String materielType;
  final String materielMarque;
  final String dateEntree;
  final String? dateReparation;

  Intervention({
    required this.numero,
    required this.etat,
    required this.prix,
    required this.materielType,
    required this.materielMarque,
    required this.dateEntree,
    this.dateReparation,
  });

  factory Intervention.fromJson(Map<String, dynamic> json) {
    return Intervention(
      numero: json['numero'].toString(),
      etat: json['etat'].toString(),
      prix: double.tryParse(json['prix'].toString()) ?? 0.0,
      materielType: json['materiel_type']?.toString() ?? '',
      materielMarque: json['materiel_marque']?.toString() ?? '',
      dateEntree: json['date_entree']?.toString() ?? '',
      dateReparation: json['date_reparation']?.toString(),
    );
  }

  String get etatLabel {
    switch (etat) {
      case 'saisie': return 'Saisie';
      case 'offre': return 'Offre envoyée';
      case 'en_cours': return 'En cours';
      case 'repare': return 'Réparé';
      case 'non_reparable': return 'Non réparable';
      default: return etat;
    }
  }
}