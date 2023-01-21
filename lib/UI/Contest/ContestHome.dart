import 'package:doodler/Bloc/ContestBloc.dart';
import 'package:doodler/Bloc/ContestEvent.dart';
import 'package:doodler/Model/User.dart';
import 'package:doodler/Model/contest.dart';
import 'package:doodler/UI/Contest/ContestDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class ContestHome extends StatefulWidget {
  final User? user;

  ContestHome({this.user});
  @override
  _PublicPostState createState() => _PublicPostState();
}

class _PublicPostState extends State<ContestHome> {
  @override
  void didChangeDependencies() {
    ContestBloc _contestBloc = BlocProvider.of<ContestBloc>(context);
    _contestBloc.contestEventSink.add(GetContest());
    super.didChangeDependencies();
  }

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ContestBloc _contestBloc = BlocProvider.of<ContestBloc>(context);
    return Container(
      padding: EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<List<Contest>?>(
        stream: _contestBloc.allContestStream,
        initialData: _contestBloc.allContest,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            } else {
              return Scrollbar(
                child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      if (snapshot.data![i].status == "active") {
                        return Container(
                            padding: EdgeInsets.only(bottom: 15.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: Colors.greenAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  Icons.event,
                                  color: Colors.black,
                                  size: 30.0,
                                ),
                                title: Text(
                                  "${snapshot.data![i].title}",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ContestDetails(
                                                contest: snapshot.data![i],
                                                user: widget.user,
                                              )));
                                },
                              ),
                            ));
                      } else {
                        return Container();
                      }
                    }),
              );
            }
          } else {
            return Container(
              child: Center(
                child: Text(
                  "Contest will be held soon!!",
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
