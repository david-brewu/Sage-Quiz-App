
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:gamie/Providers/authUserProvider.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/reuseable/components.dart';
import 'package:gamie/screens/competition/competitionScreen.dart';
import 'package:gamie/screens/competition/enrolledCompetions.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../../models/enrolment_data_model.dart';
import '../../models/competition_data_model.dart';
import '../../Providers/network_provider.dart';


class CompetitionStartConfirmation extends StatelessWidget {
  final EnrolmentDataModel dataModel;
  CompetitionStartConfirmation(this.dataModel);

  void _unEnrollUser(context){
    FirebaseFirestore.instance.collection("enrolments").doc(dataModel.id).delete();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
   
    final Size deviceSize= MediaQuery.of(context).size;
    final networkProvider = Provider.of<NetworkProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed:()=>Navigator.of(context).pop()),
        title: Text(
          "${dataModel.title}",
          style: APP_BAR_TEXTSTYLE,
        ),
        backgroundColor: APP_BAR_COLOR,
      ),
      body: Container(
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      CountdownTimer(
                        endTime: dataModel.end.millisecondsSinceEpoch,
                        onEnd: (){
                          _unEnrollUser(context);
                        },
                        widgetBuilder: (_, time){
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TimeBlock(main: time.days??0, subText: "days",),
                              TimeBlock(main: time.hours??0, subText: "Hrs",),
                              TimeBlock(main: time.min??0, subText: "mins",),
                              TimeBlock(main: time.sec??0, subText: "sec",),
                            ],);
                        },),
                      Text("Till competition Closes", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),),
                    ],
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "Opened on:\t ", style: LABEL_TEXT_STYLE_MEDIUM_BLACK),
                    TextSpan(text: "${dataModel.formatStart()}\n", style: LABEL_TEXT_STYLE),
                    TextSpan(text: "\nCloses on:\t", style: LABEL_TEXT_STYLE_MEDIUM_BLACK),
                    TextSpan(text: "${dataModel.formatEnd()}\n", style: LABEL_TEXT_STYLE),
                    TextSpan(text: "\nMax duration:\t", style: LABEL_TEXT_STYLE_MEDIUM_BLACK),
                    TextSpan(text: "${dataModel.duration.inMinutes} minutes\n", style: LABEL_TEXT_STYLE),
                    TextSpan(text: "\nNumber of Questions:\t", style: LABEL_TEXT_STYLE_MEDIUM_BLACK),
                    TextSpan(text: "${dataModel.numberOfQuestions} \n", style: LABEL_TEXT_STYLE),
                  ])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:18.0),
                    child: CustomRoundedButton(
                        height: 70,
                        radius: 20.0,
                        color: LIGHT_BLUE_BUTTON_COLOR,
                        textColor: Colors.white,
                        onTap: (){
                          showCupertinoDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (_) =>CupertinoAlertDialog(
                                  title: Text("Start Competition?"),
                                actions: [
                                   FlatButton(onPressed: (){
                                          //pops the dialog before navigating
                                          Navigator.pop(context);
                                          if(!networkProvider.connectionStatus){
                                            Toast.show('Please connect to internet to proceed', context,duration: Toast.LENGTH_SHORT);
                                            return;
                                          }
                                          FirebaseFirestore.instance.collection("competitions").doc(dataModel.competitionId).get().then((doc){
                                          final data = CompetitionDataModel.fromMap(doc,0);
                                          if(data.documents.length>0){
                                            User user = Provider.of<UserAuthProvider>(context, listen: false).authUser;
                                            Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (_)=>CompetitionScreen(dataModel: data,user:  user)));
                                          }

                                        }).catchError((err){
                                          print(err);
                                        }).timeout(
                                          Duration(seconds: 30),
                                          onTimeout: (){
                                            
                                          }
                                        );
                                  },
                                        child: Text("Go", style: TextStyle(fontSize: 22),),)],
                                content: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                                  child: Text("\nReady to compete? tap go!\n\nElse tap anywhere outside", style:TextStyle(fontSize: 15),),
                                ),
                              ),);
                        },
                        text: "Start competition",

                        ),
                  )]),
                   ),
            );
  }
}

