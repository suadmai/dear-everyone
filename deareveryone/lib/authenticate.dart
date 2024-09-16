import 'package:everyone/adminPage.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  final password = '122333444444firdaus55555666666';
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  
      Center(
        child: 
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Uh oh!',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 20),
              const Text(
                'Please enter password to continue:',
                style: TextStyle(fontSize: 20),
              ),
              Form(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        
                        ),
                        labelText: 'Password',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                              if(passwordController.text == password){
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AdminPage(),
                                ),
                              );
                            }
                            else{
                              const SnackBar(content: Text('Incorrect password'));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3C3C3C)
                        ),
                          child: const Text('Authenticate', style: TextStyle(color: Color(0xFF8ddce3)),),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3C3C3C)
                        ),
                          child: const Text('Go Back', style: TextStyle(color: Color(0xFF8ddce3)),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
