import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:glass/glass.dart';
import 'main.dart';

class LetterPage extends StatefulWidget {
  final Letter letter;
  const LetterPage({Key? key, required this.letter}) : super(key: key);

  @override
  _LetterPageState createState() => _LetterPageState();
}

class _LetterPageState extends State<LetterPage> with SingleTickerProviderStateMixin {

  bool depressPage = false;
  double letter = 0;
  double response = 1000;
  final _formKey = GlobalKey<FormState>();
  final _responseController = TextEditingController();
  ScrollController? _scrollController;
  AnimationController? _animationController;
  late Timer _timer;
  

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(vsync: this);
    //update the letter's isRead status to true
    //_scrollToEnd();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
    _scrollToEnd(); // Call scrollToEnd method every second
    });
    
    FirebaseFirestore.instance
    .collection('letters')
    .doc(widget.letter.code)
    .update({'read': true});

    FirebaseFirestore.instance
    .collection('activities')
    .add({
      //format the date and time
      
      'activity': '${widget.letter.recipient} read their letter at ${DateTime.now()}',
    });

  }

  @override
  void dispose() {
    _scrollController!.dispose();
    _animationController!.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
  setState(() {
    print('scrolling to end');
    _scrollController!.animateTo(
      _scrollController!.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
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


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: 
      AnimatedOpacity(
        opacity: depressPage ? 0 : 1,
        duration: const Duration(milliseconds: 200),
        //visible: !depressPage,
        child: 
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                  },
                  child: const Text('Send response', style: TextStyle(color: Color(0xFF8ddce3))),
                ),
              ],
            ),
          ),
        ).asGlass(
          clipBorderRadius: const BorderRadius.all(Radius.circular(15)),
          blurX: 5,
          blurY: 5,
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
            duration: const Duration(milliseconds: 300),
            curve: Curves.decelerate,
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
                  padding: const EdgeInsets.symmetric(horizontal: 30),//if depressPage is true, the letter will be displayed in a depressed state
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 70),
                            Text(
                              '@ ${widget.letter.recipient}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: SingleChildScrollView(
                                //controller: _scrollController,
                                child: AnimatedTextKit(
                                  onFinished: (){
                                    setState(() {
                                      //stop the timer
                                      _timer.cancel();
                                    });
                                  },
                                  isRepeatingAnimation: false,
                                  animatedTexts: [
                                  TyperAnimatedText(widget.letter.message!,
                                    speed: const Duration(milliseconds: 20),
                                    textAlign: TextAlign.start,
                                    textStyle: const TextStyle(
                                      height: 2,
                                      fontSize: 16,
                                    ),
                                  ),
                                ]
                                ),
                              ),
                            ),
                            const SizedBox(height: 100),
                          ],

                        ),
                  ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.decelerate,
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
            )
          ),
        ],
      )
      );
  }
}
