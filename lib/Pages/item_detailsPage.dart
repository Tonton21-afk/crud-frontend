import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:activity_crud/model/student.dart';
import 'package:activity_crud/services/services.dart';

class ItemDetailspage extends StatelessWidget {
  final Student student;
  const ItemDetailspage({super.key, required this.student});
  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${student.firstName} ${student.lastName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showEditDialog(context, student);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteStudent(student.id, context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First Name: ${student.firstName}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Last Name: ${student.lastName}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Course: ${student.course}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Year: ${student.year}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Enrolled: ${student.enrolled ? "Yes" : "No"}',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // Function to show edit dialog
  void _showEditDialog(BuildContext context, Student student) {
    TextEditingController firstNameController =
        TextEditingController(text: student.firstName);
    TextEditingController lastNameController =
        TextEditingController(text: student.lastName);
    TextEditingController courseController =
        TextEditingController(text: student.course);
    String dropdownValue = student.year;
    bool enrolledValue = student.enrolled;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Student'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: firstNameController,
                      decoration:
                          const InputDecoration(labelText: 'First Name'),
                    ),
                    TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                    ),
                    TextField(
                      controller: courseController,
                      decoration: const InputDecoration(labelText: 'Course'),
                    ),
                    Gap(20),
                    DropdownButtonFormField<String>(
                      value: dropdownValue,
                      items: const [
                        DropdownMenuItem<String>(
                            value: "First Year", child: Text("First Year")),
                        DropdownMenuItem<String>(
                            value: "Second Year", child: Text("Second Year")),
                        DropdownMenuItem<String>(
                            value: "Third Year", child: Text("Third Year")),
                        DropdownMenuItem<String>(
                            value: "Fourth Year", child: Text("Fourth Year")),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            dropdownValue = newValue; // Update dropdown value
                          });
                        }
                      },
                    ),
                    Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Enrolled'),
                        Switch(
                          value: enrolledValue,
                          onChanged: (bool newValue) {
                            setState(() {
                              enrolledValue = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await _updateStudent(
                      student.id,
                      firstNameController.text,
                      lastNameController.text,
                      courseController.text,
                      dropdownValue,
                      enrolledValue,
                      context,
                    );

                    Navigator.pop(context, true);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Update API
  // Update API
  Future<void> _updateStudent(String id, String firstName, String lastName,
      String course, String year, bool enrolled, BuildContext context) async {
    try {
      Student updatedStudent = Student(
        id: id,
        firstName: firstName,
        lastName: lastName,
        course: course,
        year: year,
        enrolled: enrolled,
      );
      await Services().updateStudent(id, updatedStudent);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Student updated successfully!'),
            backgroundColor: Colors.green),
      );

      // Indicate that an update occurred
      Navigator.pop(context, true); // Pass 'true' to indicate update
    } catch (error) {
      debugPrint('Error updating student: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error updating student: $error'),
            backgroundColor: Colors.red),
      );
    }
  }

  // Delete API
  Future<void> _deleteStudent(String id, BuildContext context) async {
    try {
      await Services().deleteStudent(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Student deleted successfully!'),
            backgroundColor: Colors.green),
      );
      Navigator.pop(context, true);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error deleting student: $error'),
            backgroundColor: Colors.red),
      );
    }
  }
}
