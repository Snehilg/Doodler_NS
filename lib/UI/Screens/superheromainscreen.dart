import 'dart:convert';

import 'package:doodler/Model/superhero.dart';
import 'package:doodler/UI/Screens/superherodescription.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;

import '../../search.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var url = "https://akabab.github.io/superhero-api/api/all.json";

  List? superHero = [];
  List superHeroFeatured = [];

  @override
  void initState() {
    super.initState();
    fetchSuperHeroes();
  }

  bool loading = true;

  fetchSuperHeroes() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        print("Json Output");
        //print(json.decode(response.body));

        for (var test in json.decode(response.body)) {
          if (SuperHero.fromJson(test).biography!.publisher != null &&
              (SuperHero.fromJson(test)
                      .biography!
                      .publisher!
                      .contains("Marvel Comics") ||
                  SuperHero.fromJson(test)
                      .biography!
                      .publisher!
                      .contains("DC Comics") ||
                  SuperHero.fromJson(test)
                      .biography!
                      .publisher!
                      .contains("Shueisha"))) {
            if (SuperHero.fromJson(test).name!.startsWith("Spider-Man") ||
                SuperHero.fromJson(test).name!.startsWith("Superman") ||
                SuperHero.fromJson(test).name!.startsWith("Hulk") ||
                SuperHero.fromJson(test).name!.startsWith("Captain America") ||
                SuperHero.fromJson(test).name!.startsWith("Wonder Girl") ||
                SuperHero.fromJson(test).name!.startsWith("Batman") ||
                SuperHero.fromJson(test).name!.startsWith("Thor") ||
                SuperHero.fromJson(test).name!.startsWith("Lantern") ||
                SuperHero.fromJson(test).name!.startsWith("Flash") ||
                SuperHero.fromJson(test).name!.startsWith("Thanos") ||
                SuperHero.fromJson(test).name!.startsWith("Wolverine") ||
                SuperHero.fromJson(test).name!.startsWith("Iron Man") ||
                SuperHero.fromJson(test).name!.startsWith("Green Arrow") ||
                SuperHero.fromJson(test).name!.startsWith("Torch") ||
                SuperHero.fromJson(test).name!.startsWith("Ben 10") ||
                SuperHero.fromJson(test).name!.startsWith("Black Widow") ||
                SuperHero.fromJson(test).name!.startsWith("Doctor Strange") ||
                SuperHero.fromJson(test).name!.startsWith("Goku") ||
                SuperHero.fromJson(test).name!.startsWith("Naruto Uzumaki") ||
                SuperHero.fromJson(test).name!.startsWith("One Punch Man") ||
                SuperHero.fromJson(test).name!.startsWith("Hawk") ||
                SuperHero.fromJson(test).name!.startsWith("Aquaman")) {
              superHeroFeatured.add(test);
              //print(SuperHero.fromJson(test).biography.publisher);
            }
          }
          // if (SuperHero.fromJson(test).biography.publisher.contains("Marvel")) {
          //   superHero.add(test);
          // }
        }

        superHero = json.decode(response.body);
      });
      setState(() {
        loading = false;
      });
      throw Exception('Failed to Load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.lime,
          appBar: AppBar(
            title: Center(
              child: Text(
                'Super Heroes',
                style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold),
              ),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Featured",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )),
                ),
                Tab(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "All",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )),
                ),
              ],
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  iconSize: 25,
                  onPressed: () {
                    superHero == null
                        ? print("Chill")
                        : showSearch(
                            context: context,
                            delegate: HeroSearch(all: superHero),
                          );
                  })
            ],
          ),
          body: TabBarView(
            children: [
              Center(
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GridView.builder(
                          itemCount: superHeroFeatured.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.8 / 2.3,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            SuperHero superhero =
                                SuperHero.fromJson(superHeroFeatured[index]);

                            // if (SuperHero.fromJson(superHero[index])
                            //     .biography
                            //     .publisher
                            //     .contains("Marvel")) {
                            //   superhero = SuperHero.fromJson(superHero[index]);
                            // }
                            return Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => HeroDetails(
                                                  hero: superhero,
                                                )));
                                  },
                                  child: Hero(
                                    tag: superhero.images!.lg!,
                                    child: Container(
                                      height: 200,
                                      width: 150,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        elevation: 5,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            child: Image.network(
                                              superhero.images!.lg!,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  superhero.name!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            );
                          },
                        ),
                      ),
              ),
              Center(
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GridView.builder(
                          itemCount: superHero!.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.8 / 2.3,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            SuperHero superhero =
                                SuperHero.fromJson(superHero![index]);

                            // if (SuperHero.fromJson(superHero[index])
                            //     .biography
                            //     .publisher
                            //     .contains("Marvel")) {
                            //   superhero = SuperHero.fromJson(superHero[index]);
                            // }
                            return Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => HeroDetails(
                                                  hero: superhero,
                                                )));
                                  },
                                  child: Hero(
                                    tag: superhero.images!.lg!,
                                    child: Container(
                                      height: 200,
                                      width: 150,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        elevation: 5,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            child: Image.network(
                                              superhero.images!.lg!,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  superhero.name!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            );
                          },
                        ),
                      ),
              ),
            ],
          )),
    );
  }
}
