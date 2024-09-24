import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'item_detailsPage.dart';
import 'package:http/http.dart' as http;
import 'package:activity_crud/services/services.dart';
import 'package:activity_crud/model/student.dart';

class Listviewpage extends StatefulWidget {
  const Listviewpage({super.key});

  @override
  _ListviewpageState createState() => _ListviewpageState();
}

class _ListviewpageState extends State<Listviewpage> {
  final Services _studentService = Services();
  List<Student> students = [];
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController course = TextEditingController();
  String dropdownValue = 'First Year';
  bool isEnrolled = false;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  // Fetch students from the API
  Future<void> _fetchStudents() async {
    try {
      List<Student> fetchedStudents = await _studentService.fetchStudents();
      setState(() {
        students = fetchedStudents;
      });
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (BuildContext context, int index) {
                final student = students[index];

                return (Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: Text('${student.firstName} ${student.lastName}'),
                        subtitle: Text(student.course),
                        onTap: () async {
                         
                          final result = await Navigator.pushNamed(
                            context,
                            ItemDetailspage.routeName,
                            arguments: student,
                          );

                          
                          if (result == true) {
                            _fetchStudents(); 
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 1.0),
                  ],
                ));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: ElevatedButton(
              onPressed: () => _showAddStudentDialog(),
              child: const Text('Add Student'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddStudentDialog() async {
    bool localIsEnrolled = false;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Add Student',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Gap(20),
                    TextField(
                      controller: firstName,
                      decoration: const InputDecoration(
                        label: Text('First Name'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                    Gap(10),
                    TextField(
                      controller: lastName,
                      decoration: const InputDecoration(
                        label: Text('Last Name'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                    Gap(10),
                    TextField(
                      controller: course,
                      decoration: const InputDecoration(
                        label: Text("Course"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                    Gap(20),
                    DropdownButtonFormField<String>(
                      value: dropdownValue,
                      items: const [
                        DropdownMenuItem<String>(
                          value: "First Year",
                          child: Text("First Year"),
                        ),
                        DropdownMenuItem<String>(
                          value: "Second Year",
                          child: Text("Second Year"),
                        ),
                        DropdownMenuItem<String>(
                          value: "Third Year",
                          child: Text("Third Year"),
                        ),
                        DropdownMenuItem<String>(
                          value: "Fourth Year",
                          child: Text("Fourth Year"),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                    Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Enrolled'),
                        Switch(
                          value: localIsEnrolled,
                          onChanged: (bool newValue) {
                            setState(() {
                              localIsEnrolled = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            firstName.clear();
                            lastName.clear();
                            course.clear();
                            setState(() {
                              dropdownValue = "First Year";
                              isEnrolled = localIsEnrolled;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        ),
                        const Gap(20),
                        TextButton(
                          onPressed: () {
                            _addStudent(
                              firstName.text,
                              lastName.text,
                              course.text,
                              dropdownValue,
                              localIsEnrolled,
                            );
                            firstName.clear();
                            lastName.clear();
                            course.clear();
                            setState(() {
                              dropdownValue = "First Year";
                              isEnrolled = localIsEnrolled;
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _addStudent(String firstName, String lastName, String course,
      String year, bool enrolled) async {
    final newStudent = Student(
      id: '',
      firstName: firstName,
      lastName: lastName,
      course: course,
      year: year,
      enrolled: enrolled,
    );

    try {
      await _studentService.addStudent(newStudent);
      _fetchStudents();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Failed to add student: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
