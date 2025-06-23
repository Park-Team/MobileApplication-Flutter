import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/debug_logger.dart';
import '../providers/auth_provider.dart';
import '../screens/payment_screen.dart';
import '../config/app_config.dart';

class TimeSlotSelectionDialog extends StatefulWidget {
  final String parkingId;
  final String parkingName;
  final double pricePerHour;
  final List<int> availableHours;
  final Function(DateTime startTime, DateTime endTime) onTimeSelected;

  const TimeSlotSelectionDialog({
    super.key,
    required this.parkingId,
    required this.parkingName,
    required this.pricePerHour,
    required this.availableHours,
    required this.onTimeSelected,
  });

  @override
  State<TimeSlotSelectionDialog> createState() => _TimeSlotSelectionDialogState();
}

class _TimeSlotSelectionDialogState extends State<TimeSlotSelectionDialog>
    with TickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  List<int> selectedTimeSlots = [];
  List<Map<String, DateTime>> occupiedSlots = [];
  bool isLoadingOccupiedSlots = false;  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _loadOccupiedTimeSlots();
    _animationController.forward();
    
    // Auto scroll to current hour with animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentHour = DateTime.now().hour;
      if (currentHour >= 6) {
        _scrollController.animateTo(
          (currentHour - 6) * 90.0, // Increased from 60 to 90 for larger cards
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOutQuart,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  Future<void> _loadOccupiedTimeSlots() async {
    setState(() {
      isLoadingOccupiedSlots = true;
    });
    
    try {
      // Simular algunos horarios ocupados para demostración
      await Future.delayed(Duration(milliseconds: 300));
      final mockOccupiedSlots = <Map<String, DateTime>>[];
      
      // Agregar algunos slots ocupados de forma aleatoria para demostración
      final random = DateTime.now().millisecond;
      if (random % 3 == 0) {
        mockOccupiedSlots.add({
          'start': DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 10),
          'end': DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 12),
        });
      }
      if (random % 4 == 0) {
        mockOccupiedSlots.add({
          'start': DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 14),
          'end': DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 16),
        });
      }
      
      setState(() {
        occupiedSlots = mockOccupiedSlots;
        isLoadingOccupiedSlots = false;
      });
    } catch (e) {
      DebugLogger.log("Error cargando horarios ocupados: $e", category: "TimeSlot");
      setState(() {
        occupiedSlots = [];
        isLoadingOccupiedSlots = false;
      });
    }
  }

  bool _isHourOccupied(int hour) {
    final hourDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, hour);
    final nextHourDateTime = hourDateTime.add(const Duration(hours: 1));
    
    for (var slot in occupiedSlots) {
      if (hourDateTime.isBefore(slot['end']!) && nextHourDateTime.isAfter(slot['start']!)) {
        return true;
      }
    }
    return false;
  }

  bool _isHourPastGracePeriod(int hour) {
    final now = DateTime.now();
    final slotDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, hour);
    const gracePeriod = Duration(minutes: 15);
    
    if (!_isSameDay(selectedDate, now)) {
      return false;
    }
    
    return now.isAfter(slotDateTime.add(gracePeriod));
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  void _toggleTimeSlot(int hour) {
    if (_isHourOccupied(hour)) {
      _showErrorSnackBar('Este horario ya está reservado. Por favor, selecciona otro horario.');
      return;
    }

    if (_isHourPastGracePeriod(hour)) {
      _showErrorSnackBar('Este horario ya ha pasado más de 15 minutos. Por favor, selecciona otro horario.');
      return;
    }
    
    setState(() {
      if (selectedTimeSlots.contains(hour)) {
        selectedTimeSlots.removeWhere((h) => h >= hour);
      } else {
        if (selectedTimeSlots.isEmpty) {
          selectedTimeSlots.add(hour);
        } else {
          final lastHour = selectedTimeSlots.last;
          if (hour == lastHour + 1) {
            selectedTimeSlots.add(hour);
          } else {
            selectedTimeSlots = [hour];
          }
        }
      }
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: AppConfig.primaryWhite, size: 20),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppConfig.primaryRed,
        duration: Duration(seconds: 4),
      ),
    );
  }

  Color _getTimeSlotColor(int hour, bool isAvailable, bool isOccupied) {
    final isPastGrace = _isHourPastGracePeriod(hour);
    
    if (isOccupied) {
      return AppConfig.primaryYellow.withOpacity(0.8);
    } else if (!isAvailable || isPastGrace) {
      return AppConfig.borderLight;
    } else if (selectedTimeSlots.contains(hour)) {
      return AppConfig.primaryBlue;
    } else {
      return AppConfig.backgroundPrimary;
    }
  }

  Color _getTimeSlotTextColor(int hour, bool isAvailable, bool isOccupied) {
    final isPastGrace = _isHourPastGracePeriod(hour);
    
    if (isOccupied) {
      return AppConfig.primaryWhite;
    } else if (!isAvailable || isPastGrace) {
      return AppConfig.textSecondary;
    } else if (selectedTimeSlots.contains(hour)) {
      return AppConfig.primaryWhite;
    } else {
      return AppConfig.textPrimary;
    }
  }
  Border _getTimeSlotBorder(int hour, bool isAvailable, bool isOccupied) {
    final isPastGrace = _isHourPastGracePeriod(hour);
    
    if (selectedTimeSlots.contains(hour)) {
      return Border.all(color: AppConfig.primaryBlue, width: 2);
    } else if (isOccupied) {
      return Border.all(color: AppConfig.primaryYellow, width: 2);
    } else if (!isAvailable || isPastGrace) {
      return Border.all(color: AppConfig.borderLight, width: 1);
    } else {
      return Border.all(color: AppConfig.borderColor, width: 1);
    }
  }

  double _calculateTotalPrice() {
    return selectedTimeSlots.length * widget.pricePerHour;
  }

  String _getTimeInfoMessage() {
    if (selectedTimeSlots.isEmpty) return '';
    
    final now = DateTime.now();
    final firstSlot = selectedTimeSlots.first;
    final slotStart = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, firstSlot);
    
    if (_isSameDay(selectedDate, now) && now.isAfter(slotStart) && now.isBefore(slotStart.add(const Duration(minutes: 15)))) {
      final minutesUsed = now.difference(slotStart).inMinutes;
      final minutesRemaining = 60 - minutesUsed;
      return 'Tiempo restante en primera hora: $minutesRemaining minutos';
    }
    return '';
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: todayStart,
      lastDate: todayStart.add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppConfig.primaryBlue,
              onPrimary: AppConfig.primaryWhite,
              surface: AppConfig.backgroundPrimary,
              onSurface: AppConfig.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        selectedTimeSlots = [];
      });
      _loadOccupiedTimeSlots();
    }
  }

  void _confirmTimeSlot() {
    if (selectedTimeSlots.isEmpty) {
      _showErrorSnackBar('Por favor selecciona al menos una hora');
      return;
    }    final userId = Provider.of<AuthProvider>(context, listen: false).currentUser?.id;
    if (userId == null) {
      _showErrorSnackBar('Usuario no autenticado');
      return;
    }

    final startHour = selectedTimeSlots.first;
    final endHour = selectedTimeSlots.last + 1;
    
    final startTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      startHour,
    );
    
    final endTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      endHour,
    );
    
    final totalPrice = _calculateTotalPrice();
      Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => PaymentScreen(
          userId: userId,
          parkingId: widget.parkingId,
          startTime: startTime,
          endTime: endTime,
          pricePerHour: widget.pricePerHour,
          totalPrice: totalPrice,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _slideAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                  maxWidth: MediaQuery.of(context).size.width * 0.95,
                ),
                decoration: AppConfig.modalDecoration,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(),
                      _buildDateSelector(),
                      _buildLegend(),
                      _buildTimeSlotGrid(),
                      _buildSummary(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppConfig.primaryGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConfig.primaryWhite.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_parking_rounded,
                  color: AppConfig.primaryWhite,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.parkingName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppConfig.primaryWhite,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppConfig.primaryGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'S/. ${widget.pricePerHour.toStringAsFixed(2)} / hora',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppConfig.primaryWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close_rounded,
                  color: AppConfig.primaryWhite,
                  size: 28,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: AppConfig.primaryWhite.withOpacity(0.2),
                  padding: EdgeInsets.all(8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            color: AppConfig.primaryBlue,
            size: 24,
          ),
          SizedBox(width: 12),
          Text(
            'Fecha de reserva:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConfig.textPrimary,
            ),
          ),
          Spacer(),
          Material(
            color: AppConfig.backgroundAccent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _selectDate,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppConfig.primaryBlue,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppConfig.primaryBlue,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConfig.backgroundAccent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConfig.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecciona horas consecutivas para tu reserva',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConfig.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildLegendItem(
                color: AppConfig.primaryYellow.withOpacity(0.8),
                text: 'Ocupado',
                icon: Icons.block_rounded,
              ),
              SizedBox(width: 16),
              _buildLegendItem(
                color: AppConfig.borderLight,
                text: 'No disponible',
                icon: Icons.schedule_rounded,
              ),
              SizedBox(width: 16),
              _buildLegendItem(
                color: AppConfig.primaryBlue,
                text: 'Seleccionado',
                icon: Icons.check_circle_rounded,
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConfig.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppConfig.primaryBlue.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_rounded,
                  color: AppConfig.primaryBlue,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Se cobra por hora completa. Si reservas a las 13:30, pagas desde las 13:00.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppConfig.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String text,
    required IconData icon,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            color: color == AppConfig.borderLight ? AppConfig.textSecondary : AppConfig.primaryWhite,
            size: 12,
          ),
        ),
        SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: AppConfig.textBody,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotGrid() {
    return Container(
      height: 320,
      margin: EdgeInsets.all(20),
      child: isLoadingOccupiedSlots
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppConfig.primaryBlue),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Cargando horarios disponibles...',
                    style: TextStyle(
                      color: AppConfig.textBody,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              radius: Radius.circular(8),
              child: GridView.builder(
                controller: _scrollController,
                padding: EdgeInsets.only(right: 8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 24,
                itemBuilder: (context, index) {
                  final hour = index;
                  final isAvailable = widget.availableHours.contains(hour);
                  final isOccupied = _isHourOccupied(hour);
                  final isPastGrace = _isHourPastGracePeriod(hour);
                  final isSelectable = isAvailable && !isOccupied && !isPastGrace;
                  
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: _getTimeSlotColor(hour, isAvailable, isOccupied),
                      borderRadius: BorderRadius.circular(16),
                      border: _getTimeSlotBorder(hour, isAvailable, isOccupied),
                      boxShadow: selectedTimeSlots.contains(hour)
                          ? [
                              BoxShadow(
                                color: AppConfig.primaryBlue.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: isSelectable ? () => _toggleTimeSlot(hour) : null,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${hour.toString().padLeft(2, '0')}:00',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: _getTimeSlotTextColor(hour, isAvailable, isOccupied),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              if (isOccupied) ...[
                                SizedBox(height: 2),
                                Icon(
                                  Icons.block_rounded,
                                  size: 16,
                                  color: AppConfig.primaryWhite,
                                ),
                              ] else if (!isAvailable || isPastGrace) ...[
                                SizedBox(height: 2),
                                Icon(
                                  Icons.schedule_rounded,
                                  size: 16,
                                  color: AppConfig.textSecondary,
                                ),
                              ] else if (selectedTimeSlots.contains(hour)) ...[
                                SizedBox(height: 2),
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 16,
                                  color: AppConfig.primaryWhite,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppConfig.backgroundAccent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          if (selectedTimeSlots.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConfig.backgroundPrimary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppConfig.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: AppConfig.cardShadow,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSummaryRow(
                    'Horario seleccionado:',
                    '${selectedTimeSlots.first.toString().padLeft(2, '0')}:00 - ${(selectedTimeSlots.last + 1).toString().padLeft(2, '0')}:00',
                    icon: Icons.access_time_rounded,
                  ),
                  Divider(height: 24, color: AppConfig.borderLight),
                  _buildSummaryRow(
                    'Total de horas:',
                    '${selectedTimeSlots.length} ${selectedTimeSlots.length == 1 ? 'hora' : 'horas'}',
                    icon: Icons.timer_rounded,
                  ),
                  Divider(height: 24, color: AppConfig.borderLight),
                  _buildSummaryRow(
                    'Precio total:',
                    'S/. ${_calculateTotalPrice().toStringAsFixed(2)}',
                    icon: Icons.payments_rounded,
                    isPrice: true,
                  ),
                  if (_getTimeInfoMessage().isNotEmpty) ...[
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppConfig.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppConfig.primaryGreen.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            color: AppConfig.primaryGreen,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _getTimeInfoMessage(),
                              style: TextStyle(
                                fontSize: 13,
                                color: AppConfig.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
          
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: selectedTimeSlots.isNotEmpty ? _confirmTimeSlot : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedTimeSlots.isNotEmpty 
                        ? AppConfig.primaryBlue 
                        : AppConfig.borderLight,
                    foregroundColor: AppConfig.primaryWhite,
                    elevation: selectedTimeSlots.isNotEmpty ? 0 : 0,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.payment_rounded,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Continuar al pago',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {IconData? icon, bool isPrice = false}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 20,
            color: isPrice ? AppConfig.primaryGreen : AppConfig.primaryBlue,
          ),
          SizedBox(width: 12),
        ],
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: AppConfig.textBody,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isPrice ? AppConfig.primaryGreen : AppConfig.textPrimary,
          ),
        ),
      ],
    );
  }
}
