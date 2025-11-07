import 'package:countries/core/di/home_binding.dart';
import 'package:countries/core/di/initializer_binding.dart';
import 'package:countries/features/home/view/pages/home_page.dart';
import 'package:countries/features/initializer/view/pages/initializer_page.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BaseRoute {
  static List<GetPage> pages() => [
    _getPage(
      name: PageTo.initializer,
      page: () => const InitializerPage(),
      binding: InitializerBinding(),
    ),
    _getPage(
      name: PageTo.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
  ];

  static GetPage _getPage({
    required dynamic name,
    required Widget Function() page,
    Bindings? binding,
  }) => GetPage(
    name: name,
    page: page,
    binding: binding,
    transition: Transition.rightToLeftWithFade,
    transitionDuration: const Duration(milliseconds: 400),
  );
}

class PageTo {
  static const initializer = "/initializer";
  static const home = "/home";
}
