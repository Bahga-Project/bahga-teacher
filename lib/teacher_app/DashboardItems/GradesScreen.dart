import 'package:flutter/material.dart';
import '../../Refactoration/Colors.dart';
import '../../Refactoration/common_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GradesScreen extends StatefulWidget {
  @override
  _GradesPageState createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesScreen> {
  String? selectedLevel;
  String? selectedClass;
  String? selectedSubject;
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> allStudents = [
    {
      "name": "Ahmed Mohamed",
      "class": "Class A",
      "subject": "Math",
      "mid": "",
      "quiz": "",
      "total": ""
    },
    {
      "name": "Mohamed Nasser",
      "class": "Class A",
      "subject": "Science",
      "mid": "",
      "quiz": "",
      "total": ""
    },
    {
      "name": "Khalid Ali",
      "class": "Class B",
      "subject": "English",
      "mid": "",
      "quiz": "",
      "total": ""
    },
    {
      "name": "Hayam Ahmed",
      "class": "Class B",
      "subject": "Math",
      "mid": "",
      "quiz": "",
      "total": ""
    },
    {
      "name": "Sara Ahmed",
      "class": "Class C",
      "subject": "Science",
      "mid": "",
      "quiz": "",
      "total": ""
    },
    {
      "name": "Hager Maher",
      "class": "Class C",
      "subject": "English",
      "mid": "",
      "quiz": "",
      "total": ""
    },
    {
      "name": "Ali Mahmoud",
      "class": "Class A",
      "subject": "Math",
      "mid": "",
      "quiz": "",
      "total": ""
    },
  ];

  List<Map<String, dynamic>> filteredStudents = [];

  final List<String> levels = ['Level 1', 'Level 2', 'Level 3'];
  final List<String> classes = ['Class A', 'Class B', 'Class C'];
  final List<String> subjects = ['Math', 'Science', 'English'];

  @override
  void initState() {
    super.initState();
    _loadGrades();
  }

  Future<void> _loadGrades() async {
    final prefs = await SharedPreferences.getInstance();
    final savedGrades = prefs.getStringList('grades') ?? [];
    if (savedGrades.isNotEmpty) {
      setState(() {
        for (int i = 0; i < allStudents.length && i < savedGrades.length; i++) {
          final gradeData = savedGrades[i].split(',');
          if (gradeData.length == 3) {
            allStudents[i]['mid'] = gradeData[0];
            allStudents[i]['quiz'] = gradeData[1];
            allStudents[i]['total'] = gradeData[2];
          }
        }
        _filterStudents();
      });
    }
  }

  @override
  void dispose() {
    _saveGradesToStorage();
    _searchController.dispose();
    super.dispose();
  }

  void _updateTotal(int index) {
    final mid = int.tryParse(filteredStudents[index]['mid'] ?? '') ?? 0;
    final quiz = int.tryParse(filteredStudents[index]['quiz'] ?? '') ?? 0;
    setState(() {
      filteredStudents[index]['total'] = (mid + quiz).toString();
    });
  }

  void _saveGrades() {
    _saveGradesToStorage();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grades saved successfully!')),
    );
  }

  Future<void> _saveGradesToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final gradeList = allStudents.map((student) {
      return '${student['mid']},${student['quiz']},${student['total']}';
    }).toList();
    await prefs.setStringList('grades', gradeList);
  }

  void _filterStudents() {
    if (selectedLevel != null &&
        selectedClass != null &&
        selectedSubject != null) {
      setState(() {
        filteredStudents = allStudents
            .where((student) =>
                student['class'] == selectedClass &&
                student['subject'] == selectedSubject)
            .toList();
        if (_searchController.text.isNotEmpty) {
          filteredStudents = filteredStudents
              .where((student) => student['name']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
              .toList();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Grades',
        showBackButton: true,
        showSearchIcon: true,
        onSearchPressed: () {
          setState(() {
            isSearching = !isSearching;
            if (!isSearching) {
              _searchController.clear();
              _filterStudents();
            }
          });
        },
        searchField: isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: AppColors.white),
                decoration: const InputDecoration(
                  hintText: 'Search ...',
                  hintStyle: TextStyle(color: AppColors.white),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  _filterStudents();
                },
              )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: CreateDropdown(
                        value: selectedLevel,
                        items: levels,
                        onChanged: (value) => setState(() {
                          selectedLevel = value;
                          _filterStudents();
                        }),
                        hint: 'Select level',
                      ),
                    ),
                    SizedBox(width: 16),
                    Flexible(
                      child: CreateDropdown(
                        value: selectedClass,
                        items: classes,
                        onChanged: (value) => setState(() {
                          selectedClass = value;
                          _filterStudents();
                        }),
                        hint: 'Select Class',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Center(
                  child: Flexible(
                    child: CreateDropdown(
                      value: selectedSubject,
                      items: subjects,
                      onChanged: (value) => setState(() {
                        selectedSubject = value;
                        _filterStudents();
                      }),
                      hint: 'Select Sub',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (filteredStudents.isNotEmpty)
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                'No',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Mid',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Quiz',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'Total',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredStudents.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text('${index + 1}'),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child:
                                          Text(filteredStudents[index]['name']),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            filteredStudents[index]['mid'] =
                                                value;
                                            _updateTotal(index);
                                          });
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(8.0),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 1,
                                      child: TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            filteredStudents[index]['quiz'] =
                                                value;
                                            _updateTotal(index);
                                          });
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(8.0),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        filteredStudents[index]['total'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            CustomButton(
              buttonText: 'Submit',
              onPressed: _saveGrades,
            ),
          ],
        ),
      ),
    );
  }
}
