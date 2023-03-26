import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:message_app/pages/groupchat/create_group/new_group.dart';
import 'package:message_app/pages/groupchat/group_chat_screen.dart';
import 'package:message_app/utils/utils.dart';

class AddMemberWhenCreateGroup extends StatefulWidget {
  const AddMemberWhenCreateGroup({super.key});

  @override
  State<AddMemberWhenCreateGroup> createState() =>
      _AddMemberWhenCreateGroupState();
}

class _AddMemberWhenCreateGroupState extends State<AddMemberWhenCreateGroup> {
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> membersList = [];
  bool isLoading = false;
  Map<String, dynamic>? userMap;

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }

  void getCurrentUserDetails() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((userMap) {
      setState(() {
        membersList.add({
          "name": userMap['name'],
          "phoneNum": userMap['phoneNum'],
          "email": userMap['email'],
          "uid": userMap['uid'],
          "isAdmin": true,
        });
      });
    });
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("phoneNum", isEqualTo: _search.text) //email
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        setState(() {
          userMap = value.docs.first.data();
          userMap?.addAll({
            "uid": value.docs.first.id,
          });
          isLoading = false;
        });
      }
      print(userMap);
    });
  }

  void onResultTap() {
    bool isAlreadyExist = false;

    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == userMap!['uid']) {
        isAlreadyExist = true;
        break; //suggest break when found exist
      }
    }

    if (!isAlreadyExist) {
      setState(() {
        membersList.add({
          "name": userMap!['name'],
          "phoneNum": userMap!['phoneNum'],
          "email": userMap!['email'],
          "uid": userMap!['uid'],
          "isAdmin": false,
        });

        userMap = null;
      });
    }
  }

  void onRemoveMembers(int index) {
    if (membersList[index]['uid'] != _auth.currentUser!.uid) {
      setState(() {
        membersList.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const GroupChatScreen(),
              ));
            },
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 25,
            )),
        title: const Text("Add Members"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Container(
                width: size.width / 1.1,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(200, 168, 201, 0.3),
                          blurRadius: 20,
                          offset: Offset(0, 10)),
                    ],
                    borderRadius: BorderRadius.circular(20)),
                child: ListView.builder(
                  itemCount: membersList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => onRemoveMembers(index),
                      leading: Icon(
                        Icons.account_circle,
                        color: Colors.red[900],
                        size: 40,
                      ),
                      title: Text(membersList[index]['name']),
                      subtitle: Text(membersList[index]['email']),
                      trailing: Icon(Icons.close, color: Colors.red[900]),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              height: size.height / 16,
              width: size.width / 1.2,
              alignment: Alignment.center,
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
                width: size.width / 1.2,
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: Colors.grey.shade500,
                    hintText: "Phone number search",
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height / 50,
            ),
            InkWell(
              onTap: () {
                if (_search.text.isEmpty) {
                  Utils.snackBar('Please enter the phonenumber', context);
                } else {
                  onSearch();
                }
              },
              child: Container(
                height: size.height / 18,
                width: size.width / 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red[900],
                ),
                child: Center(
                  child: Text('Search',
                      style: GoogleFonts.poppins(color: Colors.white)),
                ),
              ),
            ),
            SizedBox(
              height: size.height / 30,
            ),
            userMap != null
                ? GestureDetector(
                    onTap: () {
                      onResultTap();
                    },
                    child: Container(
                      width: size.width / 1.1,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(200, 168, 201, 0.3),
                                blurRadius: 20,
                                offset: Offset(0, 10)),
                          ],
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        leading: Icon(Icons.account_circle_rounded,
                            color: Colors.red[900], size: 40),
                        title: Text(userMap!['name']),
                        subtitle: Text(userMap!['email']),
                        trailing: Text('Add',
                            style: GoogleFonts.poppins(
                                color: Colors.red[900],
                                fontWeight: FontWeight.w500,
                                fontSize: 16)),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
      floatingActionButton: membersList.length >= 2
          ? FloatingActionButton(
              backgroundColor: Colors.red[900],
              child: const Tooltip(
                  message: "Create group",
                  child: Icon(
                    Icons.forward,
                    color: Colors.white,
                  )),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CreateGroup(
                    membersList: membersList,
                  ),
                ),
              ),
            )
          : SizedBox(),
    );
  }
}
