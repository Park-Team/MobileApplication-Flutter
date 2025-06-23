import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/reservation_provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/reservation_item.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadReservations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadReservations() async {
    setState(() => _isLoading = true);
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final reservationProvider = Provider.of<ReservationProvider>(context, listen: false);
      
      if (authProvider.currentUser != null) {        await reservationProvider.loadUserReservations(
          authProvider.currentUser!.id,
        );
      }    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando reservas: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: EzParkAppBar(
        title: 'Mis Reservas',
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFFE65C2D),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFFE65C2D),
              tabs: const [
                Tab(text: 'Activas'),
                Tab(text: 'Completadas'),
                Tab(text: 'Canceladas'),
              ],
            ),
          ),
          
          Expanded(
            child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Consumer<ReservationProvider>(
                  builder: (context, reservationProvider, child) {
                    if (reservationProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (reservationProvider.error != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error: ${reservationProvider.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadReservations,
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        // Reservas activas
                        _buildReservationsList(
                          reservations: reservationProvider.activeReservations,
                          emptyMessage: 'No tienes reservas activas',
                        ),
                        
                        // Reservas completadas
                        _buildReservationsList(
                          reservations: reservationProvider.completedReservations,
                          emptyMessage: 'No tienes reservas completadas',
                        ),
                        
                        // Reservas canceladas
                        _buildReservationsList(
                          reservations: reservationProvider.cancelledReservations,
                          emptyMessage: 'No tienes reservas canceladas',
                        ),
                      ],
                    );
                  },
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE65C2D),
        onPressed: () {
          Navigator.pushNamed(context, '/home');
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
  
  Widget _buildReservationsList({required reservations, required String emptyMessage}) {
    if (reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _loadReservations,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          return ReservationItem(
            reservation: reservations[index],            onCancelPressed: () async {
              // Capture context-dependent objects before async operations
              final reservationProvider = Provider.of<ReservationProvider>(
                context, 
                listen: false
              );
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              
              // Mostrar diálogo de confirmación
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cancelar reserva'),
                  content: const Text('¿Estás seguro de que deseas cancelar esta reserva?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        'Sí, cancelar',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
              
              // Si el usuario confirmó, cancelar la reserva
              if (confirm == true) {
                final success = await reservationProvider.cancelReservation(
                  reservations[index].id,
                );
                
                if (success) {
                  if (mounted) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Reserva cancelada correctamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } else {
                  if (mounted) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error al cancelar la reserva: ${reservationProvider.error}',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
          );
        },
      ),
    );
  }
}