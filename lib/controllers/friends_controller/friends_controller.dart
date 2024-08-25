import 'dart:async';
import 'dart:developer';

import 'package:bike_gps/constants/app_images.dart';
import 'package:bike_gps/core/constants/instances_constants.dart';
import 'package:bike_gps/core/utils/dialogs.dart';
import 'package:bike_gps/core/utils/snackbars.dart';
import 'package:bike_gps/models/friends_model/friends_model.dart';
import 'package:bike_gps/models/request_model/request_model.dart';
import 'package:bike_gps/services/firebase/firebase_crud.dart';
import 'package:bike_gps/view/widget/dialogs/permission_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/firebase_collection_references.dart';
import '../../core/utils/uuid/uuid_functions.dart';
import '../../models/user_models/user_model.dart';

class FriendsController extends GetxController {
  List phoneNumbers = [];
  var phoneNumbersSeparated = [];
  RxList<UserModel> friendsList = RxList([]);
  RxList<UserModel> requestList = RxList([]);

  //list of user friends ids
  RxList<String> friendsIds = RxList<String>();

  String normalizeAndRemove(String contact) {
    // Remove dashes, parentheses, and any non-numeric characters except '+'
    String contactWithoutSpecialChars =
        contact.replaceAll(RegExp(r'[^\d\+]'), '');

    // Check if the contact starts with a number (assume it's from the US)
    if (contactWithoutSpecialChars.startsWith(RegExp(r'[0-9]'))) {
      // Add the US country code
      contactWithoutSpecialChars = '+1$contactWithoutSpecialChars';
    }

    // Remove the country code
    String removedString = contactWithoutSpecialChars.startsWith('+')
        ? contactWithoutSpecialChars
            .substring(contactWithoutSpecialChars.indexOf(' ') + 1)
        : contactWithoutSpecialChars;

    return removedString;
  }

  String removeCountryCode(String contact) {
    // Remove any non-numeric characters
    String contactWithoutSpecialChars =
        contact.replaceAll(RegExp(r'[^\d]'), '');

    // Remove the country code
    String removedString = contactWithoutSpecialChars.startsWith('0')
        ? contactWithoutSpecialChars.substring(1) // Remove leading '0'
        : contactWithoutSpecialChars;

    return removedString;
  }

  //method to get all contacts from Device
  Future<void> getUserContacts() async {
    //list of phone numbers
    phoneNumbers = [];

    final PermissionStatus permissionStatus =
        await Permission.contacts.request();

    if (permissionStatus == PermissionStatus.denied ||
        permissionStatus == PermissionStatus.permanentlyDenied) {
      //redirecting the user to enable contacts permission
      Get.dialog(PermissionDialog(
        onAllowTap: () {
          //popping dialog
          Get.back();
          openAppSettings();
        },
        description:
            "Please allow permission to your contacts to get the users from your conatcts list",
        permission: "",
        icon: Assets.imagesLockPhone,
      ));
    }

    if (permissionStatus.isGranted) {
      // Get all contacts on device
      final contacts = await FastContacts.getAllContacts();

      //iterating all the contacts
      for (int i = 0; i < contacts.length; i++) {
        //adding phone no in the list
        for (int j = 0; j < contacts[i].phones.length; j++) {
          phoneNumbers.add(contacts[i].phones[j].number);
        }
      }

      for (String contact in phoneNumbers) {
        String removedString = normalizeAndRemove(contact);
        if (removedString != userModelGlobal.value.phoneNo) {
          phoneNumbersSeparated.add(removedString);
        }
        print('Original: $contact, Removed: $removedString');
      }

      log(phoneNumbers.toString());
      log(phoneNumbersSeparated.toString());
    } else {
      // Permission not granted, handle the situation accordingly
      CustomSnackBars.instance.showFailureSnackbar(
          title: "Permission Error",
          message: "You have not granted permission to your contacts");
    }
  }

  //method to convert phones list into chunks of 30 elements list
  List<List> chunkPhonesList<T>({required List inputList}) {
    List<List> chunks = [];
    int length = inputList.length;

    for (int i = 0; i < length; i += 30) {
      int end = i + 30;
      if (end > length) {
        end = length;
      }
      chunks.add(inputList.sublist(i, end));
    }

    return chunks;
  }

  //list of UserModels
  RxList<UserModel> knownUsers = RxList<UserModel>([]);

  //flag to check if the fetchin contacts query has been completed
  RxBool areKnownUsersFetched = false.obs;

