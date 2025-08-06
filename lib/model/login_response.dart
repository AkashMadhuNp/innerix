class LoginResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? user;
  final String? accessToken;
  final String? refreshToken;

  LoginResponse({
    required this.success,
    required this.message,
    this.user,
    this.accessToken,
    this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? json['status'] ?? false,
      message: json['message'] ?? '',
      user: json['user'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user': user,
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }
}