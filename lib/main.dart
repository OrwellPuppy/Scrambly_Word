//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:flutter/animation.dart';
import 'package:scrambly_word_web/globals.dart';
import 'package:scrambly_word_web/game.dart';
import 'package:scrambly_word_web/score.dart';

//import 'dart:ui';
import 'dart:math';
//import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ScoreModel(),
      child: MaterialApp(
        title: 'Scrambly Word',
        theme: ThemeData(
          //primarySwatch: Colors.blue,
          scaffoldBackgroundColor: mainBackgroundColor,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) {
            //trigger initialization of ScoreModel
            Provider.of<ScoreModel>(context, listen: true);
            return const MenuScreen();
          },
          '/novice': (context) {
            return ChangeNotifierProvider(
                //should be lower in tree?
                create: (context) => GameModel(context, 'novice'),
                child: const GameScreen('novice'));
          },
          '/expert': (context) {
            return ChangeNotifierProvider(
                //should be lower in tree?
                create: (context) => GameModel(context, 'expert'),
                child: const GameScreen('expert'));
          },
          '/howToPlay': (context) => const HowToScreen(),
          '/noviceHighScores': (context) => const ScoreScreen('novice'),
          '/expertHighScores': (context) => const ScoreScreen('expert'),
        },
      )));
}

class MenuScreen extends StatelessWidget {
  const MenuScreen( {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('MenuScreen built');
    var myWidth = getWidth(context);
    var myHeight = getHeight(context);
    var myFontSize = myWidth * .045;
    var topSpace = myHeight * .014;
    var bigButtonHeight = myHeight * .1 + topSpace;

    var smallButtonHeight = bigButtonHeight * .55;
    var sidePads = min(myWidth * .1, myHeight * .1);
    var smallButtonFontSize = myFontSize * 1.4;
    var largeButtonFontSize = myFontSize * 1.5;
    var lettWidth = myWidth / 11;
    var lettHeight = lettWidth * 1.66;
    var letterFontSize = lettWidth * 1.3 - 6;
    var buttonWidth = myWidth / 1.7;
    Axis titleDirection = Axis.vertical;
    var smallButtonWidth = myWidth*.8;
    var voidWidth = getVoidWidth(context);
    var smallButtonSidePads = sidePads;
    if (voidWidth / myWidth > 0.2) {
      smallButtonSidePads = sidePads / 20;
      titleDirection = Axis.horizontal;
      buttonWidth = (myWidth + voidWidth - sidePads * 3 - 6) / 2;
      smallButtonWidth =
          (myWidth + voidWidth - smallButtonSidePads * 2 - sidePads - 6) / 3;
      //bigButtonHeight *= 1.2;
      //smallButtonHeight = bigButtonHeight;
      //smallButtonFontSize = smallButtonWidth * .075;
    }

    final Widget titleScrambly = TitleLetter(
      UniqueKey(),
      'SCRAMBLY',
      lettWidth,
      lettHeight,
      letterFontSize,
      true,
    );
    Widget titleWord = TitleLetter(
      UniqueKey(),
      'WORD',
      lettWidth,
      lettHeight,
      letterFontSize,
      false,
    );

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flex(
                        direction: titleDirection,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  top: 0,
                                  bottom: topSpace * .5,
                                  left: lettWidth / 2,
                                  right: lettWidth / 2),
                              child: titleScrambly),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: topSpace * 1,
                                  left: lettWidth / 2,
                                  right: lettWidth / 2),
                              child: titleWord),
                        ]),
                    Padding(
                        padding: EdgeInsets.only(
                            top: topSpace * 2, bottom: topSpace),
                        child: Text(
                          '- play -',
                          style: myStyle(myFontSize * 1, 'mainSubTitle'),
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: sidePads, right: sidePads),
                        child: Flex(
                            direction: titleDirection,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: bigButtonHeight,
                                  width: buttonWidth,
                                  child: MyButton(
                                      'NOVICE',
                                      largeButtonFontSize,
                                      sidePads / 8,
                                      sidePads / 8,
                                      0,
                                      topSpace, () {
                                    Navigator.pushNamed(context, '/novice');
                                  }, )),
                              SizedBox(
                                  height: bigButtonHeight,
                                  width: buttonWidth,
                                  child: MyButton(
                                      'EXPERT',
                                      largeButtonFontSize,
                                      sidePads / 8,
                                      sidePads / 8,
                                      0,
                                      topSpace, () {
                                    Navigator.pushNamed(context, '/expert');
                                  }, )),
                            ])),
                    Padding(
                        padding: EdgeInsets.only(
                            top: topSpace * 2, bottom: 0), //topSpace),
                        child: Text(
                          '- info -',
                          style: myStyle(myFontSize, 'mainSubTitle'),
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                            left: smallButtonSidePads,
                            right: smallButtonSidePads),
                        child: Flex(
                            direction: titleDirection,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: smallButtonHeight,
                                  width: smallButtonWidth,
                                  child: MyInfoButton(
                                    Icon(Icons.psychology, size: smallButtonFontSize * 1.0),
                                    ' How To Play',
                                    smallButtonFontSize,
                                    sidePads / 6,
                                    sidePads / 6,
                                    0,
                                    0,//topSpace,
                                    () {
                                      Navigator.pushNamed(
                                          context, '/howToPlay');
                                    },
                                     //() {Navigator.pushNamed(context, '/noviceHighScores');}
                                  )),
                              SizedBox(
                                  height: smallButtonHeight,
                                  width: smallButtonWidth,
                                  child: MyInfoButton(
                                      Icon(Icons.star, size: smallButtonFontSize * 0.85),
                                      ' Novice High Scores',
                                      smallButtonFontSize,
                                      sidePads / 6,
                                      sidePads / 6,
                                      0,
                                      0,//topSpace,
                                          () {
                                    Navigator.pushNamed(
                                        context, '/noviceHighScores');
                                  }, )),
                              SizedBox(
                                  height: smallButtonHeight,
                                  width: smallButtonWidth,
                                  child: MyInfoButton(
                                      Icon(Icons.stars, size: smallButtonFontSize * 1.15),
                                      ' Expert High Scores',
                                      smallButtonFontSize,
                                      sidePads / 6,
                                      sidePads / 6,
                                      0,
                                      0,//topSpace,
                                          () {
                                    Navigator.pushNamed(
                                        context, '/expertHighScores');
                                  }, ))
                            ])),
                    /* FloatingActionButton(
                  onPressed: () {
                    var sMod = Provider.of<ScoreModel>(context, listen: false);
                    sMod.clearData();
                  },
                  //gMod.recalcPositions(true)),
                  tooltip: 'Increment',
                  child: Icon(Icons.add),
                ),*/
                  ]),
            )));
  }
}

