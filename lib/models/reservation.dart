class Reservation {
  final String id;
  final int userId;
  final int parkingId;
  final int? vehicleId;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime? actualStartTime;
  final DateTime? actualEndTime;
  final String status; // PENDING, CONFIRMED, ACTIVE, COMPLETED, CANCELLED, EXPIRED
  final double totalPrice;
  final double? finalPrice;
  final String? notes;
  final String? cancellationReason;
    // Computed properties for compatibility
  String get guestId => userId.toString();
  double get priceTotal => totalPrice;
  String? get parkingName => null; // Would need to be fetched separately
  String? get parkingAddress => null; // Would need to be fetched separately
  Duration get duration => endTime.difference(startTime);
  
  Reservation({
    required this.id,
    required this.userId,
    required this.parkingId,
    this.vehicleId,
    required this.startTime,
    required this.endTime,
    this.actualStartTime,
    this.actualEndTime,
    required this.status,
    required this.totalPrice,
    this.finalPrice,
    this.notes,
    this.cancellationReason,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'].toString(),
      userId: json['userId'] as int,
      parkingId: json['parkingId'] as int,
      vehicleId: json['vehicleId'] as int?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      actualStartTime: json['actualStartTime'] != null 
          ? DateTime.parse(json['actualStartTime']) 
          : null,
      actualEndTime: json['actualEndTime'] != null 
          ? DateTime.parse(json['actualEndTime']) 
          : null,
      status: json['status'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      finalPrice: json['finalPrice'] != null 
          ? (json['finalPrice'] as num).toDouble() 
          : null,
      notes: json['notes'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'parkingId': parkingId,
      if (vehicleId != null) 'vehicleId': vehicleId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      if (actualStartTime != null) 'actualStartTime': actualStartTime!.toIso8601String(),
      if (actualEndTime != null) 'actualEndTime': actualEndTime!.toIso8601String(),
      'status': status,
      'totalPrice': totalPrice,
      if (finalPrice != null) 'finalPrice': finalPrice,
      if (notes != null) 'notes': notes,
      if (cancellationReason != null) 'cancellationReason': cancellationReason,
    };
  }

  Reservation copyWith({
    String? id,
    int? userId,
    int? parkingId,
    int? vehicleId,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? actualStartTime,
    DateTime? actualEndTime,
    String? status,
    double? totalPrice,
    double? finalPrice,
    String? notes,
    String? cancellationReason,
  }) {
    return Reservation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      parkingId: parkingId ?? this.parkingId,
      vehicleId: vehicleId ?? this.vehicleId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      actualStartTime: actualStartTime ?? this.actualStartTime,
      actualEndTime: actualEndTime ?? this.actualEndTime,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      finalPrice: finalPrice ?? this.finalPrice,
      notes: notes ?? this.notes,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }

  @override
  String toString() {
    return 'Reservation{id: $id, parkingId: $parkingId, status: $status, totalPrice: $totalPrice}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Reservation &&
        other.id == id &&
        other.userId == userId &&
        other.parkingId == parkingId &&
        other.startTime == startTime &&
        other.endTime == endTime;
  }

  @override
  int get hashCode {
    return Object.hash(id, userId, parkingId, startTime, endTime);
  }
}
