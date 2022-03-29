import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'dart:async';
import 'package:scrambly_word_web/dict.dart';
import 'package:scrambly_word_web/globals.dart';
import 'package:scrambly_word_web/score.dart';
import 'package:flutter/services.dart';

final myListKey = GlobalKey<AnimatedListState>();

class GameModel extends ChangeNotifier {
  //colors
//Sections top to bottom: 6, 2, 4, 4, 6 = 22
  int layoutDivision = 22;

  Color guessBorderColor= Colors.white;//initialized
  Color guessFillColor= Colors.white;//initialized
  Color clockColor= Colors.white;//initialized

  EdgeInsets guessInsets= const EdgeInsets.all(0);
  String skill='none set';
  int skillMult = 1;
  List<Timer> timerHolder = [];
  final int _lettMax = 8; //maximum number of letters
  List<Letter> myLetterList = []; //list of widgets to build
  List<Widget> myStarList = []; //list of star widgets to build
  List<Letter> myMiniLetterList = []; //list of mini widgets to build
  List<List<TextSpan>> myGotWordList = []; //list of got words to build

  List<CompLett> compLettList = []; //list of letter attributes
  List<int> gIndex = []; //ordered in guess pos, stores index of compLettList
  List<int> hIndex = []; //ordered in hand pos, stores index of compLettList
  List<int> mIndex =
      []; //arbitrarily ordered list of miniletters, stores index of compLettList
  List<int> lastWord = []; //list of compLettList indexes of the last word tried

  int guessCount = 0; //number of letters guessed

  //List<String> letters = []; //actual letters of letters
  List<bool> guessed = []; //true is guessed

  double lettWidth = 0; //width of a letter
  double lettHeight = 0; //height of a letter
  double mLettWidth = 0; //width of a miniletter
  double mLettHeight = 0; //height of a miniletter

  double sWidth = 0; //screen width
  double sHeight = 0; //screen height
  double voidSpace = 0; //void space

  double vertMarginSpace = 0.0; //vertical margin size
  double horzButtonMarginSpace = 0.0; //horizontal margin on sides of buttons

  double handTop = 0.0; //Top position of letters in hand
  double guessTop = 0.0; //Top position of letters guessed
  List<double> leftPos = []; //[left] position for each letter in hand
  // List<double> topPos = []; //[top] position for each letter in hand

  List<String> wtdConPool = [];
  List<String> wtdVowPool = [];
  List<String> wtdAlphaPool = [];
  List<String> specials = [];

  double clockFontSize = 0;
  double gotWordFontSize = 0;
  double buttonFontSize = 0;
  double smallButtonFontSize = 0;
  Axis flexDirection = Axis.vertical;
  bool miniNeedsCleared = false; //true when game needs to clear the mini letts
  int genDelay = 100; //normal letter gen time delay milliseconds

  //timer variables
  int startTicks = 10; //starting time based on skill difficulty
  int addedTicks = 0;
  int score = 0; //game score
  bool gameInProgress = true;

  //curve of main letter movement animation
  Curve primaryCurve = Curves.easeOut;

  //guessBox animation variable
  Duration guessBoxDuration =
  const Duration(milliseconds: 750); //flash duration; changes
  bool guessBoxCallNeeded = false; //used to make the callback only call once

  //gotWords animated list timing
  Duration addedAniTime = const Duration(milliseconds: 250);
  Duration offsetAniTime =
      const Duration(milliseconds: 1250); //must be greater than addedAniTime
  Duration removedAniTime = const Duration(seconds: 9);

  final Map<String, List<dynamic>> miniSpot = {
    'A': [0.0, 0.0],
    'B': [0.0, 0.0],
    'C': [0.0, 0.0],
    'E': [0.0, 0.0],
    'D': [0.0, 0.0],
    'F': [0.0, 0.0],
    'G': [0.0, 0.0],
    'H': [0.0, 0.0],
    'I': [0.0, 0.0],
    'J': [0.0, 0.0],
    'K': [0.0, 0.0],
    'L': [0.0, 0.0],
    'M': [0.0, 0.0],
    'N': [0.0, 0.0],
    'O': [0.0, 0.0],
    'P': [0.0, 0.0],
    'Q': [0.0, 0.0],
    'R': [0.0, 0.0],
    'S': [0.0, 0.0],
    'T': [0.0, 0.0],
    'U': [0.0, 0.0],
    'V': [0.0, 0.0],
    'W': [0.0, 0.0],
    'X': [0.0, 0.0],
    'Y': [0.0, 0.0],
    'Z': [0.0, 0.0],
  };

//determines how many of a single letter can be in your hand at a time
  final Map<String, int> alphaPool = {
    'A': 3,
    'B': 3,
    'C': 3,
    'E': 3,
    'D': 3,
    'F': 3,
    'G': 3,
    'H': 3,
    'I': 2,
    'J': 1,
    'K': 3,
    'L': 3,
    'M': 3,
    'N': 3,
    'O': 3,
    'P': 3,
    'Q': 1,
    'R': 3,
    'S': 3,
    'T': 3,
    'U': 2,
    'V': 3,
    'W': 2,
    'X': 1,
    'Y': 2,
    'Z': 2
  };

