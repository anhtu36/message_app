import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:message_app/pages/groupchat/group_chat_screen.dart';
import 'package:message_app/services/login/login_screen.dart';
import 'package:message_app/repository/login_auth.dart';
import 'package:message_app/utils/utils.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phoneNum = TextEditingController();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Center(
                child: Container(
                  height: size.height / 20,
                  width: size.height / 20,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(children: [
                  Container(
                    alignment: Alignment.topLeft,
                    //width: size.width / 1.2,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                  ),
                  // SizedBox(
                  //   height: size.height / 40,
                  // ),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Create new account!',
                          style: GoogleFonts.poppins(
                              color: Colors.red[900],
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Please sign in to your account',
                          style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height / 30,
                  ),
                  input(size, "UserName", _name),
                  input(size, "Phone Number", _phoneNum),
                  input(size, "Email", _email),
                  inputPassWord(size, "Password", _password),
                  SizedBox(
                    height: size.height / 20,
                  ),
                  signUpButton(size),
                  SizedBox(height: size.height / 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: GoogleFonts.poppins(color: Colors.black54),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                          },
                          child: Text(
                            "Sign in",
                            style: GoogleFonts.poppins(color: Colors.black),
                          )),
                    ],
                  ),
                ]),
              ),
      ),
    );
  }

  Widget input(Size size, String text, TextEditingController textEdit) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.2,
      padding: EdgeInsets.symmetric(horizontal: size.width / 13),
      margin: EdgeInsets.symmetric(
          horizontal: size.width / 14, vertical: size.height / 35),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(200, 168, 201, 0.3),
                blurRadius: 20,
                offset: Offset(0, 10)),
          ],
          borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: size.width / 1.5,
        child: Center(
          child: TextField(
            controller: textEdit,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: text,
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputPassWord(Size size, String text, TextEditingController textEdit) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.2,
      padding: EdgeInsets.symmetric(horizontal: size.width / 13),
      margin: EdgeInsets.symmetric(
          horizontal: size.width / 14, vertical: size.height / 35),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(200, 168, 201, 0.3),
                blurRadius: 20,
                offset: Offset(0, 10)),
          ],
          borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: size.width / 1.5,
        child: Center(
          child: TextField(
            controller: textEdit,
            obscureText: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: text,
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget signUpButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_name.text.isEmpty) {
          Utils.flushBarErrorMessage('Please enter your username !', context);
        } else if (_phoneNum.text.isEmpty) {
          Utils.flushBarErrorMessage('Please enter your phonenumber !', context);
        } else if (_email.text.isEmpty) {
          Utils.flushBarErrorMessage('Please enter your email !', context);
        } else if (_password.text.isEmpty) {
          Utils.flushBarErrorMessage('Please enter your password !', context);
        } else if (_password.text.length < 6) {
          Utils.flushBarErrorMessage(
              'Please enter at least 6 digit password!', context);
        } else if (_email.text.isEmpty && _password.text.isEmpty) {
          Utils.flushBarErrorMessage(
              'Please enter email and password!', context);
        } else {
          if (_name.text.isNotEmpty &&
              _email.text.isNotEmpty &&
              _password.text.isNotEmpty) {
            setState(() {
              isLoading = true;
            });
            createAccount(
                    _name.text, _phoneNum.text, _email.text, _password.text)
                .then((user) {
              if (user != null) {
                setState(() {
                  isLoading = false;
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => GroupChatScreen()));
                print('Account created succesfull');
              } else {
                print('Login failed');
                setState(() {
                  isLoading = false;
                });
              }
            });
          } else {
            print('Please fill the field');
          }
        }
      },
      child: Container(
        height: size.height / 14,
        width: size.width / 1.2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.red[900]),
        child: Center(
          child: Text(
            'Sign up',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w300, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
