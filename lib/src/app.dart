import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frontend/src/config/routes/app_router.dart';
import 'package:frontend/src/config/themes/app_theme.dart';
import 'package:frontend/src/screen/shared/settings/controller/settings_controller.dart';
import 'package:frontend/src/util/services/storage/auth_storage.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
    required this.authStorage,
  });

  final SettingsController settingsController;
  final AuthStorage authStorage;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsController),
        ChangeNotifierProvider.value(value: authStorage),
      ],
      child: ListenableBuilder(
        listenable: settingsController,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            restorationScopeId: 'app',
            localizationsDelegates: const [
              //AppLocalizations is missing
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', '')],
            theme: TAppTheme.lightTheme,
            darkTheme: TAppTheme.darkTheme,
            themeMode: settingsController.themeMode,
            routerConfig: AppRouter().config(
              navigatorObservers: () => [routeObserver],
            ),
          );
        },
      ),
    );
  }
}
