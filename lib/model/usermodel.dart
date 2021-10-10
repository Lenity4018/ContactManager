import 'package:hive/hive.dart';

part 'usermodel.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String phone;

  @HiveField(2)
  late String email;

  @HiveField(3)
  late List<ContactModel> contacts;
}

@HiveType(typeId: 1)
class ContactModel extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String phone;

  @HiveField(2)
  late String email;

  @HiveField(3)
  late String notes;

  @HiveField(4)
  late int userid;
}
