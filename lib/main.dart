import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/src/app.dart';
import 'package:frontend/src/screen/shared/settings/controller/settings_controller.dart';
import 'package:frontend/src/screen/shared/settings/services/settings_service.dart';
import 'package:frontend/src/util/services/storage/auth_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  final authStorage = AuthStorage();
  await authStorage.getUser();

  runApp(
    MyApp(settingsController: settingsController, authStorage: authStorage),
  );
}
