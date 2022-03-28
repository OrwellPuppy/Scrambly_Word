import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

const bool showLetterGens = false;
const bool showBuilds = false;
const bool showAniEnds = false;

//Colors
const Color myPurple = Colors.purple;
final Color myDarkPurple = Colors.purple.shade800;
const Color myDeepPurple = Colors.deepPurple;
final Color myVeryDeepPurple = Colors.deepPurple.shade900;
const Color myGreen = Color.fromRGBO(34, 140, 19, 1);
final Color myGrey = Colors.grey.shade700;
final Color myDarkGrey = Colors.grey.shade900;
const Color myBlack = Colors.black;
final Color myWhite = Colors.grey.shade300; //Colors.white;
const Color myRed = Colors.red;
const Color myBlue =
    Color.fromRGBO(58, 134, 255, 1); //Color.fromRGBO(43, 139, 251,1);
const Color myBlueAccent = Colors.blueAccent;
const Color myPaleBlue = Color.fromRGBO(43, 139, 251, 1);
const Color myPaleBlueAccent = Colors.blueAccent;

final Color myNiceGrey = Colors.grey.shade800;
final Color myLightGrey = Colors.grey.shade600;
final Color myMidGrey = Colors.grey.shade700;

//Color Scheme
const Color specialTileColor = myPurple;
final Color specialTileFadeColor = myDarkPurple;
const Color commonTileColor = myDeepPurple;
final Color commonTileFadeColor = myVeryDeepPurple;
const Color acceptBorderColor = myGreen;
final Color rejectBorderColor = myGrey;
const Color bonusPointsColor = myGreen;
const Color bonusFlashColor = myGreen;
final Color plainClockColor = myDarkGrey;
const Color guessPlainFill = myBlack;
const Color mainBackgroundColor = myBlack;
final Color letterTextColor = myWhite;
final Color buttonTextColor = myWhite;
const Color myWarningColor = myRed;
const Color myButtonColor = myBlue;
const Color myPaleButtonColor = myPaleBlue;
const Color myButtonAccent = myBlueAccent;
final Color disabledButtonColor = myLightGrey;
final Color disabledButtonTextColor = myMidGrey;
const Color cursorColor = myPurple;
final Color notGotTextColor = myGrey;
final Color myScoreColor = myWhite;
const Color titleColor = myPurple;
final Color highScoreColor = myWhite;
final Color clockTextColor = myWhite;
final Color popupMenuTextColor = myWhite;
final Color customFormBackgroundColor = myNiceGrey;

