import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:gamie/config/config.dart';

import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../../models/results_data_model.dart';
import '../../services/cloud_firestore_services.dart';
import '../../Providers/authUserProvider.dart';
import '../../Providers/network_provider.dart';
import '../../reuseable/no_connectivity_widget.dart';
import '../../reuseable/empty_items.dart';
import '../../reuseable/network_error_widget.dart';
import '../../screens/competition/ScoreBoard.dart';
import '../../screens/homeScreen.dart';

class ShowAnswer extends StatelessWidget {
  final String comID;
  ShowAnswer(this.comID);
  //final Size deviceSize = MediaQuery.of(context).size;
  //var b;

  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);
    User user = Provider.of<UserAuthProvider>(context).authUser ??
        FirebaseAuth.instance.currentUser;
    return WillPopScope(
      onWillPop: () => Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (context) => HomeScreen())),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            RaisedButton(
              padding: EdgeInsets.only(top: 5),
              color: Colors.black,
              onPressed: () => Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(builder: (context) => ScoreBoard(comID, ))),
              child: Text('Go to rankings',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            )
          ],
          backgroundColor: Colors.white,
          title: Text('',
              style: TextStyle(
                color: Colors.black,
              )),
          leading: IconButton(
            iconSize: 18.0,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 25,
            ),
            onPressed: () => Navigator.of(context).pushReplacement(
                CupertinoPageRoute(builder: (context) => HomeScreen())),
          ),
          bottom: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(color: Colors.red),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        '=' + '    ' + 'your wrong answers',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(color: Colors.blue),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        '=' + '    ' + 'your correct answers',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        child: Icon(
                          Icons.check_box,
                          color: Colors.black,
                          size: 25,
                        ),
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        '=' + '    ' + 'correct answers',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            preferredSize: Size(MediaQuery.of(context).size.width, 75),
          ),
        ),
        body: SafeArea(
          child: Scaffold(
              body: networkProvider.connectionStatus
                  ? competionStream(user, comID)
                  : Center(child: NoConnectivityWidget())),
        ),
      ),
    );
  }
}

