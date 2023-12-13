import 'package:flutter/material.dart';

class SubBreedsScreen extends StatelessWidget {
  final String breed;
  final List<String> subBreeds;

  const SubBreedsScreen(
      {super.key, required this.breed, required this.subBreeds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${breed[0].toUpperCase()}${breed.substring(1)}'),
      ),
      body: subBreeds.isNotEmpty
          ? ListView.builder(
              itemCount: subBreeds.length,
              itemBuilder: (context, index) {
                final capitalizedSubBreed =
                    '${subBreeds[index][0].toUpperCase()}${subBreeds[index].substring(1)}';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 6.0,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[300]!,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, top: 12, bottom: 12, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            capitalizedSubBreed,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text('No sub-breeds available.'),
            ),
    );
  }
}
