import 'package:countries/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotFoundIndicator extends StatelessWidget {
  const NotFoundIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      width: 230,
      child: Lottie.asset(
        'assets/lottie/not_found.lottie',
        decoder: lottieFileDecoder,
      ),
    );
  }
}
