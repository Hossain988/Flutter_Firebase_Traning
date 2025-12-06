import '../models/note.dart';

/// Firebase Service with placeholder methods
/// 
/// Students will implement all Firebase operations here
/// This teaches them:
/// - CRUD operations
/// - Firestore queries
/// - Array queries (arrayContains)
/// - Range queries (date filtering)
/// - Composite queries (pinned + createdAt)
class FirebaseService {
  // TODO: STEP 1 - Initialize Firestore instance
  // 1. First, make sure you've added cloud_firestore to pubspec.yaml
  // 2. Import: import 'package:cloud_firestore/cloud_firestore.dart';
  // 3. Uncomment the line below to create a Firestore instance
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // TODO: STEP 2 - Get current user ID for filtering notes
  // 1. Import: import 'package:firebase_auth/firebase_auth.dart';
  // 2. Uncomment the line below to get the current authenticated user's ID
  // 3. This will be used in all queries to filter notes by user
  // 4. Note: currentUser can be null if user is not logged in, so handle null case
  // final String? _currentUserId = FirebaseAuth.instance.currentUser?.uid;

  /// Create a new note
  /// 
  /// TODO: IMPLEMENT THIS METHOD - Step by step guide:
  /// 
  /// STEP 1: Convert Note to Map
  ///   - Call note.toMap() to convert the Note object to a Map<String, dynamic>
  ///   - This Map contains all note fields in Firestore-compatible format
  /// 
  /// STEP 2: Add document to Firestore
  ///   - Use _firestore.collection('notes').add(noteMap)
  ///   - The .add() method automatically generates a unique document ID
  ///   - This returns a DocumentReference
  /// 
  /// STEP 3: Return the document ID
  ///   - Get the ID from the DocumentReference: documentReference.id
  ///   - Return this ID as a String
  /// 
  /// EXAMPLE CODE:
  ///   final noteMap = note.toMap();
  ///   final docRef = await _firestore.collection('notes').add(noteMap);
  ///   return docRef.id;
  /// 
  /// IMPORTANT NOTES:
  ///   - Make sure note.toMap() is implemented first
  ///   - The noteId in the Note object will be empty initially
  ///   - Firestore will generate the ID, which you'll return
  ///   - createdAt should already be set in the Note object before calling this
  Future<String> createNote(Note note) async {
    // TODO: Uncomment and implement the code below
    // Step 1: Convert Note to Map
    // final noteMap = note.toMap();
    // 
    // Step 2: Add to Firestore and get document reference
    // final docRef = await _firestore.collection('notes').add(noteMap);
    // 
    // Step 3: Return the generated document ID
    // return docRef.id;
    
    throw UnimplementedError('Students need to implement createNote()');
  }

