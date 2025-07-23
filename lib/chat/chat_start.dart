import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _messages = [
    {
      "text":
          "Hello Jane,\nPlease provide some details\nMeasurements of neck, arms, waist, hips, thigh",
      "isUser": false,
      "time": "11:31 AM"
    },
  ];

  bool _isSearching = false;
  String _searchQuery = '';
  Map<String, dynamic>? _replyTo;

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({
        "text": message.trim(),
        "isUser": true,
        "time": _getTimeNow(),
        "replyTo": _replyTo,
      });
      _replyTo = null;
    });
    _controller.clear();
  }

  String _getTimeNow() {
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return "$hour:${now.minute.toString().padLeft(2, '0')} $period";
  }

  List<Map<String, dynamic>> get _filteredMessages {
    if (_searchQuery.isEmpty) return _messages;
    return _messages
        .where((msg) =>
            msg['text'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search...",
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              )
            : const Text('Chat'),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search,
                color: Colors.black),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                }
                _isSearching = !_isSearching;
              });
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              // Handle actions here
              if (value == "Clear Chat") {
                setState(() => _messages.clear());
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: "Pin Chat", child: Text("Pin Chat")),
              const PopupMenuItem(
                  value: "Clear Chat", child: Text("Clear Chat")),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (_replyTo != null) _buildReplyPreview(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filteredMessages.length,
              itemBuilder: (context, index) {
                final message = _filteredMessages[index];
                final isUser = message['isUser'] ?? false;
                final reply = message['replyTo'];

                return GestureDetector(
                  onLongPress: () {
                    setState(() => _replyTo = message);
                  },
                  child: Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.green[200] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: isUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (reply != null)
                            Container(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                "↪ ${reply['text']}",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[700]),
                              ),
                            ),
                          Text(message['text'],
                              style: const TextStyle(fontSize: 15)),
                          const SizedBox(height: 4),
                          Text(message['time'],
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          _buildInputArea(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildReplyPreview() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[300],
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Replying to: ${_replyTo?['text']}",
              style: const TextStyle(fontStyle: FontStyle.italic),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() => _replyTo = null),
          )
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Message',
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => _sendMessage(_controller.text),
              child: const CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: 2,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.flag), label: "My Plan"),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: "Merits"),
        BottomNavigationBarItem(icon: Icon(Icons.extension), label: "Tools"),
      ],
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
    );
  }
}
