import 'package:flutter/material.dart';
import 'exceptions.dart';
import '../l10n/l10n.dart';

String getFailureMessage(
  Failure? failure, {
  String? fallback,
  BuildContext? context,
}) {
  if (failure == null) {
    return fallback ?? 'An unexpected error occurred';
  }

  if (failure is NetworkException) {
    if (context != null) {
      return context.l10n.offlineMessage;
    }
    return "It seems like you're offline. You can still access your favorite coffee images.";
  }

  // For generic Failure (not NetworkException, ServerException, or CacheException)
  // show a user-friendly message instead of the raw error
  if (failure is! ServerException && failure is! CacheException) {
    if (context != null) {
      return context.l10n.unexpectedError;
    }
    return fallback ?? 'An unexpected error occurred. Please try again.';
  }

  // For ServerException and CacheException, use their message or fallback
  return failure.message ?? fallback ?? 'An unexpected error occurred';
}