  /// Get all notes for current user
  /// 
  /// TODO: IMPLEMENT THIS METHOD - Step by step guide:
  /// 
  /// STEP 1: Check if user is authenticated
  ///   - Verify _currentUserId is not null
  ///   - If null, return empty list or throw error
  /// 
  /// STEP 2: Build the query
  ///   - Start with: _firestore.collection('notes')
  ///   - Filter by user: .where('uid', isEqualTo: _currentUserId)
  ///   - Order by pinned first: .orderBy('pinned', descending: true)
  ///   - Then order by date: .orderBy('createdAt', descending: true)
  /// 
  /// STEP 3: Execute query and get documents
  ///   - Call .get() on the query to execute it
  ///   - This returns a QuerySnapshot
  /// 
  /// STEP 4: Convert documents to Note objects
  ///   - Loop through querySnapshot.docs
  ///   - For each doc: Note.fromMap(doc.data(), doc.id)
  ///   - Collect all notes into a List<Note>
  /// 
  /// STEP 5: Return the list
  /// 
  /// EXAMPLE CODE:
  ///   if (_currentUserId == null) return [];
  ///   final querySnapshot = await _firestore
  ///     .collection('notes')
  ///     .where('uid', isEqualTo: _currentUserId)
  ///     .orderBy('pinned', descending: true)
  ///     .orderBy('createdAt', descending: true)
  ///     .get();
  ///   return querySnapshot.docs
  ///     .map((doc) => Note.fromMap(doc.data(), doc.id))
  ///     .toList();
  /// 
  /// IMPORTANT: This query requires a COMPOSITE INDEX!
  ///   - When you run this, Firestore will show an error with a link
  ///   - Click the link to create the index automatically
  ///   - The index combines: uid (Ascending), pinned (Descending), createdAt (Descending)
  ///   - Wait a few minutes for the index to build before testing
  Future<List<Note>> getAllNotes() async {
    // TODO: Uncomment and implement the code below
    // Step 1: Check authentication
    // if (_currentUserId == null) {
    //   throw Exception('User not authenticated');
    // }
    // 
    // Step 2: Build and execute query
    // final querySnapshot = await _firestore
    //   .collection('notes')
    //   .where('uid', isEqualTo: _currentUserId)
    //   .orderBy('pinned', descending: true)
    //   .orderBy('createdAt', descending: true)
    //   .get();
    // 
    // Step 3: Convert documents to Note objects
    // return querySnapshot.docs
    //   .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
    //   .toList();
    
    throw UnimplementedError('Students need to implement getAllNotes()');
  }

  /// Get notes filtered by category
  /// 
  /// TODO: IMPLEMENT THIS METHOD - Step by step guide:
  /// 
  /// STEP 1: Check if user is authenticated
  ///   - Verify _currentUserId is not null
  /// 
  /// STEP 2: Build the query with multiple filters
  ///   - Start with: _firestore.collection('notes')
  ///   - Filter by user: .where('uid', isEqualTo: _currentUserId)
  ///   - Filter by category: .where('category', isEqualTo: category)
  ///   - Order by date: .orderBy('createdAt', descending: true)
  /// 
  /// STEP 3: Execute query and convert to Note objects
  ///   - Call .get() to execute
  ///   - Map documents to Note objects using Note.fromMap()
  /// 
  /// EXAMPLE CODE:
  ///   if (_currentUserId == null) return [];
  ///   final querySnapshot = await _firestore
  ///     .collection('notes')
  ///     .where('uid', isEqualTo: _currentUserId)
  ///     .where('category', isEqualTo: category)
  ///     .orderBy('createdAt', descending: true)
  ///     .get();
  ///   return querySnapshot.docs
  ///     .map((doc) => Note.fromMap(doc.data(), doc.id))
  ///     .toList();
  /// 
  /// IMPORTANT: This requires a COMPOSITE INDEX!
  ///   - Fields: uid (Ascending), category (Ascending), createdAt (Descending)
  ///   - Firestore will provide a link to create it automatically
  Future<List<Note>> getNotesByCategory(String category) async {
    // TODO: Uncomment and implement
    // if (_currentUserId == null) return [];
    // final querySnapshot = await _firestore
    //   .collection('notes')
    //   .where('uid', isEqualTo: _currentUserId)
    //   .where('category', isEqualTo: category)
    //   .orderBy('createdAt', descending: true)
    //   .get();
    // return querySnapshot.docs
    //   .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
    //   .toList();
    
    throw UnimplementedError('Students need to implement getNotesByCategory()');
  }

