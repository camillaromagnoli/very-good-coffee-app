import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:very_good_coffee_app/core/di/injection.dart';

import 'core/presentation/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await configureDependencies();

  runApp(const VeryGoodCoffeeApp());
}