  GameModel(BuildContext context, String mySkill) {
    if (showBuilds) {
      print('GameModel constructing');
    }
    setSkill(mySkill);
    guessBorderColor = rejectBorderColor;
    guessFillColor = bonusFlashColor; //bonusFlashColor; mark
    clockColor = plainClockColor;

    //create the weighted strings
    wtdConPool.clear();
    conPool.forEach((k, v) {
      for (var i = 0; i < v; i++) {
        wtdConPool.add(k);
      }
    });
    wtdVowPool.clear();
    vowPool.forEach((k, v) {
      for (var i = 0; i < v; i++) {
        wtdVowPool.add(k);
      }
    });
    wtdAlphaPool.clear();
    wtdAlphaPool.addAll(wtdConPool);
    wtdAlphaPool.addAll(wtdVowPool);
    //initialize hIndex and leftPos
    hIndex.clear();
    for (int i = 0; i < _lettMax; i++) {
      hIndex.add(0); //edited for null safety
      leftPos.add(0.0);
    }
    //initialize the special letts
    specials = List<String>.from(alphabet);
    //generate the miniLetter placeholders
    String tempLett = '';
    int tempIndex = 0;
    for (var i = 0; i < 26; i++) {
      tempLett = String.fromCharCode(i + 65);
      //miniSpot[String.fromCharCode(i + 65)] = [
      tempIndex = compLettList.length;
      myMiniLetterList.add(Letter(
          key: UniqueKey(),
          lett: tempLett,
          myIndex: tempIndex,
          mainColor: mainBackgroundColor,
          fadeColor: mainBackgroundColor,
          textStyleName: 'letterPlaceholder'));
      compLettList.add(CompLett(
          tempLett,
          miniSpot[tempLett]![0],
          miniSpot[tempLett]![1],
          mLettHeight,
          mLettWidth,
          0,//edited from null for null safety
          0,//edited from null for null safety
          false,
          false,
          true,
          true,
          //isMini
          false //clickAllowed
          ));
    }
    //generate initial set of letters
    for (var i = 0; i < _lettMax; i++) {
      generateLetter(i, 350);
    }
    //initializes or the guess box flash size
    guessInsets = EdgeInsets.all((sHeight / layoutDivision) *
        2); // mark(sHeight / (layoutDivision) * 2 + 1)
    print('GameModel constructed');
  }

  void setSkill(String mySkill) {
    skill = mySkill;
    if (mySkill == 'novice') {
      skillMult = 2;
      startTicks = startTicks * skillMult;
    } else {
      skillMult = 1;
    }
  }

  void flashAni() {
    if (showAniEnds) {
      print('guessBox flash');
    }
    guessBoxDuration = const Duration(milliseconds: 750); //750 mark
    guessFillColor = guessPlainFill; //guessPlainFill; mark
    guessInsets = const EdgeInsets.all(0); //0 mark
    guessBoxCallNeeded = true;
    notifyListeners();
    print('guessBox flash');
  }

  void guessBoxCallback() {
    if (guessBoxCallNeeded) {
      if (showAniEnds) {
        print('guessBox flash callback');
      }
      guessInsets = EdgeInsets.all((sHeight / layoutDivision) *
          2); //mark (sHeight / (layoutDivision) * 2 + 1)
      guessFillColor = bonusFlashColor;
      guessBoxDuration = const Duration(milliseconds: 1); //1 mark
      guessBoxCallNeeded = false;
      notifyListeners();
      print('guessBox flash callback');
    }
  }

  void updateSizes(BuildContext context) {
    if (showBuilds) {
      print('resized [$resizedCounter]');
    }

    resizedCounter++;
    sHeight = getHeight(context);
    sWidth = getWidth(context);
    voidSpace = getVoidWidth(context);
    print('height: $sHeight / width: ${sWidth + voidSpace}');
    if (voidSpace / sWidth > .1) {
      flexDirection = Axis.horizontal;
      layoutDivision = 20;
    } else {
      layoutDivision = 22;
      flexDirection = Axis.vertical;
    }
    recalcPositions(false);
  }

  void recalcPositions(bool refresh) {
    //calculate the letter positions
    print('recalcPositions [$recalcCounter]');
    if (showBuilds) {
      print('recalcPositions [$recalcCounter]');
    }
    recalcCounter++;
    //calc top positions
    vertMarginSpace = sHeight / 175;
    double vTinyMargin = sHeight / 800;
    double sideMargin = sWidth / 90; //left and right border space for letters
    handTop = (sHeight / layoutDivision) * 12 + vertMarginSpace;
    guessTop = (sHeight / layoutDivision) * 8 + vertMarginSpace;
    //calc letter sizes
    lettWidth = (sWidth - sideMargin * 2) / _lettMax;
    lettHeight = (sHeight / layoutDivision) * 4 - vertMarginSpace * 2;
    leftPos.clear();
    //calc left positions
    for (var i = 0; i < _lettMax; i++) {
      leftPos.add(sideMargin + (i * lettWidth) + voidSpace);
    }
    mLettHeight =
        ((sHeight / layoutDivision) * 2 - vertMarginSpace * 2 - vTinyMargin) /
            2;
    //calc mLetter size ratios (preferred 1.40)
    mLettWidth = min(
        ((sWidth + voidSpace * .2) - sideMargin * 2 - lettWidth * 2) / 13,
        mLettHeight / 1.3);

    double topRow = (sHeight / layoutDivision) * 8 -
        mLettHeight * 2 -
        vertMarginSpace -
        vTinyMargin;
    double botRow =
        (sHeight / layoutDivision) * 8 - mLettHeight - vertMarginSpace;
    double startLeft = (sWidth - mLettWidth * 13 - vTinyMargin * 12) / 2;
    //top row of miniletters
    for (var i = 0; i < 13; i++) {
      //print(String.fromCharCode(i));
      miniSpot[String.fromCharCode(i + 65)] = [
        topRow,
        startLeft + i * (mLettWidth + vTinyMargin) + voidSpace,
      ]; //top, left
    }
    //bottom row of miniletters
    for (var i = 0; i < 13; i++) {
      //print(String.fromCharCode(i));
      miniSpot[String.fromCharCode(i + 78)] = [
        botRow,
        startLeft + i * (mLettWidth + vTinyMargin) + voidSpace,
      ];
    }

    //update hIndex letters with the new sizes and positions, if not null
    //changed to if clickallowed
    for (var i = 0; i < hIndex.length; i++) {
      //if (hIndex[i] != null) {
      if (compLettList[hIndex[i]].clickAllowed) {
        if (compLettList[hIndex[i]].guessed) {
          compLettList[hIndex[i]].top = guessTop;
        } else {
          compLettList[hIndex[i]].top = handTop;
          compLettList[hIndex[i]].left = leftPos[i];
        }
        if (!compLettList[hIndex[i]].flat) {
          compLettList[hIndex[i]].height = lettHeight;
        }
        compLettList[hIndex[i]].width = lettWidth;
      }
    }
    //update miniletter sizes and positions, if there are any
    for (var i = 0; i < mIndex.length; i++) {
      compLettList[mIndex[i]].width = mLettWidth;
      compLettList[mIndex[i]].height = mLettHeight;
      compLettList[mIndex[i]].top = miniSpot[compLettList[mIndex[i]].lett]![0];
      compLettList[mIndex[i]].left = miniSpot[compLettList[mIndex[i]].lett]![1];
    }
    //update shadow letter sizes and positions
    for (var i = 0; i < 26; i++) {
      compLettList[i].width = mLettWidth;
      compLettList[i].height = mLettHeight;
      compLettList[i].top = miniSpot[compLettList[i].lett]![0];
      compLettList[i].left = miniSpot[compLettList[i].lett]![1];
    }
    //calc various margins
    if (sWidth > 500) {
      horzButtonMarginSpace = sWidth * 0.16;
    } else {
      horzButtonMarginSpace = sWidth * 0.08;
    }
    //calc some font sizes
    gotWordFontSize = mLettWidth * 1.5;
    buttonFontSize = mLettWidth * 1.1;
    smallButtonFontSize =
        [gotWordFontSize * .8, buttonFontSize * .7].reduce(min);
    clockFontSize = sWidth * .21;
    if (voidSpace / sWidth > .1) {
      clockFontSize = sWidth * .13;
    }
    //initializes or resets the guess box flash size
    //130*
    guessInsets = EdgeInsets.all((sHeight / layoutDivision) *
        2); // mark(sHeight / (layoutDivision) * 2 + 1)

    if (refresh) {
      notifyListeners();
      print('refresh');
    }
    recalcGuessPos();
  }

