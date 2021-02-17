import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;




GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);


class Login1 extends StatefulWidget {
  @override
  _UserLogin1State createState() => _UserLogin1State();
}

class _UserLogin1State extends State<Login1> {
   bool _agreedToTOS = true;
   GoogleSignInAccount _currentUser;
  String _contactText;
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
      '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }
  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }
   Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 90.0, 0.0, 0.0),
                    child: Text('Welcome to Zappkode',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold)),
                  ),
                  
                  
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                         icon:  Icon(Icons.email,color: Color.fromRGBO(17,52, 102, 1),),
                          labelText: 'EMAIL',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                              
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color.fromRGBO(17,52, 102, 1)))),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      decoration: InputDecoration(
                         icon:  Icon(Icons.security,color: Color.fromRGBO(17,52, 102, 1)),
                          labelText: 'PASSWORD',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color.fromRGBO(17,52, 102, 1)))),
                      obscureText: true,
                    ),
                    Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: <Widget>[ 
                Checkbox(
                  value: _agreedToTOS,
                  activeColor: Color.fromRGBO(17, 52, 102, 1),
                  onChanged: _setAgreedToTOS,
                ),
                GestureDetector(
                  onTap: () => _setAgreedToTOS(!_agreedToTOS),
                  child: const Text(
                    'Remember Me', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
 
                   
                    SizedBox(height: 5),
                    Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Color.fromRGBO(63, 81, 181, 1),
                        color: Color.fromRGBO(17, 52, 102, 1),
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: () {
                            
                          },
                          child: Center(
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Color.fromRGBO(63, 81, 181, 1),
                        color: Color.fromRGBO(17, 52, 102, 1),
                        elevation: 7.0,
                        child: GestureDetector(
                          onTap: 
                            _handleSignIn
                          ,
                          child: Center(
                            child: Text(
                              'Login with Google',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    ),
                
                  ],
                )),
          
          ],
        ));
  }
  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }
}

