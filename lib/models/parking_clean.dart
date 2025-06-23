class AvailableSchedule {
  final String day;
  final String start;
  final String end;

  AvailableSchedule({
    required this.day,
    required this.start,
    required this.end,
  });

  factory AvailableSchedule.fromJson(Map<String, dynamic> json) {
    return AvailableSchedule(
      day: json['day'] ?? '',
      start: json['start'] ?? '',
      end: json['end'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'start': start,
      'end': end,
    };
  }
}

class ParkingLocation {
  final double latitude;
  final double longitude;

  ParkingLocation({
    required this.latitude,
    required this.longitude,
  });

  factory ParkingLocation.fromJson(Map<String, dynamic> json) {
    return ParkingLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class Parking {
  final String id;
  final String ownerId;
  final String name;
  final String address;
  final String description;
  final double pricePerHour;
  final ParkingLocation location;
  final List<AvailableSchedule> availableSchedules;
  final List<String> images;
  final int totalSpaces;
  final List<String> features;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Parking({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.address,
    required this.description,
    required this.pricePerHour,
    required this.location,
    required this.availableSchedules,
    required this.images,
    required this.totalSpaces,
    required this.features,
    this.rating = 0.0,
    this.reviewCount = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      description: json['description'] as String,
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
      location: ParkingLocation.fromJson(json['location'] as Map<String, dynamic>),
      availableSchedules: (json['availableSchedules'] as List)
          .map((schedule) => AvailableSchedule.fromJson(schedule as Map<String, dynamic>))
          .toList(),
      images: List<String>.from(json['images'] as List),
      totalSpaces: json['totalSpaces'] as int,
      features: List<String>.from(json['features'] as List),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'address': address,
      'description': description,
      'pricePerHour': pricePerHour,
      'location': location.toJson(),
      'availableSchedules': availableSchedules.map((schedule) => schedule.toJson()).toList(),
      'images': images,
      'totalSpaces': totalSpaces,
      'features': features,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Parking copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? address,
    String? description,
    double? pricePerHour,
    ParkingLocation? location,
    List<AvailableSchedule>? availableSchedules,
    List<String>? images,
    int? totalSpaces,
    List<String>? features,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Parking(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      address: address ?? this.address,
      description: description ?? this.description,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      location: location ?? this.location,
      availableSchedules: availableSchedules ?? this.availableSchedules,
      images: images ?? this.images,
      totalSpaces: totalSpaces ?? this.totalSpaces,
      features: features ?? this.features,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Parking{id: $id, name: $name, address: $address, pricePerHour: $pricePerHour}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Parking &&
        other.id == id &&
        other.name == name &&
        other.address == address &&
        other.pricePerHour == pricePerHour;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, address, pricePerHour);
  }
}