  //method to get all the contacts accounts (the accounts that exist corresponding to a phone no)
  Future<void> getAccountsOfUserContacts() async {
    try {
      knownUsers.value = [];

      // List phones = await getUserContacts();

      List phoneChunks = chunkPhonesList(inputList: phoneNumbersSeparated);

      //giving a chunk of 30 contacts to Firebase query (limitation by Firebase)
      for (var chunk in phoneChunks) {
        print('THIS IS CHUNK ${chunk}');
        var userData =
            await usersCollection.where("phoneNo", whereIn: chunk).get();

        //adding snapshot to known users list (if there exists any)
        if (userData.docs.isNotEmpty) {
          //adding docs into users list
          for (var doc in userData.docs) {
            knownUsers.add(UserModel.fromJson(doc));
            log('THIS IS KNOWS USER ${doc.data()}');
          }
        }
      }

      //setting the flag as complete
      areKnownUsersFetched.value = true;
    } on FirebaseException catch (e) {
      log("This was the exception while getting known users: $e");
      //setting the flag as complete
      areKnownUsersFetched.value = true;
    } catch (e) {
      log("This was the exception while getting known users: $e");
      //setting the flag as complete
      areKnownUsersFetched.value = true;
    }
  }

  //Canceling a request
  deleteRequest({required requestTo}) async {
    var snapshots = await requestCollection
        .where(Filter.and(Filter('requestedTo', isEqualTo: requestTo),
            Filter('requestedFrom', isEqualTo: userModelGlobal.value.userId!)))
        .get();
    if (snapshots.docs.isNotEmpty) {
      await requestCollection.doc(snapshots.docs[0].id).delete();
      update();
      return true;
    } else {
      update();
      return false;
    }
  }

