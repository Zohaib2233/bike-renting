import 'dart:async';
import 'dart:developer';

import 'package:bike_gps/core/constants/firebase_collection_references.dart';
import 'package:bike_gps/core/constants/instances_constants.dart';
import 'package:bike_gps/models/post_model/user_fav_post_model.dart';
import 'package:bike_gps/models/user_models/user_model.dart';
import 'package:bike_gps/services/firebase/firebase_crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void getUserDataStream({required String userId}) async {
  //getting user id
  String userId = FirebaseAuth.instance.currentUser!.uid;

  //getting user fav posts (to use it throughout the app)
  var userFavPostDoc = await FirebaseCRUDService.instance.readSingleDocument(
    collectionReference: userFavPostsCollection,
    docId: userId,
  );

  //initializing userFavPostModelGlobal
  if (userFavPostDoc != null) {
    userFavPostModelGlobal.value = UserFavPostModel.fromJson(userFavPostDoc);
  }

  //getting user's data stream
  StreamSubscription<DocumentSnapshot<Object?>> userDataStream =
      FirebaseCRUDService.instance
          .getSingleDocStream(
              collectionReference: usersCollection, docId: userId)
          .listen((DocumentSnapshot<Object?> event) {
    userModelGlobal.value = UserModel.fromJson(event);

    log("Full name from model is: ${userModelGlobal.value.fullName}");
  });

  //you can cancel the stream if you wanna do
  // userDataStream.cancel();
}
