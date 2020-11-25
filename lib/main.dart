import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  return runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue.shade800,
        appBar: AppBar(
          title: Text('Roll or die'),
          backgroundColor: Colors.blue.shade800,
        ),
        body: SafeArea(
          child: DicePage(),
        ),
      ),
    ),
  );
}

class DicePage extends StatefulWidget {
  @override
  _DicePageState createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> with TickerProviderStateMixin {
  AnimationController _controller;

  int leftDiceNumber = Random().nextInt(6) + 1;
  int rightDiceNumber = Random().nextInt(6) + 1;
  bool initial = true;
  bool started = false;
  String message =
      'Welcome to Roll or Die! Press Start Game button to start a new game';
  String buttonText = 'START GAME';
  int playerOneScore;
  int playerTwoScore;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AutoSizeText(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
        started
            ? Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          rollDices(0.0);
                        },
                        child: Lottie.asset(
                          'assets/lottie/dice$leftDiceNumber.json',
                          controller: _controller,
                          onLoaded: (composition) {
                            loadDiceState(composition);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          rollDices(0.0);
                        },
                        child: Lottie.asset(
                          'assets/lottie/dice$rightDiceNumber.json',
                          controller: _controller,
                          onLoaded: (composition) {
                            loadDiceState(composition);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
          child: RaisedButton(
            color: Colors.white,
            onPressed: () => initial ? startGame() : rollDices(0.0),
            child: Text(
              buttonText,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  void loadDiceState(LottieComposition composition) {
    setState(() {
      _controller.duration = composition.duration;
      if (initial) {
        _controller.forward(from: composition.seconds);
        initial = false;
      }
    });
  }

  void rollDices(double duration) {
    if (started) {
      _controller.reset();
      setState(() {
        leftDiceNumber = Random().nextInt(6) + 1;
        rightDiceNumber = Random().nextInt(6) + 1;
      });

      _controller.forward(from: duration).then((_value) => setState(() {
            if (playerOneScore == null) {
              playerOneScore = leftDiceNumber + rightDiceNumber;
              message =
                  "It's Player two's turn. Roll the dice to see your score";
              buttonText = 'ROLL DICE';
            } else {
              playerTwoScore = leftDiceNumber + rightDiceNumber;
              displayScore();
            }
          }));
    }
  }

  void startGame() {
    setState(() {
      message = "It's Player one's turn. Roll the dice to see your score";
      buttonText = 'ROLL DICE';
      playerOneScore = null;
      playerTwoScore = null;
      started = true;
      leftDiceNumber = Random().nextInt(6) + 1;
      rightDiceNumber = Random().nextInt(6) + 1;
    });
  }

  void displayScore() {
    setState(() {
      int difference = playerOneScore - playerTwoScore;
      if (difference > 0) {
        message =
            "Player one win with a score of $playerOneScore to $playerTwoScore";
      } else if (difference < 0) {
        message =
            "Player two win with a score of $playerTwoScore to $playerOneScore";
      } else {
        message = "No one win on this one. It's a tie";
      }

      buttonText = 'PLAY AGAIN';
      initial = true;
      started = false;
    });
  }
}
