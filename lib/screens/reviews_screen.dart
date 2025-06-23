import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/parking_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/review_item.dart';
import '../utils/debug_logger.dart';

class ReviewsScreen extends StatefulWidget {
  final String parkingId;
  
  const ReviewsScreen({
    super.key,
    required this.parkingId,
  });

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReviews();
    });
  }
  
  Future<void> _loadReviews() async {
    final parkingProvider = Provider.of<ParkingProvider>(context, listen: false);
    try {
      DebugLogger.logReviewInfo("Cargando reseñas para el estacionamiento ID: ${widget.parkingId}");
      
      // Siempre refrescar las reseñas cuando se abre la pantalla
      if (parkingProvider.selectedParking == null || 
          parkingProvider.selectedParking!.id != widget.parkingId) {
        DebugLogger.logReviewInfo("No hay estacionamiento seleccionado o es diferente, cargando detalles completos");
        await parkingProvider.selectParking(widget.parkingId);
      } else {
        DebugLogger.logReviewInfo("Estacionamiento ya seleccionado, actualizando solo las reseñas");
        await parkingProvider.fetchParkingReviews(widget.parkingId);
      }
      
      // Debug
      DebugLogger.logReviewInfo("Cargadas ${parkingProvider.selectedParkingReviews.length} reseñas");
      if (parkingProvider.selectedParkingReviews.isNotEmpty) {
        final firstReview = parkingProvider.selectedParkingReviews.first;
        DebugLogger.logReviewInfo("Primera reseña - Usuario: ${firstReview.userName}, Rating: ${firstReview.rating}");
        DebugLogger.logReviewInfo("Comentario de la primera reseña: '${firstReview.comment}'");
      } else {
        DebugLogger.logReviewInfo("No se encontraron reseñas para este estacionamiento");
      }
      
      // Forzar una reconstrucción de la UI
      if (mounted) {
        setState(() {});
      }    } catch (e) {
      DebugLogger.logReviewInfo("Error al cargar reseñas: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al cargar reseñas: $e"))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7A8499), // Blue-gray background
      appBar: EzParkAppBar(
        title: 'EZ Park',
        showMenu: false,
      ),
      body: Consumer<ParkingProvider>(
        builder: (context, parkingProvider, child) {
          if (parkingProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (parkingProvider.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Error loading reviews: ${parkingProvider.error}',
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: _loadReviews,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final parking = parkingProvider.selectedParking;
          if (parking == null) {
            return const Center(
              child: Text('Parking not found'),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title with Address
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  parking.address,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Ratings & Reviews',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Rating Banner
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${parking.rating}/5',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    const Icon(
                      Icons.star,
                      color: Color(0xFFE65C2D),
                    ),
                  ],
                ),
              ),
              
              // Reviews List
              Expanded(
                child: parkingProvider.selectedParkingReviews.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.rate_review_outlined,
                            color: Colors.white70,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No hay reseñas todavía',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '¡Sé el primero en dejar una reseña!',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        // Contador de reseñas
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${parkingProvider.selectedParkingReviews.length} ${parkingProvider.selectedParkingReviews.length == 1 ? 'reseña' : 'reseñas'}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              // Aquí puedes agregar un menú para filtrar reseñas si lo necesitas
                            ],
                          ),
                        ),
                        
                        // Lista de reseñas
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: parkingProvider.selectedParkingReviews.length,
                            itemBuilder: (context, index) {
                              final review = parkingProvider.selectedParkingReviews[index];
                              
                              // Logging para debug
                              DebugLogger.logReviewInfo("👁️ Renderizando Review #$index - Usuario: ${review.userName}");
                              DebugLogger.logReviewInfo("👁️ Comentario: '${review.comment.length > 30 ? "${review.comment.substring(0, 30)}..." : review.comment}'");
                              
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: ReviewItem.fromReview(review),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
              ),

              // Add your review button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Verificar si el usuario está autenticado antes de mostrar el diálogo
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    if (authProvider.currentUser == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Debes iniciar sesión para dejar una reseña')),
                      );
                      return;
                    }
                    
                    // Show review dialog
                    _showAddReviewDialog(context, parking.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF121212),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  child: const Text(
                    'Add Your Review',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context, String parkingId) {
    final commentController = TextEditingController();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    double rating = 3.0; // default rating

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Review'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFE65C2D),
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = index + 1.0;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16.0),
                  // Mejorado el campo para introducir comentarios
                  TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      labelText: 'Comentario',
                      hintText: 'Cuéntanos tu experiencia en este estacionamiento',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                    ),
                    maxLines: 5,
                    minLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(                onPressed: () async {
                  // Validar que el comentario tenga contenido
                  final comment = commentController.text.trim();
                  final navigator = Navigator.of(context);
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  
                  if (comment.isEmpty) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text('Por favor, añade un comentario a tu reseña')),
                    );
                    return;
                  }
                  
                  final parkingProvider = Provider.of<ParkingProvider>(context, listen: false);
                  
                  DebugLogger.logReviewInfo("Enviando comentario: $comment");
                  await parkingProvider.addReview(
                    parkingId,
                    authProvider.currentUser!.id, // Usar ID del usuario actual
                    authProvider.currentUser!.name, // Usar nombre del usuario actual
                    comment,
                    rating,
                  );
                  
                  if (mounted) {
                    navigator.pop();
                    
                    if (parkingProvider.error != null) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text(parkingProvider.error!)),
                      );
                    } else {
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text('Review added successfully')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE65C2D),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
