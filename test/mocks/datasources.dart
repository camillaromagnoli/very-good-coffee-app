import 'package:mocktail/mocktail.dart';

import 'package:very_good_coffee_app/features/coffee/data/datasources/coffee_local_data_source.dart';
import 'package:very_good_coffee_app/features/coffee/data/datasources/coffee_remote_data_source.dart';

class MockRemoteDataSource extends Mock implements CoffeeRemoteDataSource {}

class MockLocalDataSource extends Mock implements CoffeeLocalDataSource {}
