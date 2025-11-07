import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Converts a [Color] object to a hex string (e.g., 'ff0000' for red).
String rgbToHex(Color color) {
  // Use the recommended component accessors to avoid deprecated 'value' property.
  final r = color.red.toRadixString(16).padLeft(2, '0');
  final g = color.green.toRadixString(16).padLeft(2, '0');
  final b = color.blue.toRadixString(16).padLeft(2, '0');
  return '$r$g$b';
}

/// Converts a hex string (with an optional '#' prefix) to a [Color] object.
Color hexToColor(String hex) {
  final hexCode = hex.startsWith('#') ? hex.substring(1) : hex;
  // Handle 8-digit hex codes (with alpha) as well as 6-digit codes.
  if (hexCode.length == 6) {
    return Color(int.parse('FF$hexCode', radix: 16));
  } else {
    // Assumes 8-digit hex code if not 6.
    return Color(int.parse(hexCode, radix: 16));
  }
}

void showSnackBar({
  required String title,
  required String message,
  Color backgroundColor = Colors.redAccent,
}) {
  if (Get.isSnackbarOpen) {
    Get.closeCurrentSnackbar();
  }
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: backgroundColor,
    colorText: Colors.white,
    borderRadius: 10,
    margin: const EdgeInsets.all(10),
    icon: const Icon(Icons.error_outline, color: Colors.white),
    duration: const Duration(seconds: 4),
  );
}

void addFontLicenseRegistry() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString(
      'assets/fonts/ComicRelief/OFL.txt',
    );
    yield LicenseEntryWithLineBreaks(['fonts'], license);
  });
}

Future<String> getAppVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

Future<String> loadFromJsonFile(String path) async {
  return await rootBundle.loadString(path);
}

Future<LottieComposition?> lottieFileDecoder(List<int> bytes) {
  return LottieComposition.decodeZip(
    bytes,
    filePicker: (files) {
      return files.firstWhereOrNull(
        (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'),
      );
    },
  );
}
