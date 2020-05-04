// import "package:flutter/material.dart";

// import 'package:flutter_sakeshochu/action/authentication.dart';
// // import 'package:flutter_app/src/view/index.dart';
// import 'package:flutter_sakeshochu/src/controller/index.dart';

// /// StatefulWidget class to keep track of user input
// class Login extends StatefulWidget {
//   Login({Key key}) : super(key: key);
//   @override
//   _MyApp createState() => _MyApp();
// }

// /// Required field
// class LoginData {
//   String username = "";
//   String pin = "";
// }

// /// The Login UI contains
// class _MyApp extends State {
//   LoginData _loginData = new LoginData();

//   /// Needed for MVC model program
//   // static View v = View();

//   /// Needed for MVC model program
//   static Model m = Model();

//   /// Needed for MVC model program
//   Controller c = Controller(m, v);
//   // Used when login credentials doesnt match
//   var err = '';
//   GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext inContext) {
//     print('Login');
//     return MaterialApp(
//         home: Scaffold(
//             body: Container(
//                 padding: EdgeInsets.all(50.0),
//                 child: Form(
//                     key: this._formKey,
//                     child: Column(children: [
//                       Text(
//                         'Login',
//                         style: TextStyle(height: 3, fontSize: 80),
//                       ),
//                       TextFormField(
//                           keyboardType: TextInputType.emailAddress,
//                           validator: (String inValue) {
//                             if (inValue.length == 0) {
//                               return "Please enter username";
//                             }
//                             return null;
//                           },
//                           onSaved: (String inValue) {
//                             this._loginData.username = inValue;
//                           },
//                           decoration: InputDecoration(
//                               hintText: "username", labelText: "Username")),
//                       TextFormField(
//                           obscureText: true,
//                           keyboardType: TextInputType.number,
//                           validator: (String inValue) {
//                             if (inValue.length != 4) {
//                               return "Pin must be ==4 in length";
//                             }
//                             return null;
//                           },
//                           onSaved: (String inValue) {
//                             this._loginData.pin = inValue;
//                           },
//                           decoration: InputDecoration(
//                               hintText: "Pin", labelText: "Pin")),
//                       Text(err, style: TextStyle(color: Colors.red)),
//                       RaisedButton(
//                           child: Text("Log In!"),
//                           onPressed: () async {
//                             if (_formKey.currentState.validate()) {
//                               _formKey.currentState.save();
//                               if (await c.login(
//                                       _loginData.username, _loginData.pin) ==
//                                   true) {
//                                 Navigator.pushNamed(context, 'createQuiz',
//                                     arguments: {'c': c});
//                               } else {
//                                 setState(() {
//                                   err = c.getReason;
//                                 });
//                                 return false;
//                               }
//                             } else {
//                               return false;
//                             }
//                           })
//                     ])))));
//   }
// }