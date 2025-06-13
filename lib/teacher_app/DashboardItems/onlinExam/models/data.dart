class QuizDataStructure {
  final Map<String, List<String>> levelClasses = {
    'Primary': ['1st Primary', '2nd Primary', '3rd Primary', '4th Primary', '5th Primary', '6th Primary'],
    'Preparatory': ['1st Preparatory', '2nd Preparatory', '3rd Preparatory'],
    'Secondary': ['1st Secondary', '2nd Secondary', '3rd Secondary'],
  };

  final Map<String, List<String>> classSubjects = {
    '1st Primary': ['Math', 'Arabic', 'English', 'Science'],
    '2nd Primary': ['Math', 'Arabic', 'English', 'Science'],
    '3rd Primary': ['Math', 'Arabic', 'English', 'Science', 'Social Studies'],
    '4th Primary': ['Math', 'Arabic', 'English', 'Science', 'Social Studies'],
    '5th Primary': ['Math', 'Arabic', 'English', 'Science', 'Social Studies'],
    '6th Primary': ['Math', 'Arabic', 'English', 'Science', 'Social Studies'],
    '1st Preparatory': ['Math', 'Arabic', 'English', 'Science', 'History'],
    '2nd Preparatory': ['Math', 'Arabic', 'English', 'Science', 'History', 'Geography'],
    '3rd Preparatory': ['Math', 'Arabic', 'English', 'Science', 'History', 'Geography'],
    '1st Secondary': ['Math', 'Arabic', 'English', 'Physics', 'Chemistry', 'Biology'],
    '2nd Secondary': ['Math', 'Arabic', 'English', 'Physics', 'Chemistry', 'Biology', 'History'],
    '3rd Secondary': ['Math', 'Arabic', 'English', 'Physics', 'Chemistry', 'Biology', 'History'],
  };
}