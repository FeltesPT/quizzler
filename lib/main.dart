import 'package:flutter/material.dart';
import 'package:quizzler/quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(Quizzler());

QuizBrain quizBrain = QuizBrain();

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];

  void userAnswered(bool answer) {
    setState(() {
      if (quizBrain.getAnswer() == answer) {
        correctAnswer();
      } else {
        wrongAnswer();
      }

      quizBrain.nextQuestion();
    });

    if (quizBrain.hasEnded()) {
      int correct = quizBrain.correct;
      int wrong = quizBrain.wrong;
      Alert(
        context: context,
        type: AlertType.success,
        title: "Quiz Ended",
        desc: "You got $correct correct and $wrong wrong.",
        buttons: [
          DialogButton(
            child: Text(
              "RESET",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              resetQuiz();
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
    }
  }

  void correctAnswer() {
    quizBrain.correct++;
    scoreKeeper.add(
      Icon(
        Icons.check,
        color: Colors.green,
      ),
    );
  }

  void wrongAnswer() {
    quizBrain.wrong++;
    scoreKeeper.add(
      Icon(
        Icons.close,
        color: Colors.red,
      ),
    );
  }

  void resetQuiz() {
    setState(() {
      quizBrain.reset();
      scoreKeeper = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestion(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                userAnswered(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                userAnswered(false);
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}
