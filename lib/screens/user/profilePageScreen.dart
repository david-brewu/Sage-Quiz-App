/* import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/Providers/authUserProvider.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/screens/profilePageWidgets/activities.dart';
import 'package:gamie/screens/profilePageWidgets/personalInfo.dart';
import 'package:provider/provider.dart';

import '../../Providers/edit_profile_provider.dart';

class ProfilePage extends StatefulWidget {
  static String routeName = "profile_page";

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String imagePath;
  String phone = "0545555777";

  TabController _tabController;
  List<Tab> _tabs = [
    Tab(
      text: "Personal Info",
    ),
    //  Tab(text: "Activities")
  ];

  List<Widget> generatetabViews() => [
        PersonalInfo(formKey: GlobalKey<FormState>()),
        //Activities(),
      ];

  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserAuthProvider>(context).authUser;
    print(user.displayName);
    print(user.email);
    print(user.phoneNumber);
    final edit = Provider.of<EditProfileProvider>(context);
    String name = user.displayName;
    String email = user.email;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          color: APP_BAR_COLOR,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: SizedBox(
                      height: 150,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40)),
                          color: Colors.white),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                name == null ? '' : name,
                                style: LABEL_TEXT_STYLE_MEDIUM_BLACK,
                              ),
                              Text(
                                email,
                                style: SMALL_DISABLED_TEXT,
                              ),
                              SizedBox(height: 10),
                              TabBar(
                                unselectedLabelColor: Colors.black45,
                                labelColor: Colors.black,
                                labelStyle: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal),
                                indicatorWeight: 3,
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorColor: APP_BAR_COLOR,
                                controller: _tabController,
                                tabs: _tabs,
                              ),
                              Divider(
                                height: 0,
                                color: Colors.black54,
                              ),
                              Expanded(
                                child: TabBarView(
                                    controller: _tabController,
                                    children: generatetabViews()),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 4,
                top: MediaQuery.of(context).size.height / 50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: APP_BAR_COLOR.withOpacity(0.6),
                          offset: Offset(0, 3),
                          blurRadius: 10,
                          spreadRadius: 0.5)
                    ],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: APP_BAR_COLOR, width: 5),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        child: user.photoURL != null
                            ? CachedNetworkImage(
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                imageUrl: user.photoURL,
                                fit: BoxFit.contain)
                            : Image.asset(
                                DEFAULT_USER_AVATAR,
                                fit: BoxFit.cover,
                              ),
                      )),
                ),
              ),
              Positioned(
                right: 40,
                top: MediaQuery.of(context).size.height * (1 / 3.2),
                child: InkWell(
                  onTap: () => edit.edit = true,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.05),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: APP_BAR_COLOR,
                      size: 30,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
 */