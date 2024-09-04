import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrustedContacts extends StatefulWidget {
  @override
  _TrustedContactsState createState() => _TrustedContactsState();
}

class _TrustedContactsState extends State<TrustedContacts> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> _addContact() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users')
          .doc(user.uid)
          .collection('trusted_contacts')
          .add({
        'name': _nameController.text,
        'phone': _phoneController.text,
      });
      _nameController.clear();
      _phoneController.clear();
    }
  }

  Future<void> _deleteContact(String contactId) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users')
          .doc(user.uid)
          .collection('trusted_contacts')
          .doc(contactId)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Trusted Contacts"),
      ),
      body: user == null
          ? Center(child: Text("Please log in"))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Contact Name'),
                      ),
                      SizedBox(height: 8.0),
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(labelText: 'Contact Phone'),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _addContact,
                        child: Text("Add Contact"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('users')
                        .doc(user.uid)
                        .collection('trusted_contacts')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final contacts = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          final contact = contacts[index];
                          return ListTile(
                            title: Text(contact['name']),
                            subtitle: Text(contact['phone']),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteContact(contact.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
