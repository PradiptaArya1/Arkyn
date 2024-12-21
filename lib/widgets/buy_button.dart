import 'package:flutter/material.dart';

class BuyButton extends StatelessWidget {
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
        onPressed: () {},
        child: Text(
          "Buy",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
