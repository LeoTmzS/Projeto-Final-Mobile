import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import './widgets/widgets.dart';
import './views/views.dart';
import 'bindings/initial_binding.dart';
import './database/app_database.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  // Registrar os services globais

  WidgetsFlutterBinding.ensureInitialized();

  // Inicialização do banco para desktop (Windows, Linux, MacOS)
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await GetStorage.init(); // Inicializa o GetStorage

  // Inicializa o banco de dados local
  await AppDatabase().database;

  // Inicializa locale para pt_BR
  await initializeDateFormatting('pt_BR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loja de Produtos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        primaryColor: const Color.fromARGB(255, 201, 7, 7),
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 83, 2, 2),
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 153, 6, 6),
          foregroundColor: Colors.white,
          elevation: 6,
          shape: StadiumBorder(),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
          bodySmall: TextStyle(fontSize: 12, color: Colors.black54),
          titleLarge: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color.fromARGB(255, 167, 4, 4),
          selectedColor: const Color.fromARGB(255, 0, 102, 255),
          secondarySelectedColor: const Color.fromARGB(255, 0, 60, 255),
          labelStyle: const TextStyle(color: Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const MainNavigationPage(),
          binding: InitialBinding(),
        ),
        GetPage(name: '/cart', page: () => CartPage()),
        GetPage(name: '/category/:category', page: () => CategoryPage()),
        GetPage(name: '/signup', page: () => const SignUpPage()),
        GetPage(name: '/login', page: () => const LoginPage()),
      ],
    );
  }
}
