import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
    case '/login':
      return MaterialPageRoute(builder: (_) => const LoginPage());
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(body: Center(child: Text('404'))),
      );
  }
}
