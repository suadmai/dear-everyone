import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'package:animated_text_kit/animated_text_kit.dart';
import 'main.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  final _formKey = GlobalKey<FormState>();
  var letters = [];
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
                  setState(() {
                    
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
        title: const Text('Admin Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          writeLetter();
        },
        backgroundColor: const Color(0xFF3C3C3C),
        child: const Icon(Icons.add, color: Color(0xFF8ddce3)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text('Letter status', style: TextStyle(fontSize: 24)),
            SizedBox(
              height: 350,
              child: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
                stream: FirebaseFirestore.instance.
                        collection('letters').
                        snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
                  if(snapshot.hasData){
                    final letters = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: letters.length,
                      itemBuilder: (context,index){
                        final letter = letters[index].data();
                        final recipient = letter['recipient'] as String?;
                        final read = letter['read'] as bool?;
              
                        return ListTile(
                          title: Text(recipient!),
                          subtitle: read! ? const Text('Read') : const Text('Unread'),
                        );
                      },
                    ); 
                  }
                  else{
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
            const Divider(
              color: Colors.black,
              thickness: 0.5,
            ),
            const SizedBox(height: 20),
            const Text('Responses', style: TextStyle(fontSize: 24)),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
                stream: FirebaseFirestore.instance.
                        collection('responses').
                        snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
                  if(snapshot.hasData){
                    final responses = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: responses.length,
                      itemBuilder: (context,index){
                        final response = responses[index].data();
                        final recipient = response['sender'] as String?;
                        final message = response['response'] as String?;
              
                        return ListTile(
                          title: Text(recipient!),
                          subtitle: Text(message!),
                        );
                      },
                    ); 
                  }
                  else{
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}