import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:message_app/pages/groupchat/create_group/add_member_first.dart';
import 'package:message_app/pages/groupchat/create_group/new_group.dart';
import 'package:message_app/pages/groupchat/group_chat_detail.dart';
import 'package:message_app/repository/login_auth.dart';
import 'package:message_app/services/add_member.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;

  List groupList = [];

  @override
  void initState() {
    super.initState();
    getAvailableGroups();
  }

  void getAvailableGroups() async {
    String uid = _auth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red[900],
          leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.menu_rounded,
                color: Colors.white,
              )),
          title: Center(
            child: Text("Fire Notification Groups",
                style: GoogleFonts.poppins(color: Colors.white)),
          ),
          actions: [
            TextButton(
                onPressed: () => signOut(context),
                child: Text('Sign out',
                    style: GoogleFonts.poppins(color: Colors.white)))
          ]),
      body: isLoading
          ? Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GroupChatDetail(
                      groupName: groupList[index]['name'],
                      groupChatId: groupList[index]['id'],
                    ),
                  )),
                  leading: Container(
                    height: size.height / 13,
                    width: size.height / 19,
                    decoration:  BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red[900],
                    ),
                    child: Icon(
                      Icons.group,
                      color: Colors.white,
                      size: size.width / 14,
                    ),
                  ),
                  title: Text(groupList[index]['name'],
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18)),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[900],
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddMemberWhenCreateGroup())),
        child: const Icon(Icons.group_add_rounded, color: Colors.white),
      ),
    );
  }
}
