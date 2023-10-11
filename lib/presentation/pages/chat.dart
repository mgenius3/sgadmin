import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class ChatPage extends StatefulWidget {
  final messages;
  final username;

  ChatPage({this.messages, required this.username});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  List<dynamic> _messages = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _messages = widget.messages;
    });
    _databaseReference.child(widget.username).onValue.listen((event) {
      // final Map<String, dynamic> messageData = Map<String, dynamic>.from(
      //     event.snapshot.value as Map<String, dynamic>);

      final messageData = jsonDecode(jsonEncode(event.snapshot.value));

      setState(() {
        // Update _messages only when the specific child is updated.
        // _messages.add(messageData);
        _messages = messageData["messages"];
      });

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300), // Adjust the duration as needed
        curve: Curves.easeOut, // Adjust the curve as needed
      );
    });
  }

  void _sendMessage(BuildContext context, String message) async {
    final currentTime = DateTime.now();

    _databaseReference.child(widget.username).once().then((DatabaseEvent data) {
      String jsonData = jsonEncode(data.snapshot.value);

      var userData = jsonDecode(jsonData);

      // Create a new message object.
      Map<String, dynamic> newMessage = {
        'userType': 'admin', // Assuming the userType is 'user'.
        'message': message,
        'timestamp': currentTime.toLocal()
      };

      if (userData == null || userData == "null") {
        // If no data exists for the user, create a new user data object.
        userData = {
          'messages': [newMessage]
        };
      } else {
        // Check if the user has existing messages, and append the new message.
        if (userData['messages'] != null && userData['messages'] is List) {
          List<dynamic> messages = List.from(userData['messages']);
          messages.add(newMessage);
          userData['messages'] = messages;
        } else {
          // If no messages exist, create a new list with the new message.
          userData['messages'] = [newMessage];
        }
      }
      // Update the database with the updated user data.
      _databaseReference.child(widget.username).set(userData);

      // After sending a message, scroll to the end
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300), // Adjust the duration as needed
        curve: Curves.easeOut, // Adjust the curve as needed
      );
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Us'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                final messageData = _messages[index];
                final userType = messageData['userType'];
                final messageText = messageData['message'];
                final timestamp = messageData['timestamp'];
                return ListTile(
                  title: Align(
                    alignment: userType == 'user'
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: userType == 'user' ? Colors.green : Colors.blue,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        '$messageText',
                        style: TextStyle(color: Colors.white),
                      ),
                      // child: Column(
                      //   children: [
                      //     Text(
                      //       userType == 'user'
                      //           ? '$messageText'
                      //           : '$messageText',
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //     Align(
                      //       alignment: Alignment.bottomRight,
                      //       child: Text(
                      //         timestamp.toString(),
                      //         style: TextStyle(fontSize: 5),
                      //       ),
                      //     )
                      //   ],
                      // )
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Write Message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _sendMessage(context, _messageController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
