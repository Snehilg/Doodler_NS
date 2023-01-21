import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
//import 'package:getflutter/components/button/gf_button.dart';

class AllCountries extends StatefulWidget {
  @override
  _AllCountriesState createState() => _AllCountriesState();
}

class _AllCountriesState extends State<AllCountries> {
  List countries = [];
  List filteredCountries = [];
  bool isSearching = false;

  late FlutterTts flutterTts;

  void setTts() async {
    flutterTts = FlutterTts();
    await flutterTts.isLanguageAvailable("en-US");
    await flutterTts.setSpeechRate(0.7);
  }

  Future _speak(text) async {
    await flutterTts.speak(text);
  }

  TextStyle? _textstyle() {
    color:
    Colors.black;
  }

  getCountries() async {
    var response = await Dio().get('https://restcountries.eu/rest/v2/all');
    return response.data;
  }

  @override
  void initState() {
    getCountries().then((data) {
      setState(() {
        countries = filteredCountries = data;
      });
    });
    super.initState();
    setTts();
  }

  void _filterCountries(value) {
    setState(() {
      filteredCountries = countries
          .where((country) =>
              country['name'].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text('All Countries')
            : TextField(
                onChanged: (value) {
                  _filterCountries(value);
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "Search Country Here",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
        actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      this.isSearching = false;
                      filteredCountries = countries;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      this.isSearching = true;
                    });
                  },
                )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: filteredCountries.length > 0
            ? ListView.builder(
                itemCount: filteredCountries.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 5,
                    child: ExpansionTile(
                      leading: SvgPicture.network(
                          filteredCountries[index]['flag'],
                          width: 110,
                          height: 80),
                      title: Text(
                        filteredCountries[index]['name'],
                        //style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        filteredCountries[index]['capital'],
                        //style: TextStyle(fontSize: 18),
                      ),
                      children: [
                        Card(
                          color: Colors.cyan,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Name"),
                                    TextButton.icon(
                                      /* elevation: 5,
                                      color: Colors.amber,*/
                                      icon: Icon(Icons.volume_up),
                                      onPressed: () => _speak(
                                          filteredCountries[index]['name']),
                                      label: Text(
                                        filteredCountries[index]['name'],
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Capital"),
                                    TextButton.icon(
                                      /*elevation: 5,
                                      color: Colors.amber,*/
                                      icon: Icon(Icons.volume_up),
                                      onPressed: () => _speak("Capital of  " +
                                          filteredCountries[index]['name'] +
                                          "  is" +
                                          filteredCountries[index]['capital']),
                                      label: Text(
                                        filteredCountries[index]['capital'],
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Currency"),
                                    TextButton.icon(
                                      /* elevation: 5,
                                      color: Colors.amber,*/
                                      icon: Icon(Icons.volume_up),
                                      onPressed: () => _speak("Currency of " +
                                          filteredCountries[index]['name'] +
                                          "is " +
                                          filteredCountries[index]['currencies']
                                              [0]['name']),
                                      label: Text(
                                        filteredCountries[index]['currencies']
                                            [0]['name'],
                                        style: TextStyle(color: Colors.black),
                                        //style: TextStyle(fontSize: 18),
                                      ),
                                    )
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Region"),
                                    TextButton.icon(
                                      /*elevation: 5,
                                      color: Colors.amber,*/
                                      icon: Icon(Icons.volume_up),
                                      onPressed: () => _speak(
                                          filteredCountries[index]['name'] +
                                              " is in " +
                                              filteredCountries[index]
                                                  ['region']),
                                      label: Text(
                                        filteredCountries[index]['region'],
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Language"),
                                    TextButton.icon(
                                      /* elevation: 5,
                                      color: Colors.amber,*/
                                      icon: Icon(Icons.volume_up),
                                      onPressed: () => _speak("Language is " +
                                          filteredCountries[index]['languages']
                                              [0]['name']),
                                      label: Text(
                                        filteredCountries[index]['languages'][0]
                                            ['name'],
                                        //style: TextStyle(fontSize: 18),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                })
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
