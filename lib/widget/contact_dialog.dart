import 'package:flutter/material.dart';
import 'package:mycontactbook/model/usermodel.dart';

class ContactDialog extends StatefulWidget {
  final ContactModel? contact;
  final Function(String name, String phone, String email, String notes)
      onClickedDone;

  const ContactDialog({
    Key? key,
    this.contact,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _ContactDialogState createState() => _ContactDialogState();
}

class _ContactDialogState extends State<ContactDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.contact != null) {
      final contact = widget.contact!;

      nameController.text = contact.name;
      phoneController.text = contact.phone;
      emailController.text = contact.email;
      notesController.text = contact.notes;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    notesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;
    final title = isEditing ? 'Edit Contact' : 'Add Contact';

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
              SizedBox(height: 8),
              buildNotes(),
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

  Widget buildNotes() => TextFormField(
        controller: notesController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter your Contact Notes',
        ),
        validator: (notes) =>
            notes != null && notes.isEmpty ? 'Enter your notes' : null,
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
          final notes = emailController.text;

          widget.onClickedDone(name, phone, email, notes);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
