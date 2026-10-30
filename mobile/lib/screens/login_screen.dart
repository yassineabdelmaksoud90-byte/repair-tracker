import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/intervention.dart';
import 'status_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final gsmController = TextEditingController();
  final numeroController = TextEditingController();
  String? errorMessage;
  bool isLoading = false;

  Future<void> handleLogin() async {
    final gsm = gsmController.text.trim();
    final numero = numeroController.text.trim();

    if (gsm.isEmpty || numero.isEmpty) {
      setState(() => errorMessage = "Veuillez remplir tous les champs");
      return;
    }

    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    try {
      // login() now returns BOTH the client data AND a token
      final result = await ApiService.login(gsm, numero);
      final clientData = result['client'];
      final token = result['token'];

      final intervention = Intervention.fromJson(clientData);
      final nom = clientData['nom'] ?? '';

      setState(() => isLoading = false);
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StatusScreen(
            intervention: intervention,
            clientNom: nom,
            token: token, // <-- passing the token forward now, not the gsm
          ),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceAll("Exception: ", "");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1565C0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/logo.png', height: 120),
                const SizedBox(height: 12),
                const Text(
                  "CISEN COMPUTER",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const Text(
                  "Suivi de réparation",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: gsmController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Numéro GSM",
                          prefixIcon: Icon(Icons.phone_android),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: numeroController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Numéro d'intervention",
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : handleLogin,
                          child: isLoading
                              ? const SizedBox(
                                  height: 20, width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text("Se connecter"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}