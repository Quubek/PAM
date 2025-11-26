import 'package:flutter/material.dart';
import '../models/champion_model.dart';

class AbilityDetailScreen extends StatelessWidget {
  final String championName;
  final String championId;
  final List<Spell> spells;
  final Passive passive;

  const AbilityDetailScreen({
    super.key,
    required this.championName,
    required this.championId,
    required this.spells,
    required this.passive,
  });

  @override
  Widget build(BuildContext context) {
    final loadingUrl = 'https://ddragon.leagueoflegends.com/cdn/img/champion/loading/${championId}_0.jpg';
    final List<String> spellKeys = ['Q', 'W', 'E', 'R', 'P'];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.deepPurple,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Umiejętności: $championName',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    loadingUrl,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                        stops: [0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Pasywka (Passive)'),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: _buildSpellIcon(passive.imageUrl, 'P', Colors.orange),
                        title: Text(passive.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(passive.description),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    _buildSectionHeader('Zaklęcia (Spells)'),
                    const SizedBox(height: 10),

                    ...spells.asMap().entries.map((entry) {
                      int index = entry.key;
                      Spell spell = entry.value;
                      String keyLetter = index < 4 ? spellKeys[index] : '?';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ExpansionTile(
                          title: Text(spell.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          leading: _buildSpellIcon(spell.imageUrl, keyLetter, Colors.blueAccent),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(spell.description),
                                  const SizedBox(height: 15),
                                  const Divider(),
                                  _buildSpellStatRow(Icons.timer, "Czas odnowienia:", "${spell.cooldown} s"),
                                  _buildSpellStatRow(Icons.water_drop, "Koszt:", spell.cost),
                                  _buildSpellStatRow(Icons.ads_click, "Zasięg:", spell.range),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
        title,
        style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple
        )
    );
  }

  Widget _buildSpellIcon(String imageUrl, String letter, Color borderColor) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: 2),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
              ]
          ),
        ),
        Positioned(
          bottom: -5,
          right: -5,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white30),
            ),
            alignment: Alignment.center,
            child: Text(
              letter,
              style: TextStyle(
                color: borderColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSpellStatRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800])),
          const SizedBox(width: 5),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }
}