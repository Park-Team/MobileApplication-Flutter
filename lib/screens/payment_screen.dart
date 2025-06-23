import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_config.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';

class PaymentScreen extends StatefulWidget {
  final String userId;
  final String parkingId;
  final DateTime startTime;
  final DateTime endTime;
  final double pricePerHour;
  final double totalPrice;

  const PaymentScreen({
    Key? key,
    required this.userId,
    required this.parkingId,
    required this.startTime,
    required this.endTime,
    required this.pricePerHour,
    required this.totalPrice,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pago'),        backgroundColor: AppConfig.primaryBlue,
        foregroundColor: AppConfig.primaryWhite,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen de la reserva
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen de Reserva',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConfig.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildSummaryRow('Estacionamiento:', widget.parkingId),
                    _buildSummaryRow('Inicio:', _formatDateTime(widget.startTime)),
                    _buildSummaryRow('Fin:', _formatDateTime(widget.endTime)),
                    _buildSummaryRow('Precio por hora:', '\$${widget.pricePerHour.toStringAsFixed(2)}'),
                    Divider(),
                    _buildSummaryRow('Total:', '\$${widget.totalPrice.toStringAsFixed(2)}', isTotal: true),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Botón de pago
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _processPayment(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.primaryBlue,
                  foregroundColor: AppConfig.primaryWhite,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Procesar Pago',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppConfig.textSecondary,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isTotal ? AppConfig.primaryBlue : AppConfig.textPrimary,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  void _processPayment() async {
    // Mostrar indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Procesando pago...'),
          ],
        ),
      ),
    );

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUser = authProvider.currentUser;
      
      if (currentUser == null) {
        Navigator.of(context).pop(); // Cerrar indicador de carga
        _showErrorDialog('Error: Usuario no autenticado');
        return;
      }      // Llamada a la API para procesar el pago
      await ApiService.processPayment(
        userId: currentUser.id,
        parkingId: widget.parkingId,
        startTime: widget.startTime,
        endTime: widget.endTime,
        totalAmount: widget.totalPrice,
        paymentMethod: 'card', // Método de pago por defecto
      );

      Navigator.of(context).pop(); // Cerrar indicador de carga

      // Mostrar éxito
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Pago Procesado'),
          content: Text('Su reserva ha sido confirmada exitosamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar dialog
                Navigator.of(context).pop(); // Volver a pantalla anterior
                Navigator.of(context).pop(); // Volver al home
              },
              child: Text('OK'),
            ),
          ],
        ),
      );

    } catch (e) {
      Navigator.of(context).pop(); // Cerrar indicador de carga
      _showErrorDialog('Error al procesar el pago: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
