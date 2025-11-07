import 'package:countries/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      width: 160,
      child: Lottie.asset(
        'assets/lottie/loading.lottie',
        decoder: lottieFileDecoder,
      ),
    );
  }
}
