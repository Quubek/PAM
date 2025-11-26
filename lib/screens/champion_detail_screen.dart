import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/champion_model.dart';
import '../viewmodels/champion_view_model.dart';
import 'ability_detail_screen.dart';
import 'champion_skins_screen.dart';

class ChampionDetailScreen extends StatelessWidget {
  final String championId;
  final String championName;

  const ChampionDetailScreen({super.key, required this.championId, required this.championName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(championName),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<ChampionDetail>(
        future: context.read<ChampionViewModel>().getChampionDetails(championId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) return const Center(child: Text('Błąd pobierania danych'));

          final d = snapshot.data!;
          final splashUrl = 'https://ddragon.leagueoflegends.com/cdn/img/champion/splash/${d.id}_0.jpg';

          final bool hasStats = (d.info.attack + d.info.defense + d.info.magic + d.info.difficulty) > 0;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Splash Art
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(splashUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(d.name, style: Theme.of(context).textTheme.headlineLarge),
                      Text(d.blurb, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: _buildNavBtn(context, 'Umiejętności', Icons.flash_on,
                                AbilityDetailScreen(
                                    championName: d.name,
                                    spells: d.spells,
                                    passive: d.passive,
                                    championId: d.id
                                )
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildNavBtn(context, 'Skiny (${d.skins.length})', Icons.palette,
                                ChampionSkinsScreen(championName: d.name, skins: d.skins)
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      if (hasStats) ...[
                        const Divider(),
                        const Text("Statystyki", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]
                          ),
                          child: Column(
                            children: [
                              _buildStatRow("Atak", d.info.attack, Colors.redAccent),
                              const SizedBox(height: 8),
                              _buildStatRow("Obrona", d.info.defense, Colors.green),
                              const SizedBox(height: 8),
                              _buildStatRow("Magia", d.info.magic, Colors.blueAccent),
                              const SizedBox(height: 8),
                              _buildStatRow("Trudność", d.info.difficulty, Colors.purpleAccent),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                      ],

                      if (d.allyTips.isNotEmpty || d.enemyTips.isNotEmpty) ...[
                        if (!hasStats) const Divider(),
                        const Text("Porady Taktyczne", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),

                        if (d.allyTips.isNotEmpty)
                          _buildTipsSection("Jak grać ${d.name}?", d.allyTips, Colors.teal),

                        const SizedBox(height: 15),

                        if (d.enemyTips.isNotEmpty)
                          _buildTipsSection("Jak grać PRZECIWKO?", d.enemyTips, Colors.redAccent),
                      ],

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatRow(String label, int value, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Row(
            children: List.generate(10, (index) {
              bool isFilled = index < value;
              return Expanded(
                child: Container(
                  height: 15,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isFilled ? color : Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 10),
        Text("$value/10", style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildTipsSection(String title, List<String> tips, Color headerColor) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: headerColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        title: Text(title, style: TextStyle(color: headerColor, fontWeight: FontWeight.bold, fontSize: 18)),
        iconColor: headerColor,
        children: tips.map((tip) => ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: const Icon(Icons.arrow_right, size: 28),
          title: Text(
            tip,
            style: const TextStyle(
              fontSize: 16.0,
              height: 1.4,
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildNavBtn(BuildContext context, String title, IconData icon, Widget page) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 18),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).cardColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
    );
  }
}