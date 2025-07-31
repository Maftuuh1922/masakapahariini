import 'package:flutter/material.dart';

class TrendingRecipes extends StatelessWidget {
  final List recipes; // List<Recipe>
  const TrendingRecipes({Key? key, required this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recipes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.restaurant)),
            title: Text(recipe.title),
            subtitle: Text(recipe.description),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.pink[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(recipe.difficulty, style: const TextStyle(fontSize: 12, color: Colors.pink)),
            ),
            onTap: () {},
          ),
        );
      },
    );
  }
}
