import 'package:mifadeschats/services/singleton/firebase_storage.dart';
import 'package:mifadeschats/services/singleton/local_notification.dart';
import 'package:mifadeschats/services/singleton/shared_preferences.dart';

void setupLocator() {
  getIt.registerSingleton<SharedPref>(SharedPref());
  getIt.registerLazySingleton(() => LocalNotification());
  getIt.registerLazySingleton(() => FirestoreStorage());
}
