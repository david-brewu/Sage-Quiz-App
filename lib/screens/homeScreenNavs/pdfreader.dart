import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:gamie/config/config.dart';

class PDFReader extends StatefulWidget {
  final Reference reference;
  PDFReader(this.reference);
  @override
  _PDFReaderState createState() => _PDFReaderState();
}

class _PDFReaderState extends State<PDFReader> {
  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  Future<String> url() async {
    String urlstring = await widget.reference.getDownloadURL();
    return urlstring.toString();
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
          backgroundColor: APP_BAR_COLOR,
          centerTitle: true,
          title: Text(
            widget.reference.name,
            style: APP_BAR_TEXTSTYLE,
          ),
        ),
        body: Center(
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
