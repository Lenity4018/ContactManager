import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mycontactbook/boxes.dart';
import 'package:mycontactbook/model/usermodel.dart';
import 'package:mycontactbook/widget/user_dialog.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final List<UserModel> users = [];

  @override
  void dispose() {
    Hive.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('User Details'),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<UserModel>>(
          valueListenable: Boxes.getUsers().listenable(),
          builder: (context, box, _) {
            final users = box.values.toList().cast<UserModel>();

            return buildContent(users);
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => UserDialog(
              onClickedDone: addUser,
            ),
          ),
        ),
      );

  Widget buildContent(List<UserModel> users) {
    if (users.isEmpty) {
      return Center(
        child: Text(
          'No user yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final user = users[index];

                return buildUser(context, user);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildUser(
    BuildContext context,
    UserModel user,
  ) {
    final color = Colors.green;
    return Card(
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          user.name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(user.email),
        trailing: Text(
          user.phone,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: [
          buildButtons(context, user),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context, UserModel user) => Row(
        children: [
          Expanded(
            child: TextButton.icon(
              label: Text('Edit'),
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserDialog(
                    user: user,
                    onClickedDone: (name, phone, email) =>
                        editUser(user, name, phone, email),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              label: Text('Delete'),
              icon: Icon(Icons.delete),
              onPressed: () => deleteUser(user),
            ),
          )
        ],
      );

  Future addUser(String name, String phone, String email) async {
    final user = UserModel()
      ..name = name
      ..phone = phone
      ..email = email;

    final box = Boxes.getUsers();
    box.add(user);
  }

  void editUser(
    UserModel user,
    String name,
    String phone,
    String email,
  ) {
    user.name = name;
    user.phone = phone;
    user.email = email;

    // final box = Boxes.getUserss();
    // box.put(user.key, user);

    user.save();
  }

  void deleteUser(UserModel user) {
    // final box = Boxes.getUsers();
    // box.delete(user.key);

    user.delete();
    //setState(() => users.remove(user));
  }
}
