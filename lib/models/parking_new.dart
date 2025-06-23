class Parking {
  final String id;
  final int ownerId;
  final String address;
  final double latitude;
  final double longitude;
  final double width;
  final double length;
  final double height;
  final double pricePerHour;
  final String description;
  final String? imageUrl;
  final String availableFrom;
  final String availableTo;
  final bool isAvailable;
  final String parkingType;

  // Computed properties for compatibility
  double get hourlyRate => pricePerHour;
  List<String> get images => imageUrl != null ? [imageUrl!] : [];
  double get rating => 4.0; // Default rating since API doesn't provide it

  Parking({
    required this.id,
    required this.ownerId,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.width,
    required this.length,
    required this.height,
    required this.pricePerHour,
    required this.description,
    this.imageUrl,
    required this.availableFrom,
    required this.availableTo,
    required this.isAvailable,
    required this.parkingType,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'].toString(),
      ownerId: json['ownerId'] as int,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      length: (json['length'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      availableFrom: json['availableFrom'] as String,
      availableTo: json['availableTo'] as String,
      isAvailable: json['isAvailable'] as bool,
      parkingType: json['parkingType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'width': width,
      'length': length,
      'height': height,
      'pricePerHour': pricePerHour,
      'description': description,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'availableFrom': availableFrom,
      'availableTo': availableTo,
      'isAvailable': isAvailable,
      'parkingType': parkingType,
    };
  }

  Parking copyWith({
    String? id,
    int? ownerId,
    String? address,
    double? latitude,
    double? longitude,
    double? width,
    double? length,
    double? height,
    double? pricePerHour,
    String? description,
    String? imageUrl,
    String? availableFrom,
    String? availableTo,
    bool? isAvailable,
    String? parkingType,
  }) {
    return Parking(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      width: width ?? this.width,
      length: length ?? this.length,
      height: height ?? this.height,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      availableFrom: availableFrom ?? this.availableFrom,
      availableTo: availableTo ?? this.availableTo,
      isAvailable: isAvailable ?? this.isAvailable,
      parkingType: parkingType ?? this.parkingType,
    );
  }

  @override
  String toString() {
    return 'Parking{id: $id, address: $address, pricePerHour: $pricePerHour}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Parking &&
        other.id == id &&
        other.address == address &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return Object.hash(id, address, latitude, longitude);
  }
}
