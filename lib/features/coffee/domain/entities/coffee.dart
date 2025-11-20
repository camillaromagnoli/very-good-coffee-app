import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class Coffee extends Equatable {
  const Coffee({
    required this.id,
    required this.imageUrl,
    required this.imageBytes,
  });

  final String id;
  final String imageUrl;
  final Uint8List imageBytes;

  @override
  List<Object?> get props => [id, imageUrl, imageBytes];
}
