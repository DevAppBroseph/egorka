import 'package:egorka/ui/home/home.dart';
import 'package:egorka/ui/sidebar/about/about_page.dart';
import 'package:egorka/ui/sidebar/current_order/current_order_page.dart';
import 'package:egorka/ui/sidebar/market_place/market_page.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static const home = '/home';
  static const currentOrder = '/currentOrder';
  static const marketplaces = '/marketplaces';
  static const about = '/about';

  static Route<dynamic>? onGenerateRoute(RouteSettings route) {
    switch (route.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case currentOrder:
        return MaterialPageRoute(builder: (_) => const CurrentOrderPage());
      case marketplaces:
        return MaterialPageRoute(builder: (_) => const MarketPage());
      case about:
        return MaterialPageRoute(builder: (_) => const AboutPage());
      default:
        return null;
    }
  }
}