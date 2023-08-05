import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

/// ユーザIDの取得

getStorageData(String path) {
  final storageRef = FirebaseStorage.instance.ref();
  final pathReference =
      storageRef.child('startover/a4980de2fc4cc47eb40dc690ed5c9.jpg');
  // final fullPath = storageRef.fullPath;
// Create a reference with an initial file path and name
  // final pathReference =
  //     storageRef.child("images/a4980de2fc4cc47eb40dc690ed5c9.jpg");
  final gsReference = FirebaseStorage.instance.refFromURL(
      "gs://musicapp-414a8.appspot.com/" + pathReference.toString());
  final httpsReference = FirebaseStorage.instance.refFromURL(
      'https://firebasestorage.googleapis.com/b/musicapp-414a8.appspot.com/o/startover%20a4980de2fc4cc47eb40dc690ed5c9.jpg');
  print(httpsReference);
  // try {
  //   final listResult = await storageRef.listAll();
  //   listResult.items.forEach((itemRef) {
  //     // Do something with each item reference
  //     final StorageReference ref = itemRef.fullPath;
  //     String
  //   });
  // } catch (e) {
  //   print(e);
  // }
}
