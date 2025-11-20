import 'package:flutter/material.dart';
import 'package:very_good_coffee_app/core/design/tokens/spacing.dart';
import 'package:very_good_coffee_app/core/l10n/l10n.dart';

class FailureWidget extends StatelessWidget {
  const FailureWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.secondaryAction,
    this.secondaryActionLabel,
  });

  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? secondaryAction;
  final String? secondaryActionLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(message, textAlign: TextAlign.center),
        if (onRetry != null || secondaryAction != null) ...[
          const SizedBox(height: Spacing.md),
          if (onRetry != null && secondaryAction != null)
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: onRetry,
                    child: Text(context.l10n.retryButton),
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: OutlinedButton(
                    onPressed: secondaryAction,
                    child: Text(secondaryActionLabel!),
                  ),
                ),
              ],
            )
          else if (onRetry != null)
            FilledButton(
              onPressed: onRetry,
              child: Text(context.l10n.retryButton),
            )
          else if (secondaryAction != null)
            FilledButton(
              onPressed: secondaryAction,
              child: Text(secondaryActionLabel!),
            ),
        ],
      ],
    );
  }
}
