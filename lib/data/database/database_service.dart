import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DatabaseService extends GetxService {
  late final GetStorage _box;

  @override
  void onInit() {
    _box = GetStorage();
    debugPrint("[DatabaseService] > onInit");
    super.onInit();
  }

  Future<void> saveData(String key, dynamic value) async {
    await _box.write(key, value);
    debugPrint("[DatabaseService] > save $key > $value");
  }

  dynamic readData(String key) {
    final data = _box.read(key);
    debugPrint("[DatabaseService] > read $key > $data");
    return data;
  }

  Future<void> erase() async {
    await _box.erase();
    debugPrint("[DatabaseService] > erase");
  }
}