  void generateLetter(int newHandSpot, int delay) {
    //get the v/c count
    var rng = Random();
    bool isSpec = false;
    var myColor = commonTileColor;
    var myFadeColor = commonTileFadeColor;
    int vow = 0;
    int con = 0;
    int spec = 0;
    String newLett = '';
    //only count letters that are not null
    //changed to: count letters that are clickAllowed
    for (var i = 0; i < hIndex.length; i++) {
      //if (hIndex[i] != null) {
      if (compLettList[hIndex[i]].clickAllowed) {
        if (compLettList[hIndex[i]].special) {
          spec++;
        }
        if (alphaVow.contains(compLettList[hIndex[i]].lett)) {
          vow++;
        } else {
          con++;
        }
      }
    }
    //generate the letter, priority: 3 spec 3 vow 3 con
    if (showLetterGens) {
      print('s:$spec/v:$vow/c:$con');
    }
    //check for alpha bonus
    if (spec == 0 && specials.isEmpty) {
      miniNeedsCleared = true;
      specials = List<String>.from(alphabet);
      print('ALPHABET COMPLETED');
    }
    //CASE: you need a lot of things
    //this is first so that the spec letts arn't always first
    if ((vow < 3) &&
        (con < 3) &&
        ((vow + con) < 4) &&
        (rng.nextInt(100) < 66)) {
      do {
        newLett = wtdAlphaPool[rng.nextInt(wtdAlphaPool.length)];
      } while (alphaPool[newLett]! <= 0);
    } else if (spec < 3 && specials.isNotEmpty) {
      //CASE: you need a spec
      int indx = rng.nextInt(specials.length);
      newLett = specials[indx];
      specials.removeAt(indx);
      isSpec = true;
      myColor = specialTileColor;
      myFadeColor = specialTileFadeColor;
    } else if (alphaPool['Q']! < 1 &&
        alphaPool['U'] == 2 &&
        rng.nextInt(100) < 75) {
      //CASE: you have a Q but no U
      newLett = 'U';
    } else {
      if (vow < 3) {
        //CASE: need a vowel
        do {
          newLett = wtdVowPool[rng.nextInt(wtdVowPool.length)];
        } while (alphaPool[newLett]! <= 1);
      } else if (con < 3) {
        //CASE: need consonant
        do {
          newLett = wtdConPool[rng.nextInt(wtdConPool.length)];
        } while (alphaPool[newLett]! <= 1);
      } else {
        //CASE: need nothing; gen rando
        do {
          newLett = wtdAlphaPool[rng.nextInt(wtdAlphaPool.length)];
        } while (alphaPool[newLett]! <= 0);
      }
    }
    alphaPool[newLett]=alphaPool[newLett]!-1;
    if (showLetterGens) {
      print('generateLetter [$newLett]');
    }
    //update the model variables
    int tempIndex = 0;
    int tempMax = compLettList.length;
    //search for a dead letter to replace with a new one
    while (tempIndex < tempMax) {
      if (compLettList[tempIndex].dead) {
        //print('dead $tempIndex');
        break;
      }
      tempIndex++;
    }
    //print('new lett index: $tempIndex');
    CompLett newCompLett = CompLett(
        newLett,
        handTop,
        leftPos[newHandSpot],
        0,
        //height
        lettWidth,
        0,//edited from null for null safety
        newHandSpot,
        false,
        isSpec,
        false,
        false,
        true //clickAllowed
        );
    if (compLettList.length == tempIndex) {
      //case: there are no dead letters to replace, so add on to the end
      compLettList.add(newCompLett);
    } else {
      compLettList[tempIndex] = newCompLett;
    }
    hIndex[newHandSpot] = tempIndex;
    myLetterList.add(Letter(
        key: UniqueKey(),
        lett: newLett,
        myIndex: tempIndex,
        mainColor: myColor,
        fadeColor: myFadeColor,
        textStyleName: 'letter'));
    notifyListeners();
    Timer starter = Timer(const Duration(milliseconds: 0),(){});
    starter = Timer(Duration(milliseconds: delay), () {
      compLettList[tempIndex].flat = false;
      compLettList[tempIndex].height = lettHeight;
      notifyListeners();
      timerHolder.remove(starter);
    });
    timerHolder.add(starter);
  }

