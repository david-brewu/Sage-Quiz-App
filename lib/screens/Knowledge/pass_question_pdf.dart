import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:gamie/config/config.dart';

_PDFDocState state;

class PDFDoc extends StatefulWidget {
  final String course;
  final String year;

  PDFDoc(this.course, this.year);
  @override
  _PDFDocState createState() => _PDFDocState();
}

class _PDFDocState extends State<PDFDoc> {
  bool _isLoading = true;
  PDFDocument document;
  bool error = false;
  //final Reference reference =  FirebaseStorage.instance
  //    .ref('pass_questions/' widget.course + '/' + materialType)

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  Reference reference() {
    Reference reference = FirebaseStorage.instance.ref('pass_questions/' +
        widget.course +
        '/' +
        widget.year +
        '/' +
        widget.course +
        '_' +
        widget.year +
        '.pdf');
    return reference;
  }

  Future<String> url() async {
    try {
      String urlstring = await reference().getDownloadURL();
      return urlstring.toString();
    } catch (e) {
      setState(() {
        error = true;
      });
    }
    return null;
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(await url());

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 30,
              )),
          backgroundColor: APP_BAR_COLOR,
          centerTitle: true,
          title: Text(
            reference().name,
            style: APP_BAR_TEXTSTYLE,
          ),
        ),
        body: error
            ? Center(
                child: Text(
                'Document not found',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
              ))
            : Center(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : PDFViewer(
                        document: document,
                        zoomSteps: 1,
                        lazyLoad: false,
                        scrollDirection: Axis.vertical,
                      ),
              ),
      ),
    );
  }
}
