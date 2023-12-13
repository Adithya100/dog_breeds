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

          return DogList(dogBreeds, dogApiService);
        },
      ),
    );
  }
}

class DogList extends StatelessWidget {
  final DogBreeds dogBreeds;
  final DogApiService dogApiService; // Add this line

  const DogList(this.dogBreeds, this.dogApiService, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dogBreeds.message.length,
      itemBuilder: (context, index) {
        String breed = dogBreeds.message.keys.elementAt(index);
        List<String> subBreeds = dogBreeds.message[breed]!;

        // Fetch images
        Future<List<String>> fetchImages() async {
          try {
            return await dogApiService.fetchRandomImagesByBreed(breed);
          } catch (error) {
            print('Error fetching images for breed $breed: $error');
            return [];
          }
        }

        return FutureBuilder<List<String>>(
          future: fetchImages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              List<String> breedImages = snapshot.data ?? [];

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 6.0,
                ),
                child: GestureDetector(
                  onTap: () async {
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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        top: 12,
                        bottom: 12,
                        right: 8,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (breedImages.isNotEmpty)
                                Expanded(
                                  child: Image.network(
                                    breedImages.first,
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return Image.asset(
                                          'assets/placeholder.png',
                                          fit: BoxFit.cover,
                                          height: 200,
                                          width: 200);
                                    },
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
