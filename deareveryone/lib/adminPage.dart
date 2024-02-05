import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'package:animated_text_kit/animated_text_kit.dart';
import 'main.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

//this page is to create new letters and view if they have been read

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  final _formKey = GlobalKey<FormState>();
  Letter newLetter = Letter();
  
  
  void writeLetter() {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Code',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the recipient\'s code';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    newLetter.code = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Recipient',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the recipient\'s name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    newLetter.recipient = value;
                  },
                ),
                TextFormField(
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    hintText: 'Enter the message',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a message';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    newLetter.message = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3C3C3C)
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel', style: TextStyle(color: Color(0xFF8ddce3)),),
            ),
            ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3C3C3C)
                    ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  //save the letter to the database
                  //givethe letter firestore id the same as the code
                  FirebaseFirestore.instance.collection('letters').doc(newLetter.code).set({
                    'recipient': newLetter.recipient,
                    'message': newLetter.message,
                    'read': false,
                  });
                  print('Letter sent');
                  Navigator.pop(context);
                }
              },
              child: const Text('Send', style: TextStyle(color: Color(0xFF8ddce3)),),
            ),
          ],
        );
      },
      );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          writeLetter();
        },
        backgroundColor: const Color(0xFF3C3C3C),
        child: const Icon(Icons.add, color: Color(0xFF8ddce3)),
      ),
    );
  }
}