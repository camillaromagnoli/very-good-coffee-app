import 'package:flutter/material.dart';
import 'package:very_good_coffee_app/core/design/tokens/tokens.dart';
import 'package:very_good_coffee_app/core/design/widgets/coffee_image.dart';
import 'package:very_good_coffee_app/core/l10n/l10n.dart';
import 'package:very_good_coffee_app/features/coffee/domain/entities/coffee.dart';

class CoffeeViewerPage extends StatelessWidget {
  const CoffeeViewerPage({required this.coffee, super.key});

  final Coffee coffee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.coffeeViewerPageTitle)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(BorderRadiusTokens.r16),
              child: CoffeeImage(coffee: coffee),
            ),
          ),
        ),
      ),
    );
  }
}
