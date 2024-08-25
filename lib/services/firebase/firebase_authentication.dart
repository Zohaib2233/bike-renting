import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:bike_gps/controllers/auth/login_controller.dart';
import 'package:bike_gps/controllers/auth/signup_controller.dart';
import 'package:bike_gps/core/constants/firebase_collection_references.dart';
import 'package:bike_gps/core/utils/snackbars.dart';
import 'package:bike_gps/services/firebase/firebase_crud.dart';
import 'package:bike_gps/services/local_storage/local_storage.dart';
import 'package:bike_gps/view/screens/auth/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthService extends GetxController {
  static FirebaseAuthService get instance => FirebaseAuthService();

  //signing up user with email and password
  Future<User?> signUpUsingEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (FirebaseAuth.instance.currentUser != null) {
        User user = FirebaseAuth.instance.currentUser!;

        return user;
      }
      if (FirebaseAuth.instance.currentUser == null) {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Authentication Error', message: '${e.message}');

      return null;
    } on FirebaseException catch (e) {
      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Authentication Error', message: '${e.message}');

      return null;
    } catch (e) {
      log("This was the exception while signing up: $e");

      return null;
    }

    return null;
  }

  //method to check if the user's account already exists on firebase
  Future<bool> isAlreadyExist({required String uid}) async {
    bool isExist = await FirebaseCRUDService.instance
        .isDocExist(collectionReference: usersCollection, docId: uid);

    return isExist;
  }

  //method to authenticate with google account
  //(Firebase user,google user credentials,is user already exist on Firestore)
  Future<(User?, GoogleSignInAccount?, bool)> authWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // TODO: Use the `credential` to sign in with Firebase.
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (FirebaseAuth.instance.currentUser == null) {
        return (null, null, false);
      }

      if (FirebaseAuth.instance.currentUser != null) {
        User user = FirebaseAuth.instance.currentUser!;

        //checking if the user's account already exists on firebase
        bool isExist = await isAlreadyExist(uid: user.uid);

        return (user, googleUser, isExist);
      }
    } on FirebaseAuthException catch (e) {
      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Authentication Error', message: '${e.message}');

      return (null, null, false);
    } on FirebaseException catch (e) {
      //showing failure snackbar
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Authentication Error', message: '${e.message}');

      return (null, null, false);
    } catch (e) {
      log("This was the exception while signing up: $e");

      return (null, null, false);
    }

    return (null, null, false);
  }

  //reAuthenticating user to confirm if the same user is requesting
  Future<void> changeFirebaseEmail(
      {required String email,
      required String password,
      required String newEmail}) async {
    try {
      final User user = await FirebaseAuth.instance.currentUser!;

      final cred =
          EmailAuthProvider.credential(email: email, password: password);

      await user.reauthenticateWithCredential(cred).then((value) async {
        await user.verifyBeforeUpdateEmail(newEmail);

        CustomSnackBars.instance.showSuccessSnackbar(
          title: "Verification Link Sent",
          message:
              "Please update your email by verifying it through the link provided in the verification email we have sent to you.",
          duration: 6,
        );

        //logging out user (so that we can update his email on the Firebase when he logs in again)
        await FirebaseAuth.instance.signOut();

        //deleting isRemember me key from local storage
        await LocalStorageService.instance.deleteKey(key: "isRememberMe");

        //putting the controllers again
        Get.put<SignUpController>(SignUpController());
        Get.put<LoginController>(LoginController());
        Get.put<FirebaseAuthService>(FirebaseAuthService());

        //navigating back to Login Screen
        Get.offAll(() => Login());
      }).onError((error, stackTrace) {
        CustomSnackBars.instance
            .showFailureSnackbar(title: 'Error', message: '$error');
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          CustomSnackBars.instance
              .showFailureSnackbar(title: 'Error', message: 'User not found');
          break;
        case 'wrong-password':
          CustomSnackBars.instance
              .showFailureSnackbar(title: 'Error', message: 'Wrong password');
          break;
        case 'invalid-email':
          CustomSnackBars.instance
              .showFailureSnackbar(title: 'Error', message: 'Invalid email');
          break;
        case 'email-already-in-use':
          CustomSnackBars.instance.showFailureSnackbar(
              title: 'Error', message: 'Email already in use');
          break;
        default:
          CustomSnackBars.instance.showFailureSnackbar(
              title: 'Retry', message: 'Something went wrong');
          break;
      }
    }
  }

  //method to change Firebase password
  Future<void> changeFirebasePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred =
        EmailAuthProvider.credential(email: email, password: oldPassword);

    try {
      user!.reauthenticateWithCredential(cred).then((value) {
        user.updatePassword(newPassword).then((_) {
          CustomSnackBars.instance.showSuccessSnackbar(
              title: "Success", message: "Password updated successfully");
        }).onError((error, stackTrace) {
          CustomSnackBars.instance
              .showFailureSnackbar(title: "Failure", message: "$error");
        });
      }).onError((error, stackTrace) {
        CustomSnackBars.instance
            .showFailureSnackbar(title: "Failure", message: "$error");
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          CustomSnackBars.instance
              .showFailureSnackbar(title: 'Error', message: 'User not found');
          break;
        case 'wrong-password':
          CustomSnackBars.instance
              .showFailureSnackbar(title: 'Error', message: 'Wrong password');
          break;
        case 'invalid-email':
          CustomSnackBars.instance
              .showFailureSnackbar(title: 'Error', message: 'Invalid email');
          break;
        case 'email-already-in-use':
          CustomSnackBars.instance.showFailureSnackbar(
              title: 'Error', message: 'Email already in use');
          break;
        default:
          CustomSnackBars.instance.showFailureSnackbar(
              title: 'Retry', message: 'Something went wrong');
          break;
      }
    }
  }

  //APPLE SIGN IN METHODS
  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = math.Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  //method to Sign in with Apple
  //(Firebase user,is user already exist on Firestore)
  Future<(User?,bool)> signInWithApple() async {
    try
        {
          // To prevent replay attacks with the credential returned from Apple, we
          // include a nonce in the credential request. When signing in with
          // Firebase, the nonce in the id token returned by Apple, is expected to
          // match the sha256 hash of `rawNonce`.
          final rawNonce = generateNonce();
          final nonce = sha256ofString(rawNonce);

          // Request credential for the currently signed in Apple account.
          final appleCredential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            nonce: nonce,
          );

          // Create an `OAuthCredential` from the credential returned by Apple.
          final oauthCredential = OAuthProvider("apple.com").credential(
            idToken: appleCredential.identityToken,
            rawNonce: rawNonce,
          );

          // Sign in the user with Firebase. If the nonce we generated earlier does
          // not match the nonce in `appleCredential.identityToken`, sign in will fail.
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

          if(FirebaseAuth.instance.currentUser!=null)
            {
              User user = FirebaseAuth.instance.currentUser!;

              //checking if the user's account already exists on firebase
              bool isExist = await isAlreadyExist(uid: user.uid);

              return (user,isExist);
            }
          else
            {
              return (null,false);
            }
        }
        on FirebaseException catch(e)
    {
      log("This was the exception while signing in using apple: $e");

      CustomSnackBars.instance.showFailureSnackbar(title: "Failure", message: "$e");

      return (null,false);
    }
    catch(e)
    {
      log("This was the exception while signing in using apple: $e");

      CustomSnackBars.instance.showFailureSnackbar(title: "Failure", message: "Something went wrong, please try again!");

      return (null,false);
    }
  }
}
