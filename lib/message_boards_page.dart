// message_boards_page.dart
import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'app_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBoardsPage extends StatefulWidget {
  const MessageBoardsPage({Key? key}) : super(key: key);
  
  @override
  _MessageBoardsPageState createState() => _MessageBoardsPageState();
}

class _MessageBoardsPageState extends State<MessageBoardsPage> {
  // List of message boards with corresponding icons
  final List<Map<String, dynamic>> messageBoards = [
    {'name': 'General', 'icon': Icons.forum},
    {'name': 'Technology', 'icon': Icons.computer},
    {'name': 'Sports', 'icon': Icons.sports_soccer},
    {'name': 'Entertainment', 'icon': Icons.movie},
    {'name': 'Education', 'icon': Icons.school},
    // Add more boards as needed
  ];

  @override
  void initState() {
    super.initState();
    initializeMessageBoards();
  }

  void initializeMessageBoards() async {
    for (var board in messageBoards) {
      DocumentReference boardRef = FirebaseFirestore.instance
          .collection('messageBoards')
          .doc(board['name']);
      DocumentSnapshot doc = await boardRef.get();
      if (!doc.exists) {
        await boardRef.set({
          'name': board['name'],
          'icon': board['icon'].codePoint,
          'iconFontFamily': board['icon'].fontFamily,
          'iconFontPackage': board['icon'].fontPackage,
          // Add other board-specific data if needed
        });
      }
    }
  }

  Widget _buildMessageBoardTile(Map<String, dynamic> board) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          board['icon'],
          size: 40,
          color: Colors.blueAccent,
        ),
        title: Text(
          board['name'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatPage(
                boardName: board['name'],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Boards'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: messageBoards.length,
        itemBuilder: (context, index) {
          return _buildMessageBoardTile(messageBoards[index]);
        },
      ),
    );
  }
}
