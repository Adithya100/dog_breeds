// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:dog_breeds/services/dog_api_service.dart';
import 'package:dog_breeds/models/dog_model.dart';
import 'package:dog_breeds/screens/sub_breeds_screen.dart';

class DogScreen extends StatefulWidget {
  const DogScreen({super.key});

  @override
  _DogScreenState createState() => _DogScreenState();
}

class _DogScreenState extends State<DogScreen> {
  late Future<DogBreeds> futureDogBreeds;
  final DogApiService dogApiService = DogApiService();

  @override
  void initState() {
    super.initState();
    futureDogBreeds = dogApiService.fetchDogBreeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Breeds'),
      ),
      body: FutureBuilder(
        future: futureDogBreeds,
        builder: (context, AsyncSnapshot<DogBreeds> dogBreedsSnapshot) {
          if (dogBreedsSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (dogBreedsSnapshot.hasError) {
            return Center(
              child: Text('Error: ${dogBreedsSnapshot.error}'),
            );
          } else if (!dogBreedsSnapshot.hasData) {
            return const Center(
              child: Text('No data available.'),
            );
          }

          DogBreeds dogBreeds = dogBreedsSnapshot.data!;

          return DogList(dogBreeds);
        },
      ),
    );
  }
}

class DogList extends StatelessWidget {
  final DogBreeds dogBreeds;

  const DogList(this.dogBreeds, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dogBreeds.message.length,
      itemBuilder: (context, index) {
        String breed = dogBreeds.message.keys.elementAt(index);
        List<String> subBreeds = dogBreeds.message[breed]!;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 6.0,
          ),
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              if (subBreeds.isNotEmpty) {
                // If sub-breeds, navigate to new screen with list of breeds
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubBreedsScreen(
                      breed: breed,
                      subBreeds: subBreeds,
                    ),
                  ),
                );
              } else {
                // If no sub-breeds, show a static text in SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('No sub-breeds for $breed'),
                  ),
                );
              }
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[300]!,
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, top: 12, bottom: 12, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${breed[0].toUpperCase()}${breed.substring(1)}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 20, // Set your desired icon size
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