  void recalcGuessPos() {
    //calculates guess lett's .left position
    if (gIndex.length > 3) {
      for (var i = 0; i < gIndex.length; i++) {
        //compLettList[gIndex[i]].speed = 210;
        compLettList[gIndex[i]].left =
            ((sWidth - (gIndex.length * lettWidth)) / 2) +
                i * lettWidth +
                voidSpace;
      }
    } else {
      for (var i = 0; i < gIndex.length; i++) {
        compLettList[gIndex[i]].left =
            ((sWidth - (3 * lettWidth)) / 2) + i * lettWidth + voidSpace;
      }
    }
  }

  void tapLett(int lettIndex) {
    if (compLettList[lettIndex].clickAllowed) {
      //move to bottom of list so that it will visually be on top
      for (int i = 0; i < myLetterList.length; i++) {
        //search for it and move it to end of array so it will render on top
        if (myLetterList[i].myIndex == lettIndex) {
          Letter tempLetter = myLetterList[i];
          myLetterList.removeAt(i);
          myLetterList.add(tempLetter);
          //print('cleared ${compLettList[myTempIndex].lett}');
          break;
        }
      }
      //double beforeLeft = compLettList[lettIndex].left;
      if (compLettList[lettIndex].guessed) {
        //if guessed
        compLettList[lettIndex].top = handTop;
        compLettList[lettIndex].left = leftPos[compLettList[lettIndex].hSpot];
        compLettList[lettIndex].guessed = false;
        gIndex.remove(lettIndex);
      } else {
        //if not guessed
        gIndex.add(lettIndex);

        compLettList[lettIndex].top = guessTop;
        compLettList[lettIndex].guessed = true;
      }
      recalcGuessPos();
      //compLettList[lettIndex].speed = ((beforeLeft - compLettList[lettIndex].left) * .95).abs().round() + 200;
      updateGuessBorder();
      notifyListeners();
    }
  }

  void onAniEnd(myTempIndex) {
    //var now2 = new DateTime.now();  //part of trig
    //first check that its on last leg of animation
    if (showAniEnds) {
      print(
          'trig ${compLettList[myTempIndex].lett} $myTempIndex / ${compLettList[myTempIndex].clearMe} / ${compLettList[myTempIndex].mini}');
    }
    if (compLettList[myTempIndex].clearMe && !compLettList[myTempIndex].mini) {
      //case need to be cleared and not a mini letter,
      for (int i = 0; i < myLetterList.length; i++) {
        //start from end of list since thats more likely
        //search for it and clear it
        if (myLetterList[i].myIndex == myTempIndex) {
          myLetterList.removeAt(i);
          compLettList[myTempIndex].dead = true;
          if (showAniEnds) {
            print('cleared ${compLettList[myTempIndex].lett}');
          }
          break;
        }
      }
      notifyListeners();
    } else if (compLettList[myTempIndex].clearMe &&
        compLettList[myTempIndex].mini) {
      //case its a mini letter
      //if need to be cleared,
      for (int i = 0; i < myMiniLetterList.length; i++) {
        //search for it and clear it
        if (myMiniLetterList[i].myIndex == myTempIndex) {
          myMiniLetterList.removeAt(i);
          compLettList[myTempIndex].dead = true;
          if (showAniEnds) {
            print('cleared mini ${compLettList[myTempIndex].lett}');
          }
          break;
        }
      }
      notifyListeners();
    } else if (compLettList[myTempIndex].swapMe) {
      //if needs to be swapped to the miniLetterList

      for (int i = myLetterList.length - 1; i >= 0; i--) {
        //start from end of list since thats more likely
        //search for it and swap it
        if (myLetterList[i].myIndex == myTempIndex) {
          //flag as mini
          compLettList[myTempIndex].mini = true;
          myMiniLetterList.add(myLetterList[i]);
          myLetterList.removeAt(i);
          break;
        }
      }
      notifyListeners();
    }
  }

  void blastOff() {
    HapticFeedback.heavyImpact();
    throwPoints(10, 0, true);
    var rng = Random();
    for (int i = 0; i < mIndex.length; i++) {
      var sizeMult = max(rng.nextDouble() * 9, 1);
      compLettList[mIndex[i]].width *= sizeMult;
      compLettList[mIndex[i]].height *= sizeMult;

      compLettList[mIndex[i]].top =
          -lettHeight - rng.nextDouble() * lettHeight * 2;
      compLettList[mIndex[i]].left =
          rng.nextDouble() * sWidth * 3 - (lettWidth / 2 + sWidth);
      compLettList[mIndex[i]].speed = 600 + rng.nextInt(700);
      double spin = rng.nextDouble() * 7;
      if (rng.nextDouble() > 0.5) {
        spin = -spin;
      }
      compLettList[mIndex[i]].myAngle = spin;
      compLettList[mIndex[i]].clearMe = true;
    }
    mIndex.clear();
    notifyListeners();
  }

  void updateGuessBorder() {
    String guess = "";
    for(var indx in gIndex){
      guess += compLettList[indx].lett;
    }

    if (!words.contains(guess.toLowerCase())) {
      guessBorderColor = rejectBorderColor;
    } else {
      guessBorderColor = acceptBorderColor;
    }
  }

