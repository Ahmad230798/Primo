import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:primo/core/di/service_locator.dart';
import 'package:primo/core/network/app_storage.dart';
import 'package:primo/core/services/firebase_messaging_service.dart';
import 'package:primo/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase init note: $e");
  }
  setupServiceLocator(); // تفعيل حاقن التبعيات
  await AppStorage.init(); // تهيئة التخزين**
  await getIt<FirebaseCloudMessagingService>().init();
  runApp(const MyApp());
}