//styles
TextStyle myStyle(double myFontSize, String myStyleName) {
  switch (myStyleName) {
    /*case 'mainTitle'://no longer used
      {
        return  TextStyle(
                fontFamily:'roboto',
                fontSize: myFontSize,
                fontWeight: FontWeight.bold,
                color: highScoreColor,
                fontFeatures: [
              FontFeature.tabularFigures(),
            ]);
      }
      break;*/
    case 'mainSubTitle':
      {
        return TextStyle(
            fontFamily: 'roboto',
            fontSize: myFontSize,
            //fontWeight: FontWeight.bold,
            color: myWhite,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ]);
      }
    case 'buttonStyle':
      {
        return TextStyle(
            fontFamily: 'roboto',
            fontSize: myFontSize,
            fontWeight: FontWeight.w600,
            color: buttonTextColor,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ]);
      }
    case 'infoButtonStyle':
      {
        return TextStyle(
            fontFamily: 'roboto',
            fontSize: myFontSize,
            fontWeight: FontWeight.w600,
            color: myButtonColor,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ]);
      }
    case 'outlinedButtonStyle':
      {
        return TextStyle(
            fontFamily: 'roboto',
            fontSize: myFontSize,
            fontWeight: FontWeight.w600,
            color: myButtonColor,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ]);
      }
    case 'highScoreTitle':
      {
        return TextStyle(
            fontFamily: 'Inconsolata',
            fontSize: myFontSize,
            fontWeight: FontWeight.w700,
            color: highScoreColor,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ]);
      }
    case 'howToPlayText':
      {
        return TextStyle(
            fontFamily: 'Inconsolata',
            fontSize: myFontSize,
            fontWeight: FontWeight.w700,
            color: highScoreColor,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ]);
      }
    case 'highScores':
      {
        return TextStyle(
            fontFamily: 'Inconsolata',
            fontSize: myFontSize,
            color: highScoreColor,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ]);
      }
    case 'highScoreHeader':
      {
        return TextStyle(
            fontFamily: 'Inconsolata',
            fontSize: myFontSize,
            color: highScoreColor,
            decoration: TextDecoration.underline,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ]);
      }
    case 'clockStyle':
      {
        return TextStyle(
            fontFamily: 'robotoMono',
            fontSize: myFontSize,
            color: clockTextColor,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ]);
      }
    case 'skillLabel':
      {
        return TextStyle(
            fontFamily: 'roboto',
            fontSize: myFontSize,
            color: rejectBorderColor,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ]);
      }
    case 'scoreLabel':
      {
        return TextStyle(
            fontFamily: 'robotoMono',
            fontSize: myFontSize,
            color: myScoreColor,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ]);
      }
    case 'gotWordListSpecial':
      {
        return TextStyle(
            fontFamily: 'robotoMono',
            fontSize: myFontSize,
            color: specialTileColor,
            height: 1,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ]);
      }
    case 'gotWordListCommon':
      {
        return TextStyle(
            fontFamily: 'robotoMono',
            fontSize: myFontSize,
            color: commonTileColor,
            height: 1,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ]);
      }
    case 'letter':
      {
        return TextStyle(
          fontFamily: 'RobotoMono',
          fontSize: myFontSize,
          fontWeight: FontWeight.w500,
          color: letterTextColor,
          height: 1,
          //    fontFeatures: [FontFeature.tabularFigures(),]
        );
      }
    case 'letterPlaceholder':
      {
        return TextStyle(
            fontFamily: 'robotoMono',
            fontSize: myFontSize,
            fontWeight: FontWeight.w500,
            color: notGotTextColor,
            height: 1,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ]);
      }
    case 'popupMenuTitle':
      {
        return TextStyle(
          fontFamily: 'roboto',
          fontSize: myFontSize,
          fontWeight: FontWeight.bold,
          color: popupMenuTextColor,
        );
      }
    case 'popupMenu':
      {
        return TextStyle(
          fontFamily: 'roboto',
          fontSize: myFontSize,
          color: popupMenuTextColor,
        );
      }
    case 'popupMenuEntryText':
      {
        return TextStyle(
          fontFamily: 'roboto',
          fontSize: myFontSize,
          color: popupMenuTextColor,
        );
      }
    case 'bonusStar':
      {
        return TextStyle(
          fontFamily: 'robotoMono',
          fontSize: myFontSize,
          color: bonusPointsColor,
        );
      }
    default:
      {
        return TextStyle(
            fontFamily: 'roboto',
            fontSize: myFontSize,
            color: highScoreColor,
            fontWeight: FontWeight.bold,
            fontFeatures: const [
              FontFeature.tabularFigures(),
            ]);
      }
  }
}

int appCounter = 1;
int gameScreenCounter = 1;
int resizedCounter = 1;
int recalcCounter = 1;

double getHeight(BuildContext context) {
  //compensate for left/bottom/right/top padding for OS stuff
  double paddingHeight = MediaQuery.of(context).padding.top +
      MediaQuery.of(context).padding.bottom;
  return MediaQuery.of(context).size.height - paddingHeight;
}

