import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final dynamic contextData;
  const ChatScreen({super.key, this.contextData});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: 'user');
  final _bot = const types.User(id: 'flowmate_ai');

  @override
  void initState() {
    super.initState();
    _generateOpening();
  }

  void _generateOpening() {
    final season = widget.contextData?['season'];
    final mood = widget.contextData?['mood'] ?? '🌼';
    final flow = widget.contextData?['flow'] ?? 'N/A';

    String intro = "🌺 Hi love, how are you today?";
    if (season != null) {
      intro = switch (season.toString()) {
        "Season.spring" => "🌸 You're in Spring — a time of renewal. What feels exciting today?",
        "Season.summer" => "☀️ It's Summer phase — you're radiant. Want to share your energy?",
        "Season.autumn" => "🍂 Autumn's here. How are you holding your feelings today?",
        "Season.winter" => "❄️ It's Winter — go gently. Want to talk about how you're feeling?",
        _ => intro
      };
    }

    _addBotMessage(intro + "\n\n(Mood: $mood, Flow: $flow)");
  }

  void _addBotMessage(String text) {
    final message = types.TextMessage(
      author: _bot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: text,
    );
    setState(() => _messages.insert(0, message));
  }

  void _handleSendPressed(types.PartialText message) {
    final userMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    setState(() => _messages.insert(0, userMessage));

    // Stub AI Response for now
    Future.delayed(const Duration(milliseconds: 800), () {
      _addBotMessage("🌙 Noted. Would you like a journaling prompt or self-care idea?");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FlowMate Chat')),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
        theme: const DefaultChatTheme(
          primaryColor: Colors.pinkAccent,
          inputBackgroundColor: Colors.white,
          backgroundColor: Color(0xFFF8D5EC),
        ),
      ),
    );
  }
}
