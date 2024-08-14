import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_app/auth.dart';
import 'package:football_app/constants.dart';
import 'package:football_app/screens/about.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import 'dart:developer';
import 'package:football_app/screens/main_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _checkInitialSignInState();
  }

  void _checkInitialSignInState() async {
    var currentUser = await _auth.getCurrentUser();
    if (currentUser != null) {
      setState(() {
        _isUserSignedIn = true;
      });
    }
  }

  final _auth = AuthService();
  bool _isUserSignedIn = false;

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
  }

  void _onSignIn(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign in'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  controller: _email,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _password,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _rest(context);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Forgot password?'),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 60,
                ),
                ElevatedButton(
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: _login),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    child: const Text('Create account now!'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _onSignUp(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        );
      },
    );
  }

  void _onSignUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Sign Up'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  controller: _email),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                keyboardType: TextInputType.name,
                controller: _name,
              ),
              TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _password),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: _signup,
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  child: const Text('Already have an account? Sign in now!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _onSignIn(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _rest(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Reset password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  controller: _email),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text(
                  'Reset',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () => resetpassword(context),
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  child: const Text(''),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _onSignIn(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'assets/images/file_0bfae61b-c268-48f2-9476-268a438e946c.png',
          height: 60,
          width: 60,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the text
          children: [
            const Text("Settings", style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: kprimaryColor, // Set background color to kprimaryColor
        centerTitle: true,
        actions: [
          // Add an empty action if you want to balance the leading IconButton
          IconButton(
            icon: const Icon(null), // invisible icon or container
            onPressed: null,
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 10), // Add space between AppBar and cards
          Card(
            elevation: 4.0,
            margin: const EdgeInsets.all(8.0),
            color: kprimaryColor,
            child: ListTile(
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(_isUserSignedIn
                  ? 'Welcome '
                  : 'Tab Sign in To  Enter An Account'),
              trailing: ElevatedButton(
                child: Text(_isUserSignedIn ? 'Sign out' : 'Sign in',
                    style: TextStyle(color: Colors.black)),
                onPressed: () =>
                    _isUserSignedIn ? _signOut() : _onSignIn(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isUserSignedIn ? Color.fromARGB(255, 216, 56, 45) : null,
                ),
              ),
            ),
          ),
          Card(
            elevation: 4.0,
            margin: const EdgeInsets.all(8.0),
            color: kprimaryColor,
            child: ListTile(
              title: const Text(
                'About',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => SPLPage()));
              },
            ),
          ),
          Card(
            elevation: 4.0,
            margin: const EdgeInsets.all(8.0),
            color: kprimaryColor,
            child: ListTile(
              title: const Text(
                'Contact Us',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Tap to send an email',
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    Uri uri = Uri.parse(
                        'mailto:appgpfootball@gmail.com?subject=This is Subject');
                    if (await launcher.launchUrl(uri)) ;
                    debugPrint('fgdfgfd');
                  }),
            ),
          ),
        ],
      ),
    );
  }

  goToProfile(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(),
      ));

  goToHome(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(),
      ));

  _login() async {
    try {
      final user = await _auth.loginUserWithEmailAndPassword(
          _email.text, _password.text);
      if (user != null) {
        log("User Logged In");

        setState(() {
          _isUserSignedIn = true;
        });
        goToHome(context);
      }
    } catch (e) {
      //log("Something went wrong: $e");
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                'your email or password is not correct',
                style: TextStyle(color: Colors.red),
              ),
            );
          });

      return null;
    }
  }

  _signup() async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(
          _email.text, _password.text);
      if (user != null) {
        log("User Created Successfully");
        setState(() {
          _isUserSignedIn = true;
        });
        goToHome(context);
      }
    } on FirebaseAuthException catch (e) {
      log("Something went wrong: $e");

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                e.message.toString(),
                style: TextStyle(color: Colors.red),
              ),
            );
          });
    }
  }

  void _signOut() async {
    await _auth.signout();
    log("User Sign Out");

    setState(() {
      _isUserSignedIn = false;
    });
    goToHome(context);
  }

  Future<void> resetpassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _email.text.trim());
      Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Password reset link sent! Check your email.'),
            );
          });
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again later.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      }

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(errorMessage),
            );
          });
      log('Error resetting password: ${e.code}, ${e.message}'); // Log the error code and message for debugging
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Failed to send reset email. Please try again.'),
            );
          });
      log('Unknown error: $e'); // Log unexpected errors
    }
  }

  void _restpass() async {
    try {
      // await _auth.passwordRest(_email.text.trim());
      goToProfile(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('password rest link sent! Check your email'),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }
}
