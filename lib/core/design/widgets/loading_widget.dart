import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:very_good_coffee_app/core/design/tokens/spacing.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: Spacing.md,
        children: [
          Lottie.asset('assets/coffee.json', width: 200, height: 200),
          const Text('Brewing your coffee...'),
        ],
      ),
    );
  }
}
