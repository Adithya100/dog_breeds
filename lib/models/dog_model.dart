class DogBreeds {
  Map<String, List<String>> message;
  Map<String, List<String>> breedImages;
  String status;

  DogBreeds({
    required this.message,
    required this.breedImages,
    required this.status,
  });

  factory DogBreeds.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>> breedNamesMap = {};
    Map<String, List<String>> breedImagesMap = {};

    (json['message'] as Map<String, dynamic>).forEach((key, value) {
      if (value is List<dynamic>) {
        breedNamesMap[key] = List<String>.from(value);
        breedImagesMap[key] = <String>[];
      } else {
        breedNamesMap[key] = <String>[];
        breedImagesMap[key] = <String>[];
      }
    });

    return DogBreeds(
      message: breedNamesMap,
      breedImages: breedImagesMap,
      status: json['status'],
    );
  }
}
