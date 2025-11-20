import 'dart:typed_data';

import 'package:very_good_coffee_app/features/coffee/domain/entities/coffee.dart';

class CoffeeModel extends Coffee {
  const CoffeeModel({
    required super.id,
    required super.imageUrl,
    required super.imageBytes,
  });

  Coffee toEntity() =>
      Coffee(id: id, imageUrl: imageUrl, imageBytes: imageBytes);

  factory CoffeeModel.fromEntity(Coffee coffee) => CoffeeModel(
    id: coffee.id,
    imageUrl: coffee.imageUrl,
    imageBytes: coffee.imageBytes,
  );

  factory CoffeeModel.fromJson(Map<String, dynamic> json) => CoffeeModel(
    id: json['id'] as String,
    imageUrl: json['imageUrl'] as String,
    imageBytes: Uint8List.fromList((json['imageBytes'] as List).cast<int>()),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'imageUrl': imageUrl,
    'imageBytes': imageBytes.toList(),
  };
}
