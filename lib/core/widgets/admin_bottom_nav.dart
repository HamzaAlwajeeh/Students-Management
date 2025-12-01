import 'package:flutter/material.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';

class AdminBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AdminBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.gavel, 0),
            label: 'المخالفات',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.home, 1),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon(Icons.receipt_long, 2),
            label: 'المدفوعات',
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color:
            currentIndex == index
                ? AppColors.textLight.withOpacity(0.2)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 28),
    );
  }
}
