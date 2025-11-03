import 'package:base_app/model/base_app_user.dart';
import 'package:base_app/service/login_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen(
    this.switchTheme,
    this.successfulRegistration,
    this.successMessage, {
    super.key,
    required this.goToHome,
    required this.goToRegister,
  });

  final void Function() switchTheme;
  final bool successfulRegistration;
  final String successMessage;
  final void Function(BaseAppUser) goToHome;
  final void Function() goToRegister;

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
  var successfulRegistratioTemp = true;

  void login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isSending = true;
      });

      formKey.currentState!.save();

      final loginUser = await loginService.loginRequest(
        context: context,
        username: enteredUsername,
        password: enteredPassword,
      );

      setState(() {
        isSending = false;
      });

      if (loginUser != null) {
        widget.goToHome(loginUser);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.successfulRegistration && successfulRegistratioTemp) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            content: Text(widget.successMessage),
          ),
        );
      });

      setState(() {
        successfulRegistratioTemp = false;
      });
    }

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
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
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
                onPressed: isSending ? null : widget.goToRegister,
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
