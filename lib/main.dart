import 'package:flutter/material.dart';
import 'package:primo/core/di/service_locator.dart';
import 'package:primo/core/network/app_storage.dart';
import 'package:primo/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator(); // تفعيل حاقن التبعيات
  await AppStorage.init(); // تهيئة التخزينش
  runApp(const MyApp());
}
