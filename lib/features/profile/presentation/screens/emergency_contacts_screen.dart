import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emergencyContactsProvider = StateNotifierProvider<EmergencyContactsState, List<Map<String, String>>>((ref) {
  return EmergencyContactsState();
});

class EmergencyContactsState extends StateNotifier<List<Map<String, String>>> {
  EmergencyContactsState() : super([
    {
      'name': 'John Smith',
      'relationship': 'Family',
      'phone': '+1 234 567 8901',
    },
    {
      'name': 'Sarah Johnson',
      'relationship': 'Friend',
      'phone': '+1 234 567 8902',
    },
  ]);

  void addContact(Map<String, String> contact) {
    state = [...state, contact];
  }

  void removeContact(int index) {
    state = [...state]..removeAt(index);
  }

  void updateContact(int index, Map<String, String> contact) {
    state = [...state]..[index] = contact;
  }
}

class EmergencyContactsScreen extends ConsumerWidget {
  const EmergencyContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(emergencyContactsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddContactDialog(context, ref),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(contact['name']![0]),
              ),
              title: Text(contact['name']!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contact['relationship']!),
                  Text(contact['phone']!),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ref.read(emergencyContactsProvider.notifier).removeContact(index);
                },
              ),
              onTap: () => _showEditContactDialog(context, ref, index, contact),
            ),
          );
        },
      ),
    );
  }

  void _showAddContactDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final relationshipController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Emergency Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: relationshipController,
              decoration: const InputDecoration(labelText: 'Relationship'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(emergencyContactsProvider.notifier).addContact({
                'name': nameController.text,
                'relationship': relationshipController.text,
                'phone': phoneController.text,
              });
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditContactDialog(BuildContext context, WidgetRef ref, int index, Map<String, String> contact) {
    final nameController = TextEditingController(text: contact['name']);
    final relationshipController = TextEditingController(text: contact['relationship']);
    final phoneController = TextEditingController(text: contact['phone']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Emergency Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: relationshipController,
              decoration: const InputDecoration(labelText: 'Relationship'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(emergencyContactsProvider.notifier).updateContact(index, {
                'name': nameController.text,
                'relationship': relationshipController.text,
                'phone': phoneController.text,
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
} 