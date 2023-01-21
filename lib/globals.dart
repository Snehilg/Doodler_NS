library globals;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color primaryColor = Colors.amber;

final staticContent = [
  "Musical",
  "SketchBoard",
  "Xylophone",
  "DrumPad",
  "Piano",
  "BMI Calculator",
  "Tetris",
  "Dice Roll",
  "Tic Tac Toe",
  "Quiz",
  "Fun Facts",
  "Countries",
  "Numbers",
  "Super Hero",
  "Memory Cards",
  "Color Matching",
  "Read Out Loud"
];

final List<String> parentsTabOptions = [
  "Profile",
  "Forum",
  "Buy and Sell",
  "Parenting Tips",
  "Active Contests",
  "Subscription",
  "Rate Us",
  "refer and learn"
];

int alphabetsTotalScore = 0, alphabetsMaxScore = 26;

int animalsTotalScore = 0, animalsMaxScore = 8;

int diceeTotalScore = 0, diceeMaxScore = 1;

int flowersTotalScore = 0, flowersMaxScore = 19;

int fruitsTotalScore = 0, fruitsMaxScore = 13;

int vegetablesTotalScore = 0, vegetablesMaxScore = 13;

int dqTotalScore = 0, dqMaxScore = 6;

int speechTotalScore = 0, speechMaxScore = 6;

int numbersTotalScore = 0, numbersMaxScore = 10;

int xyloTotalScore = 0, xyloMaxScore = 7;

List<String> alphabetsScoreList = [
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0'
];

List<String> animalsScoreList = ['0', '0', '0', '0', '0', '0', '0', '0'];

List<String> diceeScoreList = ['0'];

List<String> flowersScoreList = [
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0'
];

List<String> fruitsScoreList = [
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0'
];

List<String> vegetablesScoreList = [
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0'
];

List<String> numbersScoreList = [
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0',
  '0'
];

List<String> xyloScoreList = ['0', '0', '0', '0', '0', '0', '0'];

//save() async{
//  final prefs = await SharedPreferences.getInstance();
//  prefs.setInt('alphabetsTotalScore', alphabetsTotalScore);
//  prefs.setInt('animalsTotalScore', animalsTotalScore);
//  prefs.setInt('diceeTotalScore', diceeTotalScore);
//  prefs.setInt('flowersTotalScore', flowersTotalScore);
//  prefs.setInt('fruitsTotalScore', fruitsTotalScore);
//  prefs.setInt('vegetablesTotalScore', vegetablesTotalScore);
//  prefs.setInt('dqTotalScore', dqTotalScore);
//  prefs.setInt('speechTotalScore', speechTotalScore);
//
//  prefs.setStringList('alphabetsScoreList', alphabetsScoreList);
//  prefs.setStringList('animalsScoreList', animalsScoreList);
//  prefs.setStringList('diceeScoreList', diceeScoreList);
//  prefs.setStringList('flowersScoreList', flowersScoreList);
//  prefs.setStringList('fruitsScoreList', fruitsScoreList);
//  prefs.setStringList('vegetablesScoreList', vegetablesScoreList);
//
//}

alphaScore() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('alphabetsTotalScore', alphabetsTotalScore);
  prefs.setStringList('alphabetsScoreList', alphabetsScoreList);
}

animalsScore() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('animalsTotalScore', animalsTotalScore);
  prefs.setStringList('animalsScoreList', animalsScoreList);
}

diceeScore() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('diceeTotalScore', diceeTotalScore);
  prefs.setStringList('diceeScoreList', diceeScoreList);
}

flowersScore() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('flowersTotalScore', flowersTotalScore);
  prefs.setStringList('flowersScoreList', flowersScoreList);
}

fruitsScore() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('fruitsTotalScore', fruitsTotalScore);
  prefs.setStringList('fruitsScoreList', fruitsScoreList);
}

vegScore() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('vegetablesTotalScore', vegetablesTotalScore);
  prefs.setStringList('vegetablesScoreList', vegetablesScoreList);
}

dqScore() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('dqTotalScore', dqTotalScore);
}

speechScore() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('speechTotalScore', speechTotalScore);
}

numbersScore() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('numbersTotalScore', numbersTotalScore);
  prefs.setStringList('numbersScoreList', numbersScoreList);
}

xyloScore() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('xyloTotalScore', xyloTotalScore);
  prefs.setStringList('xyloScoreList', xyloScoreList);
}

//Firebase Load data is stored here
Map<String, String> animalImgMap = {}, animalVoiceMap = {};

Map<String, String> alphabetImgMap = {};

Map<String, String> flowersImgMap = {};

Map<String, String> fruitsImgMap = {};

Map<String, String> vegetableImgMap = {};

List<String> dragQuizImgList = new List.filled(6, "");

Map<String, String> numbersImgMap = {};
