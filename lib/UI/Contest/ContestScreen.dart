import 'package:doodler/Bloc/ContestBloc.dart';
import 'package:doodler/Bloc/ContestEvent.dart';
import 'package:doodler/Model/User.dart';
import 'package:doodler/UI/Contest/ContestHome.dart';
import 'package:doodler/UI/Contest/PrivateContest.dart';
import 'package:doodler/UI/Contest/PublicContest.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class ContestScreen extends StatefulWidget {
  final User? user;
  ContestScreen({this.user});
  @override
  _ContestScreenState createState() => _ContestScreenState();
}

class _ContestScreenState extends State<ContestScreen> {
  late ContestBloc _contestBloc;
  @override
  void didChangeDependencies() {
    _contestBloc = BlocProvider.of<ContestBloc>(context);
    _contestBloc.contestEventSink.add(FetchContest());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.lightGreen,
                title: Center(
                  child: Text(
                    "Contests",
                    style: TextStyle(color: Colors.black),
                  ),
                ),

//

                bottom: TabBar(
                    /*     unselectedLabelColor: Colors.black,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.grey[300]
        ),*/
                    tabs: [
                      Tab(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Global",
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
                              "Personal",
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
                                "All Contests",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 16.0),
                              ))),
                    ])),
            body: TabBarView(children: [
              PublicContest(
                userData: widget.user != null ? widget.user : null,
              ),
              PrivateContest(
                userData: widget.user != null ? widget.user : null,
              ),
              ContestHome(
                user: widget.user,
              ),
            ])));
  }
}
