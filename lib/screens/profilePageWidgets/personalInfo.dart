import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamie/Providers/authUserProvider.dart';
import 'package:gamie/Providers/network_provider.dart';
import 'package:gamie/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:gamie/models/user_model.dart';
import 'package:gamie/reuseable/drawer.dart';
import 'package:gamie/reuseable/empty_items.dart';
import 'package:gamie/reuseable/network_error_widget.dart';
import 'package:gamie/reuseable/no_connectivity_widget.dart';
import 'package:gamie/services/cloud_firestore_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_validator/the_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

// ignore: must_be_immutable
class PersonalInfo extends StatefulWidget {
  static String routeName = "profile_Info";

  final GlobalKey<FormState> formKey;
  final String docID;

  PersonalInfo({
    @required this.formKey,
    this.docID,
  });

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserAuthProvider>(context).authUser ??
        FirebaseAuth.instance.currentUser;
    final networkProvider = Provider.of<NetworkProvider>(context);
    return SafeArea(
      child: Scaffold(
          body: networkProvider.connectionStatus
              ? userStream(user.uid, widget.formKey, widget.docID)
              : Center(child: NoConnectivityWidget())),
    );
  }
}

Widget userStream(String id, GlobalKey<FormState> formKey, String docID) {
  return StreamBuilder(
      stream: CloudFirestoreServices.userStream(id),
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
          List<DocumentSnapshot> data = snapshot.data.docs;
          print(data.length);
          print(data.toString());

          if (data.length == 0)
            return Center(
              child: EmptyWidget(
                msg: 'No profile available',
              ),
            );
          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ProfileBuilder(
                  model: UserDataModel.fromMap(data[index], index),
                  formKey: formKey,
                  docID: docID,
                );
              });
        } else
          return Text('has not data');
      });
}

class ProfileBuilder extends StatefulWidget {
  final UserDataModel model;
  final GlobalKey<FormState> formKey;
  final String docID;
  const ProfileBuilder(
      {Key key,
      @required this.model,
      @required this.formKey,
      @required this.docID})
      : super(key: key);

  @override
  _ProfileBuilderState createState() => _ProfileBuilderState();
}

