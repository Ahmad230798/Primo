import 'package:flutter/material.dart';
import 'package:primo/core/network/app_storage.dart';
import 'package:primo/my_app.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage.init(); // تهيئة التخزين
  runApp(const MyApp());
}
