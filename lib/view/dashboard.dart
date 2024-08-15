import 'package:alguik/routes/routes.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("dashboard"),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Text(
                "Halaman tes",
                style: TextStyle(fontSize: 100),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, halamanRoute);
                  },
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    child: Text("klik"),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
