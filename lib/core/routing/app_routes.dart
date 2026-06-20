import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:primo/core/routing/routes.dart';
import 'package:primo/feature/auth/presentation/screens/login_screen.dart';
import 'package:primo/feature/auth/presentation/screens/register_screen.dart';
import 'package:primo/feature/cart/presentation/screens/cart.dart';
import 'package:primo/feature/home/presentation/screen/home.dart';
import 'package:primo/feature/orders/presentation/screens/order_tracking.dart';
import 'package:primo/feature/product/presentation/screen/product_details.dart';
import 'package:primo/feature/profile/presentation/screen/edit_profile.dart';
import 'package:primo/feature/profile/presentation/screen/profile.dart';
import 'package:primo/feature/splash_screen/splash_screen.dart';

class AppRoutes {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return CupertinoPageRoute(builder: (_) => const SplashScreen());

      case Routes.login:
        return CupertinoPageRoute(builder: (_) => const LoginScreen());
      case Routes.register:
        return CupertinoPageRoute(builder: (_) => const RegisterScreen());
      case Routes.profile:
        return CupertinoPageRoute(builder: (_) => const Profile());
      case Routes.editProfile:
        return CupertinoPageRoute(builder: (_) => const EditProfile());
      case Routes.home:
        return CupertinoPageRoute(builder: (_) => const Home());
      case Routes.productDetails:
        return CupertinoPageRoute(builder: (_) => const ProductDetails());
      case Routes.cart:
        return CupertinoPageRoute(builder: (_) => const Cart());
      case Routes.orderTrucking:
        return CupertinoPageRoute(builder: (_) => const OrderTracking());
      default:
        return CupertinoPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("No route defined for this path")),
          ),
        );
    }
  }
}
