import 'package:flutter_amplify_demo/services/navigation_service.dart';
import 'package:get_it/get_it.dart';

// ignore: non_constant_identifier_names
GetIt get_it_instance_const = GetIt.instance;

/// Using get_it as service locator for navigation
class GetItService {
  static void setupLocator() {
    get_it_instance_const.registerLazySingleton(() => NavigationService());
  }
}
