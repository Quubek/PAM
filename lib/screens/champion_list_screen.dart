import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/champion_model.dart';
import '../viewmodels/champion_view_model.dart';
import 'champion_detail_screen.dart';

class ChampionListScreen extends StatelessWidget {
  const ChampionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista Bohaterów')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Wyszukaj...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                filled: true,
              ),
              onChanged: (val) {
                context.read<ChampionViewModel>().searchChampions(val);
              },
            ),
          ),
          Expanded(
            child: Consumer<ChampionViewModel>(
              builder: (context, vm, _) {
                if (vm.state == ViewState.loading) return const Center(child: CircularProgressIndicator());

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: vm.filteredChampions.length,
                  itemBuilder: (ctx, i) => _buildBigTile(ctx, vm.filteredChampions[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBigTile(BuildContext context, Champion champion) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => ChampionDetailScreen(championId: champion.id, championName: champion.name),
          ));
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
              child: Image.network(
                champion.imageUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (_,__,___) => const Icon(Icons.error, size: 50),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    champion.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    champion.title,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600], fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}