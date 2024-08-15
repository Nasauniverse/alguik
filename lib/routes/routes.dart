import 'package:alguik/view/dashboard.dart';
import 'package:alguik/view/halaman.dart';
import 'package:flutter/material.dart';

const String initRoute = "/dashboard";
const String halamanRoute = "/halaman";

class Routes {
  static Route<dynamic> generateRoute(RouteSettings sett) {
    switch (sett.name) {
      case halamanRoute:
        return MaterialPageRoute(builder: (_) => HalamanPage());
      case initRoute:
        return MaterialPageRoute(builder: (_) => DashboardPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                '404 Not Found !! \n${sett.name}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
    }
  }
}
