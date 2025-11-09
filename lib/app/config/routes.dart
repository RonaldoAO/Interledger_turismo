import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turex/features/home/presentation/pages/CartPage.dart';
import 'package:turex/features/home/presentation/pages/TransactionsPage.dart';
import '../../features/home/presentation/pages/client_home_page.dart';
import '../../features/home/presentation/pages/business_home_page.dart';
import '../../features/split/presentation/pages/split_payment_page.dart';
import '../../features/split/presentation/pages/group_payment_page.dart';
import '../../features/split/presentation/pages/payment_callback_page.dart';
import '../../features/discover/presentation/pages/discover_page.dart';
import '../../core/widgets/main_layout.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/client',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/client',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ClientHomePage(),
          ),
        ),
        GoRoute(
          path: '/business',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: BusinessHomePage(),
          ),
        ),
        GoRoute(
          path: '/split',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SplitPaymentPage(),
          ),
        ),
        GoRoute(
          path: '/group',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: GroupPaymentPage(),
          ),
        ),
        GoRoute(
          path: '/discover',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DiscoverPage(),
          ),
        ),
        GoRoute(
          path: '/cart',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CartPage(), // Para futuro
          ),
        ),
        GoRoute(
          path: '/payment',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: Placeholder(), // Para futuro
          ),
        ),
        GoRoute(
          path: '/history',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TransactionsPage(), // Para futuro
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/callback',
      builder: (context, state) {
        final interactRef = state.uri.queryParameters['interact_ref'] ?? '';
        final nonce = state.uri.queryParameters['nonce'] ?? '';
        return PaymentCallbackPage(
          interactRef: interactRef,
          nonce: nonce,
        );
      },
    ),
  ],
);