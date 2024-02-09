import 'package:everyone/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();
  final newLetter = Letter();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Page'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Letter Status'),
              Tab(text: 'Responses'),
              Tab(text: 'Activities'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LetterStatusTab(),
            ResponsesTab(),
            ActivitiesTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => writeLetter(),
          backgroundColor: const Color(0xFF3C3C3C),
          child: const Icon(Icons.add, color: Color(0xFF8ddce3)),
        ),
      ),
    );
  }

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
                  FirebaseFirestore.instance.collection('letters').doc(newLetter.code).set({
                    'recipient': newLetter.recipient,
                    'message': newLetter.message,
                    'read': false,
                  });
                  setState(() {});
                  //return snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Letter sent to ${newLetter.recipient}'),
                    ),
                  );
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

}

class LetterStatusTab extends StatelessWidget {
  const LetterStatusTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('Letter status', style: TextStyle(fontSize: 24)),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('letters').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                final letters = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: letters.length,
                  itemBuilder: (context, index) {
                    final letter = letters[index].data();
                    final recipient = letter['recipient'] as String?;
                    final read = letter['read'] as bool?;
                    return ListTile(
                      title: Text(recipient!),
                      subtitle: read! ? const Text('Read') : const Text('Unread'),
                    );
                  },
                );
              } else {
                return const Center(child: Text('Loading'));
              }
            },
          ),
        ),
      ],
    );
  }
}

class ResponsesTab extends StatelessWidget {
  const ResponsesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('Responses', style: TextStyle(fontSize: 24)),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('responses').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                final responses = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: responses.length,
                  itemBuilder: (context, index) {
                    final response = responses[index].data();
                    final sender = response['sender'] as String?;
                    final message = response['response'] as String?;
                    return ListTile(
                      title: Text(sender!),
                      subtitle: Text(message!),
                    );
                  },
                );
              } else {
                return const Center(child: Text('Loading'));
              }
            },
          ),
        ),
      ],
    );
  }
}

class ActivitiesTab extends StatelessWidget {
  const ActivitiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('Activities', style: TextStyle(fontSize: 24)),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('activities').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                final activites = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: activites.length,
                  itemBuilder: (context, index) {
                    final activitiesList = activites[index].data();
                    final activity = activitiesList['activity'] as String?;
                    return ListTile(
                      subtitle: Text(activity!),
                    );
                  },
                );
              } else {
                return const Center(child: Text('Loading'));
              }
            },
          ),
        ),
      ],
    );
  }
}
