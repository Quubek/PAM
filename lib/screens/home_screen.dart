import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/champion_view_model.dart';
import 'champion_list_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChampionViewModel>(context, listen: false).loadChampions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                Hero(
                  tag: 'app_logo',
                  child: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/League_of_Legends_2019_vector.svg/1200px-League_of_Legends_2019_vector.svg.png',
                    height: 120,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        'League of Legends',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                          height: 120,
                          child: Center(child: CircularProgressIndicator())
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Informacje',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1
                  ),
                ),

                const SizedBox(height: 30),

                _buildHomeButton(
                    context,
                    'Lista Bohaterów',
                    Icons.people_alt_outlined,
                    const ChampionListScreen()
                ),
                const SizedBox(height: 12),
                _buildHomeButton(
                    context,
                    'Ustawienia',
                    Icons.settings_outlined,
                    const SettingsScreen()
                ),

                const SizedBox(height: 30),

                Consumer<ChampionViewModel>(
                  builder: (context, vm, _) {
                    if (vm.randomChampion != null) {
                      return InkWell(
                        onTap: () {
                        },
                        child: Container(
                          height: 280,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8)
                              )
                            ],
                            image: DecorationImage(
                              image: NetworkImage(vm.randomChampion!.splashImageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(24),
                                    topRight: Radius.circular(24)
                                ),
                                gradient: LinearGradient(
                                    colors: [Colors.black, Colors.transparent],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    stops: [0.0, 0.8]
                                )
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vm.randomChampion!.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                      shadows: [Shadow(color: Colors.black, blurRadius: 10)]
                                  ),
                                ),
                                Text(
                                  vm.randomChampion!.title,
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        height: 280,
                        decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(24)
                        ),
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeButton(
      BuildContext context, String text, IconData icon, Widget screen) {
    return SizedBox(
      height: 55,
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 26),
        label: Text(text, style: const TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      ),
    );
  }
}