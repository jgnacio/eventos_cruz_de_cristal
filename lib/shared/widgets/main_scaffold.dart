import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  final String currentPath;

  const MainScaffold({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _buildModernBottomNavBar(context),
    );
  }

  Widget _buildModernBottomNavBar(BuildContext context) {
    final currentIndex = _getCurrentIndex();
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingSmall, 
            vertical: AppConstants.paddingSmall
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.home_rounded,
                label: 'Inicio',
                index: 0,
                isSelected: currentIndex == 0,
                onTap: () => context.go('/home'),
              ),
              _buildNavItem(
                context: context,
                icon: Icons.event_note_rounded,
                label: 'Eventos',
                index: 1,
                isSelected: currentIndex == 1,
                onTap: () => context.go('/events'),
              ),
              _buildNavItem(
                context: context,
                icon: Icons.church_rounded,
                label: 'Iglesias',
                index: 2,
                isSelected: currentIndex == 2,
                onTap: () => context.go('/churches'),
              ),
              _buildNavItem(
                context: context,
                icon: Icons.favorite_rounded,
                label: 'Ayunos',
                index: 3,
                isSelected: currentIndex == 3,
                onTap: () => context.go('/fasting'),
              ),
              _buildNavItem(
                context: context,
                icon: Icons.person_rounded,
                label: 'Perfil',
                index: 4,
                isSelected: currentIndex == 4,
                onTap: () => context.go('/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;
    final unselectedColor = Colors.grey.shade600;
    
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: AnimatedContainer(
          duration: AppConstants.animationMedium,
          padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            color: isSelected 
                ? primaryColor.withOpacity(0.1)
                : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: AppConstants.animationMedium,
                padding: const EdgeInsets.all(AppConstants.paddingSmall),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.paddingSmall),
                  color: isSelected 
                      ? primaryColor.withOpacity(0.15)
                      : Colors.transparent,
                ),
                child: Icon(
                  icon,
                  size: AppConstants.iconMedium,
                  color: isSelected ? primaryColor : unselectedColor,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: AppConstants.animationMedium,
                style: TextStyle(
                  fontSize: AppConstants.textSmall,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? primaryColor : unselectedColor,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getCurrentIndex() {
    if (currentPath.startsWith('/home')) return 0;
    if (currentPath.startsWith('/events')) return 1;
    if (currentPath.startsWith('/churches')) return 2;
    if (currentPath.startsWith('/fasting')) return 3;
    if (currentPath.startsWith('/profile')) return 4;
    return 0;
  }
}

/// Widget reutilizable para tarjetas modernas con gradientes
class ModernCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const ModernCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largeBorderRadius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingSmall),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: AppConstants.textXLarge,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: AppConstants.textSmall,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget reutilizable para secciones inspiracionales
class InspirationalCard extends StatelessWidget {
  final String title;
  final String content;
  final String reference;
  final IconData? icon;

  const InspirationalCard({
    super.key,
    required this.title,
    required this.content,
    required this.reference,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(AppConstants.borderRadius),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: AppConstants.iconLarge,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
          ],
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppConstants.borderRadius),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            reference,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
} 