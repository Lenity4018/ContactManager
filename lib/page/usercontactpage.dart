import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mycontactbook/boxes.dart';
import 'package:mycontactbook/model/usermodel.dart';
import 'package:mycontactbook/widget/contact_dialog.dart';

class UserContactPage extends StatefulWidget {
  const UserContactPage({Key? key}) : super(key: key);

  @override
  _UserContactPageState createState() => _UserContactPageState();
}

class _UserContactPageState extends State<UserContactPage> {
  final List<ContactModel> contacts = [];

  @override
  void dispose() {
    Hive.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Contact Details'),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<ContactModel>>(
          valueListenable: Boxes.getContacts().listenable(),
          builder: (context, box, _) {
            final contacts = box.values.toList().cast<ContactModel>();

            return buildContent(contacts);
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => ContactDialog(
              onClickedDone: addContact,
            ),
          ),
        ),
      );

  Widget buildContent(List<ContactModel> contacts) {
    if (contacts.isEmpty) {
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
              itemCount: contacts.length,
              itemBuilder: (BuildContext context, int index) {
                final contact = contacts[index];

                return buildContact(context, contact);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildContact(
    BuildContext context,
    ContactModel contact,
  ) {
    final color = Colors.green;
    return Card(
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          contact.name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(contact.email),
        trailing: Text(
          contact.phone,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: [
          buildButtons(context, contact),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context, ContactModel contact) => Row(
        children: [
          Expanded(
            child: TextButton.icon(
              label: Text('Edit'),
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ContactDialog(
                    contact: contact,
                    onClickedDone: (name, phone, email, notes) =>
                        editContact(contact, name, phone, email, notes),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              label: Text('Delete'),
              icon: Icon(Icons.delete),
              onPressed: () => deleteContact(contact),
            ),
          )
        ],
      );

  Future addContact(
      String name, String phone, String email, String notes) async {
    final contact = ContactModel()
      ..name = name
      ..phone = phone
      ..email = email
      ..notes = notes;

    final box = Boxes.getContacts();
    box.add(contact);
  }

  void editContact(
    ContactModel contact,
    String name,
    String phone,
    String email,
    String notes,
  ) {
    contact.name = name;
    contact.phone = phone;
    contact.email = email;

    // final box = Boxes.getUserss();
    // box.put(user.key, user);

    contact.save();
  }

  void deleteContact(ContactModel contact) {
    // final box = Boxes.getUsers();
    // box.delete(user.key);

    contact.delete();
    //setState(() => users.remove(user));
  }
}