  void submit() {
    String guess = "";
    //gIndex.forEach((indx) => guess += compLettList[indx].lett);
    for (var indx in gIndex){
      guess += compLettList[indx].lett;
    }
    if (guess == '' && lastWord.isNotEmpty) {
      //CASE: no word, but a lastWord
      //lastWord.forEach((ind) => tapLett(ind));
      for (var ind in lastWord){
        tapLett(ind);
      }
    } else if (words.contains(guess.toLowerCase()) && gameInProgress) {
      //CASE: accepted word (and game isn't over)
      HapticFeedback.lightImpact();
      print('$guess accepted');
      flashAni();
      int specCount = 0;
      lastWord.clear();
      List<int> tempList = [];
      var rng = Random();
      //create the colored textSpans
      List<TextSpan> guessSpans = [];
      for (int i = 0; i < gIndex.length; i++) {
        if (compLettList[gIndex[i]].special) {
          specCount++;
          guessSpans.add(TextSpan(
              text: compLettList[gIndex[i]].lett,
              style: myStyle(gotWordFontSize, 'gotWordListSpecial')));
        } else {
          guessSpans.add(TextSpan(
              text: compLettList[gIndex[i]].lett,
              style: myStyle(
                gotWordFontSize,
                'gotWordListCommon',
              )));
        }
      }
      throwPoints(guess.length, specCount, false);

      //add item to the list, tell list where it was inserted, add blank
      myGotWordList.insert(0, guessSpans);
      myListKey.currentState!.insertItem(0, duration: addedAniTime);
      myGotWordList.insert(0, []); //edited for null safety, was null
      myListKey.currentState!
          .insertItem(0, duration: const Duration(milliseconds: 0));
      //remove image
      removeGotListItem();
      removeGotListItem();
      for (int i = 0; i < gIndex.length; i++) {
        //keep a list of the hand position of the letters removed
        tempList.add(compLettList[gIndex[i]].hSpot);
        //make letter's hand spot null--//edited for null safety, was null
        //hIndex[compLettList[gIndex[i]].hSpot] = null;//removed for null safety
        //update the pool of letters that are allowed
        alphaPool[compLettList[gIndex[i]].lett]=alphaPool[compLettList[gIndex[i]].lett]!+1;
        //make image so it can't be clicked on
        compLettList[gIndex[i]].clickAllowed = false;
      }
      for (int i = 0; i < gIndex.length; i++) {
        var now = DateTime.now();
        compLettList[gIndex[i]].now = now;
        if (compLettList[gIndex[i]].special) {
          //if special, add to the list of miniletters
          mIndex.add(gIndex[i]);
          //assign new mini height/width/left/top
          compLettList[gIndex[i]].speed = 1000;
          compLettList[gIndex[i]].top =
              miniSpot[compLettList[gIndex[i]].lett]![0];
          compLettList[gIndex[i]].left =
              miniSpot[compLettList[gIndex[i]].lett]![1];
          compLettList[gIndex[i]].height = mLettHeight;
          compLettList[gIndex[i]].width = mLettWidth;
          compLettList[gIndex[i]].lettAlign = const Alignment(0, 0);
        } else {
          //else blast it off
          //regular letter blast code
          compLettList[gIndex[i]].speed = 600 + rng.nextInt(700);
          double blastWidth = rng.nextDouble() * (sWidth + lettWidth);
          double posNeg = (rng.nextInt(2) - .5) * 2;
          compLettList[gIndex[i]].left += blastWidth * posNeg;
          compLettList[gIndex[i]].top -= sHeight * .8;
          var spin = rng.nextDouble() * 7;
          if (rng.nextDouble() > 0.5) {
            spin = -spin;
          }
          compLettList[gIndex[i]].myAngle = spin;
        }
        //compLettList[gIndex[i]].gSpot = null;//edited for null safety; not needed?
        //compLettList[gIndex[i]].hSpot = null;//edited for null safety--not needed
        compLettList[gIndex[i]].guessed = false;
        generateLetter(tempList[i], genDelay);
        lightFuse(gIndex[i]); //triggers .swapMe or .clearMe after 50 ms
      }
      if (miniNeedsCleared) {
        blastOff();
        miniNeedsCleared = false;
      }
      gIndex.clear();
    } else if (guess != '') {
      //CASE: rejected non-blank word
      print('$guess rejected');
      lastWord.clear();
      for (int i = 0; i < gIndex.length; i++) {
        lastWord.add(gIndex[i]);
        compLettList[gIndex[i]].top = handTop;
        compLettList[gIndex[i]].left = leftPos[compLettList[gIndex[i]].hSpot];
        compLettList[gIndex[i]].guessed = false;
      }
      gIndex.clear();
    }
    updateGuessBorder();
    notifyListeners();
  }

  void lightFuse(int index) {
    Timer fuse = Timer(const Duration(), (){});//edited for null safety
    fuse = Timer(const Duration(milliseconds: 50), () {
      if (compLettList[index].special) {
        compLettList[index].swapMe = true;
      } else {
        compLettList[index].clearMe = true;
      }
      timerHolder.remove(fuse);
    });
    timerHolder.add(fuse);
  }

  //got list animation
  Widget _baseItem(word, animation) {
    return Center(
        child: Text.rich(TextSpan(
      children: word,
    )));
  }

  Widget buildItem(word, animation) {
    if (word.isEmpty) {//edit for null safety; was null
      return const SizedBox(height: 0, width: 0);
    } else {
      return SizeTransition(
          sizeFactor: animation,
          //opacity:animation,
          child: _baseItem(word, animation));
    }
  }

  Widget _buildRemovedItem(word, animation) {
    return FadeTransition(
        //key: UniqueKey(),
        //axis:Axis.horizontal,
        opacity: animation,
        child: _baseItem(word, animation));
  }

  void removeGotListItem() {
    Timer remover = Timer(const Duration(milliseconds: 0), (){});
    remover = Timer(offsetAniTime, () {
      int index = myGotWordList.length - 1;
      if (index > 0) {
        //remove item from the list
        List<TextSpan> removedItem = myGotWordList.removeAt(index);
        //tell list where it was inserted
        /* edited for new Dart code guidance
        AnimatedListRemovedItemBuilder builder = (context, animation) {
          // A method to build the Card widget.
          if (removedItem.isEmpty) {
            return const SizedBox(height: 0, width: 0);
          } else {
            return _buildRemovedItem(removedItem, animation);
          }
        };
        */
        Widget builder(context, animation) {
          // A method to build the Card widget.
          if (removedItem.isEmpty) {
            return const SizedBox(height: 0, width: 0);
          } else {
            return _buildRemovedItem(removedItem, animation);
          }
        }
        myListKey.currentState!
            .removeItem(index, builder, duration: removedAniTime);
      }
      timerHolder.remove(remover);
    });
    timerHolder.add(remover);
  }

