import 'package:flutter/material.dart';

class EzParkAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showMenu;
  final Function()? onMenuPressed;
  
  const EzParkAppBar({
    super.key,
    required this.title,
    this.showMenu = true,
    this.onMenuPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: showMenu 
        ? IconButton(
            icon: const Icon(
              Icons.menu,
              color: Color(0xFFE65C2D), // Primary orange color
            ),
            onPressed: onMenuPressed ?? () {
              Scaffold.of(context).openDrawer();
            },
          )
        : IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFFE65C2D), // Primary orange color
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
