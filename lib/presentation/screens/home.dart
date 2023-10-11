import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:sgadmin/presentation/pages/chat.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  Map<String, dynamic> _messages = {};
  ScrollController _scrollController = ScrollController();

  // Dummy data for chat names
  final List<String> chatNames = [
    "John Doe",
    "Alice Johnson",
    "Bob Smith",
    "Emma Watson",
    // Add more chat names as needed
  ];

  @override
  void initState() {
    super.initState();
    _databaseReference.onValue.listen((event) {
      // final Map<String, dynamic> messageData = Map<String, dynamic>.from(
      //     event.snapshot.value as Map<String, dynamic>);
      print(event.snapshot.value);

      final messageData = jsonDecode(jsonEncode(event.snapshot.value));

      print(messageData);
      setState(() {
        // Update _messages only when the specific child is updated.
        // _messages.add(messageData);
        _messages = messageData;
      });

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300), // Adjust the duration as needed
        curve: Curves.easeOut, // Adjust the curve as needed
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Messages'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options action
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final chatName = _messages.keys.elementAt(index);
          final messages = _messages[chatName]["messages"];
          final lastmessages = messages?.last["message"];
          final lastMessagestimestamp = messages?.last['timestamp'];
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: Text("${chatName[0]}"),
                  backgroundColor: Colors.black,
                ),
                title: Text(chatName),
                subtitle: Text(
                    '$lastmessages'), // You can replace this with actual last messages
                trailing: Text(
                    '$lastMessagestimestamp'), // You can replace this with actual timestamps
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => ChatPage(
                              messages: messages, username: chatName))));
                },
              ),
              index < _messages.length - 1
                  ? Divider(height: 2, color: Colors.grey)
                  : Divider(height: 0)
            ],
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Handle new chat button click
      //   },
      //   child: Icon(Icons.message),
      //   backgroundColor: Color(0xFF25D366), // WhatsApp green color
      // ),
    );
  }
}
