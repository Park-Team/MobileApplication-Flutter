import 'package:flutter/material.dart';

class EzParkButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool isLoading;
  final bool isOutlined;
  
  const EzParkButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.white : const Color(0xFF121212),
          foregroundColor: isOutlined ? const Color(0xFF121212) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isOutlined 
              ? const BorderSide(color: Color(0xFF121212), width: 2)
              : BorderSide.none,
          ),
          elevation: 0,
        ),
        child: isLoading 
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isOutlined ? const Color(0xFF121212) : Colors.white,
              ),
            ),
      ),
    );
  }
}
