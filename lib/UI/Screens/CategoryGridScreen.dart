import 'package:doodler/Bloc/dataBloc.dart';
import 'package:doodler/Bloc/dataEvent.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../globals.dart';
import 'DynamicScrollUIScreen.dart';

class MyCategories extends StatefulWidget {
  final String group;

  MyCategories({required this.group});

  @override
  _MyCategoriesState createState() => _MyCategoriesState();
}

class _MyCategoriesState extends State<MyCategories> {
  late DataBloc dataBloc;

  List<String>? images;

  @override
  void didChangeDependencies() {
    dataBloc = BlocProvider.of<DataBloc>(context);
    dataBloc.mapEventToState(FetchCategories(group: widget.group));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, String>>(
        stream: dataBloc.categoriesStream as Stream<Map<String, String>>?,
        //                                        initialData: _storeBloc.getInitialRateList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> categories = snapshot.data!.keys.toList();
            images = snapshot.data!.values.toList();

            if (widget.group == "Alphabets") categories.sort();
            return Scaffold(
              backgroundColor: Colors.cyan,
              appBar: AppBar(
                backgroundColor: Colors.cyan,
                title: Text('Alphabets'),
              ),
              // bottomNavigationBar: BottomNavBar(),
              //drawer: MainDrawer(),
              body: GridView.count(
                crossAxisCount: 2,
                children: categories.map((name) {
                  return GestureDetector(
                    onTap: () {
                      // print("LOG_NAME" + name);
                      if (staticContent.contains(name)) {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, name);
                      } else {
//                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                title: name,
                                group: widget.group,
                              ),
                            ));
                      }
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, bottom: 5, top: 20),
                        child: Card(
                          elevation: 10,
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            side: BorderSide(color: Colors.purple),
                          ),
                          child: Stack(
                            children: [
                              // Positioned(
                              //     top: 0,
                              //     left: 0,
                              //     right: 0,
                              //     bottom: 0,
                              //     child: Image.network(
                              //         images[categories.indexOf(name)],
                              //         fit: BoxFit.fill)),
                              Center(
                                  child: Text(
                                name,
                                style: widget.group != "Alphabets"
                                    ? TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)
                                    : GoogleFonts.portLligatSans(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4!,
                                        fontSize: 70,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                              )),
                            ],
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
