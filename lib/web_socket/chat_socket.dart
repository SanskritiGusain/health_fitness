import 'package:flutter/material.dart';
import 'package:test_app/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatSocketPage extends StatefulWidget {
  const ChatSocketPage({super.key});

  @override
  State<ChatSocketPage> createState() => _ChatSocketPageState();
}

class _ChatSocketPageState extends State<ChatSocketPage> {
  late WebSocketChannel channel;
  final TextEditingController controller = TextEditingController();
  final List<Map<String, String>> messages =
      []; // {"sender": "You"/"Server", "text": "..."}

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  Future<void> _connectWebSocket() async {
    String? token = await PersistentData.getAuthToken();
    if (token == null) {
      debugPrint("❌ No auth token found");
      return;
    }

    channel = WebSocketChannel.connect(
      Uri.parse("ws://192.168.1.35:8000/chat/ws/user?token=$token"),
    );

    channel.stream.listen(
      (data) {
        setState(() {
          messages.add({"sender": "Server", "text": data.toString()});
        });
        _scrollToBottom();
      },
      onError: (error) {
        debugPrint("❌ WebSocket error: $error");
      },
      onDone: () {
        debugPrint("🔌 WebSocket connection closed");
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (controller.text.trim().isEmpty) return;

    channel.sink.add(controller.text.trim());
    setState(() {
      messages.add({"sender": "You", "text": controller.text.trim()});
    });
    controller.clear();
    _scrollToBottom();
  }

  Widget _buildMessageBubble(Map<String, String> message) {
    bool isMe = message["sender"] == "You";
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(12),
          ),
        ),
        child: Text(
          message["text"]!,
          style: TextStyle(color: isMe ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WebSocket Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder:
                  (context, index) => _buildMessageBubble(messages[index]),
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueAccent,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
