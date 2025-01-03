import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parkmycar_client_shared/parkmycar_client_stuff.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/screens/main_screen.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ThemeService(),
          ),
        ],
        child: ParkMyCarApp(),
      ),
    ),
  );
}

class ParkMyCarApp extends StatelessWidget {
  const ParkMyCarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkMyCar',
      debugShowCheckedModeBanner: false,
      themeMode: Provider.of<ThemeService>(context).themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Color.fromRGBO(85, 234, 242, 1.0),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Color.fromRGBO(85, 234, 242, 1.0),
      ),
      home: const AuthViewSwitcher(),
    );
  }
}

class AuthViewSwitcher extends StatelessWidget {
  const AuthViewSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: switch (authState.status) {
        AuthStateStatus.authenticated => const MainScreen(), // When logged in
        _ => const LoginScreen(title: 'ParkMyCar'), // For all other cases
      },
    );
  }
}