  void throwPoints(int wordLength, int specCount, bool alphaB) {
    int points = specCount * 1;
    double expandRange = 0;
    switch (wordLength) {
      case 3:
        points += 0;
        expandRange += 0.0;
        break;
      case 4:
        points += 1;
        expandRange += 0.09;
        break;
      case 5:
        points += 3;
        expandRange += 0.27;
        break;
      case 6:
        points += 5;
        expandRange += 0.45;
        break;
      case 7:
        points += 7;
        expandRange += 0.63;
        break;
      case 8:
        points += 9;
        expandRange += 0.81;
        break;
      case 10: //alphabet complete bonus
        points += 10;
        expandRange += 0.81;
        break;
      default:
        points += 0;
        expandRange += 0.0;
    }
    expandRange = max(0, (points - 1) * .085);
    expandRange = min(.85, expandRange);
    points = points * skillMult;
    if (points > 0) {
      //Update the score and timer
      score += points;
      addedTicks += points;
      //Activate the Starpac Animation.
      myStarList.insert(
          0,
          BonusStar(
              UniqueKey(),
              Starpac(
                  removeStar,
                  sWidth,
                  sHeight,
                  clockFontSize,
                  expandRange,
                  points,
                  Duration(milliseconds: points * 250 + 1500),
                  alphaB,
                  layoutDivision,
                  flexDirection)));
      notifyListeners();
    }
  }

  removeStar() {
    myStarList.removeLast();
    notifyListeners();
  }

  void cancelAll() {
    for (int i = 0; i < timerHolder.length; i++) {
      if (timerHolder[i].isActive) {
        timerHolder[i].cancel();
      }
    }
  }

  void timesUp(BuildContext context) {
    gameInProgress = false;
    cancelAll();
    //Timer(Duration(milliseconds: 5), () {
    endGameMenu(context);
    //});
  }

  void endGameMenu(BuildContext context) {
    var sMod = Provider.of<ScoreModel>(context, listen: false);
    bool setHighScore = sMod.checkHighScore(score, skill);
    showDialog(
        //transitionDuration: const Duration(milliseconds: 200),
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MyCustomForm(
              score, skill, setHighScore, buttonFontSize, smallButtonFontSize);
        });
  }

  void scramble() {
    List<int> tempIndexList = [];
    //create a temporary list of indexes to shuffle
    for (int i = 0; i < hIndex.length; i++) {
      //only shuffle letters that haven't been guessed
      if (!compLettList[hIndex[i]].guessed) {
        tempIndexList.add(hIndex[i]);
      }
    }
    if (tempIndexList.length > 1) {
      var rng = Random();
      int temp;
      int pickSpot;
      if (tempIndexList.length > 2) {
        //shuffle the tempIndexList
        for (int i = 0; i < tempIndexList.length - 1; i++) {
          //choose a letter at random to move to end
          pickSpot = rng.nextInt(tempIndexList.length - i);
          temp = tempIndexList.removeAt(pickSpot);
          tempIndexList.add(temp);
        }
        //move final item in first position to end
        temp = tempIndexList.removeAt(0);
        tempIndexList.add(temp);
      } else {
        int z = tempIndexList[0];
        tempIndexList[0] = tempIndexList[1];
        tempIndexList[1] = z;
      }
      //fill in hIndex with the tempIndexList
      for (int i = 0; i < hIndex.length; i++) {
        //only fill in the letters that arn't guessed
        if (!compLettList[hIndex[i]].guessed) {
          hIndex[i] = tempIndexList[0];
          //update their left positions and hSpot
          compLettList[hIndex[i]].hSpot = i; //update left position
          compLettList[hIndex[i]].left = leftPos[i];
          tempIndexList.removeAt(0);
        }
      }
      notifyListeners();
    }
  }
}

//********** letter class **********
class Letter extends StatelessWidget {
  const Letter(
      {Key? key,
      required this.lett,
        required this.myIndex,
        required this.mainColor,
        required this.fadeColor,
        required this.textStyleName})
      : super(key: key);
  final String lett;
  final int myIndex; //index of position in gameLetts
  final Color mainColor;
  final Color fadeColor;
  final String textStyleName;

  @override
  Widget build(BuildContext context) {
    //pointless variable to trigger rebuilds on orientation change
    double paddingHeight = MediaQuery.of(context).padding.top;
    paddingHeight = 0;
    if (showBuilds) {
      print('Letter Built: $lett');
    }
    var gMod = Provider.of<GameModel>(context, listen: true);
    //print('lett height: ${gMod.lettHeight}');
    //print('Letter Built: $lett');
    return AnimatedPositioned(
        onEnd: () => gMod.onAniEnd(myIndex),
        duration: Duration(milliseconds: gMod.compLettList[myIndex].speed),
        left: gMod.compLettList[myIndex].left + paddingHeight,
        top: gMod.compLettList[myIndex].top,
        width: gMod.compLettList[myIndex].width,
        height: gMod.compLettList[myIndex].height,
        curve: gMod.primaryCurve,
        child: Listener(
            onPointerDown: (e) {
              gMod.tapLett(myIndex);
            },
            child: AnimatedContainer(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      gMod.compLettList[myIndex].width / 4),
                  gradient: LinearGradient(
                    colors: [mainColor, fadeColor],
                    begin: const Alignment(0.0, 0.0),
                    end: FractionalOffset.bottomCenter,
                    stops: const [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  )),
              transform: Matrix4.rotationZ(gMod.compLettList[myIndex].myAngle),
              duration:
                  Duration(milliseconds: gMod.compLettList[myIndex].speed),
              curve: gMod.primaryCurve,
              alignment: gMod.compLettList[myIndex].lettAlign,
              child: AnimatedDefaultTextStyle(
                  //TODO: letter font size calc
                  style: myStyle(gMod.compLettList[myIndex].width * 1.3 - 6,
                      textStyleName),
                  duration:
                      Duration(milliseconds: gMod.compLettList[myIndex].speed),
                  curve: gMod.primaryCurve,
                  child: Text(
                    lett,
                    textAlign: TextAlign.center,
                  )),
            )));
  }
}
//********** end letter class **********

