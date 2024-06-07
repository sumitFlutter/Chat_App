
import 'package:chat_app_6099/screen/chat/view/chat_screen.dart';
import 'package:chat_app_6099/screen/contact/view/contact_screen.dart';
import 'package:chat_app_6099/screen/home/view/home_screen.dart';
import 'package:chat_app_6099/screen/splash/view/splash_screen.dart';
import 'package:chat_app_6099/screen/user/view/profile/profile_screen.dart';
import 'package:chat_app_6099/screen/user/view/signUp/sign_up_screen.dart';
import 'package:flutter/material.dart';

import '../../screen/user/view/signIn/sign_in_screen.dart';

Map<String, WidgetBuilder> chatAppRoutes = {
  "/":(context) => const SplashScreen(),
  'SignIn': (context) => const SignInScreen(),
  "signUp":(context) => const SignUpScreen(),
  "profile":(context) => const ProfileScreen(),
  "home":(context) => const HomeScreen(),
  "chat":(context) => const ChatScreen(),
  "contact":(context) => const ContactScreen()
};