Widget competionStream(User user, String comID) {
  return StreamBuilder(
    stream: CloudFirestoreServices.getCorrectAnswers(user, comID),
    // ignore: missing_return
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else if (snapshot.hasError) {
        return Scaffold(
          body: Center(
            child: NetworkErrorWidget(),
          ),
        );
      }
      if (snapshot.hasData) {
        List<DocumentSnapshot> data1 = snapshot.data.docs;
        if (data1 != null) {
          try {
            var b = ResultDataModel.fromMap(data1[0]);
            List data = b.documents;
            List response = b.userResponse;

            print(data.length);
            print(data.toString());

            if (data.length == 0)
              return Center(
                child: EmptyWidget(
                  msg: 'The exam is not yet closed, kindly check back later',
                ),
              );
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        right: 10, left: 10, top: 12, bottom: 8),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(4),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: APP_BAR_COLOR,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(1, 3),
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                      color: Colors.black.withOpacity(0.2))
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  (index + 1).toString() + '.',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    data[index]['question'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(2),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: 0 == response[index] &&
                                        data[index]['alternatives'][0]
                                                .toString() ==
                                            data[index]['answer'].toString()
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black, width: 1.5)),
                            child: Row(
                              children: [
                                Text(
                                  'A',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: 0 == response[index] &&
                                              data[index]['alternatives'][0]
                                                      .toString() !=
                                                  data[index]['answer']
                                                      .toString()
                                          ? Colors.red
                                          : Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Text(
                                    data[index]['alternatives'][0],
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: 0 == response[index] &&
                                                data[index]['alternatives'][0]
                                                        .toString() !=
                                                    data[index]['answer']
                                                        .toString()
                                            ? Colors.red
                                            : Colors.black,
                                        fontWeight: 0 == response[index]
                                            ? FontWeight.bold
                                            : null),
                                  ),
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  icon: data[index]['alternatives'][0]
                                              .toString() ==
                                          data[index]['answer'].toString()
                                      ? Icon(
                                          Icons.check_box,
                                          color: Colors.black,
                                          size: 30,
                                        )
                                      : Icon(
                                          Icons.ac_unit,
                                          color: Colors.white70,
                                          size: 0.01,
                                        ),
                                  onPressed: null,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: EdgeInsets.all(2),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: 1 == response[index] &&
                                        data[index]['alternatives'][1]
                                                .toString() ==
                                            data[index]['answer'].toString()
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black, width: 1.5)),
                            child: Row(
                              children: [
                                Text(
                                  'B',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: 1 == response[index] &&
                                              data[index]['alternatives'][1]
                                                      .toString() !=
                                                  data[index]['answer']
                                                      .toString()
                                          ? Colors.red
                                          : Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Text(
                                    data[index]['alternatives'][1],
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: 1 == response[index] &&
                                                data[index]['alternatives'][1]
                                                        .toString() !=
                                                    data[index]['answer']
                                                        .toString()
                                            ? Colors.red
                                            : Colors.black,
                                        fontWeight: 1 == response[index]
                                            ? FontWeight.bold
                                            : null),
                                  ),
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  icon: data[index]['alternatives'][1]
                                              .toString() ==
                                          data[index]['answer'].toString()
                                      ? Icon(
                                          Icons.check_box,
                                          color: Colors.black,
                                          size: 30,
                                        )
                                      : Icon(
                                          Icons.ac_unit,
                                          color: Colors.white70,
                                          size: 0.01,
                                        ),
                                  onPressed: null,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: EdgeInsets.all(2),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: 2 == response[index] &&
                                        data[index]['alternatives'][2]
                                                .toString() ==
                                            data[index]['answer'].toString()
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black, width: 1.5)),
                            child: Row(
                              children: [
                                Text(
                                  'C',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: 2 == response[index] &&
                                              data[index]['alternatives'][2]
                                                      .toString() !=
                                                  data[index]['answer']
                                                      .toString()
                                          ? Colors.red
                                          : Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Text(
                                    data[index]['alternatives'][2],
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: 2 == response[index] &&
                                                data[index]['alternatives'][2]
                                                        .toString() !=
                                                    data[index]['answer']
                                                        .toString()
                                            ? Colors.red
                                            : Colors.black,
                                        fontWeight: 2 == response[index]
                                            ? FontWeight.bold
                                            : null),
                                  ),
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  icon: data[index]['alternatives'][2]
                                              .toString() ==
                                          data[index]['answer'].toString()
                                      ? Icon(
                                          Icons.check_box,
                                          color: Colors.black,
                                          size: 30,
                                        )
                                      : Icon(
                                          Icons.ac_unit,
                                          color: Colors.white70,
                                          size: 0.01,
                                        ),
                                  onPressed: null,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: EdgeInsets.all(2),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: 3 == response[index] &&
                                        data[index]['alternatives'][3]
                                                .toString() ==
                                            data[index]['answer'].toString()
                                    ? Colors.blue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black, width: 1.5)),
                            child: Row(
                              children: [
                                Text(
                                  'D',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: 3 == response[index] &&
                                              data[index]['alternatives'][3]
                                                      .toString() !=
                                                  data[index]['answer']
                                                      .toString()
                                          ? Colors.red
                                          : Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Text(
                                    data[index]['alternatives'][3],
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: 3 == response[index] &&
                                                data[index]['alternatives'][3]
                                                        .toString() !=
                                                    data[index]['answer']
                                                        .toString()
                                            ? Colors.red
                                            : Colors.black,
                                        fontWeight: 3 == response[index]
                                            ? FontWeight.bold
                                            : null),
                                  ),
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  icon: data[index]['alternatives'][3]
                                              .toString() ==
                                          data[index]['answer'].toString()
                                      ? Icon(
                                          Icons.check_box,
                                          color: Colors.black,
                                          size: 30,
                                        )
                                      : Icon(
                                          Icons.ac_unit,
                                          color: Colors.white70,
                                          size: 0.01,
                                        ),
                                  onPressed: null,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 3,
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ));
                });
          } catch (e) {
            return Center(
                child: Text(
              'Competition is not yet closed. Kindly check back later',
              style: DISABLED_TEXT,
              textAlign: TextAlign.center,
            ));
          }
        } else
          return Center(
              child: Text(
            'Competition is not yet closed. Kindly check back later',
            style: DISABLED_TEXT,
            textAlign: TextAlign.center,
          ));
      }
    },
  );
}
