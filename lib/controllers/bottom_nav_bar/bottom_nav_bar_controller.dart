import 'package:bike_gps/services/local_storage/local_storage.dart';
import 'package:get/get.dart';

class BottomNavBarController extends GetxController {
  //flag to check if the user has been gone through intro screens of Nearby Places
  bool _hasSeenPlacesIntro = false;

  //get hasSeenPlacesIntro flag
  bool get getPlacesIntroFlag => _hasSeenPlacesIntro;






  //reading flag from local storage
  Future<void> _checkIfIntroSeen() async {
    _hasSeenPlacesIntro =
        await LocalStorageService.instance.read(key: "hasSeenPlacesIntro") ??
            false;
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    //checking if the user has been gone through places intro screen
    await _checkIfIntroSeen();
  }
}