class HowToScreen extends StatelessWidget {
  const HowToScreen( {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var topSpace = getHeight(context) * .02;
    var totWidth = getWidth(context);
    var lettWidth = totWidth / 16;
    var lettHeight = lettWidth * 1.66;
    var myFontSize = totWidth * .042;
    var letterFontSize = lettWidth * 1.3 - 6;
    var buttonFontSize = totWidth * .035;
    var sletterFontSize = myFontSize * 1.0;
    var slettWidth = sletterFontSize;
    var slettHeight = slettWidth * 1.66;
    var sideMargins = totWidth * .04;

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                //Navigate back to first screen when tapped.
                Navigator.pop(context);
                //Navigator.pushNamed(context, '/second');
              },
              label: Text('RETURN TO MENU',
                  style: myStyle(buttonFontSize, 'buttonStyle')),
              icon:  const Icon(Icons.arrow_back, color: buttonTextColor),
              backgroundColor: myButtonColor,
            ),
            body: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        sideMargins, 0, sideMargins, buttonFontSize * 6),
                    child: Column(children: [
                      Padding(
                          padding: EdgeInsets.only(
                              top: topSpace * 3, bottom: topSpace * 2),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TitleLetter(
                                  UniqueKey(),
                                  'HOW',
                                  lettWidth,
                                  lettHeight,
                                  letterFontSize,
                                  true,
                                ),
                                Container(width: lettWidth),
                                TitleLetter(
                                  UniqueKey(),
                                  'TO',
                                  lettWidth,
                                  lettHeight,
                                  letterFontSize,
                                  true,
                                ),
                                Container(width: lettWidth),
                                TitleLetter(
                                  UniqueKey(),
                                  'PLAY',
                                  lettWidth,
                                  lettHeight,
                                  letterFontSize,
                                  true,
                                ),
                              ])),
                      Text(
                        'Construct words from a pool of eight random letters before time runs out.'
                        ' Additional time and points are awarded for longer words.'
                        ' NOVICE is awarded 2x the points and time of EXPERT.\n',
                        style: myStyle(myFontSize, 'howToPlayText'),
                      ),
                      DataTable(
                        dataRowHeight: myFontSize * 1.1,
                        headingRowHeight: myFontSize * 1.25,
                        columnSpacing: totWidth * .075,
                        columns: [
                          DataColumn(
                              label: Text('Word Length',
                                  style:
                                      myStyle(myFontSize, 'highScoreHeader'))),
                          DataColumn(
                              label: Text('Points & Time (EXPERT)',
                                  style:
                                      myStyle(myFontSize, 'highScoreHeader'))),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(Text('3 letters',
                                style: myStyle(myFontSize, 'highScores'))),
                            DataCell(Text('+0',
                                style: myStyle(myFontSize, 'highScores'))),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('4 letters',
                                style: myStyle(myFontSize, 'highScores'))),
                            DataCell(Text('+1',
                                style: myStyle(myFontSize, 'highScores'))),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('5 letters',
                                style: myStyle(myFontSize, 'highScores'))),
                            DataCell(Text('+3',
                                style: myStyle(myFontSize, 'highScores'))),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('6 letters',
                                style: myStyle(myFontSize, 'highScores'))),
                            DataCell(Text('+5',
                                style: myStyle(myFontSize, 'highScores'))),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('7 letters',
                                style: myStyle(myFontSize, 'highScores'))),
                            DataCell(Text('+7',
                                style: myStyle(myFontSize, 'highScores'))),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('8 letters',
                                style: myStyle(myFontSize, 'highScores'))),
                            DataCell(Text('+9',
                                style: myStyle(myFontSize, 'highScores'))),
                          ]),
                        ],
                      ),
                      Text(
                        '\nThree of the letters in your letter pool will typically be bonus letters which can be identified by their lighter color.',
                        style: myStyle(myFontSize, 'howToPlayText'),
                      ),
                      Padding(
                          padding: (EdgeInsets.fromLTRB(
                              0, myFontSize, 0, myFontSize)),
                          child: Row(children: [
                            const Spacer(),
                            Text(
                              'Example bonus letters: ',
                              style: myStyle(myFontSize, 'highScores'),
                            ),
                            TitleLetter(
                              UniqueKey(),
                              'A',
                              slettWidth,
                              slettHeight,
                              sletterFontSize,
                              true,
                            ),
                            TitleLetter(
                              UniqueKey(),
                              'B',
                              slettWidth,
                              slettHeight,
                              sletterFontSize,
                              true,
                            ),
                            TitleLetter(
                              UniqueKey(),
                              'C',
                              slettWidth,
                              slettHeight,
                              sletterFontSize,
                              true,
                            ),
                            const Spacer(),
                            const Spacer(),
                          ])),
                      Text(
                        'Each bonus letter used in a word awards an additional +1 points and time on EXPERT (+2 on NOVICE).'
                        ' Using a bonus letter also adds it to your collection, and once all the letters in the alphabet are collected, '
                        'the collection is reset and you are awarded with +10 points and time on EXPERT (+20 on NOVICE).'
                        '\n\nBe quick! The timer ticks down faster as the game progresses.',
                        style: myStyle(myFontSize, 'howToPlayText'),
                      ),
                    ])))));
  }
}

