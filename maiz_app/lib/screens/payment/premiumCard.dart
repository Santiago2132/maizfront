import 'package:flutter/material.dart';

class PremiumPlanCard extends StatelessWidget {
  final VoidCallback onSelect;

  const PremiumPlanCard({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.deepPurple, size: 50),
            const SizedBox(height: 12),
            const Text(
              'Plan Premium',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '99 MXN/mes',
              style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 20, 20, 20)),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildBenefit('Acceso ilimitado al chat emocional'),
            _buildBenefit('Registro de emociones diario'),
            _buildBenefit('Recomendaciones personalizadas'),
            _buildBenefit('Estadísticas avanzadas'),
            _buildBenefit('Soporte prioritario'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onSelect,
              icon: const Icon(Icons.check_circle, color: Colors.white,),
                label: const Text(
                  'Seleccionar Plan',
                  style: TextStyle(color: Colors.white),
                ),              
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefit(String text) {
    return ListTile(
      leading: const Icon(Icons.check, color: Colors.deepPurple),
      title: Text(text),
    );
  }
}
