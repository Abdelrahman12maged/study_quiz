import 'dart:io';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:study_quiz/core/supabase/supabase_config.dart';

class N8nWebhookException implements Exception {
  final String message;
  final dynamic error;
  N8nWebhookException(this.message, [this.error]);

  @override
  String toString() =>
      'N8nWebhookException: $message${error != null ? ' ($error)' : ''}';
}

/// Handles image upload to Supabase Storage and creating quiz sessions.
class SupabaseCaptureDatasource {
  final SupabaseClient _client;
  final Dio _dio = Dio();

  SupabaseCaptureDatasource(this._client);

  /// Uploads [imageFile] to Supabase Storage under `captures/{userId}/`.
  /// Creates a new quiz_session row with status='processing'.
  /// Returns the session ID.
  Future<String> uploadAndCreateSession(File imageFile) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ext = imageFile.path.split('.').last;
    final storagePath = '$userId/$timestamp.$ext';

    // 1. Upload image to Storage
    final String uploadPath = await _client.storage.from('captures').upload(
          storagePath,
          imageFile,
          fileOptions: const FileOptions(upsert: false),
        );

    if (uploadPath.isEmpty) {
      throw Exception('Image upload failed: Storage returned an empty path.');
    }

    // Double-check: verify file exists in storage
    final fileName = '$timestamp.$ext';
    final files = await _client.storage.from('captures').list(path: userId);
    final fileExists = files.any((f) => f.name == fileName);

    if (!fileExists) {
      throw Exception(
        'Image verification failed: File was not found in storage after upload.',
      );
    }

    // 2. Get the public/signed URL for the thumbnail
    final imageUrl = _client.storage.from('captures').getPublicUrl(storagePath);

    // 3. Create a quiz_session row
    final response = await _client
        .from('quiz_sessions')
        .insert({
          'user_id': userId,
          'subject': 'General',
          'status': 'processing',
          'thumbnail_url': imageUrl,
        })
        .select('id')
        .single();

    final sessionId = response['id'] as String;

    // 4. Trigger n8n processing workflow and wait for the response.
    // If it throws an N8nWebhookException (e.g., unclear image), the repository will catch it
    // and return a Left(Failure), allowing the CaptureCubit to show the specific error.
    try {
      await triggerProcessing(
        uid: userId,
        sessionId: sessionId,
        imageUrl: imageUrl,
        subject: 'General',
      );
      // If the webhook completes successfully, ensure the session is marked as ready.
      await _client.from('quiz_sessions').update({'status': 'ready'}).eq('id', sessionId);
    } catch (e) {
      print('n8n Webhook trigger error: $e');
      // If the webhook fails or times out, mark the session as failed in DB
      await _client.from('quiz_sessions').update({'status': 'failed'}).eq('id', sessionId);
      // Rethrow to be caught by the Repository and converted into a Failure
      rethrow;
    }

    return sessionId;
  }

  Future<void> triggerProcessing({
    required String uid,
    required String sessionId,
    required String imageUrl,
    String subject = 'General',
  }) async {
    try {
      final response = await _dio.post(
        SupabaseConfig.n8nWebhookUrl,
        data: {
          'uid': uid,
          'sessionId': sessionId,
          'imageUrl': imageUrl,
          'subject': subject,
        },
        options: Options(
          // Wait longer for the n8n workflow to process the AI response
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 120),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // The webhook might return a JSON array with error details:
        // [ { "success": false, "error": "unclear_image", "reason": "..." } ]
        if (data is List && data.isNotEmpty) {
          final firstItem = data.first;
          if (firstItem is Map<String, dynamic> && firstItem['success'] == false) {
            throw N8nWebhookException(
              firstItem['reason'] ?? 'Image is unclear or invalid.',
              firstItem['error'],
            );
          }
        } else if (data is Map<String, dynamic> && data['success'] == false) {
          throw N8nWebhookException(
            data['reason'] ?? 'Image is unclear or invalid.',
            data['error'],
          );
        }
      } else {
        throw N8nWebhookException(
          'Webhook returned unexpected status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw N8nWebhookException('Failed to trigger processing pipeline', e);
    }
  }
}
