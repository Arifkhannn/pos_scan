import 'package:flutter/material.dart';
import 'package:pos_scan/screens/Xreport.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Reports',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildReportButton(
                context,
                title: 'X Report',
                icon: Icons.receipt_long_outlined,
                onTap: () {
                  Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ReceiptScreen(),
                          ),
                        );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("X Report tapped")),
                  );
                },
              ),
              const SizedBox(height: 30),
              _buildReportButton(
                context,
                title: 'Z Report',
                icon: Icons.summarize_outlined,
                onTap: () {
                  // TODO: Navigate to Z Report screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Z Report tapped")),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shadowColor: Colors.grey.withOpacity(0.2),
        elevation: 3,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.blueAccent, width: 1.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
