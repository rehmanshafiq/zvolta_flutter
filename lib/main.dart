import 'package:flutter/material.dart';
import 'package:zvolta_flutter/core/constants/app_constants.dart';
import 'package:zvolta_flutter/core/di/injection.dart';
import 'package:zvolta_flutter/core/theme/app_theme.dart';
import 'package:zvolta_flutter/presentation/controllers/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const ZvoltaApp());
}

class ZvoltaApp extends StatelessWidget {
  const ZvoltaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
