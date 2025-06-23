class PaymentCard {
  final String id;
  final String userId;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cardType;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentCard({
    required this.id,
    required this.userId,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cardType,
    this.isDefault = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Propiedades adicionales para compatibilidad
  String get brand => cardType;
  String get number => cardNumber;
  String get last4 => lastFourDigits;
  int get expMonth {
    if (expiryDate.contains('/')) {
      return int.tryParse(expiryDate.split('/')[0]) ?? 1;
    }
    return 1;
  }
  int get expYear {
    if (expiryDate.contains('/')) {
      var year = int.tryParse(expiryDate.split('/')[1]) ?? DateTime.now().year;
      if (year < 100) {
        year += 2000;
      }
      return year;
    }
    return DateTime.now().year;
  }

  // Crear desde JSON
  factory PaymentCard.fromJson(Map<String, dynamic> json) {
    return PaymentCard(
      id: json['id'] as String,
      userId: json['userId'] as String,
      cardNumber: json['cardNumber'] as String,
      cardHolderName: json['cardHolderName'] as String,
      expiryDate: json['expiryDate'] as String,
      cardType: json['cardType'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'cardNumber': _maskCardNumber(cardNumber),
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'cardType': cardType,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Enmascarar número de tarjeta para mostrar
  String _maskCardNumber(String cardNumber) {
    if (cardNumber.length < 4) return cardNumber;
    return '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
  }

  // Obtener número de tarjeta enmascarado
  String get maskedCardNumber => _maskCardNumber(cardNumber);

  // Obtener los últimos 4 dígitos
  String get lastFourDigits {
    if (cardNumber.length < 4) return cardNumber;
    return cardNumber.substring(cardNumber.length - 4);
  }

  // Copia con modificaciones
  PaymentCard copyWith({
    String? id,
    String? userId,
    String? cardNumber,
    String? cardHolderName,
    String? expiryDate,
    String? cardType,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentCard(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expiryDate: expiryDate ?? this.expiryDate,
      cardType: cardType ?? this.cardType,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'PaymentCard{id: $id, userId: $userId, cardNumber: $maskedCardNumber, cardHolderName: $cardHolderName, cardType: $cardType, isDefault: $isDefault}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentCard &&
        other.id == id &&
        other.userId == userId &&
        other.cardNumber == cardNumber &&
        other.cardHolderName == cardHolderName &&
        other.expiryDate == expiryDate &&
        other.cardType == cardType &&
        other.isDefault == isDefault;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      cardNumber,
      cardHolderName,
      expiryDate,
      cardType,
      isDefault,
    );
  }
}
