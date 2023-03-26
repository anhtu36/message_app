import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:message_app/pages/groupchat/group_chat_screen.dart';
import 'package:message_app/services/add_member.dart';
import 'package:message_app/services/login/create_account.dart';
import 'package:message_app/repository/login_auth.dart';
import 'package:message_app/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                child: SizedBox(
                  height: size.height / 20,
                  width: size.height / 20,
                  child: const CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: size.height / 20),
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.asset('assets/images/fire-station.png'),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 30,
                    ),
                    Center(
                      child: Text(
                        'Fire SOS',
                        style: GoogleFonts.poppins(
                            color: Colors.red[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 40),
                      ),
                    ),
                    // SizedBox(
                    //   height: size.height /30,
                    // ),
                    inputEmail(size, "Email", _email),
                    inputPassword(size, "Password", _password),
                    SizedBox(
                      height: size.height / 15,
                    ),
                    loginButton(size),
                    SizedBox(height: size.height / 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.poppins(color: Colors.black54),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const CreateAccount(),
                              ));
                            },
                            child: Text(
                              "Sign up",
                              style: GoogleFonts.poppins(color: Colors.black),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget inputEmail(Size size, String text, TextEditingController textEdit) {
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

  Widget inputPassword(Size size, String text, TextEditingController textEdit) {
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

  Widget loginButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_email.text.isEmpty && _password.text.isEmpty) {
          Utils.flushBarErrorMessage('Please enter your email and password !', context);
        } else if (_email.text.isEmpty) {
          Utils.flushBarErrorMessage('Please enter your email !', context);
        }else if (_password.text.isEmpty) {
          Utils.flushBarErrorMessage(
              'Please enter your password !', context);
        } else if (_password.text.length < 6) {
          Utils.flushBarErrorMessage(
              'Please enter at least 6 digit password !', context);
        }  else {
          if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
            setState(() {
              isLoading = true;
            });
            signIn(_email.text, _password.text).then((user) {
              if (user != null) {
                print('Login scessfull');
                setState(() {
                  isLoading = false;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GroupChatScreen(),
                    ));
              } else {
                print('Login failed');
                setState(() {
                  isLoading = false;
                });
              }
            });
          } else {
            print('Please fill the form correctly');
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
            'Sign in',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w300, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
