import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:playfield/firebase_options.dart';
import 'package:playfield/widgets/footer.dart';
import 'package:playfield/widgets/HeaderLogo.dart';

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
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final UserCredential user =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print('Logged in successfully: ${user.user}');
    } catch (e) {
      print('Error logging in: $e');
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: LoginForm(
                emailController: _emailController,
                passwordController: _passwordController,
                onLoginPressed: _signInWithEmailAndPassword,
                errorMessage: _errorMessage,
              ),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}


class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLoginPressed;
  final String errorMessage;

  const LoginForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginPressed,
    this.errorMessage = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
        SizedBox(height: 20),
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
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: onLoginPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
          child: const Text('Log In'),
        ),
        if (errorMessage.isNotEmpty)
          Text(errorMessage, style: const TextStyle(color: Colors.red)),
      ],
    );
  }
}

