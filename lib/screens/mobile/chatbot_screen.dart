import 'package:flutter/material.dart';
import '../../services/gemini_service.dart';
import '../../utils/constants.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  late GeminiService _geminiService;
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isInitialized = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeGemini();
  }

  Future<void> _initializeGemini() async {
    try {
      _geminiService = GeminiService();
      // Assume initialized if service constructs; Firebase handles auth/key server-side.
      setState(() => _isInitialized = true);
      _addWelcomeMessage();
    } catch (e) {
      print('Initialization error: $e');
      _addErrorMessage('Error initializing chatbot: $e');
    }
  }

  void _addWelcomeMessage() {
    _messages.insert(
      0,
      ChatMessage(
        text: 'Hello! I\'m your DiPrep AI Assistant. I can help you with disaster preparedness, safety tips, and emergency information. What would you like to know?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void _addErrorMessage(String error) {
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: '⚠️ $error',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final userMessage = _messageController.text.trim();
    if (userMessage.isEmpty) return;

    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chatbot is still initializing. Please wait...')),
      );
      return;
    }

    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: userMessage,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      final response = await _geminiService.getResponse(userMessage);
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            text: response,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            text: 'Error: ${e.toString()}',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
    }
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat?'),
        content: const Text('Are you sure you want to clear all messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _messages.clear();
                _addWelcomeMessage();
              });
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('DiPrep AI Assistant'),
            Text(
              _isInitialized ? '🟢 Connected' : '🟡 Initializing...',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearChat,
            tooltip: 'Clear chat',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text(
                      'No messages yet',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == 0 && _isLoading) {
                        return _buildTypingIndicator();
                      }
                      final messageIndex = _isLoading ? index - 1 : index;
                      if (messageIndex >= _messages.length) {
                        return const SizedBox.shrink();
                      }
                      final message = _messages[messageIndex];
                      return _buildMessageBubble(message, context, isLight);
                    },
                  ),
          ),
          Container(
            decoration: BoxDecoration(
              color: isLight ? Colors.white : Colors.grey[900],
              border: Border(
                top: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask about disaster preparedness...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    onPressed: _isLoading ? null : _sendMessage,
                    backgroundColor:
                        _isLoading ? Colors.grey : AppColors.primary,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
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

  Widget _buildMessageBubble(
    ChatMessage message,
    BuildContext context,
    bool isLight,
  ) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.primary : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                color: message.isUser ? Colors.white70 : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[400],
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Typing...',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