class ScoreScreen extends StatelessWidget {
  const ScoreScreen(this.skill, {Key? key}) : super(key: key);

  final String skill;

  @override
  Widget build(BuildContext context) {
    var sMod = Provider.of<ScoreModel>(context, listen: false);
    print('ScoreScreen Built');
    var totWidth = getWidth(context);
    var sideSpace = totWidth * .06;
    var topSpace = getHeight(context) * .02;
    var myFontSize = totWidth * .047;
    var lettWidth = totWidth / 16;
    var lettHeight = lettWidth * 1.66;
    var letterFontSize = lettWidth * 1.3 - 6;
    var buttonFontSize = totWidth * .035;
    List<int> myScores = [];
    List<String> myNames = [];
    List<String> myDates = [];

    if (skill == 'novice') {
      myScores = sMod.noviceScores;
      myNames = sMod.noviceNames;
      myDates = sMod.noviceDates;
    } else {
      myScores = sMod.expertScores;
      myNames = sMod.expertNames;
      myDates = sMod.expertDates;
    }
    BoxDecoration myBoxDecoration;
    BoxDecoration myRegularBoxDecoration = const  BoxDecoration();

    BoxDecoration mySpecialBoxDecoration = BoxDecoration(
      boxShadow: [
        const BoxShadow(
          color: bonusPointsColor,
        ),
        BoxShadow(
          color: myBlack,
          spreadRadius: 0,
          blurRadius: lettHeight / 6,
        ),
      ],
    );

    List<Widget> scoreList = [];
    for (var i = 0; i < sMod.maxScores; i++) {
      //print(i);
      if (sMod.lastHighScore == i && sMod.lastSkill == skill) {
        myBoxDecoration = mySpecialBoxDecoration;
      } else {
        myBoxDecoration = myRegularBoxDecoration;
      }
      scoreList.add(Container(
          decoration: myBoxDecoration,
          padding: EdgeInsets.only(
            top: topSpace / 2,
            bottom: topSpace / 2,
          ),
          child: Row(children: [
            Padding(
                padding: EdgeInsets.only(left: sideSpace / 2),
                child: Text(
                  '${((i + 1).toString() + '. ').padRight(4, ' ')}${myNames[i].padRight(10, ' ')}', //
                  style: myStyle(myFontSize, 'highScores'),
                )),
            const Spacer(),
            Text(
              myDates[i],
              style: myStyle(myFontSize, 'highScores'),
            ),
            const Spacer(),
            Padding(
                padding: EdgeInsets.only(right: sideSpace / 2),
                child: Text(
                  (myScores[i] == 0 ? '-' : myScores[i].toString()).padLeft(7, ' '),
                  style: myStyle(myFontSize, 'highScores'),
                )),
          ])));
    }

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        Padding(
            padding: EdgeInsets.only(top: topSpace * 3, bottom: topSpace),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TitleLetter(
                UniqueKey(),
                'HIGH',
                lettWidth,
                lettHeight,
                letterFontSize,
                true,
              ),
              Container(width: lettWidth),
              TitleLetter(
                UniqueKey(),
                'SCORES',
                lettWidth,
                lettHeight,
                letterFontSize,
                true,
              ),
            ])),
        Padding(
            padding: EdgeInsets.only(bottom: topSpace),
            child: Text(
              skill.toUpperCase(),
              style: myStyle(myFontSize + 10, 'highScoreTitle'),
            )),
        Padding(
            padding: EdgeInsets.only(left: sideSpace, right: sideSpace),
            child: Row(children: [
              const Text('          '),
              Text(
                'Name',
                style: myStyle(myFontSize + 4, 'highScoreHeader'),
              ),
              const Text(''),
              const Spacer(),
              Text(
                'Date',
                style: myStyle(myFontSize + 4, 'highScoreHeader'),
              ),
              const Spacer(),
              Text(
                'Score',
                style: myStyle(myFontSize + 4, 'highScoreHeader'),
              ),
            ])),
        Flexible(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    sideSpace / 2, 0, sideSpace / 2, buttonFontSize * 6),
                child: ListView(children: scoreList))),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //Navigate back to first screen when tapped.
          Navigator.pop(context);
          //Navigator.pushNamed(context, '/second');
        },
        label: Text('RETURN TO MENU',
            style: myStyle(buttonFontSize, 'buttonStyle')),
        icon:  const Icon(Icons.arrow_back, color: buttonTextColor),
        backgroundColor: myButtonColor,
      ),
    ));
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen(this.skill, {Key? key}) : super(key: key);
  final String skill;

  @override
  Widget build(BuildContext context) {
    if (showBuilds) {
      print('GameScreen Built [$gameScreenCounter]');
    }
    gameScreenCounter++;
    var gMod = Provider.of<GameModel>(context, listen: false);
    //var gModU = Provider.of<GameModel>(context, listen: true);
    gMod.updateSizes(context);


    Future<bool> _onWillPop() async {

        return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: customFormBackgroundColor,
            title: Text(
              'Exit?',
              style: TextStyle(
                fontSize: gMod.buttonFontSize,
                fontWeight: FontWeight.bold,
                color: popupMenuTextColor,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: TextStyle(
                    fontSize: gMod.smallButtonFontSize,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  gMod.cancelAll();
                  Navigator.pop(context);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    fontSize: gMod.smallButtonFontSize,
                  ),
                ),
              ),
            ],
          ),
        )) ??
            false;
    }

    return WillPopScope(
        onWillPop: _onWillPop,
        child:SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(children: [
            Column(children: <Widget>[
              Flexible(
                flex: 6,
                child: Row(
                  children: <Widget>[
                    const Expanded(
                      child: MyClock(),
                    ),
                    Expanded(
                        child: Column(children: <Widget>[
                      MyOutlinedButton(
                          'FORFEIT',
                          gMod.smallButtonFontSize,
                          gMod.horzButtonMarginSpace,
                          gMod.horzButtonMarginSpace,
                          0,
                          gMod.vertMarginSpace, () {
                        gMod.cancelAll();
                        Navigator.pop(context);
                      }),
                          Consumer<GameModel>(builder: (context, gModU, child) {
                            return Text('SCORE: ${gMod.score.toString().padLeft(4, '0')}',
                                style: myStyle(gMod.buttonFontSize * .65, 'scoreLabel'));}),
                      Expanded(
                        child: AnimatedList(
                            shrinkWrap: true,
                            reverse: true,
                            physics: const NeverScrollableScrollPhysics(),
                            key: myListKey,
                            itemBuilder: (context, index, animation) {
                              return gMod.buildItem(
                                  gMod.myGotWordList[index], animation);
                            }),
                      ),
                    ])),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                ),
              ),
              Flexible(
                flex: 4,
                child: Stack(children: [
                  Consumer<GameModel>(builder: (context, gModU, child) {
                    return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: gModU.guessBorderColor,
                              width: (gMod.sHeight / 22) / 10),
                        ),
                        child: Center(
                            child: AnimatedContainer(
                          curve: Curves.easeOutSine,
                          onEnd: () => gMod.guessBoxCallback(),
                          margin: gModU.guessInsets,
                          //(gMod.sHeight / 22) / 10),
                          duration: gModU.guessBoxDuration,
                          color: gModU.guessFillColor,
                        )));
                  }),
                  Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 8, 0),
                          child: Text(gMod.skill.toUpperCase(),
                              style: myStyle(
                                  gMod.buttonFontSize * .65, 'skillLabel'))))
                ]),
              ),
              Flexible(
                flex: 4,
                child: Container(
                    //color: myDarkGrey,
                    //margin: const EdgeInsets.symmetric(horizontal: 20),
                    ),
              ),
              Flexible(
                  flex: gMod.flexDirection == Axis.vertical ? 6 : 4,
                  child: Column(children: [
                    Expanded(
                        child: FractionallySizedBox(
                            child: Flex(
                                direction: gMod.flexDirection,
                                children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: MyButton(
                              'SUBMIT',
                              gMod.buttonFontSize,
                              gMod.horzButtonMarginSpace,
                              gMod.horzButtonMarginSpace,
                              0,
                              gMod.vertMarginSpace / 2,
                              gMod.submit,

                            ),
                          ),
                          Flexible(
                              flex: 1,
                              child: MyButton(
                                  'SCRAMBLE',
                                  gMod.buttonFontSize,
                                  gMod.horzButtonMarginSpace,
                                  gMod.horzButtonMarginSpace,
                                  gMod.vertMarginSpace / 2,
                                  gMod.vertMarginSpace / 2,
                                  gMod.scramble)),
                        ]))),

                  ])),
            ]),
            IgnorePointer(
                child: Consumer<GameModel>(builder: (context, gModU, child) {
              return Stack(children: gMod.myMiniLetterList);
            })),
            Consumer<GameModel>(builder: (context, gModU, child) {
              return Stack(children: gModU.myStarList);
            }),
            Consumer<GameModel>(builder: (context, gModU, child) {
              return Stack(children: gModU.myLetterList);
            }),
          ]);
        },
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          //gMod.ticksLeft += 4;
          gMod.blastOff();
          gMod.throwPoints(6, 2, false);
          //gMod.endGameMenu(context);
        },
        //gMod.recalcPositions(true)),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),*/
    )));
  }
} // _MyHomePageState

//TODO notes and todo list here
//go through the game.dart and remove the gSpot parameter as it's not used

//list of variable made null safe:
//hSpot
//gSpot
//hIndex[]




//improve GameScreen's horizontal layout (maybe menus' as well) (use flex groups?)
//consider making a variation of the button class that doesn't trigger on mousedown
//better workarounds for spawn ani's
//remove Opacity from points animation for performance improvement
//make timer text not go to second line..(?) use a fittedBox?
//replace text sizes with fittedBox?
//    see: https://flutter.dev/docs/development/ui/layout/constraints
//make everything getters and setters?
//examine tree and remove unnecessary widgets
//examine state management code to optimize placement in tree

//UPDATES SINCE LAST ROLLOUT
//added "meme" to dictionary
//added the gameInProgress boolean to help fix word-submit-after-game-over bug

//COMMANDS
//run in terminal to upgrade flutter: /Users/jonhathhorn/flutter/bin/flutter upgrade
//   /Users/jonhathhorn/flutter/bin/flutter doctor --verbose
//   /Users/jonhathhorn/flutter/bin/flutter channel

//LOCATION OF APK FILE
//Users/jonhathhorn/Documents/Projects/flutterProjects/scrambly_word_project/build/app/outputs/apk/release
