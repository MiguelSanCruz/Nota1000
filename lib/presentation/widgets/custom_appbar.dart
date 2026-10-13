import 'package:flutter/material.dart';
import 'package:nota_1000/presentation/controllers/app_controller.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {

    final bool isDark = AppTheme.instance.isDarkMode;
    final backgroundColor = Theme.of(context).primaryColor;

    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: showBackButton,
      iconTheme: const IconThemeData(color: Colors.white), 
      actions: [
        ...?actions,

        IconButton(
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          color: Colors.white,
          tooltip: 'Alternar Tema',
          onPressed: () {
            AppTheme.instance.changeTheme();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}