//TODO: complett
class CompLett {
  CompLett(
      this.lett,
      this.top,
      this.left,
      this.height,
      this.width,
      this.gSpot,
      this.hSpot,
      this.guessed,
      this.special,
      this.shadow,
      this.mini,
      this.clickAllowed) {
    if (mini) {
      lettAlign = const Alignment(0, 0);
    } else {
      lettAlign = const Alignment(0, -.65);
    }
  }

  String lett;
  double top;
  double left;
  double height;
  double width;
  int gSpot; //not needed?
  int hSpot;
  bool special;
  //var myColor;
  bool shadow; //if its a miniletter placeholder
  bool mini; //if it's appearance is a mini-letter
  bool flat = true; //for initial spawn animation
  var now = DateTime.now();
  bool guessed = false; //true if it's on the list gIndex
  bool clearMe = false; //if to-be-deleted
  bool swapMe = false; //if it needs to be swapped to the miniLetter list
  int speed = 425; //initial speed of normal letter movement
  //800 & 600 a little too slow, 400 too fast..

  bool clickAllowed;
  Alignment lettAlign = const Alignment(0, 0);
  double myAngle = 0;
  bool dead = false;
}

class BonusStar extends StatefulWidget {
  const BonusStar(Key key, this.aniStar) : super(key: key);
  final Starpac aniStar;

  @override
  _BonusStarState createState() => _BonusStarState();//_BonusStarState(aniStar);
}

class _BonusStarState extends State<BonusStar>
    with SingleTickerProviderStateMixin {
  //_BonusStarState(this.aniStar);

  //Animation<double> animationSize;
  late AnimationController controller;
  //Starpac aniStar;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: widget.aniStar.aniDuration, vsync: this);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) => GrowTransition(
        controller: controller,
        aniStar: widget.aniStar,
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

//*** end animation code ***

class Starpac {
  //boxes up a bunch of parameters to pass through the animation mess
  Starpac(
      this.removeStar,
      this.sWidth,
      this.sHeight,
      this.clockFontSize,
      this.expandRange,
      this.points,
      this.aniDuration,
      this.alphaB,
      this.layoutD,
      this.flexD);

  Function removeStar;
  double sWidth;
  double sHeight;
  double clockFontSize;
  double expandRange;
  int points;
  Duration aniDuration;
  bool alphaB;
  int layoutD;
  Axis flexD;
}

// Define a custom Form widget to get a name for scoreboard if needed
class MyCustomForm extends StatefulWidget {
  final int highScore;
  final String mySkill;
  final bool setHighScore;
  final double buttonFontSize;
  final double smallButtonFontSize;

  const MyCustomForm(this.highScore, this.mySkill, this.setHighScore,
      this.buttonFontSize, this.smallButtonFontSize, {Key? key}) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm>
    with SingleTickerProviderStateMixin {
  late AnimationController aniController;
  late Animation<double> myAnimation;
  bool isEnabled = false;
  Color currentButtonColor = disabledButtonColor;
  Color currentButtonTextColor = disabledButtonTextColor;

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    aniController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    myController.text = '';
    super.initState();
    aniController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    myAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: aniController,
        curve: const Interval(
          0.5,
          1,
          curve: Curves.easeOutQuad,
        ),
      ),
    );
    aniController.addListener(() {
      setState(() {});
    });
    aniController.forward();
    //Timer(Duration(milliseconds: 3500), () {isEnabled=true;});
  }

  @override
  Widget build(BuildContext context) {
    double mySpacer = getHeight(context) * .01;
    List<Widget> highScoreContent = [];
    var sMod = Provider.of<ScoreModel>(context, listen: false);
    void scoreButtonEvent() {
      if (isEnabled) {
        sMod.fileHighScore(widget.highScore, myController.text, widget.mySkill);
        myController.text = ''; //attempt to fix saving-text issue
        //set scoreboard name variable to myController.text
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        //Navigator.pop(context);
        Navigator.pushNamed(context, '/${widget.mySkill}HighScores');
      }
    }

    if (widget.setHighScore) {
      //if a high score is set
      highScoreContent = <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(8, mySpacer * 2, 8, mySpacer * 3),
          child: Text("YOU'VE SET A HIGH SCORE!",
              textAlign: TextAlign.center,
              style: myStyle(widget.buttonFontSize, 'popupMenuTitle')),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Text("Enter a name for the scoreboard:",
              textAlign: TextAlign.center,
              style: myStyle(widget.smallButtonFontSize, 'popupMenu')),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, mySpacer),
            child: TextField(
              style: myStyle(widget.buttonFontSize, 'popupMenuEntryText'),
              controller: myController,
              autocorrect: false,
              cursorColor: cursorColor,
              enableSuggestions: false,
              keyboardAppearance: Brightness.dark,
              maxLines: 1,
              onChanged: (myChange) {
                if (myController.text.isNotEmpty) {
                  isEnabled = true;
                  setState(() {
                    currentButtonColor = myButtonColor;
                    currentButtonTextColor = buttonTextColor;
                  });
                } else {
                  isEnabled = false;
                  setState(() {
                    currentButtonColor = disabledButtonColor;
                    currentButtonTextColor = disabledButtonTextColor;
                  });
                }
              },
              //enable button if not blank
              showCursor: true,
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.words,
              maxLength: 10,
            )),
        Padding(
            padding: EdgeInsets.fromLTRB(8, mySpacer * 4, 8, mySpacer * 2),
            child: RawMaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                fillColor: currentButtonColor,
                textStyle:  const TextStyle(color: buttonTextColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80)),
                splashColor: myButtonAccent,
                onPressed: isEnabled ? scoreButtonEvent : null,
                child: Center(
                  child: Text(
                    "VIEW HIGH SCORES",
                    style: TextStyle(
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.w600,
                      fontSize: widget.smallButtonFontSize,
                      //gMod.buttonFontSize,
                      color: currentButtonTextColor,
                    ), //need to somehow pass buttonfontsize
                  ),
                ))),
      ];
    } else {
      //if a high score isn't set
      highScoreContent = <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(8, mySpacer * 2, 8, mySpacer * 3),
          child: Text("You're out of time.",
              textAlign: TextAlign.center,
              style: myStyle(widget.buttonFontSize, 'popupMenuTitle')),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Text("Score: ${widget.highScore}",
              //textAlign: TextAlign.center,
              style: myStyle(widget.buttonFontSize, 'popupMenu')),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(8, mySpacer * 4, 8, mySpacer),
            child: MyButton(
                'RETURN TO MENU', widget.smallButtonFontSize, 2, 2, 2, 2, () {
              Navigator.of(context).pop();
              Navigator.pop(context);
            })),
      ];
    }

    Future<bool> _onBackPressed() async {
      if (!widget.setHighScore) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
      return false;
    }

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            backgroundColor: const Color.fromRGBO(0, 0, 0, .5),
            body: Center(
                child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Material(
                        color: Colors.transparent,
                        child: FadeTransition(
                            opacity: myAnimation,
                            child: Container(
                                decoration: ShapeDecoration(
                                    color: customFormBackgroundColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0))),
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: highScoreContent,
                                    )))))))));
  }
}

