import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final chatProvider = StateNotifierProvider<ChatState, List<Map<String, dynamic>>>((ref) {
  return ChatState();
});

class ChatState extends StateNotifier<List<Map<String, dynamic>>> {
  ChatState() : super([
    {
      'id': '1',
      'name': 'John Guide',
      'lastMessage': 'Looking forward to our tour tomorrow!',
      'time': '14:30',
      'unread': 2,
      'type': 'guide',
    },
    {
      'id': '2',
      'name': 'Sarah Travel Buddy',
      'lastMessage': 'When are you arriving in Paris?',
      'time': '12:15',
      'unread': 0,
      'type': 'buddy',
    },
    {
      'id': '3',
      'name': 'Support Team',
      'lastMessage': 'Your booking has been confirmed',
      'time': 'Yesterday',
      'unread': 0,
      'type': 'support',
    },
  ]);

  void addChat(Map<String, dynamic> chat) {
    state = [...state, chat];
  }

  List<Map<String, dynamic>> searchChats(String query) {
    if (query.isEmpty) return state;
    return state.where((chat) {
      return chat['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
          chat['lastMessage'].toString().toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _startNewChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Chat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('New Guide Chat'),
              onTap: () {
                Navigator.pop(context);
                context.push('/messages/new/guide');
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('New Travel Buddy Chat'),
              onTap: () {
                Navigator.pop(context);
                context.push('/messages/new/buddy');
              },
            ),
            ListTile(
              leading: const Icon(Icons.support),
              title: const Text('Contact Support'),
              onTap: () {
                Navigator.pop(context);
                context.push('/messages/new/support');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chats = ref.watch(chatProvider);
    final filteredChats = _searchQuery.isEmpty
        ? chats
        : ref.read(chatProvider.notifier).searchChats(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ChatSearchDelegate(ref),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Guides'),
            Tab(text: 'Buddies'),
            Tab(text: 'Support'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChatList(filteredChats.where((chat) => chat['type'] == 'guide').toList()),
          _buildChatList(filteredChats.where((chat) => chat['type'] == 'buddy').toList()),
          _buildChatList(filteredChats.where((chat) => chat['type'] == 'support').toList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startNewChat,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildChatList(List<Map<String, dynamic>> chats) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(chat['name'][0]),
          ),
          title: Text(chat['name']),
          subtitle: Text(chat['lastMessage']),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(chat['time']),
              if (chat['unread'] > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    chat['unread'].toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
            ],
          ),
          onTap: () => context.push('/messages/${chat['id']}'),
        );
      },
    );
  }
}

class ChatSearchDelegate extends SearchDelegate {
  final WidgetRef ref;

  ChatSearchDelegate(this.ref);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final chats = ref.read(chatProvider.notifier).searchChats(query);
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(chat['name'][0]),
          ),
          title: Text(chat['name']),
          subtitle: Text(chat['lastMessage']),
          onTap: () {
            close(context, null);
            context.push('/messages/${chat['id']}');
          },
        );
      },
    );
  }
} 