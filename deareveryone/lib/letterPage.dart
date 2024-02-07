import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'package:animated_text_kit/animated_text_kit.dart';
import 'main.dart';

class LetterPage extends StatefulWidget {
  final Letter letter;
  const LetterPage({Key? key, required this.letter}) : super(key: key);

  @override
  _LetterPageState createState() => _LetterPageState();
}

class _LetterPageState extends State<LetterPage> {

  final _formKey = GlobalKey<FormState>();
  final _responseController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void showResponseDialog() {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: const Color(0xFF3C3C3C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  minLines: 1,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    labelText: 'Type your response',
                    focusColor: Color(0xFF8ddce3),
                  ),
                  controller: _responseController,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3C3C3C),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      FirebaseFirestore.instance.collection('responses')
                      .add({
                        'sender': widget.letter.recipient,
                        'response': _responseController.text,
                      });
                      //add snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Response sent!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      //clear the response field
                      _responseController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Send', style: TextStyle(color: Color(0xFF8ddce3))),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: 
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3C3C3C),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close', style: TextStyle(color: Color(0xFF8ddce3))),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3C3C3C),
            ),
            onPressed: () {
              showResponseDialog();
            },
            child: const Text('Send response', style: TextStyle(color: Color(0xFF8ddce3))),
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
          child: SingleChildScrollView(
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Dear ${widget.letter.recipient},',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: SingleChildScrollView(
                        child: AnimatedTextKit(
                          isRepeatingAnimation: false,
                          animatedTexts: [
                          TyperAnimatedText(widget.letter.message!,
                            speed: const Duration(milliseconds: 30),
                            textAlign: TextAlign.left,
                            textStyle: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
            
                ),
          ),
      )
      );
  }
}
