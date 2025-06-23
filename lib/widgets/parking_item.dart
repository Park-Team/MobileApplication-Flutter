import 'package:flutter/material.dart';

class ParkingItem extends StatelessWidget {
  final String id;
  final String address;
  final int availableSpaces;
  final double pricePerHour;
  final double rating;
  final String? imageUrl;
  final Function(String) onTap;
  
  const ParkingItem({
    super.key,
    required this.id,
    required this.address,
    required this.availableSpaces,
    required this.pricePerHour,
    required this.rating,
    this.imageUrl,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(id),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade700,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            // Image container
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.grey,
                child: imageUrl != null && imageUrl!.isNotEmpty 
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.local_parking,
                          size: 40,
                          color: Colors.white54,
                        );
                      },
                    )
                  : const Icon(
                      Icons.local_parking,
                      size: 40,
                      color: Colors.white54,
                    ),
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '$availableSpaces spaces',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      'S/. ${pricePerHour.toStringAsFixed(2)}/hr',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
