
import 'package:chat_app_6099/screen/splash/controller/theme_controller.dart';
import 'package:chat_app_6099/utils/helpers/fcm_helper.dart';
import 'package:chat_app_6099/utils/routes/chat_routes.dart';
import 'package:chat_app_6099/utils/service/notification_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'main.dart';
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
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeController.mode.value,
        );
      }
    ),
  );
}