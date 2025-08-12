import 'package:flutter/material.dart';

class PaymentSettingsPage extends StatelessWidget {
  const PaymentSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Settings"),
        backgroundColor: Colors.lightBlue.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Manage Payment Methods",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.blue),
              title: const Text("Add Credit/Debit Card"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Add Card feature coming soon")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: Colors.blue),
              title: const Text("Link E-Wallet"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Link E-Wallet feature coming soon")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.payments, color: Colors.blue),
              title: const Text("Payment History"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Payment History feature coming soon")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
