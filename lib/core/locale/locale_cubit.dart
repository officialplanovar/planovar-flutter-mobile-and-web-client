import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the app's active locale and persists the choice. Drives
/// MaterialApp.locale so a language change takes effect app-wide.
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  static const _key = 'preferred_language';

  /// Languages with actual translations available today.
  static const supported = ['en', 'fr'];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null && supported.contains(code)) emit(Locale(code));
  }

  Future<void> setLocale(String code) async {
    if (!supported.contains(code)) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, code);
    emit(Locale(code));
  }
}
