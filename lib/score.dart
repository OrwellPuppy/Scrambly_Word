import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreModel extends ChangeNotifier {
  List<int> noviceScores = [];
  List<String> noviceNames = [];
  List<String> noviceDates = [];
  List<int> expertScores = [];
  List<String> expertNames = [];
  List<String> expertDates = [];
  final int maxScores = 10;
  int lastHighScore = 999; //the place # of the high score set
  String lastSkill = 'null'; //novice/expert of last high score set

  ScoreModel() {
    print('ScoreModel constructed');
    loadData();
  }

  loadData() async {
    final prefs = await SharedPreferences.getInstance();
    noviceScores.clear();
    noviceNames.clear();
    noviceDates.clear();
    expertScores.clear();
    expertNames.clear();
    expertDates.clear();
    for (int i = 0; i < maxScores; i++) {
      noviceScores.add(prefs.getInt('noviceScore$i') ?? 0);
      noviceNames.add(prefs.getString('noviceName$i') ?? '-');
      noviceDates.add(prefs.getString('noviceDate$i') ?? '-');

      expertScores.add(prefs.getInt('expertScore$i') ?? 0);
      expertNames.add(prefs.getString('expertName$i') ?? '-');
      expertDates.add(prefs.getString('expertDate$i') ?? '-');
    }
    print('loaded Novice Scores: $noviceScores');
    print('loaded Novice Names: $noviceNames');
    print('loaded Novice Dates: $noviceDates');
    print('loaded Expert Scores: $expertScores');
    print('loaded Expert Names: $expertNames');
    print('loaded Expert Dates: $expertDates');
  }

  saveData() async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < maxScores; i++) {
      prefs.setInt('expertScore$i', expertScores[i]);
      prefs.setInt('noviceScore$i', noviceScores[i]);
      prefs.setString('expertName$i', expertNames[i]);
      prefs.setString('noviceName$i', noviceNames[i]);
      prefs.setString('expertDate$i', expertDates[i]);
      prefs.setString('noviceDate$i', noviceDates[i]);
    }
    print('saved Novice Scores: $noviceScores');
    print('saved Novice Names: $noviceNames');
    print('saved Novice Dates: $noviceDates');
    print('saved Expert Scores: $expertScores');
    print('saved Expert Names: $expertNames');
    print('saved Expert Dates: $expertDates');
  }

  clearData() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < maxScores; i++) {
      prefs.remove('noviceScore$i');
      prefs.remove('noviceName$i');
      prefs.remove('noviceDate$i');
      prefs.remove('expertScore$i');
      prefs.remove('expertName$i');
      prefs.remove('expertDate$i');
    }
    print('DATA CLEARED');
    loadData();
  }

  bool checkHighScore(int myScore, String skill) {
    //reset last high score
    lastHighScore = 999;
    lastSkill = 'null';
    //returns true if a high score is set
    if (skill == 'novice') {
      return (myScore > noviceScores[maxScores - 1]);
    } else {
      return (myScore > expertScores[maxScores - 1]);
    }
  }

  void fileHighScore(int newScore, String newName, String skill) {
    var i = maxScores - 1;
    DateTime now = DateTime.now();
    String date = now.toString().substring(0, 10);
    if (skill == 'novice') {
      while (noviceScores[i] < newScore) {
        i--;
        if (i == -1) {
          break;
        }
      }
      i++;
      noviceScores.insert(i, newScore);
      noviceNames.insert(i, newName);
      noviceDates.insert(i, date);
    } else {
      while (expertScores[i] < newScore) {
        i--;
        if (i == -1) {
          break;
        }
      }
      i++;
      expertScores.insert(i, newScore);
      expertNames.insert(i, newName);
      expertDates.insert(i, date);
    }
    lastHighScore = i;
    lastSkill = skill;
    saveData();
  }
}
