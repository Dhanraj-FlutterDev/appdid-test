import 'package:appdid_test/screens/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userPhone = TextEditingController();
  String? phoneNumber, verificationId;
  String? otp, authStatus = "";
  var prefs;

  Future<void> verifyPhoneNumber(BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91' + userPhone.text.trim(),
      timeout: const Duration(seconds: 15),
      verificationCompleted: (AuthCredential authCredential) {
        setState(() {
          authStatus = "Your account is successfully verified";
        });
      },
      verificationFailed: (FirebaseAuthException authException) {
        setState(() {
          authStatus = "Authentication failed";
        });
      },
      // codeSent: (String verId, [int forceCodeResent]) {
      //   verificationId = verId;
      //   setState(() {
      //     authStatus = "OTP has been successfully send";
      //   });
      //   otpDialogBox(context).then((value) {});
      // },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
        setState(() {
          authStatus = "TIMEOUT";
        });
      },
      codeSent: (String verId, int? forceResendingToken) {
        verificationId = verId;
        setState(() {
          authStatus = "OTP has been successfully send";
        });
        otpDialogBox(context).then((value) {});
      },
    );
  }

  otpDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter your OTP'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                ),
                onChanged: (value) {
                  otp = value;
                },
              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  signIn(otp!);
                },
                child: Text(
                  'Submit',
                ),
              ),
            ],
          );
        });
  }

  Future<void> signIn(String otp) async {
    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: otp,
    ));
  }

  final sharePref = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: userPhone,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              decoration:
                  const InputDecoration(hintText: 'Enter 10 digit phone'),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => Homescreen()));

                // final prefs = await SharedPreferences.getInstance();
                // prefs.setString('Login', 'loggedIN');
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(builder: (context) => Homescreen()),
                //     (route) => false);
                if (userPhone.text.isNotEmpty) {
                  verifyPhoneNumber(context);
                } else {
                  print('Enter Phone');
                }
              },
              child: const Text('Login'),
            ),
          )
        ],
      ),
    );
  }
}
