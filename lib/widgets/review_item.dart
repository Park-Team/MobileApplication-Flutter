import 'package:flutter/material.dart';
import '../models/review.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/debug_logger.dart';

class ReviewItem extends StatelessWidget {
  final String userId;
  final String userName;
  final String comment;
  final double rating;
  final DateTime createdAt;
  
  const ReviewItem({
    super.key,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });
    factory ReviewItem.fromReview(Review review) {
    // Validar el comentario antes de crear el widget
    String validComment = "Sin comentario";
    
    if (review.comment.isNotEmpty && review.comment != "null") {
      validComment = review.comment;
      DebugLogger.logReviewInfo("ReviewItem: Usando comentario existente: '${validComment.length > 30 ? "${validComment.substring(0, 30)}..." : validComment}'");
    } else {
      DebugLogger.logReviewInfo("ReviewItem: Comentario inválido, usando texto predeterminado");
    }
      return ReviewItem(
      userId: review.userId,
      userName: review.userName ?? 'Usuario',
      comment: validComment,
      rating: review.rating,
      createdAt: review.date,
    );
  }
    String _formatDate(DateTime date) {
    // Lista de nombres de meses
    final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    
    // Obtener tiempo transcurrido
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays < 1) {
      if (difference.inHours < 1) {
        return "Hace ${difference.inMinutes} min";
      } else {
        return "Hace ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}";
      }
    } else if (difference.inDays < 7) {
      return "Hace ${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'}";
    } else if (difference.inDays < 365) {
      return "${date.day} ${months[date.month - 1]}";
    } else {
      return "${date.day} ${months[date.month - 1]} ${date.year}";
    }
  }
    @override
  Widget build(BuildContext context) {
    // Verificar si esta reseña es del usuario actual
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bool isCurrentUserReview = authProvider.currentUser != null && 
                                    authProvider.currentUser!.id == userId;    DebugLogger.logReviewInfo('📝 REVIEW DISPLAY - Usuario: $userName, Rating: $rating');
    debugPrint('📝 Comentario: "${comment.length > 50 ? "${comment.substring(0, 50)}..." : comment}"');
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: isCurrentUserReview 
          ? Border.all(color: const Color(0xFFE65C2D), width: 2.0)
          : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 20.0,
                      color: Color(0xFFE65C2D),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrentUserReview)
                      Container(
                        margin: const EdgeInsets.only(left: 8.0),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE65C2D).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Text(
                          'Tu reseña',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Color(0xFFE65C2D),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                _formatDate(createdAt),
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),          // Container mejorado para el comentario con mayor visibilidad
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.format_quote,
                      color: Color(0xFFE65C2D),
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Comentario del Usuario:",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE65C2D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),                // Validación mejorada del comentario
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    (comment.isEmpty || comment == 'Sin comentario' || comment == 'null') 
                      ? "El usuario no dejó ningún comentario." 
                      : comment,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: comment.isEmpty ? Colors.grey.shade500 : Colors.black87,
                      height: 1.5,
                      letterSpacing: 0.2,
                      fontStyle: comment.isEmpty ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),          Row(
            children: [
              ...List.generate(
                5,
                (index) => Icon(
                  index < rating.floor() 
                    ? Icons.star
                    : (index < rating && index >= rating.floor())
                      ? Icons.star_half
                      : Icons.star_border,
                  color: const Color(0xFFE65C2D),
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                rating.toStringAsFixed(1),
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
