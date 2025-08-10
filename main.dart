import 'package:flutter/material.dart';

void main() {
  runApp(SmartQuestionsApp());
}

class SmartQuestionsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Questions',
      debugShowCheckedModeBanner: false,
      home: QuizPage(),
    );
  }
}

class Question {
  String questionText;
  List<String> options;
  int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class QuizPage extends StatefulWidget {
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<List<Question>> allQuestions = [
    [
      Question(
        questionText: "বাংলাদেশের রাজধানীর নাম কী?",
        options: ["খুলনা", "রংপুর", "ঢাকা", "চট্টগ্রাম"],
        correctAnswerIndex: 2,
      ),
      Question(
        questionText: "বাংলাদেশের জাতীয় ফুল কোনটি?",
        options: ["শাপলা", "গোলাপ", "জবা", "চামেলী"],
        correctAnswerIndex: 0,
      ),
      Question(
        questionText: "পৃথিবীর বৃহত্তম মহাসাগর কোনটি?",
        options: ["অ্যাটলান্টিক", "ইন্ডিয়ান", "আর্কটিক", "প্যাসিফিক"],
        correctAnswerIndex: 3,
      ),
      Question(
        questionText: "মানব দেহের সবচেয়ে বড় অঙ্গ কোনটি?",
        options: ["মস্তিষ্ক", "হৃদয়", "চামড়া", "যকৃত"],
        correctAnswerIndex: 2,
      ),
      Question(
        questionText: "বাংলাদেশের স্বাধীনতা ঘোষণা হয় কোন বছর?",
        options: ["১৯৭১", "১৯৬৫", "১৯৮০", "১৯৭৫"],
        correctAnswerIndex: 0,
      ),
    ],
    [
      Question(
        questionText: "সুর্যের সবচেয়ে কাছের গ্রহ কোনটি?",
        options: ["বুধ", "শনি", "মঙ্গল", "বৃহস্পতি"],
        correctAnswerIndex: 0,
      ),
      Question(
        questionText: "আইফেল টাওয়ার কোথায় অবস্থিত?",
        options: ["লন্ডন", "প্যারিস", "নিউইয়র্ক", "রোম"],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: "বাংলাদেশের জাতীয় খেলা কী?",
        options: ["ক্রিকেট", "ফুটবল", "হকি", "ব্যাডমিন্টন"],
        correctAnswerIndex: 2,
      ),
      Question(
        questionText: "মানব দেহে রক্তের প্রধান রং কী?",
        options: ["নীল", "লাল", "সবুজ", "হলুদ"],
        correctAnswerIndex: 1,
      ),
      Question(
        questionText: "দ্রুততম প্রাণী কোনটি?",
        options: ["চিতা", "শের", "গরু", "হাতি"],
        correctAnswerIndex: 0,
      ),
    ],
  ];

  int currentSetIndex = 0;
  Map<int, int> selectedAnswers = {};
  bool answered = false;

  void selectAnswer(int questionIndex, int optionIndex) {
    if (!answered) {
      setState(() {
        selectedAnswers[questionIndex] = optionIndex;
      });
    }
  }

  void checkAnswers() {
    if (selectedAnswers.length < allQuestions[currentSetIndex].length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('সব প্রশ্নের উত্তর দিন')),
      );
      return;
    }
    setState(() {
      answered = true;
    });
  }

  void nextQuestions() {
    if (currentSetIndex < allQuestions.length - 1) {
      setState(() {
        currentSetIndex++;
        selectedAnswers.clear();
        answered = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('আর কোনো প্রশ্ন নেই')),
      );
    }
  }

  Color? getOptionColor(int questionIndex, int optionIndex) {
    if (!answered) return null;

    int correctIndex = allQuestions[currentSetIndex][questionIndex].correctAnswerIndex;
    int? selectedIndex = selectedAnswers[questionIndex];

    if (optionIndex == correctIndex) {
      return Colors.green.withOpacity(0.7);
    } else if (selectedIndex == optionIndex && selectedIndex != correctIndex) {
      return Colors.red.withOpacity(0.7);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var questions = allQuestions[currentSetIndex];
    final banglaOptions = ['ক', 'খ', 'গ', 'ঘ'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Questions'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, i) {
                  var q = questions[i];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\${i + 1}. \${q.questionText}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 8),
                          ...List.generate(q.options.length, (j) {
                            return GestureDetector(
                              onTap: () => selectAnswer(i, j),
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: getOptionColor(i, j),
                                  border: Border.all(
                                    color: selectedAnswers[i] == j ? Colors.blue : Colors.grey,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '\${banglaOptions[j]}. \${q.options[j]}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: answered ? nextQuestions : checkAnswers,
                    child: Text(answered ? 'পরের ৫ টি প্রশ্ন' : 'উত্তর যাচাই করো'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
