import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat/widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;


  void _submitAuthForm(
      String email,
      String password,
      String username,
      bool isLogin,
      BuildContext context) async {
    final authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin){
        authResult = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password);

      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password);
      }

      await FirebaseFirestore.instance.collection('users')
          .doc(authResult.user.uid).set({
        'username': username,
        'email': email
      });
      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (err) {
      var message = 'Произошла ошибка, пожалуйста, проверьте свои учетные данные!';

      if (err.message != null) {
        message = err.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).errorColor,
          ));
    } on FirebaseAuthException {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Такая почта уже используеться, попробуйте другую."),
            backgroundColor: Theme.of(context).errorColor,
          ));
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading)
    );
  }
}

