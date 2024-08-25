import 'package:bike_gps/core/constants/base_urls.dart';
import 'package:bike_gps/core/env/keys.dart';
import 'package:bike_gps/core/utils/encryption/encryption.dart';
import 'package:bike_gps/core/utils/snackbars.dart';
import 'package:bike_gps/services/api/api.dart';
import 'package:bike_gps/services/local_storage/local_storage.dart';

class KnaapServices {
  // Private constructor
  KnaapServices._privateConstructor();

  // Singleton instance variable
  static KnaapServices? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to KnaapServices.instance will return the same instance that was created before.

  // Getter to access the singleton instance
  static KnaapServices get instance {
    _instance ??= KnaapServices._privateConstructor();
    return _instance!;
  }

  //method to get access token
  Future<Map?> _callAccessTokenAPI() async {
    //getting signature and timestamp (signature,timestamp)
    (String, String) generatedSignature =
        KnaapEncryption.instance.generateSignature();

    //creating payload
    Map<String, dynamic> payload = {
      "appid": appId,
      "signature": generatedSignature.$1,
      "time": generatedSignature.$2,
    };

    //calling API to get access token
    Map? response = await APIService.instance.post(
      authBaseUrl,
      payload,
      true,
    );

    if (response != null) {
      return response;
    } else {
      return null;
    }
  }

  //handling access token
  Future<void> _handleAccessToken({required Map accessTokenResp}) async {
    int tokenExpiryTime = accessTokenResp['expiresIn'];

    String accessToken = accessTokenResp['accessToken'];

    //time at which token was created
    DateTime tokenCreatedAt = DateTime.now();

    //creating access token resp (to store in local storage)
    Map accessTokenMap = {
      "accessToken": accessToken,
      "createdAt": tokenCreatedAt.toString(),
      "expiresIn": tokenExpiryTime,
    };

    //storing accessTokenMap in local storage
    await LocalStorageService.instance
        .write(key: "accessTokenMap", value: accessTokenMap);
  }

  //method to create access token for calling APIs
  Future<String?> _createAccessToken() async {
    Map? accessTokenResp = await _callAccessTokenAPI();

    if (accessTokenResp != null) {
      //handling access token response
      if (accessTokenResp['code'] == 0) {
        await _handleAccessToken(accessTokenResp: accessTokenResp);

        return accessTokenResp['accessToken'];
      } else {
        CustomSnackBars.instance.showFailureSnackbar(
            title: "Failure",
            message: "Could not get access token for authentication");

        return null;
      }
    }

    return null;
  }

  //method to check if the token is expired or not
  bool _checkIfTokenExpired({required DateTime tokenCreatedAt}) {
    DateTime now = DateTime.now();

    Duration difference = now.difference(tokenCreatedAt);

    Duration oneAndHalfHours = Duration(hours: 1, minutes: 30);

    if (difference.compareTo(oneAndHalfHours) > 0) {
      return true;
    } else {
      return false;
    }
  }

  //method to create access token for Knaap services
  Future<String?> getAccessToken() async {
    //flag to check if the token is expired
    bool isAccessTokenExpired = true;

    //getting access token map from local storage
    Map? accessTokenMap =
        await LocalStorageService.instance.read(key: "accessTokenMap") ?? null;

    //it means the token was existing in the local storage
    //if the token exists, then checking if the token is expired
    if (accessTokenMap != null) {
      isAccessTokenExpired = _checkIfTokenExpired(
          tokenCreatedAt: DateTime.parse(accessTokenMap['createdAt']));

      //if the token is expired then creating the token again
      if (isAccessTokenExpired) {
        String? accessToken = await _createAccessToken();

        return accessToken;
      }
      //if the token is not expired, returning the same token again
      else if (isAccessTokenExpired == false) {
        return accessTokenMap['accessToken'];
      }
    }
    //it means the token was not existing in the local storage (creating the access token first time)
    else if (accessTokenMap == null) {
      String? accessToken = await _createAccessToken();

      return accessToken;
    }

    return null;
  }
}
