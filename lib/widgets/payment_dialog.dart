import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class PaymentDialog extends StatelessWidget {
  final String parkingName;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;
  final Function() onPaymentCompleted;

  PaymentDialog({
    Key? key,
    required this.parkingName,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.onPaymentCompleted,
  }) : super(key: key);

  void _showAddCardDialog(BuildContext context, String userId) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cardholderNameController = TextEditingController(text: authProvider.currentUser?.name ?? '');
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController expiryDateController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();
    final TextEditingController cardBrandController = TextEditingController();
    bool saveCard = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Card'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: cardholderNameController,
                      decoration: const InputDecoration(
                        labelText: 'Cardholder Name',
                        hintText: 'Enter full name',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: cardBrandController,
                      decoration: const InputDecoration(
                        labelText: 'Card Brand',
                        hintText: 'e.g., Visa, MasterCard',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: cardNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Card Number',
                        hintText: '1234 5678 9012 3456',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: expiryDateController,
                      decoration: const InputDecoration(
                        labelText: 'Expiry Date',
                        hintText: 'MM/YY',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final text = newValue.text;
                          String formattedText = text;

                          if (text.length >= 2 && !text.contains('/')) {
                            formattedText = '${text.substring(0, 2)}/${text.substring(2)}';
                          }

                          return TextEditingValue(
                            text: formattedText,
                            selection: TextSelection.collapsed(offset: formattedText.length),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        hintText: '123',
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: saveCard,
                          onChanged: (value) {
                            setState(() {
                              saveCard = value ?? false;
                            });
                          },
                        ),
                        const Text('Save this card'),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (saveCard) {
                      final expiryParts = expiryDateController.text.split('/');
                      if (expiryParts.length == 2) {
                        final expMonth = int.tryParse(expiryParts[0]);
                        final expYear = int.tryParse('20${expiryParts[1]}');

                        if (expMonth != null && expMonth >= 1 && expMonth <= 12 &&
                            expYear != null && expYear >= DateTime.now().year) {
                          final cardData = {
                            'name': cardholderNameController.text,
                            'brand': cardBrandController.text,
                            'expMonth': expMonth,
                            'expYear': expYear,
                            'number': cardNumberController.text,
                            'default': false,
                          };
                          try {
                            await ApiService.saveCard(userId, cardData);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Card saved successfully!')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Failed to save card.')),
                              );
                            }
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Invalid expiry date. Month: $expMonth, Year: $expYear')),
                            );
                          }
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invalid expiry date format. Please use MM/YY.')),
                          );
                        }
                      }
                    }
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add Card'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPaymentOptions(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Simulated list of saved cards
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text('Visa **** 1234'),
                onTap: () {
                  Navigator.pop(context);
                  onPaymentCompleted();
                },
              ),
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text('MasterCard **** 5678'),
                onTap: () {
                  Navigator.pop(context);
                  onPaymentCompleted();
                },
              ),
              const Divider(),
              // Add new card option
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Add New Card'),
                onTap: () {
                  Navigator.pop(context);
                  _showAddCardDialog(context, userId);
                },
              ),
              const Divider(),
              // Yape QR code option
              ListTile(
                leading: const Icon(Icons.qr_code),
                title: const Text('Pay with Yape'),
                onTap: () {
                  // Show QR code (currently blank)
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Yape QR Code'),
                        content: Container(
                          height: 200,
                          width: 200,
                          color: Colors.grey[300], // Placeholder for QR code
                          child: const Center(
                            child: Text('QR Code Placeholder'),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser?.id;

    if (userId == null) {
      // Handle the case where the user is not logged in or user ID is not available
      return AlertDialog(
        title: const Text('Error'),
        content: const Text('User not authenticated. Please log in to proceed with payment.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text('Payment for $parkingName'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Total amount: \$${totalPrice.toStringAsFixed(2)}'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _showPaymentOptions(context, userId),
            child: const Text('Pay Now'),
          ),
        ],
      ),
    );
  }
}
