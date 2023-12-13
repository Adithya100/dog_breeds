import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dog_breeds/models/dog_model.dart';

class DogApiService {
  final String apiUrlAllBreeds = 'https://dog.ceo/api/breeds/list/all';
  final String apiUrlRandomImage = 'https://dog.ceo/api/breed/';

  Future<DogBreeds> fetchDogBreeds() async {
    try {
      final response = await http.get(Uri.parse(apiUrlAllBreeds));
      if (response.statusCode == 200) {
        return DogBreeds.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load dog breeds');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<List<String>> fetchRandomImagesByBreed(String breed) async {
    try {
      final response =
          await http.get(Uri.parse('$apiUrlRandomImage$breed/images/random/'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final dynamic message = data['message'];

        if (message is String) {
          // If the message is a string, convert it to a list with a single element
          return [message];
        } else if (message is List<dynamic>) {
          // If the message is a list, convert it to a list of strings
          return List<String>.from(message);
        } else {
          throw Exception('Unexpected format for message');
        }
      } else {
        throw Exception('Failed to load random images for breed: $breed');
      }
    } catch (error) {
      throw Exception('Error fetching images for breed: $breed, Error: $error');
    }
  }
}
