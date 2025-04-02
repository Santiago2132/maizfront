import 'package:flutter/material.dart';
import 'package:mAIz/screens/navegator/main_screen.dart';
import 'package:mAIz/screens/payment/premiumCard.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text( 'Métodos de Pago',
          style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.deepPurple,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white,),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                  (route) => false,
                );
            }, 
          ),
        ),
      body: Center(
        child: PremiumPlanCard(
          onSelect: () {
            _showPaymentDialog(context);
          },
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar compra'),
        content: const Text('¿Quieres adquirir el plan premium por 99 MXN/mes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Compra realizada con éxito')),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
