import 'package:uuid/uuid.dart';

class UuidFunctions {
  //singleton instance
  // Private constructor
  UuidFunctions._privateConstructor();

  // Singleton instance variable
  static UuidFunctions? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to UuidFunctions.instance will return the same instance that was created before.

  // Getter to access the singleton instance
  static UuidFunctions get instance {
    _instance ??= UuidFunctions._privateConstructor();
    return _instance!;
  }

  String createUuidV7() {
    String uuid = Uuid().v1();
    return uuid;
  }
}
