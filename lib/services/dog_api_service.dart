import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dog_model.dart';

class DogApiService {
  final String apiUrl = 'https://dog.ceo/api/breeds/list/all';

  Future<DogBreeds> fetchDogBreeds() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return DogBreeds.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load dog breeds');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
