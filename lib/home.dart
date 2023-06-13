import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:peeyush/chart.dart';
import 'package:peeyush/history.dart';
import 'package:peeyush/accounts.dart';
import 'package:peeyush/profile.dart';

import 'package:peeyush/settings.dart';
import 'package:intl/intl.dart';

import 'package:peeyush/user.dart';
import 'package:peeyush/loader.dart';

bool isAuth = false;

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
final StorageReference storageRef = FirebaseStorage.instance.ref();
DateTime timestamp = DateTime.now();
String day = DateFormat('EEEE').format(timestamp);
String day1 =
    DateFormat('EEEE').format(DateTime(timestamp.year, timestamp.month, 1));
int dd = weekd.indexOf(day1);
List weekd = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];
List month = [
  "",
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];
List ld = [31, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
int x = ld[timestamp.month];
int x1 = ld[timestamp.month - 1];

final usersRef = Firestore.instance.collection('Peeyush_users');
final setRef = Firestore.instance.collection('Peeyush_settings');
final trRef = Firestore.instance.collection('Peeyush_trans');
final billRef = Firestore.instance.collection('Peeyush_bills');

User currentUser;
final datazx = MediaQueryData.fromWindow(WidgetsBinding.instance.window);

final _scaffoldKey = new GlobalKey<ScaffoldState>();

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  bool isForgot = false;
  bool signup = false;
  bool ispass = true;
  bool ischeck = false;
  final _formKey = new GlobalKey<FormState>();

  PageController pageController;
  int pageIndex = 0;

  String _errorMessage = "";

  bool isLoading;

  @override
  void initState() {
    super.initState();

    /* SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);*/

    pageController = PageController();

    fauth();
  }

  fauth() {
    check();

    _errorMessage = "";
    isLoading = false;
  }

  forgot() async {
    try {
      _firebaseAuth.sendPasswordResetEmail(email: mailController.text.trim());
    } catch (e) {
      print('Error: $e');

      setState(() {
        isLoading = false;
        _errorMessage = e.message;
      });
      funx1();
    }
  }

  check() async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    if (user != null) {
      setState(() {
        isLoading = true;
      });
      print(user.displayName);
      DocumentSnapshot doc = await usersRef.document(user.email).get();
      currentUser = User.fromDocument(doc);

      setState(() {
        isLoading = false;
        isAuth = true;
      });
    }
  }

  fun1() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("ACCOUNT CREATED",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              content: Text(
                  "EMAIL\n${mailController.text.trim()}\nPASSWORD\n${passController.text.trim()}",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ));
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }

  funx1() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              backgroundColor: _getColorFromHex("#F2F2F2"),
              title: Text("ERROR",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Poppins-Bold",
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              content: Text("$_errorMessage",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins-Regular",
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ));
  }

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (isForgot) {
          if (mailController.text.trim().isEmpty) {
            setState(() {
              _errorMessage = "";
              isLoading = true;
            });

            setState(() {
              _errorMessage = "Email is empty";
              funx1();
              isLoading = false;
            });
          } else
            _firebaseAuth
                .sendPasswordResetEmail(email: mailController.text.trim())
                .then((value) => print("ok"))
                .catchError((e) {
              print(e);
              print(e.code);
              setState(() {
                _errorMessage = e.message;
                funx1();
              });
            });

          setState(() {
            isLoading = false;
          });
        } else if (!signup) {
          AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
              email: mailController.text.trim(),
              password: passController.text.trim());
          FirebaseUser id = result.user;
          userId = id.uid;
          print('Signed in: $userId ');

          print(id.email);
          print(id.displayName);
          print(id.uid);

          {
            DocumentSnapshot doc = await usersRef.document(id.email).get();

            if (!doc.exists) {
              // 3) get username from create account, use it to make new user document in users collection
              usersRef.document(id.email).setData({
                "id": id.email,
                "name": nameController.text.trim(),
                "mobile": mobileController.text.trim()
              });

              setRef
                  .document(id.email)
                  .setData({"acc": [], "cat": [], "supp": []});

              doc = await usersRef.document(id.email).get();
            }

            currentUser = User.fromDocument(doc);
            print(currentUser);
            print(currentUser.name);
          }

          setState(() {
            isAuth = true;
          });
        } else {
          AuthResult result =
              await _firebaseAuth.createUserWithEmailAndPassword(
                  email: mailController.text.trim(),
                  password: passController.text.trim());
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          FirebaseUser id = result.user;
          userId = id.uid;
          print('Signed up user: $userId ');

          fun1();
        }
        setState(() {
          isLoading = false;
        });

        if (userId.length > 0 && userId != null && !signup) {}
      } catch (e) {
        print('Error: $e');

        setState(() {
          isLoading = false;
          _errorMessage = e.message;
        });
        funx1();
      }
    } else {
      setState(() {
        _errorMessage = "Invalid Data Entry.Entry can\'t be NULL";
      });

      funx1();

      isLoading = false;
    }
  }

  onPageChanged(int p) {
    setState(() {
      this.pageIndex = p;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 50), curve: Curves.bounceOut);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading)
      return circularProgress();
    else if (isAuth == false)
      return WillPopScope(
          // ignore: missing_return
          onWillPop: () {
            setState(() {
              if (isForgot == true) isForgot = !isForgot;
              if (signup == true) signup = !signup;
            });
          },
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Stack(children: [
                Form(
                    key: _formKey,
                    child: Container(
                        padding: EdgeInsets.all(16),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                (signup)
                                    ? "Create Account"
                                    : (isForgot)
                                        ? "Forgot Password?"
                                        : "Welcome Back,",
                                style: TextStyle(
                                    fontSize: 33,
                                    fontFamily: "Poppins-Regular")),
                            (signup)
                                ? Container(height: 0)
                                : Text(
                                    (isForgot)
                                        ? "Enter Email to reset password"
                                        : "Log In to continue",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontFamily: "Poppins-Regular")),
                            Container(height: 30),
                            (signup == false)
                                ? Container(height: 0)
                                : Column(children: [
                                    Container(
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        color: Colors.grey[200],
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 0.0,
                                            spreadRadius: 0.0,
                                            offset: Offset(0,
                                                -1), // shadow direction: bottom right
                                          )
                                        ],
                                      ),
                                      child: TextFormField(
                                        autofocus: false,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: "Poppins-Regular"),
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          contentPadding: EdgeInsets.only(
                                              top: 10,
                                              right: 10,
                                              bottom: 10,
                                              left: 30),
                                          hintText: "Name",
                                          hintStyle: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: "Poppins-Regular"),
                                        ),
                                      ),
                                    ),
                                    Container(height: 5)
                                  ]),
                            Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.grey[200],
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(0,
                                        -1), // shadow direction: bottom right
                                  )
                                ],
                              ),
                              child: TextFormField(
                                autofocus: false,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: "Poppins-Regular"),
                                controller: mailController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      top: 10, right: 10, bottom: 10, left: 30),
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "Poppins-Regular"),
                                ),
                              ),
                            ),
                            Container(height: 5),
                            (isForgot)
                                ? Container(height: 0, width: 0)
                                : Container(
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: Colors.grey[200],
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 0.0,
                                          spreadRadius: 0.0,
                                          offset: Offset(0,
                                              -1), // shadow direction: bottom right
                                        )
                                      ],
                                    ),
                                    child: TextFormField(
                                      autofocus: false,
                                      obscureText: ispass,
                                      obscuringCharacter: '*',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "Poppins-Regular"),
                                      controller: passController,
                                      decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          contentPadding: EdgeInsets.only(
                                              top: 10,
                                              right: 10,
                                              bottom: 10,
                                              left: 30),
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: "Poppins-Regular"),
                                          suffixIcon: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  ispass = !ispass;
                                                });
                                              },
                                              child: Icon(
                                                  (ispass == true)
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Colors.grey))),
                                    ),
                                  ),
                            (signup == false)
                                ? Container(height: 0)
                                : Column(children: [
                                    Container(
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        color: Colors.grey[200],
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 0.0,
                                            spreadRadius: 0.0,
                                            offset: Offset(0,
                                                -1), // shadow direction: bottom right
                                          )
                                        ],
                                      ),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        autofocus: false,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: "Poppins-Regular"),
                                        controller: mobileController,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                            borderSide: BorderSide(
                                                color: Colors.transparent),
                                          ),
                                          contentPadding: EdgeInsets.only(
                                              top: 10,
                                              right: 10,
                                              bottom: 10,
                                              left: 30),
                                          hintText: "Mobile Number",
                                          hintStyle: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: "Poppins-Regular"),
                                        ),
                                      ),
                                    ),
                                  ]),
                            (signup)
                                ? Transform.translate(
                                    offset: const Offset(-12, -12),
                                    child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 0, right: 8),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Transform.translate(
                                                  offset: const Offset(13, 0),
                                                  child: Transform.scale(
                                                      scale: 0.7,
                                                      child: Checkbox(
                                                        value: ischeck,
                                                        onChanged:
                                                            (bool value) {
                                                          setState(() {
                                                            ischeck = !ischeck;
                                                          });
                                                        },
                                                      ))),
                                              Text("I agree with our ",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Poppins-Regular",
                                                      fontSize: 12)),
                                              Text("Terms ",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Poppins-Regular",
                                                      color: Colors.blue,
                                                      fontSize: 12)),
                                              Text("and ",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Poppins-Regular",
                                                      fontSize: 12)),
                                              Text("Conditions ",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Poppins-Regular",
                                                      color: Colors.blue,
                                                      fontSize: 12)),
                                            ])))
                                : (isForgot)
                                    ? Container(height: 0, width: 0)
                                    : Padding(
                                        padding:
                                            EdgeInsets.only(left: 8, right: 32),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                  child: Text(
                                                      "Forgot your password?",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Poppins-Regular",
                                                          fontSize: 12)),
                                                  onTap: () {
                                                    /*   try {
                                            _firebaseAuth
                                                .sendPasswordResetEmail(
                                                    email: mailController.text
                                                        .trim());
                                          } catch (e) {
                                            print("error : $e");
                                          }*/

                                                    setState(() {
                                                      isForgot = !isForgot;
                                                    });
                                                  })
                                            ])),
                            Container(height: 100),
                            Container(
                              padding: EdgeInsets.all(4),
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: RaisedButton(
                                onPressed: () {
                                  validateAndSubmit();
                                },
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                                color: Colors.blue[800],
                                child: Text(
                                  (signup == false)
                                      ? (isForgot)
                                          ? "Reset Password"
                                          : "Log In"
                                      : "Sign Up",
                                  style: TextStyle(
                                    fontFamily: "Poppins-Regular",
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                            (isForgot)
                                ? Container(height: 0, width: 0)
                                : Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              (signup == false)
                                                  ? "Don't have an account? "
                                                  : "Already have an account? ",
                                              style: TextStyle(
                                                  fontFamily: "Poppins-Regular",
                                                  fontSize: 15,
                                                  color: Colors.grey[700])),
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  signup = !signup;
                                                });
                                              },
                                              child: Text(
                                                  (signup == false)
                                                      ? "Sign Up"
                                                      : "Log In",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Poppins-Regular",
                                                      fontSize: 15,
                                                      color: Colors.blue)))
                                        ])),
                          ],
                        )))),
                (isForgot == false)
                    ? Container(height: 0, width: 0)
                    : Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: FlatButton.icon(
                            label: Text(""),
                            onPressed: () {
                              setState(() {
                                isForgot = !isForgot;
                              });
                            },
                            icon: Row(
                              children: [
                                Image.asset('images/Arrow.png',
                                    width: 18, height: 20),
                                Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text("Log In",
                                        style: TextStyle(
                                            fontFamily: "Poppins-Regular",
                                            fontSize: 15,
                                            color: Colors.blue[800])))
                              ],
                            )))
              ])));
    else if (isAuth == true)
      return Scaffold(
        body: GestureDetector(
          child: PageView(
            children: <Widget>[
              Chart(),
              Account(),
              History(),
              Settings(),
              Container(),
              Container(),
            ],
            controller: pageController,
            onPageChanged: onPageChanged,
            physics: NeverScrollableScrollPhysics(),
          ),
          onHorizontalDragEnd: (dragEndDetails) {
            if (dragEndDetails.primaryVelocity < 0 && pageIndex <= 2) {
              // Page forwards
              print('Move page forwards');
              onTap(pageIndex + 1);
            } else if (dragEndDetails.primaryVelocity > 0) {
              // Page backwards
              print('Move page backwards');
              onTap(pageIndex - 1);
            }
          },
        ),
        bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            child: Container(
                height: 70,
                color: Colors.grey[400],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    (pageIndex == 0)
                        ? Container(
                            width: 120.0,
                            height: 48.0,
                            alignment: Alignment.center,
                            child: RaisedButton(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset('images/Home1.png',
                                        height: 20, width: 19),
                                    Text(
                                      "Home",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: "Poppins-Regular"),
                                    )
                                  ]),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              color: Colors.blue[800],
                              onPressed: () {
                                onTap(0);
                              },
                            ))
                        : GestureDetector(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child:
                                    Image.asset('images/Home.png', height: 24)),
                            onTap: () {
                              onTap(0);
                            }),
                    (pageIndex == 1)
                        ? Container(
                            width: 140.0,
                            height: 48.0,
                            alignment: Alignment.center,
                            child: RaisedButton(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset('images/File.png',
                                        width: 18, height: 20),
                                    Text(
                                      "Accounts",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: "Poppins-Regular"),
                                    )
                                  ]),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              color: Colors.blue[800],
                              onPressed: () {
                                onTap(1);
                              },
                            ))
                        : GestureDetector(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Image.asset('images/Accounts.png',
                                    height: 24)),
                            onTap: () {
                              onTap(1);
                            }),
                    (pageIndex == 2)
                        ? Container(
                            width: 120.0,
                            height: 48.0,
                            alignment: Alignment.center,
                            child: RaisedButton(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset('images/Icon.png',
                                        width: 20, height: 20),
                                    Text(
                                      "History",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins-Regular"),
                                    )
                                  ]),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              color: Colors.blue[800],
                              onPressed: () {
                                onTap(2);
                              },
                            ))
                        : GestureDetector(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Image.asset('images/History.png',
                                    height: 24)),
                            onTap: () {
                              onTap(2);
                            }),
                    (pageIndex == 3)
                        ? Container(
                            width: 140.0,
                            height: 48.0,
                            alignment: Alignment.center,
                            child: RaisedButton(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image.asset('images/Setting1.png',
                                        height: 20),
                                    Text(
                                      "Settings",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Poppins-Regular"),
                                    )
                                  ]),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              color: Colors.blue[800],
                              onPressed: () {
                                onTap(3);
                              },
                            ))
                        : GestureDetector(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Image.asset('images/Setting.png',
                                    height: 24)),
                            onTap: () {
                              onTap(3);
                            })
                  ],
                ))),
        drawer: Drawer(
            child: ListView(
          children: [
            DrawerHeader(
                margin: EdgeInsets.only(bottom: 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[500],
                          child: Text("${currentUser.name[0]}",
                              style: TextStyle(
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Poppins-Regular")),
                        ),
                      ),
                      Center(
                        child: Text("${currentUser.name.split(" ")[0]}",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: "Poppins-Regular")),
                      ),
                    ])),
            Container(height: 50),
            FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(width: 40, height: 30),
                Image.asset('images/icona1.png', height: 24),
                Container(width: 20),
                Text("Profile",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: "Poppins-Regular")),
              ]),
            ),
            FlatButton(
              onPressed: () {},
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(width: 40, height: 30),
                Image.asset('images/icona.png', height: 24),
                Container(width: 20),
                Text("Help",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: "Poppins-Regular")),
              ]),
            ),
            FlatButton(
              onPressed: () {},
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(width: 40, height: 30),
                Image.asset('images/Edit.png', height: 24),
                Container(width: 20),
                Text("Feedback",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: "Poppins-Regular")),
              ]),
            ),
            FlatButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      Future.delayed(Duration(seconds: 3), () {
                        Navigator.of(context).pop(true);
                      });
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: new Text("Logging out!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        content: Container(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          ),
                        ),
                      );
                    });

                Future.delayed(Duration(seconds: 3), () {
                  _firebaseAuth.signOut();

                  setState(() {
                    isAuth = false;
                  });
                });

                setState(() {
                  pageIndex = 0;
                });
              },
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(width: 40, height: 30),
                Image.asset('images/Login.png', height: 24),
                Container(width: 20),
                Text("Log Out",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: "Poppins-Regular")),
              ]),
            ),
            FlatButton(
              onPressed: () {},
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(width: 40, height: 30),
                Image.asset('images/trash-can.png', height: 24),
                Container(width: 20),
                Text("Delete Account",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: "Poppins-Regular")),
              ]),
            ),
          ],
        )),
        key: _scaffoldKey,
      );
  }
}

appTitle(x) {
  if (x == 0)
    return "Charts";
  else if (x == 1)
    return "Daily Accounts";
  else if (x == 2)
    return "History";
  else if (x == 3) return "Settings";
}
