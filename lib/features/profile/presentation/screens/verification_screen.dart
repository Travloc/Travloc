import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final verificationProvider =
    StateNotifierProvider<VerificationState, Map<String, dynamic>>((ref) {
      return VerificationState();
    });

class VerificationState extends StateNotifier<Map<String, dynamic>> {
  VerificationState()
    : super({
        'isVerified': false,
        'verificationType': 'none', // 'none', 'id', 'guide'
        'documents': [],
        'status': 'pending', // 'pending', 'approved', 'rejected'
        'isUploading': false,
        'uploadError': null,
      });

  void updateVerificationStatus(String status) {
    state = {...state, 'status': status};
  }

  void setUploading(bool isUploading) {
    state = {...state, 'isUploading': isUploading, 'uploadError': null};
  }

  void setUploadError(String error) {
    state = {...state, 'isUploading': false, 'uploadError': error};
  }

  void addDocument(Map<String, dynamic> document) {
    final documents = List<Map<String, dynamic>>.from(
      state['documents'] as List,
    );
    documents.add(document);
    state = {
      ...state,
      'documents': documents,
      'isUploading': false,
      'uploadError': null,
    };
  }
}

class VerificationScreen extends ConsumerWidget {
  const VerificationScreen({super.key});

  Future<void> _uploadDocument(
    BuildContext context,
    WidgetRef ref,
    String documentType,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null) {
        final file = result.files.first;
        ref.read(verificationProvider.notifier).setUploading(true);

        // Get auth token
        const storage = FlutterSecureStorage();
        final token = await storage.read(key: 'auth_token');

        if (token == null) {
          throw Exception('Authentication token not found');
        }

        // Create multipart request
        final request = http.MultipartRequest(
          'POST',
          Uri.parse(
            '${const String.fromEnvironment('API_URL')}/verification/upload',
          ),
        );

        // Add headers
        request.headers.addAll({'Authorization': 'Bearer $token'});

        // Add file
        request.files.add(
          await http.MultipartFile.fromPath(
            'document',
            file.path!,
            filename: file.name,
          ),
        );

        // Add document type
        request.fields['type'] = documentType;

        // Send request
        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          final responseData = jsonDecode(responseBody);
          ref.read(verificationProvider.notifier).addDocument({
            'type': documentType,
            'name': file.name,
            'size': file.size,
            'path': file.path,
            'uploadedAt': DateTime.now().toIso8601String(),
            'documentId': responseData['documentId'],
            'status': 'pending',
          });

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${file.name} uploaded successfully')),
            );
          }
        } else {
          final error =
              jsonDecode(responseBody)['message'] ??
              'Failed to upload document';
          throw Exception(error);
        }
      }
    } catch (e) {
      ref.read(verificationProvider.notifier).setUploadError(e.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verification = ref.watch(verificationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Verification')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verification Status',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Current Status: ${verification['status']}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload Documents',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  if (verification['isUploading'] as bool)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else ...[
                    ElevatedButton.icon(
                      onPressed: () => _uploadDocument(context, ref, 'id'),
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload ID Document'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => _uploadDocument(context, ref, 'address'),
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload Proof of Address'),
                    ),
                  ],
                  if (verification['uploadError'] != null)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        verification['uploadError'] as String,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  if ((verification['documents'] as List).isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Uploaded Documents',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...(verification['documents'] as List).map(
                      (doc) => ListTile(
                        leading: const Icon(Icons.description),
                        title: Text(doc['name'] as String),
                        subtitle: Text('Uploaded: ${doc['uploadedAt']}'),
                        trailing: Text(
                          doc['status'] as String,
                          style: TextStyle(
                            color:
                                doc['status'] == 'approved'
                                    ? Colors.green
                                    : doc['status'] == 'rejected'
                                    ? Colors.red
                                    : Colors.orange,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verification Process',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. Upload required documents\n'
                    '2. Wait for document verification\n'
                    '3. Complete identity verification\n'
                    '4. Get verified status',
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