double getWidth(BuildContext context) {
  //compensate for left/bottom/right/top padding for OS stuff
  double paddingWidth = MediaQuery.of(context).padding.left +
      MediaQuery.of(context).padding.right;
  double paddingHeight = MediaQuery.of(context).padding.top +
      MediaQuery.of(context).padding.bottom;
  double effectiveWidth = min(MediaQuery.of(context).size.width - paddingWidth,
      (MediaQuery.of(context).size.height - paddingHeight) * 1.1);
  return effectiveWidth;
}

double getVoidWidth(BuildContext context) {
  double myHeight = getHeight(context);
  double myWidth = MediaQuery.of(context).size.width -
      (MediaQuery.of(context).padding.left +
          MediaQuery.of(context).padding.right);
  double myVoidWidth = myWidth - myHeight;
  return max(myVoidWidth / 2, 0);
}

const List<String> alphabet = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z'
];

const List<String> alphaVow = [
  'A',
  'E',
  'I',
  'O',
  'U',
];

const Map<String, int> conPool = {
  //Map of consonants in the pool [weight]
  'B': 15,
  'C': 28,
  'D': 43,
  'F': 22,
  'G': 20,
  'H': 60,
  'J': 2,
  'K': 8,
  'L': 40,
  'M': 24,
  'N': 68,
  'P': 19,
  'Q': 1,
  'R': 60,
  'S': 63,
  'T': 91,
  'V': 10,
  'W': 24,
  'X': 2,
  'Y': 20,
  'Z': 1
};

const Map<String, int> vowPool = {
  //Map of vowels in the pool [weight]
  'A': 82,
  'E': 127,
  'I': 70,
  'O': 75,
  'U': 28
};

class MyButton extends StatelessWidget {
  const MyButton(
      this.buttonText,
      this.buttonTextSize,
      this.paddingLeft,
      this.paddingRight,
      this.paddingTop,
      this.paddingBottom,
      this.runFunction,
      //this.isSub,
      {Key? key})
      : super(key: key);

  final String buttonText;
  final double buttonTextSize;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final Function runFunction;
  //final bool isSub;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: paddingLeft,
          top: paddingTop,
          right: paddingRight,
          bottom: paddingBottom),
      child: Listener(
          onPointerDown: (e) {
            runFunction();
          },
          child: RawMaterialButton(
              fillColor:  myButtonColor,
              //textStyle: TextStyle(color: buttonTextColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80)),
              splashColor: myButtonAccent,
              onPressed: () {
                //gMod.submit();
              },
              child: Center(
                child: Text(
                  buttonText,
                  style: myStyle(buttonTextSize, 'buttonStyle'),
                ),
              ))),
    );
  }
}

class MyOutlinedButton extends StatelessWidget {
  const MyOutlinedButton(
      this.buttonText,
      this.buttonTextSize,
      this.paddingLeft,
      this.paddingRight,
      this.paddingTop,
      this.paddingBottom,
      this.runFunction,
         {Key? key})
      : super(key: key);

  final String buttonText;
  final double buttonTextSize;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final Function runFunction;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: paddingLeft,
          top: paddingTop,
          right: paddingRight,
          bottom: paddingBottom),
      child: Listener(
          onPointerDown: (e) {
            runFunction();
          },
          child: TextButton(
    style: TextButton
        .styleFrom(
              //fillColor: isSub ? myPaleButtonColor : myButtonColor,
              //textStyle: TextStyle(color: buttonTextColor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80),
                  side: const BorderSide(width: 1, color: myButtonColor),),
              //splashColor: myButtonAccent,
    ),
              onPressed: () {
                //gMod.submit();
              },
              child: Center(
                child: Text(
                  buttonText,
                  style: myStyle(buttonTextSize, 'outlinedButtonStyle'),
                ),
              ))),
    );
  }
}

class MyInfoButton extends StatelessWidget {
  const MyInfoButton(
      this.myIcon,
      this.buttonText,
      this.buttonTextSize,
      this.paddingLeft,
      this.paddingRight,
      this.paddingTop,
      this.paddingBottom,
      this.runFunction,

      {Key? key})
      : super(key: key);

