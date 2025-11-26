import 'package:flutter/material.dart';
import '../models/champion_model.dart';

class ChampionSkinsScreen extends StatelessWidget {
  final String championName;
  final List<Skin> skins;

  const ChampionSkinsScreen({super.key, required this.championName, required this.skins});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Skiny: $championName')),
      body: PageView.builder(
        itemCount: skins.length,
        itemBuilder: (context, index) {
          final skin = skins[index];
          return Container(
            margin: const EdgeInsets.all(10),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.network(
                      skin.skinImageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (ctx, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (_,__,___) => const Center(child: Icon(Icons.broken_image, size: 50)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.black87,
                    child: Text(
                      skin.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}