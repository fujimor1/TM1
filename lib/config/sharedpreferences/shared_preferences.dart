// import 'package:shared_preferences/shared_preferences.dart';

// class PreferenciasUsuario{
//   static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();

//   factory PreferenciasUsuario() {
//     return _instancia;
//   }
//   PreferenciasUsuario._internal();

//   late SharedPreferences _prefs;

//   initPrefs() async{
//     _prefs = await SharedPreferences.getInstance();
//   }

//   String get dni {
//     return _prefs.getString('dni') ?? '';
//   }

//   set dni(String value) {
//     _prefs.setString('dni', value);
//   }

//   String get password {
//     return _prefs.getString('password') ?? '';
//   }

//   set password(String value) {
//     _prefs.setString('password', value);
//   }

//   bool get saveSesion {
//     return _prefs.getBool('saveSesion') ?? false;
//   }

//   set saveSesion(bool value) {
//     _prefs.setBool('saveSesion', value);
//   }

//   String get tipoUsuario {
//     return _prefs.getString('tipoUsuario') ??  '';
//   } 

//   set tipoUsuario(String value){
//     _prefs.setString('tipoUsuario', value);
//   }


// }