import 'package:flutter/material.dart';
import '../models/intervention.dart';
import 'historique_screen.dart';

class StatusScreen extends StatelessWidget {
  final Intervention intervention;
  final String clientNom;
  final String token; // <-- was "gsm" before, now we carry the token instead

  const StatusScreen({
    super.key,
    required this.intervention,
    required this.clientNom,
    required this.token,
  });

  Color statusColor(String etat) {
    switch (etat) {
      case 'saisie': return Colors.blueGrey;
      case 'offre': return Colors.amber;
      case 'en_cours': return Colors.orange;
      case 'repare': return Colors.green;
      case 'non_reparable': return Colors.grey;
      default: return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bonjour, $clientNom")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${intervention.materielType} ${intervention.materielMarque}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("N° ${intervention.numero}",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    const Divider(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("État", style: TextStyle(color: Colors.grey)),
                        Chip(
                          label: Text(intervention.etatLabel, style: const TextStyle(color: Colors.white, fontSize: 12)),
                          backgroundColor: statusColor(intervention.etat),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Prix", style: TextStyle(color: Colors.grey)),
                        Text("${intervention.prix.toStringAsFixed(0)} DT",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    // pass the token onward, not the gsm
                    builder: (_) => HistoriqueScreen(token: token),
                  ),
                ),
                icon: const Icon(Icons.history),
                label: const Text("Voir l'historique"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}