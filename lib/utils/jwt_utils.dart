import 'dart:convert';

Map<String, dynamic> decodeJwtPayload(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return {};
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    return jsonDecode(payload) as Map<String, dynamic>;
  } catch (_) {
    return {};
  }
}

bool isGuestJwt(String token) => decodeJwtPayload(token)['user_type'] == 'guest';

bool isCustomerJwt(String token) => decodeJwtPayload(token)['user_type'] == 'customer';
