import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'viewmodels/champion_view_model.dart';
import 'services/champion_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ChampionService>(
          create: (_) => ChampionService(),
        ),
        ChangeNotifierProvider<ChampionViewModel>(
          create: (context) => ChampionViewModel(
            context.read<ChampionService>(),
          ),
        ),
      ],
      child: Consumer<ChampionViewModel>(
        builder: (context, viewModel, child) {
          return MaterialApp(
            title: 'LoL Champions',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: Colors.deepPurple,
                useMaterial3: true,
                scaffoldBackgroundColor: const Color(0xFFF5F5F5),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                )
            ),
            darkTheme: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Colors.deepPurple,
                useMaterial3: true,
                scaffoldBackgroundColor: const Color(0xFF121212),
                appBarTheme: AppBarTheme(
                  backgroundColor: Colors.grey[900],
                  foregroundColor: Colors.white,
                )
            ),
            themeMode: viewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}