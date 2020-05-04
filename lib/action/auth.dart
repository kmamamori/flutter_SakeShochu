import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class Model {
  List questions = List();
  List grades = List();
  var res;
  var quizName;
  var username;
  var pin;
  var reason;
  var questionsNum=0;
  var grade = 0;
  List answeringQuestions = List();
  List answeredValue;
  List uncorrectQuestions = List();

  bool get getResponse => res;

  void setQuestions(questions) {
    questions.forEach((q) {
      this.questions.add(q);
      this.setQuestionsNum(this.getQuestionsNum + 1);
    });
  }

  void setQuizName(name) {
    quizName = name;
  }

  get getQuestions => questions;

  void addAnswer(a) {
    grades.add(a);
  }

  get getGrades => grades;

  void setReason(reason) {
    this.reason = reason;
  }

  get getReason => reason;

  void setUsername(username) {
    this.username = username;
  }

  get getUsername => username;

  void setPin(pin) {
    this.pin = pin;
  }

  Future<bool> login(username, pin) async {
    this.setUsername(username);
    this.setPin(pin);
    var response = await http.post(
        'http://www.cs.utep.edu/cheon/cs4381/homework/quiz/post.php',
        body: '{"user": "$username", "pin": "$pin", "quiz":"quiz01"}');
    var data = await json.decode(response.body);
    if (data['response'] == false) {
      this.setReason(data['reason']);
      return false;
    }
    return true;
  }

  Future loadAllQuiz() async {
    print('load All Quiz');
    var response;
    var data;
    var firsttime = true;
    var i = 0;
    while (firsttime || data['response']) {
      response = await http.post(
          'http://www.cs.utep.edu/cheon/cs4381/homework/quiz/post.php',
          body: '{"user": "$username", "pin": "$pin", "quiz":"quiz0$i"}');
      i++;
      data = await json.decode(response.body);
      if (data['response'] == true) {
        print(data['quiz']['name']);
        setQuestions(data['quiz']['question']);
      }
      firsttime = false;
    }
  }

  void createQuiz(int n) {
    print('createQuiz');
 
    var r = Random();
    var nextNum = 0;
    while (n > 0) {
      nextNum = r.nextInt(this.questions.length);
      answeringQuestions.add(this.questions[nextNum]);
      n--;
    }
    answeringQuestions.forEach((q)=>print(q));
  }

  get getQuestionsNum => this.questionsNum;

  void setQuestionsNum(n) {
    this.questionsNum = n;
  }

  get getAnsweringQuestions => answeringQuestions;

  String getAtAnsweringQuestion(i) {
    print(this.answeringQuestions[i]);
    return this.answeringQuestions[i];
  }

  Future setAnsweredValue(int i, v) {
    this.answeredValue[i] = v;
  }

  Future createAnsweredList(n) {
    answeredValue = new List(n);
  }

  List get getAnsweredValue => answeredValue;

  void setGrade(n) {
    this.grade = n;
  }

  get getGrade => this.grade;

  void gradesQuestions() {
    var i = 0;
    answeringQuestions.forEach((q) {
      print(q);
      if (q['type'] == 1) {
        if (q['answer'] != answeredValue[i]) {
          uncorrectQuestions.add(q);
        } else {
          this.setGrade(this.getGrade + 1);
        }
      } else {
        if (q['answer'][0] != answeredValue[i]) {
          uncorrectQuestions.add(q);
        } else {
          this.setGrade(this.getGrade + 1);
        }
      }
      i++;
    });


  }

  get getUncorrectQuestins => this.uncorrectQuestions;

  void initialize(){
    this.answeringQuestions.clear();
    this.uncorrectQuestions.clear();
    this.setGrade(0);
  }
}