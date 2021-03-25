import 'dart:io';
import 'package:image/image.dart' as Img;


Future<String> saveImageToDisk(String pathToImage, String pathToSave)async{
  try{
    Img.Image tempImgFile = Img.decodeImage(File(pathToImage).readAsBytesSync());
    File destinationFileReference = File(pathToSave);
    destinationFileReference.writeAsBytesSync(Img.encodePng(tempImgFile));
    return pathToSave;

  }catch(err) {
    print("\n\nSaving Error: ${err.toString()}\n\n");
    return null;
  }
}
