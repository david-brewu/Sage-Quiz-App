import 'package:flutter/material.dart';
import 'package:gamie/reuseable/terms_template.dart';

// ignore: must_be_immutable
class PrivacyScreen extends StatelessWidget {
  static String routeName = "prvacyRoute";
  String _data = '''
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur interdum leo a tempus feugiat. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec et interdum purus. In hac habitasse platea dictumst. Morbi tempus vulputate velit. Cras dignissim tristique ultricies. Nunc elementum erat erat, sed bibendum orci consequat in. Aliquam bibendum nulla ac magna vehicula, sit amet tristique ligula lacinia.

Duis non pulvinar libero, ac porta turpis. Aenean accumsan sem vel auctor rutrum. Morbi efficitur, lacus id hendrerit malesuada, ante nunc rutrum quam, id ultrices nisi ante quis quam. Morbi laoreet lorem eget orci egestas, in semper lacus egestas. Nullam quis purus eget leo malesuada pulvinar vel nec diam. Quisque at magna dolor. Ut imperdiet libero at massa egestas bibendum. Morbi feugiat sapien ex, et ultricies nisl aliquet et. Pellentesque velit nulla, tincidunt hendrerit rutrum nec, elementum non nulla. Quisque vehicula auctor magna, eget viverra mi porttitor a. Aliquam erat volutpat. Nulla facilisi. Curabitur bibendum semper sem facilisis bibendum.

Donec massa nisi, faucibus faucibus rutrum id, posuere sed nunc. Sed at orci ac arcu gravida gravida. Donec aliquet diam in arcu accumsan, vitae porttitor massa iaculis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin ornare suscipit mi, sed porta est ullamcorper fermentum. Nam mollis lacus sed lobortis egestas. Etiam consectetur fringilla pharetra. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Duis ultrices blandit molestie. Morbi a est pharetra, accumsan lacus non, ultricies augue. Sed sagittis eros a urna placerat, eget ornare est congue. Maecenas convallis finibus eleifend. Sed eleifend, sem vel viverra posuere, lacus orci scelerisque leo, et posuere lacus nunc id augue.

Nam vitae dignissim magna. Nulla congue bibendum mauris, vel tincidunt nisl pharetra vitae. Pellentesque sed ipsum non odio auctor sollicitudin. Cras sagittis euismod nisl eget commodo. Praesent hendrerit, justo sit amet porta vehicula, sem nibh eleifend nunc, sed ultrices leo orci id purus. Nullam ut urna augue. Aliquam sed dignissim metus, id condimentum enim. Pellentesque eget urna eu lacus sagittis ultricies non vitae eros.

Phasellus risus augue, lacinia non vulputate sed, molestie a nibh. Etiam in semper ex. Mauris maximus quis turpis vitae pellentesque. Integer dapibus turpis sit amet nisi dictum imperdiet. Morbi pretium feugiat orci accumsan euismod. Nulla consequat enim eget libero ornare, ac laoreet neque suscipit. Morbi neque turpis, ultrices id vehicula eget, posuere scelerisque lectus.
  ''';
  String _title = "Privacy";
  @override
  Widget build(BuildContext context) {
    return TermsTemplate(
      title: _title,
      data: _data,
    );
  }
}
