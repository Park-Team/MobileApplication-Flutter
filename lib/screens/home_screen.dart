import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/parking_provider.dart';
import '../models/parking.dart';
import '../config/app_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controllers
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DraggableScrollableController _draggableController = DraggableScrollableController();
  
  // State variables
  String _searchQuery = "";
  bool _isSheetExpanded = false;
  
  // Bottom sheet size configurations
  final double _initialSheetSize = 0.25;
  final double _minSheetSize = 0.18;
  final double _maxSheetSize = 0.85;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadParkings();
    });
    // Eliminamos el listener del controller ya que ahora usamos NotificationListener
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _draggableController.dispose();
    super.dispose();
  }
  
  Future<void> _loadParkings() async {
    final parkingProvider = Provider.of<ParkingProvider>(context, listen: false);
    await parkingProvider.fetchParkings();
    
    if (parkingProvider.parkings.isEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No parking spaces available'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _onParkingTap(String parkingId) {
    Navigator.pushNamed(context, '/parking-details', arguments: parkingId);
  }

  List<Parking> _getFilteredParkings(List<Parking> parkings) {
    if (_searchQuery.isEmpty) {
      return parkings;
    }

    return parkings.where((parking) {
      return parking.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             parking.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }
  
  void _showAllParkings() {
    _draggableController.animateTo(
      _maxSheetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  Widget _buildParkingItem(Parking parking) {
    return InkWell(
      onTap: () => _onParkingTap(parking.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Parking icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.local_parking,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            
            // Parking details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parking.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          parking.address,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Available spaces indicator
                      Icon(
                        Icons.directions_car,
                        size: 14,
                        color: AppConfig.textBody,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${parking.totalSpaces} spaces',
                        style: TextStyle(
                          color: AppConfig.textBody,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Price indicator
                      Icon(
                        Icons.attach_money,
                        size: 14,
                        color: AppConfig.primaryGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${parking.pricePerHour.toStringAsFixed(2)}/hr',
                        style: TextStyle(
                          color: AppConfig.primaryGreen,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Navigation arrow
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.primary),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text(
          'EZ Park',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Theme.of(context).colorScheme.primary),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.primary,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Welcome!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: AppConfig.subtitleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/edit-profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Reservations'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/reservations');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                // Handle logout
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Map Area (gray placeholder for now)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[200],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Map will be displayed here',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Search bar at the top
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Search field
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for parking',
                        prefixIcon: const Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  
                  // Filter button
                  Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: IconButton(
                      icon: Icon(
                        Icons.tune,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () {
                        // Show filter options
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Settings button
          Positioned(
            right: 16,
            bottom: 200,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // Open settings
                },
              ),
            ),
          ),
          
          // Draggable bottom sheet with Nearby Parking
          SizedBox.expand(
            child: DraggableScrollableSheet(
              initialChildSize: _initialSheetSize,
              minChildSize: _minSheetSize,
              maxChildSize: _maxSheetSize,
              controller: _draggableController,
              snap: true,
              snapSizes: [_initialSheetSize, 0.6, _maxSheetSize],
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  // Use NotificationListener para mejorar la detección de gestos
                  child: NotificationListener<DraggableScrollableNotification>(
                    onNotification: (notification) {
                      setState(() {
                        _isSheetExpanded = notification.extent > _initialSheetSize + 0.05;
                      });
                      return true;
                    },
                    child: CustomScrollView(
                      // Esta configuración permite que el gesto de deslizamiento funcione en toda el área
                      physics: const ClampingScrollPhysics(),
                      controller: scrollController,
                      slivers: [
                        // Handle para deslizar - ahora como SliverToBoxAdapter
                        SliverToBoxAdapter(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            color: Colors.transparent,
                            child: Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        // Contenido principal
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                        // Title and View All button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _isSheetExpanded ? 'All Parking' : 'Nearby Parking',
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                              if (!_isSheetExpanded)
                                GestureDetector(
                                  onTap: _showAllParkings,
                                  child: Text(
                                    'View All',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        
                        // Search bar removed as per user request
                        // We don't want to show the search bar when sliding up
                        
                        // Parking list with dynamic height
                        Container(
                          // Min height to ensure enough area for dragging when collapsed
                          constraints: BoxConstraints(
                            minHeight: 200,
                            maxHeight: _isSheetExpanded
                                ? MediaQuery.of(context).size.height * 0.7
                                : 230, // Sufficient height for 3 items
                          ),
                          child: Consumer<ParkingProvider>(
                            builder: (context, parkingProvider, _) {
                              if (parkingProvider.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              
                              final parkings = _getFilteredParkings(parkingProvider.parkings);
                              
                              if (parkings.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No parking spaces found',
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                );
                              }
                              
                              // If not expanded, limit to 3 items
                              final displayParkings = !_isSheetExpanded && parkings.length > 3
                                  ? parkings.sublist(0, 3)
                                  : parkings;
                              
                              return ListView.separated(
                                // Allow scrolling within this list when expanded
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                                physics: _isSheetExpanded
                                    ? const ClampingScrollPhysics()
                                    : const NeverScrollableScrollPhysics(), // Gestión de física basada en el estado
                                itemCount: displayParkings.length,
                                separatorBuilder: (context, index) => const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final parking = displayParkings[index];
                                  return _buildParkingItem(parking);
                                },
                              );
                            },
                          ),
                        ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
