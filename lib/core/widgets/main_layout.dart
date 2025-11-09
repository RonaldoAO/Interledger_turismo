import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/config/theme.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.account_balance_wallet, size: 28),
            const SizedBox(width: 8),
            Text(isClientMode ? 'Cliente' : 'Negocio'),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                isClientMode = !isClientMode;
              });
              context.go(isClientMode ? '/client' : '/business');
            },
            icon: const Icon(Icons.swap_horiz),
            label: Text(isClientMode ? 'Modo Negocio' : 'Modo Cliente'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.mediumGray, width: 1),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _getSelectedIndex(currentPath),
          onDestinationSelected: (index) {
            _onItemTapped(context, index);
          },
          backgroundColor: Colors.white,
          indicatorColor: AppTheme.primaryBlue.withOpacity(0.1),
          destinations: isClientMode
              ? _clientDestinations()
              : _businessDestinations(),
        ),
      ),
    );
  }

  List<NavigationDestination> _clientDestinations() {
    return const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Inicio',
      ),
      NavigationDestination(
        icon: Icon(Icons.explore_outlined),
        selectedIcon: Icon(Icons.explore),
        label: 'Descubre',
      ),
      NavigationDestination(
        icon: Icon(Icons.shopping_cart_outlined),
        selectedIcon: Icon(Icons.shopping_cart),
        label: 'Carrito',
      ),
      NavigationDestination(
        icon: Icon(Icons.history_outlined),
        selectedIcon: Icon(Icons.history),
        label: 'Historial',
      ),
    ];
  }

  List<NavigationDestination> _businessDestinations() {
    return const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Inicio',
      ),
      NavigationDestination(
        icon: Icon(Icons.people_outline),
        selectedIcon: Icon(Icons.people),
        label: 'Pago',
      ),
      NavigationDestination(
        icon: Icon(Icons.receipt_long_outlined),
        selectedIcon: Icon(Icons.receipt_long),
        label: 'Historial',
      ),
      NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
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