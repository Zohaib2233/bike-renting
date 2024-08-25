import 'package:get_storage/get_storage.dart';

class LocalStorageService {
  //private constructor
  LocalStorageService._privateConstructor();

  //singleton instance variable
  static LocalStorageService? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to LocalStorageService.instance will return the same instance that was created before.

  //getter to access the singleton instance
  static LocalStorageService get instance {
    _instance ??= LocalStorageService._privateConstructor();
    return _instance!;
  }

  //initializing get storage instance
  final _box = GetStorage();

  //method to write into local storage
  Future<void> write({required String key, required var value}) async {
    await _box.write(key, value);
  }

  //method to read from local storage
  Future<dynamic> read({required String key}) async {
    return await _box.read(key);
  }

  //method to delete a key from the local storage service
  Future<void> deleteKey({required String key}) async {
    await _box.remove(key);
  }
}
