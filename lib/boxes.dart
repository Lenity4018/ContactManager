import 'package:hive/hive.dart';
import 'package:mycontactbook/model/usermodel.dart';

class Boxes {
  static Box<UserModel> getUsers() => Hive.box<UserModel>('users');

  static Box<ContactModel> getContacts() => Hive.box<ContactModel>('contacts');
}