  /// Get notes filtered by tag
  /// 
  /// TODO: IMPLEMENT THIS METHOD - Step by step guide:
  /// 
  /// This method teaches you about ARRAY CONTAINS queries in Firestore.
  /// When you have an array field (like 'tags'), you can query for documents
  /// where the array contains a specific value.
  /// 
  /// STEP 1: Check if user is authenticated
  ///   - Verify _currentUserId is not null
  /// 
  /// STEP 2: Build the query with arrayContains
  ///   - Start with: _firestore.collection('notes')
  ///   - Filter by user: .where('uid', isEqualTo: _currentUserId)
  ///   - Filter by tag: .where('tags', arrayContains: tag)
  ///   - Note: 'tags' is an array field, arrayContains checks if tag exists in that array
  /// 
  /// STEP 3: Execute query and convert to Note objects
  /// 
  /// EXAMPLE CODE:
  ///   if (_currentUserId == null) return [];
  ///   final querySnapshot = await _firestore
  ///     .collection('notes')
  ///     .where('uid', isEqualTo: _currentUserId)
  ///     .where('tags', arrayContains: tag)
  ///     .get();
  ///   return querySnapshot.docs
  ///     .map((doc) => Note.fromMap(doc.data(), doc.id))
  ///     .toList();
  /// 
  /// KEY LEARNING POINT:
  ///   - arrayContains is used when querying array fields
  ///   - It finds documents where the array contains the specified value
  ///   - Example: If tags = ['urgent', 'meeting'], arrayContains('urgent') will match
  Future<List<Note>> getNotesByTag(String tag) async {
    // TODO: Uncomment and implement
    // if (_currentUserId == null) return [];
    // final querySnapshot = await _firestore
    //   .collection('notes')
    //   .where('uid', isEqualTo: _currentUserId)
    //   .where('tags', arrayContains: tag)
    //   .get();
    // return querySnapshot.docs
    //   .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
    //   .toList();
    
    throw UnimplementedError('Students need to implement getNotesByTag()');
  }

  /// Get notes filtered by priority
  /// 
  /// TODO: Students will implement this
  /// - Query: where('priority', isEqualTo: priority)
  /// - Order by createdAt descending
  Future<List<Note>> getNotesByPriority(String priority) async {
    // TODO: Implement priority filter query
    throw UnimplementedError('Students need to implement getNotesByPriority()');
  }

  /// Get pinned notes
  /// 
  /// TODO: Students will implement this
  /// - Query: where('pinned', isEqualTo: true)
  /// - Order by createdAt descending
  Future<List<Note>> getPinnedNotes() async {
    // TODO: Implement pinned notes query
    throw UnimplementedError('Students need to implement getPinnedNotes()');
  }

  /// Get notes created in last N days
  /// 
  /// TODO: IMPLEMENT THIS METHOD - Step by step guide:
  /// 
  /// This method teaches you about RANGE QUERIES with timestamps.
  /// You'll learn to filter documents based on date ranges.
  /// 
  /// STEP 1: Calculate the cutoff date
  ///   - Use DateTime.now().subtract(Duration(days: days))
  ///   - This gives you the date N days ago
  ///   - Convert to Timestamp: Timestamp.fromDate(cutoffDate)
  /// 
  /// STEP 2: Check if user is authenticated
  ///   - Verify _currentUserId is not null
  /// 
  /// STEP 3: Build the range query
  ///   - Start with: _firestore.collection('notes')
  ///   - Filter by user: .where('uid', isEqualTo: _currentUserId)
  ///   - Filter by date range: .where('createdAt', isGreaterThan: cutoffTimestamp)
  ///   - Order by date: .orderBy('createdAt', descending: true)
  /// 
  /// STEP 4: Execute query and convert to Note objects
  /// 
  /// EXAMPLE CODE:
  ///   if (_currentUserId == null) return [];
  ///   final cutoffDate = DateTime.now().subtract(Duration(days: days));
  ///   final cutoffTimestamp = Timestamp.fromDate(cutoffDate);
  ///   final querySnapshot = await _firestore
  ///     .collection('notes')
  ///     .where('uid', isEqualTo: _currentUserId)
  ///     .where('createdAt', isGreaterThan: cutoffTimestamp)
  ///     .orderBy('createdAt', descending: true)
  ///     .get();
  ///   return querySnapshot.docs
  ///     .map((doc) => Note.fromMap(doc.data(), doc.id))
  ///     .toList();
  /// 
  /// IMPORTANT: Requires composite index for uid + createdAt
  /// KEY LEARNING: isGreaterThan finds documents where createdAt > cutoffTimestamp
  Future<List<Note>> getRecentNotes(int days) async {
    // TODO: Uncomment and implement
    // Step 1: Calculate cutoff date
    // final cutoffDate = DateTime.now().subtract(Duration(days: days));
    // final cutoffTimestamp = Timestamp.fromDate(cutoffDate);
    // 
    // Step 2: Check authentication
    // if (_currentUserId == null) return [];
    // 
    // Step 3: Build and execute query
    // final querySnapshot = await _firestore
    //   .collection('notes')
    //   .where('uid', isEqualTo: _currentUserId)
    //   .where('createdAt', isGreaterThan: cutoffTimestamp)
    //   .orderBy('createdAt', descending: true)
    //   .get();
    // 
    // Step 4: Convert to Note objects
    // return querySnapshot.docs
    //   .map((doc) => Note.fromMap(doc.data() as Map<String, dynamic>, doc.id))
    //   .toList();
    
    throw UnimplementedError('Students need to implement getRecentNotes()');
  }

