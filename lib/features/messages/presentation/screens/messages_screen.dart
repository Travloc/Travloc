import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/segmented_tab_control.dart';

final chatProvider =
    StateNotifierProvider<ChatState, List<Map<String, dynamic>>>((ref) {
      return ChatState();
    });

class ChatState extends StateNotifier<List<Map<String, dynamic>>> {
  ChatState()
    : super([
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
      return chat['name'].toString().toLowerCase().contains(
            query.toLowerCase(),
          ) ||
          chat['lastMessage'].toString().toLowerCase().contains(
            query.toLowerCase(),
          );
    }).toList();
  }
}

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chats = ref.watch(chatProvider);
    final filteredChats =
        _searchQuery.isEmpty
            ? chats
            : ref.read(chatProvider.notifier).searchChats(_searchQuery);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildChatList(
                  filteredChats
                      .where((chat) => chat['type'] == 'guide')
                      .toList(),
                ),
                _buildChatList(
                  filteredChats
                      .where((chat) => chat['type'] == 'buddy')
                      .toList(),
                ),
                _buildChatList(
                  filteredChats
                      .where((chat) => chat['type'] == 'support')
                      .toList(),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SegmentedTabControl(
                tabs: const ['Guides', 'Buddies', 'Support'],
                currentIndex: _tabController.index,
                currentPosition:
                    _tabController.animation?.value ??
                    _tabController.index.toDouble(),
                onTabSelected: (index) {
                  setState(() {
                    _tabController.index = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 64.0),
        child: FloatingActionButton(
          onPressed: () {
            showSearch(context: context, delegate: ChatSearchDelegate(ref));
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.search),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildChatList(List<Map<String, dynamic>> chats) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return GestureDetector(
          onTap: () => context.push('/messages/${chat['id']}'),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.08 * 255).toInt()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color:
                        chat['type'] == 'guide'
                            ? const Color(0xFFB7A6FF)
                            : chat['type'] == 'buddy'
                            ? const Color(0xFFBFFF2A)
                            : const Color(0xFFFFD6E0),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    chat['name'][0],
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chat['lastMessage'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      chat['time'],
                      style: const TextStyle(fontSize: 13, color: Colors.black),
                    ),
                    if (chat['unread'] > 0)
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB7A6FF),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          chat['unread'].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
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
          leading: CircleAvatar(child: Text(chat['name'][0])),
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
