import 'package:flutter/material.dart';
import 'package:proyectodificil/config/theme.dart';
import 'router.dart';

class ProyectoDificilApp extends StatelessWidget {
  const ProyectoDificilApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mini Bloc de Notas Inteligente',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}