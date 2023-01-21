import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doodler/Bloc/dataEvent.dart';
import 'package:doodler/UI/CardGame/card_item.dart';
import 'package:flutter/widgets.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:http/http.dart' as http;

class DataBloc extends Bloc {
  Map<String, Map<String, List<String>>> fullData = {};
  List<String> categories = [];
  List CardData = [];
  CardModel? cardModel;
  List<CardModel>? myCard;

  StreamController<DataEvent> _dataEventController =
      StreamController<DataEvent>.broadcast();

  StreamSink<DataEvent> get dataEventSink => _dataEventController.sink;

  Stream<DataEvent> get _dataEventStream => _dataEventController.stream;

  StreamController<Map<String, String>> _dataController =
      StreamController<Map<String, String>>.broadcast();

  StreamSink get dataSink => _dataController.sink;

  Stream get dataStream => _dataController.stream;

  StreamController<Map<String, String>> _categoriesController =
      StreamController<Map<String, String>>.broadcast();

  StreamSink get categoriesSink => _categoriesController.sink;

  Stream get categoriesStream => _categoriesController.stream;

  StreamController<Map<String, String>> _groupsController =
      StreamController<Map<String, String>>.broadcast();

  StreamSink get groupsSink => _groupsController.sink;

  Stream get groupsStream => _groupsController.stream;

  StreamController<List<CardModel>> _cardController =
      StreamController<List<CardModel>>.broadcast();

  StreamSink get cardSink => _cardController.sink;

  Stream get cardStream => _cardController.stream;

  DataBloc() {
    _dataEventStream.listen(mapEventToState);
  }

  Future<void> fetchImagesUrl(String category, List<String> names) async {
    print("Inside Fetch Images Url");
    String api_key = "563492ad6f91700001000001cbffa50cfb594d60b590db030de7ea82";
    Map<String, String> urls = new Map<String, String>();

    for (int i = 1; i < names.length; i++) {
      print("Fetch URL inside For Loop " + i.toString());
      final response = await http.get(
          Uri.parse('https://api.pexels.com/v1/search?query=' +
              names[i] +
              '&per_page=5'),
          headers: {"Authorization": api_key});

      if (response.statusCode == 200) {
        List<dynamic> photos = json.decode(response.body)['photos'];
//        print("Photos:"+photos.toString());

        for (int j = 0; j < photos.length; j++) {
          String val = photos[j]['src']['large'];

          if (!fullData[category]![names[i]]!.contains(val))
            fullData[category]![names[i]]!.add(val);
        }
//        print(fullData[category][names[i]]);

        urls[names[i]] = fullData[category]![names[i]]!.isEmpty
            ? "https://images.pexels.com/photos/951007/pexels-photo-951007.jpeg?auto=compress&cs=tinysrgb&h=650&w=940"
            : fullData[category]![names[i]]!.first;

        if (i == names.length - 1) {
          print("Printing URLS");
          print(urls);
          dataSink.add(urls);

          categories.forEach((element) {
            addInDB(element);
          });
//          print(fullData);
        }
      } else {
        throw Exception('Failed to load data.');
      }
      //
    }
  }

  Future<void> addInDB(String category) async {
    FirebaseFirestore.instance.collection("Module").doc(category).set({
      "Data": {"Level 1": fullData[category]}
    });
  }

