import 'package:base_app/service/login_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen(this.switchTheme, {super.key});

  final void Function() switchTheme;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginService = LoginService();
  final formKey = GlobalKey<FormState>();
  bool showPassword = false;
  var enteredUsername = '';
  var enteredPassword = '';
  var isSending = false;

  void login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isSending = true;
      });

      formKey.currentState!.save();

      final uri = Uri.https(
        '17bckriqx0.execute-api.ap-southeast-2.amazonaws.com',
        '/prod/login',
        {
          'username': enteredUsername.trim(),
          'password': enteredPassword.trim(),
        },
      );

      final response = await http.get(uri);

      if (!context.mounted) {
        return;
      }

      if (response.statusCode >= 400) {
        final Map<String, dynamic>? responseBody = jsonDecode(
          response.body,
        );

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Login failed.',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              responseBody != null ? responseBody['message'] : 'Internal Server Error',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );

        setState(() {
          isSending = false;
        });
      } else {
        setState(() {
          isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: widget.switchTheme,
            icon: Icon(Icons.brightness_6),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Padding(
        padding: EdgeInsets.all(75),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              //--

              //LOGO
              Image.asset(
                'assets/img/logo.png',
                width: 300,
                height: 300,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),

              //USERNAME INPUT
              TextFormField(
                style: Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                  label: Text('Username'),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      width: 5,
                    ),
                  ),
                ),
                enabled: !isSending,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kindly enter your username';
                  }

                  return null;
                },
                onSaved: (value) {
                  enteredUsername = value!;
                },
              ),

              //PASSWORD INPUT
              TextFormField(
                style: Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                  label: Text('Password'),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: showPassword
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      width: 5,
                    ),
                  ),
                ),
                enabled: !isSending,
                obscureText: !showPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kindly enter your password';
                  }

                  return null;
                },
                onSaved: (value) {
                  enteredPassword = value!;
                },
              ),

              //LOGIN BUTTON
              ElevatedButton(
                onPressed: isSending ? null : login,
                child: isSending
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(),
                      )
                    : Text('Login'),
              ),

              //SIGNUP BUTTON
              TextButton(
                onPressed: isSending ? null : () {},
                child: Text('Does not have an account yet? Sign Up now!'),
              ),

              //--
            ],
          ),
        ),
      ),
    );
  }
}