//TODO: points/starpac animation code
class GrowTransition extends StatelessWidget {
  final Animation<double> aniSize;
  final Animation<double> aniSizePt2;
  final Animation<double> aniFade;
  final Starpac aniStar;
  final Animation<double> controller;
  static double sizeConstant = 0.8;
  GrowTransition({Key? key, required this.controller, required this.aniStar})
      : aniSize = Tween<double>(
          begin: sizeConstant * aniStar.clockFontSize * .3,
          end: sizeConstant * aniStar.clockFontSize * (1 + aniStar.expandRange),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0,
              0.2,
              curve: Curves.easeOutQuad,
            ),
          ),
        ),
        aniSizePt2 = Tween<double>(
          begin: 0,
          end: -aniStar.clockFontSize * .7 * (aniStar.expandRange),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.25,
              0.45,
              curve: Curves.easeInQuad,
            ),
          ),
        ),
        aniFade = Tween<double>(
          begin: 1,
          end: 0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.35,
              1,
              curve: Curves.easeInOutSine,
            ),
          ),
        )..addStatusListener((AnimationStatus status) {
            //print('$status - $expandRange');
            if (status == AnimationStatus.completed) {
              aniStar.removeStar();
            }
          }),
        super(key: key);


  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Positioned(
          left: aniStar.flexD == Axis.vertical
              ? aniStar.sWidth * (0.38)
              : aniStar.sWidth * (0.55), //.38
          top: aniStar.sHeight *
                  ((aniStar.alphaB ? 4.7 : 2.7) / aniStar.layoutD) -
              (aniSize.value + aniSizePt2.value) / 2,
          //child: Container(

          child: Opacity(
            //TODO: remove the opacity widget to improve performance(?)
            opacity: aniFade.value,
            child: Text(
              '+' + aniStar.points.toString(),
              style: myStyle(aniSize.value + aniSizePt2.value, 'bonusStar'),
            ),
            //)
          )));
}

class MyClock extends StatefulWidget {
  const MyClock({Key? key}) : super(key: key);

  @override
  _MyClockState createState() => _MyClockState();
}

class _MyClockState extends State<MyClock> {
  int oneTick = 1400; //start span of a tick in milliseconds
  int displayTicks =20;//edited for null safety, arbitrary non-zero number
  Duration clockDuration = const  Duration(milliseconds: 1400); //animation time
  Color clockColor = plainClockColor;
  Timer clockTimer =Timer(const Duration(milliseconds: 0), () {});
  int ticksElapsed = 0;
  bool gameOver = false;

  void startTimer() {
    //oneTick timeLeft
    void handleTimeout() {
      // callback function
      setState(() {
        ticksElapsed += 1;
        displayTicks -= 1;
        //TODO adjust clock speed here
        if (oneTick > 1100) {
          oneTick -= 3;
        } else if (oneTick > 333) {
          oneTick -= 1;
        }
        clockDuration = Duration(milliseconds: (oneTick * .4).round());
        if (displayTicks <= 5) {
          if (clockColor == myWarningColor && displayTicks > 0) {
            clockColor = plainClockColor;
          } else {
            clockColor = myWarningColor;
          }
        } else {
          clockColor = plainClockColor;
          //print('test $clockColor');
        }
        if (displayTicks > 0) {
          clockTimer =
              Timer(Duration(milliseconds: oneTick), handleTimeout);
        }
      });
      if (displayTicks <= 0) {
        if (clockTimer.isActive) {
          clockTimer.cancel();
        }
        //out-of-time code here
        if (!gameOver) {
          var gMod = Provider.of<GameModel>(context, listen: false);
          gMod.timesUp(context);
          gameOver = true;
        }
      }
    }

    clockTimer = Timer(Duration(milliseconds: oneTick), handleTimeout);
  }

  void clockCallBack(int displayTicks) {
    setState(() {
      if (displayTicks <= 1) {
        clockColor = myWarningColor;
      } else {
        clockColor = plainClockColor;
      }
    });
  }

  @override
  void dispose() {
    clockTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    clockTimer = Timer(const Duration(milliseconds: 500), () {
      //start the timer
      startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    var gMod = Provider.of<GameModel>(context, listen: true);
    displayTicks = gMod.startTicks - ticksElapsed + gMod.addedTicks;
    if (displayTicks < 0) {
      displayTicks = 0;
    }
    return AnimatedContainer(
      duration: clockDuration,
      onEnd: () => clockCallBack(displayTicks),
      decoration: BoxDecoration(
        color: clockColor,
        shape: BoxShape.circle,
      ),
      child: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Icon(Icons.hourglass_top_sharp,
                    size: gMod.clockFontSize*.33, color: Colors.transparent),
                Text(
        '$displayTicks',
        textAlign: TextAlign.center,
        style: myStyle(gMod.clockFontSize, 'clockStyle'),
          ),
                Icon(Icons.hourglass_top_sharp,
                    size: gMod.clockFontSize*.33, color: myWhite),
              ])),
    );
  }
}
