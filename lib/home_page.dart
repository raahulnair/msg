// home_page.dart
import 'package:flutter/material.dart';
import 'message_boards_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MessageBoardsPage();
  }
}
