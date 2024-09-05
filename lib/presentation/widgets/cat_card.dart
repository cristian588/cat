import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/cat_model.dart';

class CatCard extends StatelessWidget {
  final CatBreed breed;

  CatCard({required this.breed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/catDetail/${breed.id}');
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    breed.name,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("More")
                ],
              ),
              const SizedBox(height: 10.0),
              breed.imageUrl != null
                  ? Image.network(
                      breed.imageUrl!,
                      height: 250,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.pets,
                      size: 100,
                    ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Origin Country',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          breed.origin,
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Intelligence',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          breed.intelligence.toString(),
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 4.0),
            ],
          ),
        ),
      ),
    );
  }
}
