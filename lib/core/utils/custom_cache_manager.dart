import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager {
  static const key = 'customCacheKey';

  static CacheManager? _instance;

  static CacheManager get instance {
    _instance ??= _createCacheManager();
    return _instance!;
  }

  static CacheManager _createCacheManager() {
    if (kIsWeb) {
      // For web, use the default config which uses IndexedDB.
      return CacheManager(
        Config(
          key,
          stalePeriod: const Duration(days: 30),
          maxNrOfCacheObjects: 500,
        ),
      );
    } else {
      // For mobile, use IOFileSystem.
      return CacheManager(
        Config(
          key,
          stalePeriod: const Duration(days: 30),
          maxNrOfCacheObjects: 500,
          repo: JsonCacheInfoRepository(databaseName: key),
          fileSystem: IOFileSystem(key),
          fileService: HttpFileService(),
        ),
      );
    }
  }
}
