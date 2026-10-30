import 'package:flutter_test/flutter_test.dart';
import 'package:cisen_app/models/intervention.dart';

void main() {
  test('Intervention.fromJson parse la réponse de l\'API', () {
    final i = Intervention.fromJson({
      'numero': '101',
      'etat': 'en_cours',
      'prix': 150.0,
      'materiel_type': 'Imprimante',
      'materiel_marque': 'HP',
      'date_entree': '2026-09-01',
      'date_reparation': null,
    });

    expect(i.numero, '101');
    expect(i.etat, 'en_cours');
    expect(i.etatLabel, 'En cours');
    expect(i.prix, 150.0);
    expect(i.dateReparation, isNull);
  });
}