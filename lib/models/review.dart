class Review {
  final String id;
  final String parkingId;
  final String userId;
  final double rating;
  final String comment;
  final DateTime date;
  
  // Display fields for UI compatibility
  final String? userName;
  
  Review({
    required this.id,
    required this.parkingId,
    required this.userId,
    required this.rating,
    required this.comment,
    DateTime? date,
    this.userName,
  }) : date = date ?? DateTime.now();

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      parkingId: json['parkingId'] as String,
      userId: json['userId'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      date: json['date'] != null 
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      userName: json['userName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parkingId': parkingId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'userName': userName,
    };
  }

  Review copyWith({
    String? id,
    String? parkingId,
    String? userId,
    double? rating,
    String? comment,
    DateTime? date,
    String? userName,
  }) {
    return Review(
      id: id ?? this.id,
      parkingId: parkingId ?? this.parkingId,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      date: date ?? this.date,
      userName: userName ?? this.userName,
    );
  }

  @override
  String toString() {
    return 'Review{id: $id, parkingId: $parkingId, rating: $rating, comment: $comment}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Review &&
        other.id == id &&
        other.parkingId == parkingId &&
        other.userId == userId &&
        other.rating == rating &&
        other.comment == comment;
  }

  @override
  int get hashCode {
    return Object.hash(id, parkingId, userId, rating, comment);
  }
}
