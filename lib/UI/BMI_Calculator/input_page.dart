import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'calculate_bmi.dart';
import 'icon_data.dart';
import 'reusable_card_data.dart';

const bottomContainerHeight = 50.0;
// const activeContainerColor = Color(0xFF1D1E33);
const activeContainerColor = Colors.cyan;
const inactiveContainerColor = Colors.blueGrey;

bool _visibility = false;
CalculatorBrain? calc;

enum Gender {
  male,
  female,
}

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Gender selectedGender = Gender.male;
  int height = 180;
  int age = 20;
  int weight = 60;

  String bmiResult = "";
  String resultText = "";
  String interpretation = "";

  @override
  Widget build(BuildContext context) {
    CalculatorBrain calc;

    return Scaffold(
      appBar: AppBar(
        title: Text("BMI Calculator"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = Gender.male;
                      });
                    },
                    child: ReusableCard(
                      color: selectedGender == Gender.male
                          ? activeContainerColor
                          : inactiveContainerColor,
                      cardChild: Center(
                        child: ReusableChildWidget(
                          icon: FontAwesomeIcons.mars,
                          text: "Male",
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGender = Gender.female;
                      });
                    },
                    child: ReusableCard(
                      color: selectedGender == Gender.female
                          ? activeContainerColor
                          : inactiveContainerColor,
                      cardChild: ReusableChildWidget(
                        icon: FontAwesomeIcons.venus,
                        text: "Female",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    color: activeContainerColor,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Height',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                              height.toString(),
                              style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              "cm",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: height.toDouble(),
                          onChanged: (double newValue) {
                            setState(() {
                              height = newValue.round();
                            });
                          },
                          min: 120.0,
                          max: 220.0,
                          activeColor: Color(0xFF00E676),
                          inactiveColor: Color(0xFFF5F5F5),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ReusableCard(
                    color: activeContainerColor,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Weight",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          weight.toString(),
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 40.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: RawMaterialButton(
                                onPressed: () {
                                  setState(() {
                                    weight--;
                                  });
                                },
                                elevation: 7.0,
                                shape: CircleBorder(),
                                fillColor: Color(0xFF0277BD),
                                child: Icon(FontAwesomeIcons.minus),
                              ),
                            ),
                            Expanded(
                              child: RawMaterialButton(
                                onPressed: () {
                                  setState(() {
                                    weight++;
                                  });
                                },
                                elevation: 7.0,
                                shape: CircleBorder(),
                                fillColor: Color(0xFF0277BD),
                                child: Icon(FontAwesomeIcons.plus),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    color: activeContainerColor,
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Age",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          age.toString(),
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 40.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: RawMaterialButton(
                                onPressed: () {
                                  setState(() {
                                    age--;
                                  });
                                },
                                elevation: 7.0,
                                shape: CircleBorder(),
                                fillColor: Color(0xFF0277BD),
                                child: Icon(FontAwesomeIcons.minus),
                              ),
                            ),
                            Expanded(
                              child: RawMaterialButton(
                                onPressed: () {
                                  setState(() {
                                    age++;
                                  });
                                },
                                elevation: 7.0,
                                shape: CircleBorder(),
                                fillColor: Color(0xFF0277BD),
                                child: Icon(FontAwesomeIcons.plus),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              calc = CalculatorBrain(height: height, weight: weight);

              setState(() {
                _visibility = true;
                bmiResult = calc.calculateBMI();
                resultText = calc.getResult();
                interpretation = calc.getInterpretation();
              });
//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                    builder: (context) => ResultPage(
//                          bmiResult: calc.calculateBMI(),
//                          resultText: calc.getResult(),
//                          interpretation: calc.getInterpretation(),
//                        )),
//              );
            },
            child: Container(
              child: Center(
                child: Text(
                  "Claculate",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              color: Colors.indigoAccent,
              margin: EdgeInsets.only(top: 10.0),
              width: double.infinity,
              height: bottomContainerHeight,
            ),
          ),
          Expanded(
            child: Visibility(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Your Result",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: ReusableCard(
                      color: Colors.amber,
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                resultText.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                bmiResult,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            interpretation,
                            textAlign: TextAlign.center,
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              visible: _visibility,
            ),
          )
        ],
      ),
    );
  }
}
