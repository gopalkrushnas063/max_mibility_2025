import 'package:max_mobility_assignment/util/repository.dart';
import 'package:max_mobility_assignment/model/User.dart';

class UserService {
  final Repository _repository = Repository();

  Future<int> SaveUser(User user) async {
    return await _repository.insertData('users', user.toJson());
  }

  Future<List<Map<String, dynamic>>> readAllUsers() async {
    return await _repository.readData('users');
  }

  Future<int> UpdateUser(User user) async {
    return await _repository.updateData('users', user.toJson());
  }

  Future<int> deleteUser(int userId) async {
    return await _repository.deleteDataById('users', userId);
  }
}
