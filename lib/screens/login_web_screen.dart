import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginWebScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/loginScreen.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: 
        Column(
                children: [
                  // Title
                  const Padding(
                    padding: EdgeInsets.only(top: 200.0),
                    child: Center(
                      child: Text(
                        'Budgeting App',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(5.0, 5.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Authenticate Button
                  Center(
                    child: ElevatedButton(
                      onPressed: (){context.go("/home");},
                      child: const Text('Login'),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
      ),
    );
  }
}