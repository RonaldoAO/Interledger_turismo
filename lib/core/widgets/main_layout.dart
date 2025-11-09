import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/config/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool isClientMode = true; 

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    final screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width > 768;

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      appBar: AppBar(
        toolbarHeight: 70,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.lightBlue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                'assets/icons/logo.svg',
                width: 24,
                height: 24,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'VibePayments',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            if (isTablet) ...[
              const SizedBox(width: 24),
              _buildModeTag(),
            ],
          ],
        ),
        actions: [
          if (!isTablet)
            _buildModeTag(),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: AppTheme.lightGray,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                isClientMode ? Icons.store_outlined : Icons.person_outlined,
                color: AppTheme.darkGray,
              ),
              onPressed: () {
                setState(() {
                  isClientMode = !isClientMode;
                });
                context.go(isClientMode ? '/client' : '/business');
              },
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: isTablet ? screenSize.width * 0.05 : 0,
          vertical: 0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: isTablet
              ? const BorderRadius.vertical(top: Radius.circular(24))
              : null,
        ),
        child: widget.child,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: NavigationBar(
          selectedIndex: _getSelectedIndex(currentPath),
          onDestinationSelected: (index) {
            _onItemTapped(context, index);
          },
          backgroundColor: Colors.white,
          elevation: 15,
          shadowColor: Colors.black26,
          height: 70,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: isClientMode
              ? _clientDestinations()
              : _businessDestinations(),
        ),
      ),
    );
  }

  Widget _buildModeTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isClientMode ? AppTheme.lightBlue : AppTheme.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isClientMode ? Icons.person : Icons.business,
            size: 16,
            color: isClientMode ? AppTheme.primaryBlue : AppTheme.success,
          ),
          const SizedBox(width: 6),
          Text(
            isClientMode ? 'Cliente' : 'Negocio',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isClientMode ? AppTheme.primaryBlue : AppTheme.success,
            ),
          ),
        ],
      ),
    );
  }

  List<NavigationDestination> _clientDestinations() {
    return [
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home_rounded),
        label: 'Inicio',
      ),
      const NavigationDestination(
        icon: Icon(Icons.explore_outlined),
        selectedIcon: Icon(Icons.explore),
        label: 'Descubre',
      ),
      const NavigationDestination(
        icon: Icon(Icons.shopping_cart_outlined),
        selectedIcon: Icon(Icons.shopping_cart),
        label: 'Carrito',
      ),
      const NavigationDestination(
        icon: Icon(Icons.history_outlined),
        selectedIcon: Icon(Icons.history),
        label: 'Historial',
      ),
    ];
  }

  List<NavigationDestination> _businessDestinations() {
    return [
      const NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      const NavigationDestination(
        icon: Icon(Icons.payments_outlined),
        selectedIcon: Icon(Icons.payments),
        label: 'Pagos',
      ),
      const NavigationDestination(
        icon: Icon(Icons.receipt_long_outlined),
        selectedIcon: Icon(Icons.receipt_long),
        label: 'Historial',
      ),
      const NavigationDestination(
        icon: Icon(Icons.currency_exchange),
        selectedIcon: Icon(Icons.currency_exchange_outlined),
        label: 'Conversor',
      ),
    ];
  }

  int _getSelectedIndex(String path) {
    if (isClientMode) {
      switch (path) {
        case '/client':
          return 0;
        case '/discover':
          return 1;
        case '/cart':
          return 2;
        case '/history':
          return 3;
        default:
          return 0;
      }
    } else {
      switch (path) {
        case '/business':
          return 0;
        case '/payment':
          return 1;
        case '/history':
          return 2;
        case '/conversor':
          return 3;
        default:
          return 0;
      }
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    if (isClientMode) {
      switch (index) {
        case 0:
          context.go('/client');
          break;
        case 1:
          context.go('/discover');
          break;
        case 2:
          context.go('/cart');
          break;
        case 3:
          context.go('/history');
          break;
      }
    } else {
      switch (index) {
        case 0:
          context.go('/business');
          break;
        case 1:
          context.go('/payment');
          break;
        case 2:
          context.go('/history');
          break;
        case 3:
          context.go('/conversor');
          break;
      }
    }
  }
}