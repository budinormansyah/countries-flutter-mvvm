import 'package:countries/core/widgets/loading_indicator.dart';
import 'package:countries/features/initializer/view_model/initializer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitializerPage extends GetView<InitializerViewModel> {
  const InitializerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: () {
              controller.gotoHomePage();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LoadingIndicator(key: ValueKey('loading')),
                Obx(
                  () => Text(
                    controller.errorMessage.value.isNotEmpty
                        ? controller.errorMessage.value
                        : 'Loading...',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
