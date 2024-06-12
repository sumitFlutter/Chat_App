import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/helpers/share_helper.dart';
class ThemeController extends GetxController{
  RxBool theme=false.obs;
  Rx<ThemeMode> mode=ThemeMode.light.obs;
  Rx<IconData> themeMode=Icons.dark_mode.obs;
  RxBool pTheme=false.obs;
  ShareHelper shareHelper=ShareHelper();
  RxString bgImage="assets/background/light1.jpg".obs;
  void setTheme()
  async {
    theme.value=!theme.value;
    shareHelper.saveTheme(pTheme: theme.value);
    pTheme.value=(await shareHelper.applyTheme())!;
    if(pTheme.value==true)
    {
      mode.value=ThemeMode.dark;
      themeMode.value=Icons.light_mode;
      bgImage.value="assets/background/dark.jpg";
    }
    else if(pTheme.value==false)
    {
      mode.value=ThemeMode.light;
      themeMode.value=Icons.dark_mode;
      bgImage.value="assets/background/light1.jpg";
    }
    else
    {
      mode.value=ThemeMode.light;
      themeMode.value=Icons.dark_mode;
      bgImage.value="assets/background/light1.jpg";
    }
  }
  void getTheme()
  async{
    if(await shareHelper.applyTheme()==null)
    {
      pTheme.value=true;
    }
    else
    {
      pTheme.value=(await shareHelper.applyTheme())!;
    }
    if(pTheme.value==true)
    {
      mode.value=ThemeMode.dark;
      themeMode.value=Icons.light_mode;
      bgImage.value="assets/background/dark.jpg";
    }
    else if(pTheme.value==false)
    {
      mode.value=ThemeMode.light;
      themeMode.value=Icons.dark_mode;
      bgImage.value="assets/background/light1.jpg";

    }
    else
    {
      mode.value=ThemeMode.light;
      themeMode.value=Icons.dark_mode;
      bgImage.value="assets/background/light1.jpg";
    }
  }
}