
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_chat/screen/splash/controller/theme_controller.dart';
import 'package:galaxy_chat/utils/helpers/fcm_helper.dart';
import 'package:galaxy_chat/utils/routes/chat_routes.dart';
import 'package:galaxy_chat/utils/service/notification_helper.dart';
import 'package:galaxy_chat/utils/theme/app_theme.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
ThemeController themeController=Get.put(ThemeController());
void main()
async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
NotificationService.service.initNotification();
FCMHelper.fcm.receiveMessage();
  runApp(
    Obx(
      () {
        themeController.getTheme();
        themeController.theme=themeController.pTheme;
        return
        GetMaterialApp(
          debugShowCheckedModeBanner: false,
          routes: chatAppRoutes,
          theme: light,
          darkTheme: dark,
          themeMode: themeController.mode.value,
        );
      }
    ),
  );
}