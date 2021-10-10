import 'package:flutter/material.dart';
import 'package:mycontactbook/model/usermodel.dart';

class UserDialog extends StatefulWidget {
  final UserModel? user;
  final Function(String name, String phone, String email) onClickedDone;

  const UserDialog({
    Key? key,
    this.user,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _UserDialogState createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      final user = widget.user!;

      nameController.text = user.name;
      phoneController.text = user.phone;
      emailController.text = user.email;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;
    final title = isEditing ? 'Edit User' : 'Add User';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              buildName(),
              SizedBox(height: 8),
              buildPhone(),
              SizedBox(height: 8),
              buildEmail(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() => TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a name' : null,
      );

  Widget buildPhone() => TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Phone Number',
        ),
        keyboardType: TextInputType.number,
        validator: (phone) => phone != null && double.tryParse(phone) == null
            ? 'Enter a valid number'
            : null,
        controller: phoneController,
      );

  Widget buildEmail() => TextFormField(
        controller: emailController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter email',
        ),
        validator: (email) =>
            email != null && email.isEmpty ? 'Enter your email' : null,
      );

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameController.text;
          final phone = phoneController.text;
          final email = emailController.text;

          widget.onClickedDone(name, phone, email);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
