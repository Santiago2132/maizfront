import 'package:flutter/material.dart';
import 'package:mAIz/screens/payment/PaymentMethodsPage.dart';

class PaymentCardButton extends StatelessWidget {
  const PaymentCardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        leading: const Icon(Icons.payment, color: Colors.deepPurple),
        title: const Text(
          'Planes y Métodos de Pago',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('Adquiere el plan premium y accede a todas las funciones.'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PaymentMethodsPage()),
          );
        },
      ),
    );
  }
}
