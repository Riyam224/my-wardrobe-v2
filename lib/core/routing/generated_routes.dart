import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wordrobe_v2/core/routing/app_routes.dart';
import 'package:my_wordrobe_v2/features/view/cart/cart_view.dart';
import 'package:my_wordrobe_v2/features/view/home/add_item_view.dart';
import 'package:my_wordrobe_v2/features/view/home/edit_item_view.dart';
import 'package:my_wordrobe_v2/features/view/home/favorite_item_view.dart';
import 'package:my_wordrobe_v2/features/view/home/home_view.dart';
import 'package:my_wordrobe_v2/features/view/profile/profile_view.dart';
import 'package:my_wordrobe_v2/features/view/splash/splash_view.dart';
import 'package:my_wordrobe_v2/root.dart';

class RouteGenerator {
  static GoRouter mainRoutingInOurApp = GoRouter(
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('404 Not Found'))),
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.root,
        name: AppRoutes.root,
        builder: (context, state) => const RootPage(),
      ),
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (context, state) => const HomeView(),
      ),

      GoRoute(
        path: AppRoutes.addItem,
        name: AppRoutes.addItem,
        builder: (context, state) => const AddItemView(),
      ),

      GoRoute(
        path: AppRoutes.cart,
        name: AppRoutes.cart,
        builder: (context, state) => const CartView(),
      ),

      GoRoute(
        path: AppRoutes.favorites,
        name: AppRoutes.favorites,
        builder: (context, state) => const FavoriteItemView(),
      ),

      GoRoute(
        path: AppRoutes.profile,
        name: AppRoutes.profile,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: '/editItem',
        builder: (context, state) {
          // Ensure extra is not null and is int or can be parsed to int
          final id = state.extra is int
              ? state.extra as int
              : int.tryParse(state.extra.toString()) ?? 0;

          // Optionally handle invalid id (0 or negative)
          if (id <= 0) {
            // You could return an error page or fallback
            return const Scaffold(body: Center(child: Text('Invalid item ID')));
          }

          return EditItemView(itemId: id);
        },
      ),
    ],
  );
}
