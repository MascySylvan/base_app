import 'package:base_app/model/base_app_user.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
    this.switchTheme, {
    super.key,
    required this.currentUser,
    required this.logout,
  });

  final void Function() switchTheme;
  final void Function() logout;
  final BaseAppUser currentUser;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> proceedLogout() async {
    await Future.delayed(Durations.medium1);
    widget.logout();
  }

  void toLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Logout confirmation',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              proceedLogout();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: toLogout,
          icon: Icon(Icons.logout_outlined),
        ),
        actions: [
          IconButton(
            onPressed: widget.switchTheme,
            icon: Icon(Icons.brightness_6),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Text(
                'Hello \n${widget.currentUser.firstName} ${widget.currentUser.lastName}',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontSize: 50),
                textAlign: TextAlign.center,
              ),
              Text(
                'You are now one of the Fireflies',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontSize: 50),
                textAlign: TextAlign.center,
              ),
              Image.asset(
                'assets/img/logo.png',
                width: 300,
                height: 300,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