  //Checking if a request exists
  Future<bool> checkIfRequestExist({required requestTo}) async {
    var snapshots = await requestCollection
        .where(Filter.and(Filter('requestedTo', isEqualTo: requestTo),
            Filter('requestedFrom', isEqualTo: userModelGlobal.value.userId!)))
        .get();
    if (snapshots.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<(bool, String)> checkIfRequestExist2({required requestTo}) async {
    print('FUTURE RUNNING');
    var snapshots = await requestCollection
        .where(Filter.and(
            Filter('requestedTo', isEqualTo: userModelGlobal.value.userId!),
            Filter('requestedFrom', isEqualTo: requestTo)))
        .get();
    if (snapshots.docs.isEmpty) {
      return (false, '');
    } else {
      return (true, snapshots.docs[0].id);
    }
  }

  //Adding friend request
  requestToAdd({required BuildContext context, required requestTo}) async {
    DialogService.instance.showProgressDialog(context: context);
    try {
      RequestModel requestModel = RequestModel(
          requestedTo: requestTo,
          requestedFrom: userModelGlobal.value.userId!,
          requestedAt: DateTime.now(),
          docId: '',
          requestStatus: 'Requested');
      await requestCollection.add(requestModel.toMap()).then((value) {
        requestCollection.doc(value.id).update({'docId': value.id});
      });
      Get.back();
      CustomSnackBars.instance.showToast(message: 'Request sent');
      update();
      return true;
    } on FirebaseException catch (e) {
      Get.back();
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: '${e.message}');
      update();
      return false;
    } catch (e) {
      Get.back();
      CustomSnackBars.instance
          .showFailureSnackbar(title: 'Error', message: '${e}');
      update();
      return false;
    }
  }

  //Accepting request and checking if the doc exists
  acceptRequest({required requestFrom}) async {
    var myDocExist = await FirebaseCRUDService.instance.isDocExistByFieldName(
      fieldName: 'userId',
      isEqualTo: userModelGlobal.value.userId!,
      collectionReference: friendsCollection,
    );
    var otherUserDocExist =
        await FirebaseCRUDService.instance.isDocExistByFieldName(
      fieldName: 'userId',
      isEqualTo: requestFrom,
      collectionReference: friendsCollection,
    );
    if (myDocExist.$1) {
      await FirebaseCRUDService.instance.updateDocument(
          collection: friendsCollection,
          docId: myDocExist.$2!.docs[0].id,
          data: {
            'friendsIds': FieldValue.arrayUnion([requestFrom]),
          });
    } else {
      await FirebaseCRUDService.instance.createDocument(
          collectionReference: friendsCollection,
          docId: UuidFunctions.instance.createUuidV7(),
          data: {
            'friendsIds': [requestFrom],
            'userId': userModelGlobal.value.userId
          });
    }
    if (otherUserDocExist.$1) {
      await FirebaseCRUDService.instance.updateDocument(
          collection: friendsCollection,
          docId: otherUserDocExist.$2!.docs[0].id,
          data: {
            'friendsIds': FieldValue.arrayUnion([userModelGlobal.value.userId]),
          });
    } else {
      await FirebaseCRUDService.instance.createDocument(
          collectionReference: friendsCollection,
          docId: UuidFunctions.instance.createUuidV7(),
          data: {
            'friendsIds': [userModelGlobal.value.userId],
            'userId': requestFrom
          });
    }
    var snapshotData = await checkIfRequestExist2(requestTo: requestFrom);
    if (snapshotData.$1) {
      await FirebaseCRUDService.instance.deleteDocument(
          collection: requestCollection, docId: snapshotData.$2);
    }
    await callInInit();
  }

  unfriendUser({required requestFrom}) async {
    var myDocExist = await FirebaseCRUDService.instance.isDocExistByFieldName(
      fieldName: 'userId',
      isEqualTo: userModelGlobal.value.userId!,
      collectionReference: friendsCollection,
    );
    var otherUserDocExist =
        await FirebaseCRUDService.instance.isDocExistByFieldName(
      fieldName: 'userId',
      isEqualTo: requestFrom,
      collectionReference: friendsCollection,
    );
    if (myDocExist.$1) {
      await FirebaseCRUDService.instance.updateDocument(
          collection: friendsCollection,
          docId: myDocExist.$2!.docs[0].id,
          data: {
            'friendsIds': FieldValue.arrayRemove([requestFrom]),
          });
    }
    if (otherUserDocExist.$1) {
      await FirebaseCRUDService.instance.updateDocument(
          collection: friendsCollection,
          docId: otherUserDocExist.$2!.docs[0].id,
          data: {
            'friendsIds':
                FieldValue.arrayRemove([userModelGlobal.value.userId]),
          });
    }

    await callInInit();
  }

  //Getting all friends into user model list
  getAllUserFiends() async {
    friendsList.clear();
    var friendsCollectionSnapshot = await FirebaseCRUDService.instance
        .readSingleDocByFieldName(
            collectionReference: friendsCollection,
            fieldName: 'userId',
            fieldValue: userModelGlobal.value.userId!);
    if (friendsCollectionSnapshot != null) {
      FriendsModel friendsModel = FriendsModel.fromMap(
          friendsCollectionSnapshot!.data() as Map<String, dynamic>);
      for (String friendId in friendsModel.friendsIds) {
        var singleSnapshot = await FirebaseCRUDService.instance
            .readSingleDocument(
                collectionReference: usersCollection, docId: friendId);

        //initializing friend model
        UserModel _friendModel = UserModel.fromJson(singleSnapshot!);

        friendsList.add(_friendModel);

        //adding friend id in friendsIds list
        friendsIds.add(_friendModel.userId!);
      }
    }
  }

  getAllUserRequests() async {
    requestList.clear();
    List<RequestModel> requests = [];
    var requestCollectionSnapshots = await FirebaseCRUDService.instance
        .readAllDocByFieldName(
            collectionReference: requestCollection,
            fieldName: 'requestedTo',
            fieldValue: userModelGlobal.value.userId!);
    if (requestCollectionSnapshots != null) {
      for (var data in requestCollectionSnapshots) {
        requests.add(RequestModel.fromMap(data.data() as Map<String, dynamic>));
      }
      for (var data2 in requests) {
        var userCollectionReference = await FirebaseCRUDService.instance
            .readSingleDocByFieldName(
                collectionReference: usersCollection,
                fieldName: 'userId',
                fieldValue: data2.requestedFrom);

        if (userCollectionReference != null) {
          requestList.add(UserModel.fromJson(userCollectionReference));
        }
      }
    }
  }

  separateLists() {
    for (var data in friendsList) {
      knownUsers.removeWhere((element) => element.userId == data.userId);
    }
  }

  //Init function
  callInInit() async {
    await getUserContacts();
    await getAccountsOfUserContacts();
    await getAllUserFiends();
    await getAllUserRequests();
    separateLists();
  }

  //searched users stream
  StreamSubscription<QuerySnapshot>? _searchedUsersStream;

  //found users list
  RxList<UserModel> foundUsers = RxList<UserModel>();

  //method to add user in the found users list
  Future<void> _handleFoundUsersResp({required UserModel userModel}) async {
    //flag to check if the user is already in the found users list
    bool isUserAlreadyFound = false;

    //checking if the found users list is not empty
    if (foundUsers.isNotEmpty) {
      //adding found user in the list
      for (UserModel user in foundUsers) {
        log("iterating found users list");
        //checking if the user exists in the list
        if (user.userId == userModel.userId) {
          //changing the flag
          isUserAlreadyFound = true;
        }
      }
    }
    //  else {
    //   foundUsers.add(userModel);
    // }

    //adding the user in found users list (if the user doesn't exist in the list)
    if (isUserAlreadyFound == false) {
      foundUsers.add(userModel);
    }
  }

  //method to search for a username
  void searchUsernames({required String partialUsername}) {
    //getting document snapshots stream
    _searchedUsersStream = usersCollection
        .where("userName", isNotEqualTo: userModelGlobal.value.userName)
        .where("userName", isGreaterThanOrEqualTo: partialUsername)
        .where("userName", isLessThan: partialUsername + 'z')
        .snapshots()
        .listen((querySnapshot) async {
      log("querySnapshot: $querySnapshot");
      //clearing foundUsers list
      foundUsers.value = [];

      for (DocumentSnapshot document in querySnapshot.docs) {
        //initializing UserModel
        UserModel userModel = UserModel.fromJson(document);

        //handling found user response
        await _handleFoundUsersResp(userModel: userModel);
      }
    });
  }

  @override
  void onInit() {
    callInInit();
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() async {
    // TODO: implement onClose
    super.onClose();

    if (_searchedUsersStream != null) {
      await _searchedUsersStream!.cancel();
    }
  }
}
