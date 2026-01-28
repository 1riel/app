import 'package:flutter/material.dart';

import 'package:app_1riel/routes/Main_Navigator.dart';
import 'package:app_1riel/pages/product/Manage_Product.dart';
import 'package:app_1riel/pages/About.dart';
import 'package:app_1riel/pages/driver/Driver.dart';
import 'package:app_1riel/pages/product/Product.dart';
import 'package:app_1riel/pages/profile/Profile.dart';
import 'package:app_1riel/pages/profile/Reset.dart';
import 'package:app_1riel/pages/profile/Sign_In.dart';
import 'package:app_1riel/pages/profile/Sign_Up.dart';
import 'package:app_1riel/pages/store/Store.dart';

class Routes {
  static Sign_In() => _route(Sign_In_Page());
  static Sign_Up() => _route(Sign_Up_Page());
  static Reset() => _route(Reset_Page());
  static Manage_Product() => _route(Manage_Product_Page());
  static About() => _route(About_Page());

  // exposed route names
  static final Map<String, WidgetBuilder> routes = {
    '/product': (context) => const Main_Navigator_Page(index: 0), //
    '/store': (context) => const Main_Navigator_Page(index: 1), //
    '/driver': (context) => const Main_Navigator_Page(index: 2), //
    '/profile': (context) => const Main_Navigator_Page(index: 3), //
    //
    '/about': (context) => const About_Page(), //
  };
}

MaterialPageRoute _route(Widget page) {
  return MaterialPageRoute(
    builder: (bc) => page,
    settings: RouteSettings(), //
  );
}
