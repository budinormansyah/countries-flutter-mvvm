import 'package:countries/core/utils/custom_cache_manager.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_svg/flutter_svg.dart';

class CachedNetworkSvg extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;

  const CachedNetworkSvg({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.placeholder,
  });

  Future<Uint8List?> _getAndCacheFileBytes() async {
    // First, try to get the file from the cache.
    final fileInfo = await CustomCacheManager.instance.getFileFromCache(url);
    if (fileInfo != null) {
      return await fileInfo.file.readAsBytes();
    }
    // If not in cache, download it. This also caches it for future use.
    final downloadedFile = await CustomCacheManager.instance.downloadFile(url);
    return await downloadedFile.file.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    // Use a FutureBuilder to get the image bytes.
    return FutureBuilder<Uint8List?>(
      future: _getAndCacheFileBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder ??
              const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data != null) {
          // If bytes are available, render them.
          return SvgPicture.memory(
            snapshot.data!,
            width: width,
            height: height,
            fit: fit,
          );
        } else {
          // Handle error or show a fallback
          return placeholder ?? const Icon(Icons.error);
        }
      },
    );
  }
}
