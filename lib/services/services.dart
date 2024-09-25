import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:activity_crud/model/student.dart';

class Services {
  final String baseUrl = 'https://crud-backend-lovat.vercel.app';

  // Fetch all students
  Future<List<Student>> fetchStudents() async {
    final response = await http.get(Uri.parse('$baseUrl/students'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('students')) {
        List<dynamic> body = jsonResponse['students'];
        return body.map((dynamic json) => Student.fromJson(json)).toList();
      } else {
        throw Exception('Key "students" not found in response');
      }
    } else {
      throw Exception(
          'Failed to load students, status code: ${response.statusCode}');
    }
  }

  // Add a new student
  Future<void> addStudent(Student student) async {
    final response = await http.post(
      Uri.parse('$baseUrl/students'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'firstName': student.firstName,
        'lastName': student.lastName,
        'course': student.course,
        'year': student.year,
        'enrolled': student.enrolled,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          'Failed to add student, status code: ${response.statusCode}');
    }
  }

  //update
  Future<void> updateStudent(String id, Student student) async {
    final response = await http.put(
      Uri.parse('$baseUrl/students/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(student.toJson()),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['student'] != null) {
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to update student: ${response.body}');
    }
  }

  // Delete a student
  Future<void> deleteStudent(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/students/$id'));

      if (response.statusCode != 200 && response.statusCode != 204) {
        // Change the condition to check for 204 No Content status
        throw Exception(
            'Failed to delete student, status code: ${response.statusCode}, response: ${response.body}');
      }
    } catch (e) {
      print('Error deleting student: $e');
      throw Exception('Error deleting student: $e');
    }
  }
}
