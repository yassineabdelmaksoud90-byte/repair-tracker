import 'package:flutter/material.dart';
import '../models/intervention.dart';
import '../services/api_service.dart';

class HistoriqueScreen extends StatefulWidget {
  final String token;
  const HistoriqueScreen({super.key, required this.token});

  @override
  State<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  late Future<List<Intervention>> futureHistorique;
  String selectedFilter = "Tous";

  final List<String> filterOptions = [
    "Tous",
    "saisie",
    "offre",
    "en_cours",
    "repare",
    "non_reparable",
  ];

  String filterLabel(String value) {
    switch (value) {
      case "saisie": return "Saisie";
      case "offre": return "Offre";
      case "en_cours": return "En cours";
      case "repare": return "Réparé";
      case "non_reparable": return "Non réparable";
      default: return "Tous";
    }
  }

  @override
  void initState() {
    super.initState();
    futureHistorique = ApiService.getHistorique(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Historique")),
      body: FutureBuilder<List<Intervention>>(
        future: futureHistorique,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }

          final allItems = snapshot.data ?? [];
          final items = selectedFilter == "Tous"
              ? allItems
              : allItems.where((i) => i.etat == selectedFilter).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.filter_list, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Text("Filtrer par état :", style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedFilter,
                        items: filterOptions
                            .map((f) => DropdownMenuItem(value: f, child: Text(filterLabel(f))))
                            .toList(),
                        onChanged: (value) {
                          setState(() => selectedFilter = value!);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text("Aucune intervention pour ce filtre"))
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListTile(
                            title: Text("${item.materielType} ${item.materielMarque}"),
                            subtitle: Text("N° ${item.numero} — ${item.dateEntree}"),
                            trailing: Text(item.etatLabel),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}