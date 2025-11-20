import 'dart:typed_data';

import 'package:very_good_coffee_app/features/coffee/domain/entities/coffee.dart';


final tCoffee = Coffee(
  id: '1',
  imageUrl: 'https://example.com/coffee.jpg',
  imageBytes: Uint8List.fromList([1, 2, 3]),
);
