import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mycontactbook/page/userpage.dart';

import 'model/usermodel.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('Users');

  Hive.registerAdapter(ContactModelAdapter());
  await Hive.openBox<ContactModel>('Contacts');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Contacts Maneger App';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: UsersPage(),
      );
}
