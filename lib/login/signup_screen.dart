import 'package:base_app/service/login_service.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen(this.switchTheme, {super.key, required this.successRegister, required this.cancelRegister});

  final void Function() switchTheme;
  final void Function(String) successRegister;
  final void Function() cancelRegister;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final loginService = LoginService();
  final formKey = GlobalKey<FormState>();
  bool showPassword = false;
  var enteredUsername = '';
  var enteredPassword = '';
  var enteredFirstname = '';
  var enteredLastName = '';
  var isSending = false;

  void register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isSending = true;
      });

      formKey.currentState!.save();

      final newUser = await loginService.register(
        context: context,
        username: enteredUsername,
        password: enteredPassword,
        firstName: enteredFirstname,
        lastName: enteredLastName,
      );

      setState(() {
        isSending = false;
      });

      if (newUser != null) {
        widget.successRegister(newUser);
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
                width: 200,
                height: 200,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),

              //LABEL
              Text(
                'Become a Firefly',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontSize: 30),
                textAlign: TextAlign.center,
              ),

              //USERNAME INPUT
              TextFormField(
                maxLength: 50,
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

              //FIRSTNAME INPUT
              TextFormField(
                maxLength: 50,
                style: Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                  label: Text('First Name'),
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
                    return 'Kindly enter your first name';
                  }

                  return null;
                },
                onSaved: (value) {
                  enteredFirstname = value!;
                },
              ),

              //LASTNAME INPUT
              TextFormField(
                maxLength: 50,
                style: Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                  label: Text('Last Name'),
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
                    return 'Kindly enter your last name';
                  }

                  return null;
                },
                onSaved: (value) {
                  enteredLastName = value!;
                },
              ),

              //LOGIN BUTTON
              ElevatedButton(
                onPressed: isSending ? null : register,
                child: isSending
                    ? SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(),
                      )
                    : Text('Signup'),
              ),

              //SIGNUP BUTTON
              TextButton(
                onPressed: isSending ? null : widget.cancelRegister,
                child: Text('Cancel'),
              ),

              //--
            ],
          ),
        ),
      ),
    );
  }
}
