import 'package:flutter/material.dart';
import '../../../screens/payment.dart'; // Import PaymentScreen

class BuyButton extends StatelessWidget {
  const BuyButton({Key? key}) : super(key: key); // Konstruktor tanpa parameter

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1363BF),
            Color(0xFF063871),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextButton(
        onPressed: () {
          // Navigasi ke halaman pembayaran (PaymentScreen)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreen(), // Arahkan ke PaymentScreen
            ),
          );
        },
        child: Text(
          "Buy Now",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
