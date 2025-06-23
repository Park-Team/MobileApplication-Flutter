class PaymentMethod {
  final String id;
  final String cardNumber;
  final String cardType;
  final String cardHolder;
  final String expiryDate;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.cardNumber,
    required this.cardType,
    required this.cardHolder,
    required this.expiryDate,
    this.isDefault = false,
  });

  // Método para obtener el número de tarjeta enmascarado
  String get maskedCardNumber {
    if (cardNumber.length >= 4) {
      return '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
    }
    return cardNumber;
  }

  // Método para determinar el tipo de tarjeta basado en el número
  static String getCardTypeFromNumber(String cardNumber) {
    String cleanNumber = cardNumber.replaceAll(' ', '');
    
    if (cleanNumber.startsWith('4')) {
      return 'Visa';
    } else if (cleanNumber.startsWith('5') || cleanNumber.startsWith('2')) {
      return 'Mastercard';
    } else if (cleanNumber.startsWith('3')) {
      return 'American Express';
    } else {
      return 'Otra';
    }
  }

  // Método factory para crear desde Map
  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] ?? '',
      cardNumber: map['cardNumber'] ?? '',
      cardType: map['cardType'] ?? '',
      cardHolder: map['cardHolder'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }

  // Método para convertir a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'cardType': cardType,
      'cardHolder': cardHolder,
      'expiryDate': expiryDate,
      'isDefault': isDefault,
    };
  }

  // Método copyWith para crear copias modificadas
  PaymentMethod copyWith({
    String? id,
    String? cardNumber,
    String? cardType,
    String? cardHolder,
    String? expiryDate,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      cardType: cardType ?? this.cardType,
      cardHolder: cardHolder ?? this.cardHolder,
      expiryDate: expiryDate ?? this.expiryDate,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
