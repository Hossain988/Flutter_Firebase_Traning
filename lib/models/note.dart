// TODO: Students will uncomment this when they add Firebase
// import 'package:cloud_firestore/cloud_firestore.dart';

/// Note model representing a note in Firestore
/// 
/// Students will learn:
/// - Data modeling with Firestore
/// - Timestamp handling
/// - Optional fields
class Note {
  final String noteId;
  final String uid;
  final String title;
  final String body;
  final String category; // Work, Personal, Ideas, etc.
  final List<String> tags; // ['urgent', 'meeting', etc.]
  final bool pinned;
  final String priority; // 'low', 'medium', 'high'
  final DateTime createdAt;
  final DateTime? reminderDate; // Optional reminder

  Note({
    required this.noteId,
    required this.uid,
    required this.title,
    required this.body,
    required this.category,
    required this.tags,
    required this.pinned,
    required this.priority,
    required this.createdAt,
    this.reminderDate,
  });

  /// Convert Note to Firestore Map
  /// 
  /// TODO: Students will implement this to convert Note to Map for Firestore
  Map<String, dynamic> toMap() {
    // TODO: Convert Note object to Map<String, dynamic>
    // Include all fields: noteId, uid, title, body, category, tags, pinned, priority, createdAt, reminderDate
    // Convert DateTime to Timestamp for Firestore
    throw UnimplementedError('Students need to implement toMap()');
  }

  /// Create Note from Firestore DocumentSnapshot
  /// 
  /// TODO: Students will implement this to parse Firestore data
  factory Note.fromMap(Map<String, dynamic> map, String noteId) {
    // TODO: Parse Map<String, dynamic> to Note object
    // Handle Timestamp conversion to DateTime
    // Handle optional reminderDate field
    throw UnimplementedError('Students need to implement fromMap()');
  }

  /// Create a copy of Note with updated fields
  Note copyWith({
    String? noteId,
    String? uid,
    String? title,
    String? body,
    String? category,
    List<String>? tags,
    bool? pinned,
    String? priority,
    DateTime? createdAt,
    DateTime? reminderDate,
  }) {
    return Note(
      noteId: noteId ?? this.noteId,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      body: body ?? this.body,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      pinned: pinned ?? this.pinned,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      reminderDate: reminderDate ?? this.reminderDate,
    );
  }
}

