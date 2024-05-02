import 'dart:convert';
import 'package:blnk_yeni/LoginAndSignup/user.dart'; // user.dart dosyasının bulunduğu yola göre uygun şekilde import edilmiştir
import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPrefs {
  //save-remember User-info
  static Future<void> saveRememberUser(User userInfo) async { // userinfo yerine userInfo olarak düzeltilmiştir
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString("currentUser", userJsonData);
  }
}
