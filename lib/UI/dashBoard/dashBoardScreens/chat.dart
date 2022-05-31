
import 'package:flutter/material.dart';

import '../../../chatbox/ui/dms.dart';


class ChatDashBoard extends StatefulWidget {
  @override
  _ChatDashBoardState createState() => _ChatDashBoardState();
}

class _ChatDashBoardState extends State<ChatDashBoard> {
  @override
  Widget build(BuildContext context) {
    return DMs();
  }
}
