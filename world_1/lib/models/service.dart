class Service {
  final String id;
  final String title;
  final String description;
  final double price;
  final String duration;
  final double rating;
  final String imageUrl;
  final String serviceType;
  final Location location;
  final bool isActive;

  Service({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.rating,
    required this.imageUrl,
    required this.serviceType,
    required this.location,
    required this.isActive,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      duration: json['duration'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      serviceType: json['serviceType'] ?? '',
      location: Location.fromJson(json['location'] ?? {}),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'duration': duration,
      'rating': rating,
      'imageUrl': imageUrl,
      'serviceType': serviceType,
      'location': location.toJson(),
      'isActive': isActive,
    };
  }
}

class Location {
  final double latitude;
  final double longitude;
  final String address;

  Location({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}

