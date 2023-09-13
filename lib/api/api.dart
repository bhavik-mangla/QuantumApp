import 'dart:convert';
import 'package:http/http.dart' as http;

// final String serverBaseUrl =
//     'http://10.0.2.2:5000'; // Replace with your server address
final String serverBaseUrl = 'http://127.0.0.1:5000';

Future<bool> registerUser(String username, String password) async {
  final url = Uri.parse('$serverBaseUrl/register');
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  final data = <String, String>{
    'username': username,
    'password': password,
  };

  try {
    final response =
        await http.post(url, headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      // Registration successful
      return true;
    } else {
      // Registration failed
      return false;
    }
  } catch (e) {
    // Handle exceptions
    return false;
  }
}

Future<bool> loginUser(String username, String password) async {
  final url = Uri.parse('$serverBaseUrl/login');
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  final data = <String, String>{
    'username': username,
    'password': password,
  };

  try {
    final response =
        await http.post(url, headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      // Login successful
      return true;
    } else {
      // Login failed
      return false;
    }
  } catch (e) {
    // Handle exceptions
    return false;
  }
}

Future<bool> storePassword(
    String username, String sitename, String password, String type) async {
  final url = Uri.parse('$serverBaseUrl/store-password');
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  final data = <String, String>{
    'username': username,
    'sitename': sitename,
    'password': password,
    'type': type,
  };

  try {
    final response =
        await http.post(url, headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      // Password stored successfully
      return true;
    } else {
      // Storing password failed
      return false;
    }
  } catch (e) {
    // Handle exceptions
    return false;
  }
}

Future<List<Map<String, String>>> getPasswords(
    String username, String type) async {
  final url =
      Uri.parse('$serverBaseUrl/passwords?username=$username&type=$type');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final passwordList = jsonData['passwords'] as List<dynamic>;
      return passwordList
          .map((item) => Map<String, String>.from(item as Map<String, dynamic>))
          .toList();
    } else {
      // Failed to retrieve passwords
      return [];
    }
  } catch (e) {
    // Handle exceptions
    return [];
  }
}

Future<bool> deletePassword(String username, String sitename) async {
  final url = Uri.parse('$serverBaseUrl/delete-password');
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  final data = <String, String>{
    'username': username,
    'sitename': sitename,
  };

  try {
    final response =
        await http.post(url, headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      // Password deleted successfully
      return true;
    } else {
      // Deleting password failed
      return false;
    }
  } catch (e) {
    // Handle exceptions
    return false;
  }
}

Future<bool> updatePassword(
    String username, String sitename, String newPassword) async {
  final url = Uri.parse('$serverBaseUrl/update-password');
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  final data = <String, String>{
    'username': username,
    'sitename': sitename,
    'new_password': newPassword,
  };

  try {
    final response =
        await http.post(url, headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      // Password updated successfully
      return true;
    } else {
      // Updating password failed
      return false;
    }
  } catch (e) {
    // Handle exceptions
    return false;
  }
}

Future<bool> share_Password(String user2Username, String user1Username,
    String sitename, String password, String type) async {
  final url = Uri.parse('$serverBaseUrl/password-sharing');

  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };

  final data = <String, String>{
    'user2_username': user2Username,
    'user1_username': user1Username,
    'sitename': sitename,
    'password': password,
    'type': type,
  };

  try {
    final response =
        await http.post(url, headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      // Password shared successfully
      return true;
    } else {
      // Sharing password failed
      return false;
    }
  } catch (e) {
    // Handle exceptions
    return false;
  }
}
