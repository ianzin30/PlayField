import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:playfield/firebase_options.dart';
import 'package:playfield/widgets/HeaderLogo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MatchHive',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  String _errorMessage = '';

  Future<void> _signUpWithEmailAndPassword() async {
    try {
      final UserCredential user =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Check if the user is not null
      if (user.user != null) {
        // Add the username to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.user!.uid)
            .set({
          'username': _usernameController.text.trim(),
          'email': _emailController.text.trim(),
        });
      }

      print('Signed up and data set successfully: ${user.user}');
    } catch (e) {
      print('Error signing up: $e');
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: HeaderLogo(),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.10),
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: LoginForm(
                emailController: _emailController,
                passwordController: _passwordController,
                usernameController: _usernameController,
                onLoginPressed: _signUpWithEmailAndPassword,
                errorMessage: _errorMessage,
              ),
              
            ),
            TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Go Back', style: TextStyle(color: Colors.white)),
          ),
          
          
        ],
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController usernameController;
  final VoidCallback onLoginPressed;
  final String errorMessage;

  const LoginForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.usernameController,
    required this.onLoginPressed,
    this.errorMessage = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            hintText: 'Username',
            fillColor: Colors.grey[850],
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),  
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Email',
            fillColor: Colors.grey[850],
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            fillColor: Colors.grey[850],
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        ElevatedButton(
          onPressed: onLoginPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
          child: const Text('Sign Up'),
        ),
        if (errorMessage.isNotEmpty)
          Text(errorMessage, style: const TextStyle(color: Colors.red)),
      ],
    );
  }
}
