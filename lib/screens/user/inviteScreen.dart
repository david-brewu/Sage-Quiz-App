import 'package:flutter/material.dart';
import 'package:gamie/config/config.dart';

class InviteScreen extends StatefulWidget {
  static String routeName = "invite_screen";
  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  final _emailForm = GlobalKey<FormState>();
  bool inviteSent = false;
  String img = "assets/images/invite-img.png";

  @override
  void initState() {
    super.initState();
  }

  _sendInvitation() {
//    ADD THE EMAIL TO INVITE COLLECTION
    return false;
  }

  void _invite(BuildContext context) async {
    // print(_emailForm.currentState);
    // return;
    if (_emailForm.currentState.validate()) {
      if (!inviteSent) {
        // hasen't sent invite
        bool sent = _sendInvitation();
        if (sent) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Row(
              children: <Widget>[
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                ),
                SizedBox(width: 5),
                Text("Invite sent!")
              ],
            ),
            duration: Duration(milliseconds: 500),
          ));
          return;
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Row(
              children: <Widget>[
                Icon(
                  Icons.cancel,
                  color: Colors.green,
                ),
                SizedBox(width: 5),
                Text("Couldn't send!")
              ],
            ),
            duration: Duration(milliseconds: 500),
          ));
        }
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Row(
            children: <Widget>[
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
              SizedBox(width: 5),
              Text("You already sent and invite to this person")
            ],
          ),
          duration: Duration(milliseconds: 1500),
        ));
      }

      //Navigate to next screen
      return;
    }

    //form not valid
    //send invite
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            Icon(
              Icons.error,
              color: Colors.red,
            ),
            SizedBox(width: 5),
            Text("Invite not sent!")
          ],
        ),
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    final Size DEVSIZE = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: APP_BAR_COLOR,
        title: Text("Invite a friend"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: DEVSIZE.height,
          child: Column(
            children: <Widget>[
              Container(
                width: DEVSIZE.width,
                height: DEVSIZE.height * 0.5,
                child: Image.asset(img, fit: BoxFit.cover),
              ),
              SizedBox(height: 5),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Form(
                  key: _emailForm,
                  child: TextFormField(
                    validator: (value) {
                      if (value.contains("@") || value.contains(".")) {
                        return null;
                      }
                      return "enter a valid email address";
                    },
                    // controller: _emailController,
                    decoration: InputDecoration(
                        hintText: "Enter your friends email address"),
                  ),
                ),
              ),
              Builder(
                  // ignore: deprecated_member_use
                  builder: (context) => FlatButton(
                      color: APP_BAR_COLOR,
                      onPressed: () => _invite(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Send Invite",
                            style: NORMAL_WHITE_BUTTON_LABEL,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 50,
                          )
                        ],
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
