import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyectodificil/app/app.dart';
import 'package:proyectodificil/core/database/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance.initDatabase();
  
  runApp(
    const ProviderScope(
      child: ProyectoDificilApp(),
    ),
  );
}