  Future<void> mapEventToState(DataEvent event) async {
    List<String> names = [];

    if (event is FetchGroups) {
      FirebaseFirestore.instance
          .collection("Admin_Panel")
          .doc("Dashboard")
          .snapshots()
          .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        Map<String, String> groups = {};
        Map<String, dynamic> fetchedData =
            snapshot.data() as Map<String, dynamic>;
        print("Data Block FetchGroup ");

        fetchedData.forEach((group, image) {
//          print(image);
          groups[group] = image["fieldImage"];
        });

        groupsSink.add(groups);
      });
    } else if (event is FetchCategories) {
      FirebaseFirestore.instance
          .collection("Admin_Panel")
          .doc("Dashboard")
          .snapshots()
          .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        Map<String, String> categories = {};
        Map<String, dynamic> fetchedData =
            snapshot.data() as Map<String, dynamic>;

        fetchedData[event.group].forEach((key, image) {
          if (key != "fieldImage") {
            categories[key] = image;
          }
        });

        categoriesSink.add(categories);
      });
    } else if (event is FetchData) {
      String category = event.name;
      categories = [];

//      if (fullData.isEmpty) {
      print("In Data Bloc Collecting Module Data ");
      QuerySnapshot qs =
          await FirebaseFirestore.instance.collection("Module").get();

      qs.docs.forEach((snapshot) {
//      print(snapshot.documentID);
//      print(snapshot.data);
        Map<String, List<String>> innerData = new Map<String, List<String>>();
        Map<String, dynamic> fetchedData =
            snapshot.data() as Map<String, dynamic>;

        if (!categories.contains(snapshot.id)) categories.add(snapshot.id);

        fetchedData["Data"]["Level 1"].forEach((name, urlList) {
          innerData[name] = [];
          if (urlList.isNotEmpty) {
            urlList.forEach((url) {
              innerData[name]!.add(url);
            });
          }
        });
//      print(snapshot.documentID);
//      print(innerData);
//      print(fullData[snapshot.documentID]);
        fullData[snapshot.id] = innerData;
//          print(fullData);
      });
//      }
      print("Full Data is being printed ....");
      print(fullData);
      print(category);

      if (category != "") {
        fullData[category]!.forEach((key, value) {
          names.add(key);
        });
        print("Printing Names in Data bloc");
        print(names);
        print(fullData[category]![names[0]]!.isEmpty);

        if (!(fullData[category]![names[0]]!.isEmpty)) {
          print(1);
//        fullData[category][names[0]].clear();
          fetchImagesUrl(category, names);
        } else {
          Map<String, String> urls = {};
          for (int i = 0; i < names.length; i++) {
//          int pos=Random(DateTime.now().microsecondsSinceEpoch).nextInt(fullData[category][names[i]].length);
            fullData[category]![names[i]]!
                .shuffle(Random(DateTime.now().microsecondsSinceEpoch));
            urls[names[i]] = fullData[category]![names[i]]!.isEmpty
                ? "https://images.pexels.com/photos/951007/pexels-photo-951007.jpeg?auto=compress&cs=tinysrgb&h=650&w=940"
                : fullData[category]![names[i]]!.first;
            print(urls);
          }
          dataSink.add(urls);
        }
      }
    } else if (event is FetchCardData) {
      DocumentSnapshot<Map<String, dynamic>> ds = await FirebaseFirestore
          .instance
          .collection("Module")
          .doc("CardGame")
          .get();

      //List test = ds.data()['Data']['Level 1'];
      List test = ds.data()!['Level 1']['GameData'];

      int len = test.length;
      List<String> asset = [];

      for (int i = 0; i < len - 1; i++) {
        asset.add(test[i]);
      }
      for (int i = len - 1; i >= 0; i--) {
        asset.add(test[i]);
      }

      for (int i = 0; i < asset.length - 1; i++) {
        CardModel(id: 40 - asset.length - 1, image: asset[i], key: UniqueKey());
      }

      List<CardModel> mycard = [asset.length].map((f) {
        int index = Random().nextInt(1000) % asset.length;
        String _image = asset[f];

        print("Image:" + _image);
        print("asset:" + asset[index]);
        asset.removeAt(index);
        return CardModel(
            id: 40 - asset.length - 1, image: _image, key: UniqueKey());
      }).toList();

      cardSink.add(mycard);
    }
  }

  @override
  void dispose() {
    _dataEventController.close();
    _dataController.close();
    _categoriesController.close();
    _groupsController.close();
  }
}