class _ProfileBuilderState extends State<ProfileBuilder>
    with SingleTickerProviderStateMixin {
  TextEditingController _emailController;
  TextEditingController _phoneController;
  TextEditingController _addressController;
  TextEditingController _schoolController;
  String addre = '';
  String phoneNumber = '';
  String emailAdd = '';
  String school = '';
  bool _isbusy;
  final picker = ImagePicker();
  File _imageFile;
  bool isPicked;
  Widget snackBar(IconData icondata, String text, Color color, int sec) {
    return SnackBar(
      duration: Duration(seconds: sec),
      content: Row(
        children: <Widget>[
          Icon(
            icondata,
            color: color,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  SharedPreferences prefs;

  bool editProfile;
  User user;
  TabController _tabController;
  List<Tab> _tabs = [
    Tab(
      text: "Personal Info",
    ),
  ];

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
      isPicked = true;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  void updateProfileSections() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = await jsonDecode(
      prefs.get(PREFS_PERSONAL_INFO),
    );
    data["phone_number"] = _phoneController;

    data["email_address"] = _emailController;
    data['address'] = _addressController;
    data['school'] = _schoolController;
    await user.updateEmail(_emailController.toString());
  }

  void _updateInfo(BuildContext context1) async {
    if (widget.formKey.currentState.validate()) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.docID)
          .update({'phone_number': _phoneController.text});
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.docID)
          .update({'email_address': _emailController.text});
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.docID)
          .update({'address': _addressController.text});
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.docID)
          .update({'school': _schoolController.text});
      FirebaseAuth.instance.currentUser.updateEmail(_emailController.text);

      ScaffoldMessenger.of(context1).showSnackBar(SnackBar(
        backgroundColor: Colors.black,
        duration: Duration(seconds: 2),
        content: Row(
          children: <Widget>[
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Profile Updated successfully",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ));
      setState(() {
        editProfile = false;
      });
      return;
    }
    ScaffoldMessenger.of(context1).showSnackBar(snackBar(
        Icons.warning, 'Please fill all the required fields', Colors.red, 3));
  }

  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this);
    isPicked = false;
    editProfile = false;
    _isbusy = false;

    _emailController = TextEditingController(text: widget.model.email);
    _phoneController = TextEditingController(text: widget.model.phoneNumber);
    _addressController = TextEditingController(text: widget.model.address);
    _schoolController = TextEditingController(text: widget.model.school);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Visibility(
        maintainSize: false,
        maintainAnimation: false,
        maintainState: false,
        visible: _isbusy == true,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingBouncingGrid.square(
                size: MediaQuery.of(context).size.width / 4,
                borderSize: MediaQuery.of(context).size.width / 8,
              ),
              Text(
                "Uploading your photo.\nPlease hold a sec",
                style: NORMAL_HEADER,
              )
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: SizedBox(
          height: 10,
        ),
      ),
      FirebaseAuth.instance.currentUser.photoURL == null &&
              widget.model.photoURL == ''
          ? Container(
              clipBehavior: Clip.antiAlias,
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: APP_BAR_COLOR.withOpacity(0.6),
                      offset: Offset(0, 3),
                      blurRadius: 10,
                      spreadRadius: 0.5)
                ],
                borderRadius: BorderRadius.circular(200),
                border: Border.all(color: Colors.white, width: 5),
              ),
              child: Image.asset(
                DEFAULT_USER_AVATAR,
                fit: BoxFit.cover,
              ),
            )
          : FirebaseAuth.instance.currentUser.photoURL == null
              ? CircleAvatar(
                  radius: 120,
                  backgroundImage: CachedNetworkImageProvider(
                    widget.model.photoURL,
                  ))
              : CircleAvatar(
                  radius: 120,
                  backgroundImage: CachedNetworkImageProvider(
                    FirebaseAuth.instance.currentUser.photoURL,
                  ),
                ),
      isPicked
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    iconSize: 30,
                    onPressed: () async {
                      setState(() {
                        _isbusy = true;
                      });

                      await uploadImageToFirebase(context, widget.docID);
                    },
                    icon: Icon(
                      Icons.upload,
                      color: Colors.green,
                    )),
                IconButton(
                    iconSize: 30,
                    onPressed: () {
                      setState(() {
                        _imageFile.delete();
                        isPicked = false;
                        ScaffoldMessenger.of(context).showSnackBar(snackBar(
                            Icons.cancel, 'Upload cancelled', Colors.red, 4));
                      });
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ))
              ],
            )
          : IconButton(
              onPressed: () async {
                await pickImage();
              },
              icon: Icon(Icons.add_a_photo),
              iconSize: 30,
            ),
      SizedBox(
        width: 80,
      ),
      SizedBox(
        height: 20,
      ),
      Text(
        widget.model.fullName != null ? widget.model.fullName : "",
        style: LABEL_TEXT_STYLE_MEDIUM_BLACK,
      ),
      Text(
        widget.model.email == null ? '' : widget.model.email,
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
      Container(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  emailAdd = value;
                  if (!Validator.isEmail(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
                style: MEDIUM_DISABLED_TEXT,
                controller: _emailController,
                enabled: editProfile,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  icon: Text(
                    "EMAIL: ",
                    style: LABEL_TEXT_STYLE,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                textAlign: TextAlign.center,
                validator: (value) {
                  phoneNumber = value;
                  if (value.length < 10) {
                    return "Enter a valid phone number";
                  }
                  return null;
                },
                style: MEDIUM_DISABLED_TEXT,
                controller: _phoneController,
                enabled: editProfile,
                decoration: InputDecoration(
                    icon: Text(
                  "PHONE: ",
                  style: LABEL_TEXT_STYLE,
                )),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                style: MEDIUM_DISABLED_TEXT,
                controller: _schoolController,
                enabled: editProfile,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    icon: Text(
                  "SCHOOL: ",
                  style: LABEL_TEXT_STYLE,
                )),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                style: MEDIUM_DISABLED_TEXT,
                controller: _addressController,
                enabled: editProfile,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    icon: Text(
                  "ADDRESS: ",
                  style: LABEL_TEXT_STYLE,
                )),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // ignore: deprecated_member_use
                  editProfile
                      ? FlatButton(
                          disabledColor: Colors.green.withOpacity(0.5),
                          color: Colors.green,
                          child: Text("UPDATE INFO",
                              style: NORMAL_WHITE_BUTTON_LABEL),
                          onPressed: () {
                            _updateInfo(context);
                            setState(() {});
                          },
                        )
                      : SizedBox.shrink(),

                  editProfile
                      ? FlatButton(
                          disabledColor: Colors.red.withOpacity(0.5),
                          color: Colors.red,
                          child:
                              Text('CANCEL', style: NORMAL_WHITE_BUTTON_LABEL),
                          onPressed: () {
                            setState(() {
                              _emailController.text = widget.model.email;
                              _phoneController.text = widget.model.phoneNumber;
                              _addressController.text = widget.model.address;
                              editProfile = false;
                            });
                          },
                        )
                      : FlatButton(
                          disabledColor: Colors.red.withOpacity(0.5),
                          color: APP_BAR_COLOR,
                          child: Text("Edit Info",
                              style: NORMAL_WHITE_BUTTON_LABEL),
                          onPressed: () {
                            setState(() {
                              editProfile = true;
                            });
                          },
                        ),
                ],
              )
            ],
          ),
        ),
      ))
    ]));
  }

  Future uploadImageToFirebase(BuildContext context, String docID) async {
    String fileName = basename(_imageFile.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profile_pics/$fileName');

    UploadTask uploadTask = firebaseStorageRef
        .putFile(_imageFile)
        .whenComplete(() async {
          String url = await FirebaseStorage.instance
              .ref('profile_pics/$fileName')
              .getDownloadURL();
          FirebaseAuth.instance.currentUser.updateProfile(photoURL: url);

          FirebaseFirestore.instance
              .collection('user')
              .doc(docID)
              .update({'photURL': url});
          print(url);

          setState(() {
            _isbusy = false;
            _imageFile.delete();
            isPicked = false;
            editProfile = false;
          });
        })
        .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(snackBar(
            Icons.done,
            'Upload successfull, image will be visible on next visit',
            Colors.green,
            10)))
        .whenComplete(
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => PersonalInfo(
                      formKey: GlobalKey<FormState>(),
                      docID: mydocID,
                    ))));
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => PersonalInfo(
              formKey: GlobalKey<FormState>(),
              docID: mydocID,
            )));
  }
}
