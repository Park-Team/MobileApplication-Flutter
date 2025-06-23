class Reservation {
  final String id;
  final String parkingId;
  final String guestId;
  final DateTime startTime;
  final DateTime endTime;
  final String status; // active, completed, cancelled
  final double priceTotal;
  final DateTime createdAt;
  
  // Display fields for UI compatibility
  final String? parkingName;
  final String? parkingAddress;
  
  Reservation({
    required this.id,
    required this.parkingId,
    required this.guestId,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.priceTotal,
    DateTime? createdAt,
    this.parkingName,
    this.parkingAddress,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] as String,
      parkingId: json['parkingId'] as String,
      guestId: json['guestId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      status: json['status'] as String,
      priceTotal: (json['priceTotal'] as num).toDouble(),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      parkingName: json['parkingName'] as String?,
      parkingAddress: json['parkingAddress'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parkingId': parkingId,
      'guestId': guestId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status,
      'priceTotal': priceTotal,
      'createdAt': createdAt.toIso8601String(),
      'parkingName': parkingName,
      'parkingAddress': parkingAddress,
    };
  }

  Reservation copyWith({
    String? id,
    String? parkingId,
    String? guestId,
    DateTime? startTime,
    DateTime? endTime,
    String? status,
    double? priceTotal,
    DateTime? createdAt,
    String? parkingName,
    String? parkingAddress,
  }) {
    return Reservation(
      id: id ?? this.id,
      parkingId: parkingId ?? this.parkingId,
      guestId: guestId ?? this.guestId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      priceTotal: priceTotal ?? this.priceTotal,
      createdAt: createdAt ?? this.createdAt,
      parkingName: parkingName ?? this.parkingName,
      parkingAddress: parkingAddress ?? this.parkingAddress,
    );
  }

  // Helper methods
  Duration get duration => endTime.difference(startTime);
  
  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  
  bool get isUpcoming => startTime.isAfter(DateTime.now());
  bool get isOngoing => DateTime.now().isAfter(startTime) && DateTime.now().isBefore(endTime);
  bool get isPast => endTime.isBefore(DateTime.now());

  @override
  String toString() {
    return 'Reservation{id: $id, parkingId: $parkingId, status: $status, priceTotal: $priceTotal}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Reservation &&
        other.id == id &&
        other.parkingId == parkingId &&
        other.guestId == guestId &&
        other.startTime == startTime &&
        other.endTime == endTime;
  }

  @override
  int get hashCode {
    return Object.hash(id, parkingId, guestId, startTime, endTime);
  }
}