  final Icon myIcon;
  final String buttonText;
  final double buttonTextSize;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final Function runFunction;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: paddingLeft,
          top: paddingTop,
          right: paddingRight,
          bottom: paddingBottom),
      child: Listener(
          onPointerDown: (e) {
            runFunction();
          },
          child: TextButton(
              style: TextButton.styleFrom(
                //fillColor: isSub?myPaleButtonColor: myButtonColor,
                //textStyle: TextStyle(color: buttonTextColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80)),
                //splashColor: myButtonAccent,
              ),
              onPressed: () {
                //gMod.submit();
              },
              child: Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        myIcon,
                    Text(
                      buttonText,
                      style: myStyle(buttonTextSize, 'infoButtonStyle'),
                    ),
                  ])))),
    );
  }
}

//My special Title widget
class TitleLetter extends StatefulWidget {
  TitleLetter(
    Key key,
    this.lett,
    this.width,
    this.height,
    this.fontSize,
    this.startFlipColor,
  ) : super(key: key) {
    bool flipColor = startFlipColor;
    for (var i = 0; i < lett.length; i++) {
      keyList.add(UniqueKey());
      flipColor = !flipColor;
      myLetterList.add(AnimatedContainer(
        //TODO get rid of all the unnecessary 'animated' crap
        key: UniqueKey(),
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(width / 4),
            gradient: LinearGradient(
              colors: flipColor
                  ? [commonTileColor, commonTileFadeColor]
                  : [specialTileColor, specialTileFadeColor],
              begin: const Alignment(0.0, 0.0),
              end: FractionalOffset.bottomCenter,
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp,
            )),
        duration: const Duration(seconds: 1),
        // curve: gMod.primaryCurve,
        alignment: const Alignment(0, 0),
        child: AnimatedDefaultTextStyle(
            //todo fix font size
            style: myStyle(fontSize, 'letter'),
            duration: const Duration(seconds: 1),
            //curve: gMod.primaryCurve,
            child: Text(
              lett[i],
              textAlign: TextAlign.center,
            )),
      ));
    }
  }

  final String lett;
  final double width;
  final double height;
  final double fontSize;
  final bool startFlipColor;
  final List<Widget> myLetterList = [];
  final List<Key> keyList = [];

  @override
  _TitleLetterState createState() => _TitleLetterState();
}

class _TitleLetterState extends State<TitleLetter> {
  bool _inDefaultState = true;

  @override
  Widget build(BuildContext context) {
    List<Key> _currentKeyList = [];
    List<Widget> _currentList = [];
    List<Widget> _finalList = [];
    //var _currentString = '';
    if (_inDefaultState) {
      _currentList = widget.myLetterList;
      _currentKeyList = widget.keyList;
    } else {
      var rng = Random();
      List<int> order = [];
      int tempIndex;
      for (var i = 0; i < widget.myLetterList.length; i++) {
        order.add(i);
      }
      for (var i = 0; i < widget.myLetterList.length; i++) {
        tempIndex = rng.nextInt(order.length);
        //print('$i: $tempIndex');
        _currentList.add(widget.myLetterList[order[tempIndex]]);
        _currentKeyList.add(widget.keyList[order[tempIndex]]);
        order.removeAt(tempIndex);
      }
    }
    for (var i = 0; i < widget.myLetterList.length; i++) {
      _finalList.add(AnimatedPositioned(
        duration: const Duration(milliseconds: 450),
        child: _currentList[i],
        key: _currentKeyList[i],
        top: 0,
        left: widget.width * i,
        //top:10,
      ));
    }
    return Listener(
        onPointerDown: (e) {
          setState(() {
            _inDefaultState = !_inDefaultState;
          });
        },
        child: SizedBox(
            height: widget.height,
            width: widget.width * widget.myLetterList.length,
            child: Stack(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: _finalList)));
  }
} //********** end letter class ********
