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

  bool depressPage = false;
  double letter = 0;
  double response = 1000;
  final _formKey = GlobalKey<FormState>();
  final _responseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //update the letter's isRead status to true
    FirebaseFirestore.instance
    .collection('letters')
    .doc(widget.letter.code)
    .update({'read': true});

    FirebaseFirestore.instance
    .collection('activities')
    .add({
      'activity': '${widget.letter.recipient} read their letter at ${DateTime.now()}',
    });
  }

  void setPadding(){
    if(depressPage){
      letter = 50;
      response = 80;
    } else {
      letter = 0;
      response = 1000;
    }
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
      AnimatedOpacity(
        opacity: depressPage ? 0 : 1,
        duration: const Duration(milliseconds: 200),
        //visible: !depressPage,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3C3C3C),
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
                depressPage = !depressPage;
                setPadding();
                setState(() {
                });
                //showResponseDialog();
              },
              child: const Text('Send response', style: TextStyle(color: Color(0xFF8ddce3))),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(//this container is the black background
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          AnimatedPositioned(//this container is the white background
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            top: letter,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),//if depressPage is true, the letter will be displayed in a depressed state
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
              ),
            ),
          ),
          AnimatedPositioned(//this container is the white background
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            top: response,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(57, 71, 71, 71),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),//if depressPage is true, the letter will be displayed in a depressed state
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(children: [
                            TextButton(
                              onPressed: (){
                                depressPage = false;
                                setPadding();
                                setState(() {
                                });
                              },
                              child: const Text('Cancel', style: TextStyle(color: Color(0xFF8ddce3))),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Write a response', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton(
                                
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3C3C3C),
                                ),
                                onPressed: () {
                                  if (_responseController.text.isNotEmpty) {
                                    FirebaseFirestore.instance.collection('responses')
                                    .add({
                                      'sender': widget.letter.recipient,
                                      'response': _responseController.text,
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Response sent!'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                    _responseController.clear();
                                  }
                                  else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Sending response cancelled'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  
                                  }
                                  depressPage = false;
                                  setPadding();
                                  setState(() {
                                  });
                                },
                                child: const Text('Send', style: TextStyle(color: Color(0xFF8ddce3))),
                              ),
                          ],
                          ),
                          const Divider(
                            color: Colors.black,
                            thickness: 0.5,
                          ),
                          TextFormField(
                            minLines: 1,
                            maxLines: 10,
                            decoration: const InputDecoration(
                              hintText: 'Type your response',
                              //no text field line
                              border: InputBorder.none,
                            ),
                            controller: _responseController,
                          ),
                        ],
                      ),
                    ),
                  ),
              ),
            ),
          ),
        ],
      )
      );
  }
}
