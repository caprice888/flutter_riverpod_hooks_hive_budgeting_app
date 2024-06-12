import 'package:hive/hive.dart';
import '../models/user_data_model.dart';

class UserDataService {
  static const String boxName = 'userDataBox';

  // Get the UserData from the Hive box
  Future<UserDataModel?> getUserData() async {
    var box = await Hive.openBox<UserDataModel>(boxName);
    return box.get('userData');
  }

  // Save or update UserData in the Hive box
  Future<void> saveUserData(UserDataModel userData) async {
    var box = await Hive.openBox<UserDataModel>(boxName);
    await box.put('userData', userData);
  }
}
