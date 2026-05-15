import 'package:flutter/material.dart';

import 'app.dart';
import 'core/app_dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDependencies.init();
  runApp(const QBonitaApp());
}