  /// Get notes older than N days
  /// 
  /// TODO: Students will implement this
  /// - Query: where('createdAt', isLessThan: date)
  /// - This teaches range queries with timestamps
  Future<List<Note>> getOldNotes(int days) async {
    // TODO: Calculate date N days ago
    // TODO: Implement range query with isLessThan
    throw UnimplementedError('Students need to implement getOldNotes()');
  }

  /// Get notes with reminders
  /// 
  /// TODO: Students will implement this
  /// - Query: where('reminderDate', isNotEqualTo: null)
  /// - This teaches querying optional fields
  Future<List<Note>> getNotesWithReminders() async {
    // TODO: Implement query for notes with reminders
    // .where('reminderDate', isNotEqualTo: null)
    throw UnimplementedError('Students need to implement getNotesWithReminders()');
  }

  /// Search notes by title (client-side filtering)
  /// 
  /// Note: This is a placeholder. Students can implement:
  /// 1. Client-side: Fetch all notes, filter locally
  /// 2. Server-side: Use Firestore where with title.contains (limited)
  /// 
  /// TODO: Students will implement search functionality
  Future<List<Note>> searchNotesByTitle(String searchQuery) async {
    // TODO: Option 1: Fetch all notes, filter client-side
    // TODO: Option 2: Use Firestore query (limited functionality)
    throw UnimplementedError('Students need to implement searchNotesByTitle()');
  }

  /// Search notes by body (client-side filtering)
  /// 
  /// Note: Firestore doesn't support full-text search
  /// Students will learn to fetch and filter locally
  /// 
  /// TODO: Students will implement client-side filtering
  Future<List<Note>> searchNotesByBody(String searchQuery) async {
    // TODO: Fetch all notes
    // TODO: Filter locally where body contains searchQuery
    throw UnimplementedError('Students need to implement searchNotesByBody()');
  }

  /// Update an existing note
  /// 
  /// TODO: Students will implement this
  /// - Update note in Firestore using noteId
  Future<void> updateNote(Note note) async {
    // TODO: Implement Firestore update operation
    // await _firestore.collection('notes').doc(note.noteId).update(note.toMap());
    throw UnimplementedError('Students need to implement updateNote()');
  }

  /// Delete a note
  /// 
  /// TODO: Students will implement this
  /// - Delete note from Firestore using noteId
  Future<void> deleteNote(String noteId) async {
    // TODO: Implement Firestore delete operation
    // await _firestore.collection('notes').doc(noteId).delete();
    throw UnimplementedError('Students need to implement deleteNote()');
  }

  /// Toggle pinned status of a note
  /// 
  /// TODO: Students will implement this
  /// - Update only the 'pinned' field
  Future<void> togglePinned(String noteId, bool pinned) async {
    // TODO: Implement partial update
    // await _firestore.collection('notes').doc(noteId).update({'pinned': pinned});
    throw UnimplementedError('Students need to implement togglePinned()');
  }
}

