// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everyone/adminPage.dart';
import 'package:everyone/letterPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'package:animated_text_kit/animated_text_kit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class Letter{
  String? code;
  String? recipient;
  String? message;
  bool? isRead;

  Letter({this.code, this.recipient, this.message, this.isRead});//response is optional
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '@everyone',
      theme: ThemeData(
        fontFamily: 'Bahnschrift',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Dear, @everyone'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? code;
  String? response;
  List<Letter> letters = [];
  Letter currentLetter = Letter();
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    fetchLetters();
    letters.add(myLetter);
    letters.add(myLetter2);
    super.initState();
  }

  //example letter
  Letter myLetter = Letter(
    code: '1234',
    recipient: 'Farhanah Huda',
    message: """I'm sorry things didn't work out between us.
    \nI hope you find someone who can make you happy.
    \nI wish you all the best. Goodbye.""",
    isRead: false, 
    );
  
  Letter myLetter2 = Letter(
    code: '5678',
    recipient: 'Aireen',
    message: 'I hope you read this letter',
    isRead: false, 
    );

  void findLetter(String? code){
    print('Finding letter');
    for (var letter in letters){
      if (letter.code == code){
        currentLetter = letter;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LetterPage(letter: currentLetter),
          ),
        );
      }
      print('Letter not found');
    }
  }

  void fetchLetters() async {
  try {
    QuerySnapshot<Map<String, dynamic>> response = await FirebaseFirestore.instance.collection('letters').get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> letterDoc in response.docs) {
      Map<String, dynamic> letterData = letterDoc.data();
      print('Letter data: $letterData');
      Letter letter = Letter(
        code: letterDoc.id,
        recipient: letterData['recipient'],
        message: letterData['message'],
        isRead: letterData['read'],
      );
      letters.add(letter);
    }

    print('Letters: $letters');
  } catch (e) {
    print('Error fetching letters: $e');
  }
}
  void sendResponse(String response){
    if(response.isNotEmpty){
      FirebaseFirestore.instance.collection('responses')
      .add({
        'recipient': currentLetter.recipient,
        'response': response,
      });
    }
  }

  void openLetter(String? code){
    if(code == "2101"){//admin code i hope no one uses this code lol 
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminPage(),
        ),
      );
    }
    else{
      findLetter(code);
      // if(currentLetter.code == code){
      //   showDialog(
      //   context: context,
      //   builder: (BuildContext context){
      //     return AlertDialog(
      //     backgroundColor: Colors.white,
      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //     title: Text('To ${currentLetter.recipient}'),
      //     content: SingleChildScrollView(
      //       child: Column(
      //         children: [
      //           AnimatedTextKit(
      //             isRepeatingAnimation: false,
      //             animatedTexts: [
      //               TyperAnimatedText(
      //                 currentLetter.message!,
      //                 textAlign: TextAlign.left,
      //                 speed: const Duration(milliseconds: 30),
      //                 curve: Curves.easeInOutSine,
      //               ),
      //             ],
      //           ),
      //           const SizedBox(height: 32),
      //           TextField(
      //             onChanged: (value) => response = value,
      //             minLines: 1,
      //             maxLines: 5,
      //             decoration: InputDecoration(
      //               focusColor: Color(0xFF8ddce3),
      //               border: OutlineInputBorder(
      //                 borderRadius: BorderRadius.circular(15),
      //                 gapPadding: 1,
      //               ),
      //               hintText: 'Type your response here',
      //               contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //             ),
      //           ),
      //           const SizedBox(height: 8), // Add spacing between response field and buttons
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceAround,
      //             children: [
      //             ElevatedButton(
      //               style: ElevatedButton.styleFrom(
      //                 backgroundColor: Color(0xFF3C3C3C),
      //               ),
      //               onPressed: () {
      //                 Navigator.pop(context);
      //               },
      //               child: const Text('Close', style: TextStyle(color: Color(0xFF8ddce3))),
      //             ),
      //             ElevatedButton(
      //               style: ElevatedButton.styleFrom(
      //                 backgroundColor: Color(0xFF3C3C3C),
      //               ),
      //               onPressed: () {
      //                 sendResponse(response!);
      //                 Navigator.pop(context);
      //               },
      //               child: const Text('Send Response', style: TextStyle(color: Color(0xFF8ddce3))),
      //             ),
      //           ],)
      //         ],
      //       ),
      //     ),
      //     actions: [
      //     ],
      //   );

      //   },
      // );
      // } 
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('images/@everyone.png'),
                width: 250,
              ),
              const SizedBox(height: 20,),
               const Text(
                'Please enter your 4-digit code to view your letter',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20,),
              Form(
              key: _formKey,
              child: Column(
                children: [
                SizedBox(
                  width: 90,
                  child: TextFormField(
                    validator: (value){
                      if (value!.isEmpty){
                        return 'Please enter a code';
                      }
                      return null;
                    },
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      counterText: '',
                    ),
                    onChanged: (value){
                      setState(() {
                        code = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3C3C3C)
                  ),
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                        setState(() {
                        openLetter(code);
                      });
                    }
                  },
                  child: const Text('View Letter', style: TextStyle(color: Color(0xFF8ddce3)),),
                ),
              ],
              )
              ),
            ],
          ),
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
