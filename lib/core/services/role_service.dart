import 'package:shared_preferences/shared_preferences.dart';
import 'package:almaali_university_center/core/constants/user_role.dart';

/// Service to manage user role persistence
class RoleService {
  static const String _roleKey = 'user_role';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';

  /// Save user role
  static Future<void> saveRole(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role.toStringValue());
  }

  /// Get current user role
  static Future<UserRole> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    final roleString = prefs.getString(_roleKey);
    if (roleString == null) {
      return UserRole.unauthenticated;
    }
    return UserRoleExtension.fromString(roleString);
  }

  /// Save user ID
  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  /// Get user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  /// Save user name
  static Future<void> saveUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, userName);
  }

  /// Get user name
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  /// Clear all user data (logout)
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_roleKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove('token');
  }

  /// Check if role exists (not unauthenticated)
  static Future<bool> hasValidRole() async {
    final prefs = await SharedPreferences.getInstance();
    final roleString = prefs.getString(_roleKey);
    return roleString != null && roleString.isNotEmpty;
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final role = await getRole();
    return role != UserRole.unauthenticated;
  }
}
