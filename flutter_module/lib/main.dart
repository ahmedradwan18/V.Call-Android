import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/core/helpers/helpers.dart';
import 'app/core/utils/localization_service.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/initial_bindings.dart';
import 'app/themes/app_theme.dart';

void main() async {
  // do the nececessary initializations for the application.
  WidgetsFlutterBinding.ensureInitialized();

  await Helpers.initApp();


  const platform = const MethodChannel('vlc_channel');
  platform.setMethodCallHandler((call)async{
    // you can get hear method and passed arguments with method
    print("init state setMethodCallHandler ${call.arguments}");
  });

  // to init the firebase connection.
  runApp(
    const Rooms(),
  );
}

class Rooms extends StatelessWidget {
  const Rooms({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Routes.room,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      title: 'V.Connct',
      theme: AppTheme.appTheme,
      translations: LocalizationService(),
      locale: LocalizationService.appLanguage.locale,
      localizationsDelegates: LocalizationService.localizationsDelegates,
      supportedLocales: LocalizationService.supportedLocales,
      fallbackLocale: LocalizationService.fallbackLocale,
      defaultTransition: Transition.cupertino,
    );
  }
}
