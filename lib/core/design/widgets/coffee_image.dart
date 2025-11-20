import 'package:flutter/material.dart';
import 'package:very_good_coffee_app/core/l10n/l10n.dart';
import 'package:very_good_coffee_app/features/coffee/domain/entities/coffee.dart';

class CoffeeImage extends StatelessWidget {
  const CoffeeImage({super.key, required this.coffee});

  final Coffee coffee;

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      coffee.imageBytes,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (context, _, __) {
        return Center(child: Text(context.l10n.failedToDisplayImage));
      },
    );
  }
}
