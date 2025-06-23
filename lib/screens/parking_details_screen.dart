import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/parking_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/reservation_provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/ez_park_button.dart';
import '../widgets/time_slot_selection_dialog.dart';
import '../utils/debug_logger.dart';

class ParkingDetailsScreen extends StatefulWidget {
  final String parkingId;
  
  const ParkingDetailsScreen({
    super.key,
    required this.parkingId,
  });

  @override
  State<ParkingDetailsScreen> createState() => _ParkingDetailsScreenState();
}

class _ParkingDetailsScreenState extends State<ParkingDetailsScreen> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadParkingDetails();
    });
  }

  Future<void> _loadParkingDetails() async {
    final parkingProvider = Provider.of<ParkingProvider>(context, listen: false);
    await parkingProvider.selectParking(widget.parkingId);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentImageIndex = index;
    });
  }

  void _onDotTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }  void _showReservationDialog(BuildContext context, parking) async {
    await showDialog(
      context: context,
      builder: (context) => TimeSlotSelectionDialog(
        parkingId: parking.id, // ID is already a string
        parkingName: parking.name,
        pricePerHour: parking.pricePerHour,
        availableHours: parking.availableHours, // Use the getter directly
        onTimeSelected: (startTime, endTime) async {
          Navigator.pop(context); // Cerrar el diálogo
          await _createReservation(
            context,
            parking,
            startTime,
            endTime,
          );
        },
      ),
    );
  }  Future<void> _createReservation(
    BuildContext context,
    parking,
    DateTime startTime,
    DateTime endTime,
  ) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final reservationProvider = Provider.of<ReservationProvider>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);    if (authProvider.currentUser == null) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Please log in to make a reservation')),
      );
      return;
    }    try {
      await reservationProvider.createReservation(
        userId: authProvider.currentUser!.id,
        parkingId: parking.id,
        startTime: startTime,
        endTime: endTime,
        pricePerHour: parking.pricePerHour,
      );if (reservationProvider.error == null) {
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Reservation created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error: ${reservationProvider.error}')),
          );
        }
      }    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Error creating reservation: $e')),
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
                    'Error loading parking details: ${parkingProvider.error}',
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: _loadParkingDetails,
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

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title/Address
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

                // Image Gallery
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Stack(
                    children: [
                      // Image slides
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        itemCount: parking.images.isNotEmpty ? parking.images.length : 3,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8.0),
                                image: parking.images.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(parking.images[index]),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: parking.images.isEmpty
                                  ? const Center(
                                      child: Icon(
                                        Icons.local_parking,
                                        size: 60,
                                        color: Colors.white54,
                                      ),
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                      
                      // Small thumbnails
                      Positioned(
                        left: 16.0,
                        bottom: 16.0,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.local_parking,
                              size: 30,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ),
                      
                      Positioned(
                        right: 16.0,
                        bottom: 16.0,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.local_parking,
                              size: 30,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ),
                      
                      // Dots indicator
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3, // Use actual image count in real app
                            (index) => GestureDetector(
                              onTap: () => _onDotTapped(index),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentImageIndex == index
                                      ? Colors.black
                                      : Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Space owner
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Espacio ID: ${parking.ownerId}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        parking.description.isNotEmpty 
                          ? parking.description 
                          : 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin non consequat dolor. Nulla ultrices mauris in nisi imperdiet suscipit. Phasellus sed molestie dui, nec faucibus nisi.',
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),                // Ratings & Reviews Button                // Botón mejorado de calificaciones y reseñas
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(                    onPressed: () {
                      // Recargar las reseñas antes de navegar
                      final parkingProvider = Provider.of<ParkingProvider>(context, listen: false);
                      final navigator = Navigator.of(context);
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      
                      // Mostrar cargando
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text('Cargando reseñas...'), duration: Duration(seconds: 1)),
                      );
                      
                      parkingProvider.fetchParkingReviews(widget.parkingId).then((_) {
                        // Verificar si hay reseñas cargadas
                        DebugLogger.log("Navegando a reseñas, encontradas: ${parkingProvider.selectedParkingReviews.length}", category: "ParkingDetails");
                        
                        if (mounted) {
                          navigator.pushNamed(
                            '/parking-reviews',
                            arguments: widget.parkingId,
                          );
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Calificaciones y Reseñas',
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8.0),                          Consumer<ParkingProvider>(
                            builder: (context, provider, _) {
                              final reviewCount = provider.selectedParkingReviews.length;
                              return Row(
                                children: [
                                  Text(
                                    '${parking.rating}/5',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4.0),
                                  const Icon(
                                    Icons.star,
                                    color: Color(0xFFE65C2D),
                                    size: 16.0,
                                  ),
                                  if (reviewCount > 0)
                                    Text(
                                      ' ($reviewCount)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(width: 4.0),
                          const Icon(
                            Icons.arrow_forward,
                            size: 16.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Price
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Price: S/. ${parking.pricePerHour.toStringAsFixed(2)} / hr',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),                // Reserve Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: EzParkButton(
                    text: 'Reserve now',
                    onPressed: () => _showReservationDialog(context, parking),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
