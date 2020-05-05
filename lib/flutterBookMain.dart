import 'package:flutter/material.dart';
import 'appointments/Appointments.dart';
import 'contacts/Avatar.dart';
import 'contacts/Contacts.dart';
import 'travelpictures/Pictures.dart';
import 'tasks/Tasks.dart';
import 'travelpictures/TravelPictures.dart';
import 'notes/Notes.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class FlutterBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return 
    // Scaffold(

  //  home: 
   return DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Ken Amamori'),
              actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return FlatButton(
              child: const Text('Sign out'),
              textColor: Theme.of(context).buttonColor,
              onPressed: () async {
                final FirebaseUser user = await _auth.currentUser();
                if (user == null) {
                  Scaffold.of(context).showSnackBar(const SnackBar(
                    content: Text('No one has signed in.'),
                  ));
                  return;
                }
                _signOut(context);
                final String uid = user.uid;
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(uid + ' has successfully signed out.'),
                ));
              },
            );
          })
        ],
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.date_range), text: 'Appointments'),
                  Tab(icon: Icon(Icons.contacts), text: 'Contacts'),
                  Tab(icon: Icon(Icons.note), text: 'Notes'),
                  Tab(icon: Icon(Icons.assignment_turned_in), text: 'Tasks'),
                  Tab(icon: Icon(Icons.photo_library), text: 'TravelPic')
                ]
              )
            ),
            body: TabBarView(
                children: [
                  Appointments(),
                  Contacts(),
                  Notes(),
                  Tasks(),
                  TravelPictures()
                ]
            )
          )
      );
  }
  // Example code for sign out.
  void _signOut(context) async {
    await _auth.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}