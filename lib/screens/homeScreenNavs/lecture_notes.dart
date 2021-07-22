import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamie/Providers/network_provider.dart';
import 'package:gamie/config/config.dart';
import 'package:gamie/reuseable/empty_items.dart';
import 'package:gamie/reuseable/network_error_widget.dart';
import 'package:gamie/reuseable/no_connectivity_widget.dart';
import 'package:gamie/screens/homeScreenNavs/pdfreader.dart';
import 'package:gamie/screens/homeScreenNavs/v_player.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../models/course_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

_LectureNotesState _lectureNotes;

class LectureNotes extends StatefulWidget {
  final String courseName;
  final String materialType;
  final String semester;
  //final String title;
  final String imagePath;
  LectureNotes(
      {this.courseName, this.materialType, this.semester, this.imagePath});
  @override
  _LectureNotesState createState() {
    _lectureNotes = _LectureNotesState();
    return _lectureNotes;
  }
}

List<Reference> data;

class _LectureNotesState extends State<LectureNotes> {
  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);

    return SafeArea(
        child: Scaffold(
      body: networkProvider.connectionStatus
          ? buildLectureNotesList()
          : Center(child: NoConnectivityWidget()),
    ));
  }

  Widget buildLectureNotesList() {
    Future<List<Reference>> slideList =
        listExample(widget.courseName, widget.semester, widget.materialType);
    return StreamBuilder(
        stream: slideList.asStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: Colors.white,
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
            data = snapshot.data;

            bool con = data.isEmpty;
            if (con)
              return Center(
                child: EmptyWidget(
                  msg:
                      'The material you are looking for is not here. Please check back later',
                ),
              );
            if (data.length == 0)
              return Center(
                child: EmptyWidget(
                  msg:
                      'The material you are looking for is not here. Please check back later',
                ),
              );
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return BuildReferenceList(data[index], widget.imagePath);
                });
          } else
            return Text(
                'The material you are looking for is not here. Please check back later');
        });
  }
}

Future<List<Reference>> listExample(
    String courseName, semester, materialType) async {
  ListResult result = await FirebaseStorage.instance
      .ref(courseName + '/' + semester + '/' + materialType)
      .listAll();
  return result.items;
}

class BuildReferenceList extends StatelessWidget {
  //final CourseModel dataModel;
  final Reference reference;
  final String imagePath;

  BuildReferenceList(this.reference, this.imagePath);

  Future url() async {
    String result = await reference.getDownloadURL();
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    print(url().toString());
    print(reference.fullPath);
    return Column(
      children: [
        ListTile(
          minVerticalPadding: 25,
          title: Text(reference.name,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          leading: Image.asset(
            imagePath,
            scale: 6,
          ),
          onTap: () async {
            String path = await loadReference();
            print(path);
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        reference.fullPath.contains('lecture_videos')
                            ? VideoScreen(
                                path: path,
                              )
                            : PDFReader(reference)));
          },
        ),
      ],
    );
  }

  loadReference() async {
    String referencePath = await reference.getDownloadURL();
    return referencePath;
  }
}
