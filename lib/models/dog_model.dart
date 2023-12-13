class DogBreeds {
  Map<String, List<String>> message;
  String status;

  DogBreeds({required this.message, required this.status});

  factory DogBreeds.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>> breedMap = {};
    (json['message'] as Map<String, dynamic>).forEach((key, value) {
      if (value is List<dynamic>) {
        breedMap[key] = List<String>.from(value);
      } else {
        breedMap[key] = <String>[]; // Set empty list if the value is not List<String>
      }
    });

    return DogBreeds(
      message: breedMap,
      status: json['status'],
    );
  }
}
