import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _box = GetStorage();
  final _key = 'isDarkMode';

  // Make isDarkMode reactive. Load initial value from storage.
  // Default to false (light mode) if nothing is saved.
  final isDarkMode = false.obs;

  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _loadThemeFromBox();
  }

  bool _loadThemeFromBox() => _box.read(_key) ?? false;
  void _saveThemeToBox(bool isDark) => _box.write(_key, isDark);

  void switchTheme() {
    isDarkMode.toggle();
    _saveThemeToBox(isDarkMode.value);
  }
}
