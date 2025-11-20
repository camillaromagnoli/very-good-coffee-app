import 'package:flutter/material.dart';
import 'exceptions.dart';
import '../l10n/l10n.dart';

String getFailureMessage(
  Failure? failure, {
  String? fallback,
  required BuildContext context,
}) {
  if (failure == null) {
    return fallback ?? context.l10n.unexpectedError;
  }

  if (failure is NetworkException) {
    return context.l10n.offlineMessage;
  }

  if (failure is! ServerException && failure is! CacheException) {
    return context.l10n.unexpectedError;
  }

  return failure.message ?? fallback ?? context.l10n.unexpectedError;
}
