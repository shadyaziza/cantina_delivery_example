import 'package:flutter/material.dart';
import './home.dart';
import './global_bloc.dart';
import './state_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: StreamBuilder<FirebaseUser>(
      stream: Provider.of<GlobalBloc>(context).user,
      builder: (_, AsyncSnapshot<FirebaseUser> user) {
        if (user.hasData) {
          return Home();
        } else {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Signing you in'),
                CircularProgressIndicator(),
              ],
            ),
          );
        }
      },
    ));
  }
}
