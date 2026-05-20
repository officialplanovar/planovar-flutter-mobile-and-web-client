import '../../shared/models/user_model.dart';
import 'mock_data.dart';

class MockAuthService {
  static const _delay = Duration(milliseconds: 400);

  Future<UserModel> signIn({required String email, required String password}) async {
    await Future.delayed(_delay);
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }
    return MockData.currentUser;
  }

  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(_delay);
    final parts = fullName.trim().split(' ');
    return MockData.currentUser.copyWith(
      name: fullName,
      email: email,
      firstName: parts.isNotEmpty ? parts.first : fullName,
      lastName: parts.length > 1 ? parts.last : '',
    );
  }

  Future<bool> verifyOtp({required String email, required String otp}) async {
    await Future.delayed(_delay);
    return otp.length == 6;
  }

  Future<bool> forgotPassword({required String email}) async {
    await Future.delayed(_delay);
    return true;
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    await Future.delayed(_delay);
    return true;
  }

  Future<UserModel> getMe() async {
    await Future.delayed(_delay);
    return MockData.currentUser;
  }

  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? image,
  }) async {
    await Future.delayed(_delay);
    return MockData.currentUser.copyWith(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      image: image,
    );
  }

  Future<bool> setPreferences({
    String? country,
    String? city,
    List<String>? categoryPrefs,
  }) async {
    await Future.delayed(_delay);
    return true;
  }
}
