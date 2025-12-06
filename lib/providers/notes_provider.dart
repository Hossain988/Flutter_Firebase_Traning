import 'package:flutter/foundation.dart';
import '../models/note.dart';
import '../services/firebase_service.dart';
import '../utils/constants.dart';

/// Notes Provider for state management
/// 
/// Students will learn:
/// - Provider pattern
/// - State management
/// - Loading and error states
class NotesProvider with ChangeNotifier {
  // ignore: unused_field
  final FirebaseService _firebaseService = FirebaseService(); // Students will use this when implementing Firebase

  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  bool _isLoading = false;
  String? _error;
  
  // Filter states
  String _selectedCategory = AppConstants.filterAll;
  String _selectedPriority = AppConstants.filterAll;
  String _selectedTag = '';
  String _selectedDateFilter = AppConstants.filterAll;
  String _searchQuery = '';

  // Getters
  List<Note> get notes => _filteredNotes.isEmpty && _searchQuery.isEmpty 
      ? _notes 
      : _filteredNotes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get selectedPriority => _selectedPriority;
  String get selectedTag => _selectedTag;
  String get selectedDateFilter => _selectedDateFilter;
  String get searchQuery => _searchQuery;

  /// Load all notes
  /// 
  /// TODO: Students will call FirebaseService.getAllNotes()
  Future<void> loadNotes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Call _firebaseService.getAllNotes()
      // _notes = await _firebaseService.getAllNotes();
      
      // TEMPORARY: Demo notes to show students what they need to implement
      // These will be replaced with actual Firebase data once implemented
      _notes = [
        Note(
          noteId: 'demo_1',
          uid: 'demo_user',
          title: '🚀 Getting Started - Setup & Configuration',
          body: '''STEP 1: Configure Firebase
1. Install FlutterFire CLI: dart pub global activate flutterfire_cli
2. Run: flutterfire configure
3. Select your Firebase project and platforms (Android, iOS, Web)
4. Select Flutter when prompted

STEP 2: Uncomment Dependencies
In pubspec.yaml, uncomment:
- cloud_firestore: ^5.4.0
- firebase_auth: ^5.0.0
- firebase_core: ^3.6.0
Then run: flutter pub get

STEP 3: Initialize Firebase
In lib/main.dart, add:
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

STEP 4: Uncomment Imports
In lib/models/note.dart and lib/models/user_model.dart:
Uncomment: import 'package:cloud_firestore/cloud_firestore.dart';''',
          category: 'Work',
          tags: ['setup', 'getting-started', 'configuration'],
          pinned: true,
          priority: 'high',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Note(
          noteId: 'demo_2',
          uid: 'demo_user',
          title: '📝 Task 1: Implement User Model Methods',
          body: '''In lib/models/user_model.dart:

1. toMap() Method:
   - Convert all fields to Map<String, dynamic>
   - For DateTime fields, use: Timestamp.fromDate(dateTime)
   - Handle optional fields (bio, address, lastLoginAt)
   - Example:
     'createdAt': Timestamp.fromDate(createdAt),
     'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null

2. fromMap() Factory:
   - Parse Map<String, dynamic> to UserModel
   - Convert Timestamp to DateTime: timestamp.toDate()
   - Handle optional fields with null checks
   - Example:
     createdAt: (map['createdAt'] as Timestamp).toDate(),
     lastLoginAt: map['lastLoginAt'] != null 
       ? (map['lastLoginAt'] as Timestamp).toDate() 
       : null

3. Test your implementation by creating a UserModel and calling toMap()/fromMap()''',
          category: 'Work',
          tags: ['models', 'user-model', 'todo'],
          pinned: false,
          priority: 'high',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Note(
          noteId: 'demo_3',
          uid: 'demo_user',
          title: '📝 Task 2: Implement Note Model Methods',
          body: '''In lib/models/note.dart:

1. toMap() Method:
   - Convert all Note fields to Map<String, dynamic>
   - Convert DateTime to Timestamp: Timestamp.fromDate(createdAt)
   - Handle optional reminderDate field
   - Keep tags as List<String> (Firestore supports arrays)
   - Example:
     'createdAt': Timestamp.fromDate(createdAt),
     'tags': tags, // Already a List<String>
     'reminderDate': reminderDate != null 
       ? Timestamp.fromDate(reminderDate!) 
       : null

2. fromMap() Factory:
   - Parse Map and String noteId to Note object
   - Convert Timestamp to DateTime: (map['createdAt'] as Timestamp).toDate()
   - Handle optional reminderDate
   - Example:
     createdAt: (map['createdAt'] as Timestamp).toDate(),
     reminderDate: map['reminderDate'] != null
       ? (map['reminderDate'] as Timestamp).toDate()
       : null

3. Test with: Note.fromMap(note.toMap(), 'test_id')''',
          category: 'Work',
          tags: ['models', 'note-model', 'todo'],
          pinned: false,
          priority: 'high',
          createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
        ),
        Note(
          noteId: 'demo_4',
          uid: 'demo_user',
          title: '🔐 Task 3: Implement Authentication Service',
          body: '''In lib/services/auth_service.dart:

1. Initialize Services:
   final FirebaseAuth _auth = FirebaseAuth.instance;
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

2. getCurrentUser():
   - Get: _auth.currentUser
   - If null, return null
   - If exists, fetch from Firestore: 
     _firestore.collection('users').doc(user.uid).get()
   - Return: UserModel.fromMap(doc.data()!)

3. signUp():
   - Create user: await _auth.createUserWithEmailAndPassword(email, password)
   - Update displayName: await userCredential.user?.updateDisplayName('\$firstName \$lastName')
   - Create UserModel with all fields
   - Save to Firestore: _firestore.collection('users').doc(uid).set(userModel.toMap())
   - Return UserModel

4. signIn():
   - Sign in: await _auth.signInWithEmailAndPassword(email, password)
   - Update lastLoginAt in Firestore
   - Fetch user data: _firestore.collection('users').doc(uid).get()
   - Return UserModel.fromMap()

5. signOut():
   - await _auth.signOut()

6. authStateChanges Stream:
   - Return: _auth.authStateChanges().asyncMap((user) async {
     if (user == null) return null;
     final doc = await _firestore.collection('users').doc(user.uid).get();
     return UserModel.fromMap(doc.data()!);
   })''',
          category: 'Work',
          tags: ['auth', 'firebase-auth', 'authentication'],
          pinned: false,
          priority: 'high',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Note(
          noteId: 'demo_5',
          uid: 'demo_user',
          title: '🔥 Task 4: Implement Firestore CRUD Operations',
          body: '''In lib/services/firebase_service.dart:

1. Initialize:
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

2. createNote():
   - Create document: await _firestore.collection('notes').add(note.toMap())
   - Note: Firestore auto-generates document ID
   - Return: doc.id

3. getAllNotes():
   - Query: _firestore.collection('notes')
     .where('uid', isEqualTo: _currentUserId)
     .orderBy('pinned', descending: true)
     .orderBy('createdAt', descending: true)
     .get()
   - Convert: docs.map((doc) => Note.fromMap(doc.data(), doc.id)).toList()
   - ⚠️ This requires a composite index! (See note about indexes)

4. updateNote():
   - Update: await _firestore.collection('notes')
     .doc(note.noteId)
     .update(note.toMap())

5. deleteNote():
   - Delete: await _firestore.collection('notes').doc(noteId).delete()

6. togglePinned():
   - Partial update: await _firestore.collection('notes')
     .doc(noteId)
     .update({'pinned': pinned})''',
          category: 'Work',
          tags: ['firestore', 'crud', 'queries'],
          pinned: false,
          priority: 'high',
          createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 12)),
        ),
        Note(
          noteId: 'demo_6',
          uid: 'demo_user',
          title: '🔍 Task 5: Implement Firestore Filter Queries',
          body: '''In lib/services/firebase_service.dart:

1. getNotesByCategory():
   - Query: _firestore.collection('notes')
     .where('uid', isEqualTo: _currentUserId)
     .where('category', isEqualTo: category)
     .orderBy('createdAt', descending: true)
     .get()
   - ⚠️ Requires composite index: category + createdAt

2. getNotesByTag():
   - Query: _firestore.collection('notes')
     .where('uid', isEqualTo: _currentUserId)
     .where('tags', arrayContains: tag)
     .orderBy('createdAt', descending: true)
     .get()
   - arrayContains searches within array fields

3. getNotesByPriority():
   - Query: _firestore.collection('notes')
     .where('uid', isEqualTo: _currentUserId)
     .where('priority', isEqualTo: priority)
     .orderBy('createdAt', descending: true)
     .get()

4. getPinnedNotes():
   - Query: _firestore.collection('notes')
     .where('uid', isEqualTo: _currentUserId)
     .where('pinned', isEqualTo: true)
     .orderBy('createdAt', descending: true)
     .get()

5. getRecentNotes(int days):
   - Calculate: final date = DateTime.now().subtract(Duration(days: days))
   - Query: .where('createdAt', isGreaterThan: Timestamp.fromDate(date))
   - Range query with timestamps

6. getOldNotes(int days):
   - Calculate: final date = DateTime.now().subtract(Duration(days: days))
   - Query: .where('createdAt', isLessThan: Timestamp.fromDate(date))

7. getNotesWithReminders():
   - Query: .where('reminderDate', isNotEqualTo: null)
   - Filters for non-null values''',
          category: 'Ideas',
          tags: ['firestore', 'queries', 'filtering'],
          pinned: false,
          priority: 'medium',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Note(
          noteId: 'demo_7',
          uid: 'demo_user',
          title: '🔎 Task 6: Implement Search Functionality',
          body: '''In lib/services/firebase_service.dart:

OPTION 1: Client-Side Filtering (Recommended for beginners)
1. searchNotesByTitle():
   - Fetch all notes: await getAllNotes()
   - Filter locally: notes.where((note) => 
     note.title.toLowerCase().contains(query.toLowerCase())).toList()

2. searchNotesByBody():
   - Fetch all notes: await getAllNotes()
   - Filter locally: notes.where((note) => 
     note.body.toLowerCase().contains(query.toLowerCase())).toList()

OPTION 2: Server-Side (Advanced)
- Firestore has limited text search
- Use: .where('title', isGreaterThanOrEqualTo: query)
       .where('title', isLessThanOrEqualTo: query + '\uf8ff')
- This only works for prefix matching, not full-text search
- For full-text search, consider Algolia (advanced)

RECOMMENDATION: Start with client-side filtering, it's simpler and works well for small datasets.''',
          category: 'Ideas',
          tags: ['search', 'filtering', 'queries'],
          pinned: false,
          priority: 'medium',
          createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 12)),
        ),
        Note(
          noteId: 'demo_8',
          uid: 'demo_user',
          title: '📊 Task 7: Create Composite Indexes',
          body: '''Firestore requires composite indexes for certain queries.

WHEN YOU GET "Index Required" ERROR:
1. Click the link in the error message
2. It opens Firebase Console with pre-filled index creation
3. Click "Create Index"
4. Wait 2-5 minutes for index to build
5. Retry your query

REQUIRED INDEXES:

Index 1: Pinned + CreatedAt
- Collection: notes
- Fields: 
  - uid (Ascending)
  - pinned (Descending)
  - createdAt (Descending)
- Used by: getAllNotes()

Index 2: Category + CreatedAt
- Collection: notes
- Fields:
  - uid (Ascending)
  - category (Ascending)
  - createdAt (Descending)
- Used by: getNotesByCategory()

TIP: Firestore will automatically prompt you with the exact index needed when you run a query that requires it. Just click the link!''',
          category: 'Work',
          tags: ['indexes', 'firestore', 'composite-index'],
          pinned: false,
          priority: 'medium',
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
        Note(
          noteId: 'demo_9',
          uid: 'demo_user',
          title: '🔗 Task 8: Connect Providers to Services',
          body: '''In lib/providers/auth_provider.dart:

1. _initAuthListener():
   - Listen to: _authService.authStateChanges
   - Update: _currentUser = user
   - Call: notifyListeners()

2. signUp():
   - Call: _currentUser = await _authService.signUp(...)
   - Return: true

3. signIn():
   - Call: _currentUser = await _authService.signIn(...)
   - Return: true

4. signOut():
   - Call: await _authService.signOut()
   - Set: _currentUser = null

In lib/providers/notes_provider.dart:

1. loadNotes():
   - Call: _notes = await _firebaseService.getAllNotes()
   - Call: _applyFilters()

2. createNote():
   - Call: await _firebaseService.createNote(note)
   - Call: await loadNotes() to refresh

3. updateNote():
   - Call: await _firebaseService.updateNote(note)
   - Update local list or reload

4. deleteNote():
   - Call: await _firebaseService.deleteNote(noteId)
   - Remove from local list

5. togglePinned():
   - Call: await _firebaseService.togglePinned(noteId, newStatus)
   - Update local note''',
          category: 'Work',
          tags: ['providers', 'state-management', 'integration'],
          pinned: false,
          priority: 'high',
          createdAt: DateTime.now().subtract(const Duration(days: 4, hours: 12)),
        ),
        Note(
          noteId: 'demo_10',
          uid: 'demo_user',
          title: '🛡️ Task 9: Setup Firestore Security Rules',
          body: '''In Firebase Console → Firestore Database → Rules:

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection - users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null 
        && request.auth.uid == userId;
    }
    
    // Notes collection - users can only access their own notes
    match /notes/{noteId} {
      allow read, write: if request.auth != null 
        && request.auth.uid == resource.data.uid;
      allow create: if request.auth != null 
        && request.auth.uid == request.resource.data.uid;
    }
  }
}

KEY POINTS:
- request.auth != null: User must be authenticated
- request.auth.uid == userId: User can only access their own data
- resource.data.uid: Existing document's user ID
- request.resource.data.uid: New document's user ID

TEST YOUR RULES:
- Use Firebase Console → Firestore → Rules → Rules Playground
- Test read/write operations with different user IDs''',
          category: 'Work',
          tags: ['security', 'firestore-rules', 'authentication'],
          pinned: false,
          priority: 'high',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Note(
          noteId: 'demo_11',
          uid: 'demo_user',
          title: '✅ Task 10: Testing Checklist',
          body: '''TESTING CHECKLIST:

AUTHENTICATION:
☐ User can sign up with email/password
☐ Additional user info is saved to Firestore
☐ User can sign in
☐ User can sign out
☐ Auth state persists on app restart
☐ Unauthenticated users are redirected to login

NOTES CRUD:
☐ Create note saves to Firestore
☐ Notes appear in list after creation
☐ Edit note updates Firestore
☐ Delete note removes from Firestore
☐ Toggle pinned updates Firestore

FILTERING:
☐ Filter by category works
☐ Filter by priority works
☐ Filter by tag works (arrayContains)
☐ Date filters work (recent/old)
☐ Search by title works
☐ Search by body works
☐ Multiple filters can be combined

QUERIES:
☐ getAllNotes() returns user's notes only
☐ Notes are ordered by pinned, then createdAt
☐ Composite indexes are created when needed
☐ No "index required" errors after setup

SECURITY:
☐ Users can only see their own notes
☐ Users can only create notes with their own uid
☐ Firestore rules prevent unauthorized access

UI/UX:
☐ Loading states show during operations
☐ Error messages display properly
☐ Empty states show when no notes
☐ Filters clear correctly''',
          category: 'Work',
          tags: ['testing', 'checklist', 'qa'],
          pinned: false,
          priority: 'medium',
          createdAt: DateTime.now().subtract(const Duration(days: 5, hours: 12)),
        ),
      ];
      _applyFilters();
    } catch (e) {
      _error = 'Failed to load notes: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new note
  Future<void> createNote(Note note) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Call _firebaseService.createNote(note)
      // After creation, reload notes
      // await _firebaseService.createNote(note);
      // await loadNotes();
      
      // TEMPORARY: Show message that Firebase needs to be implemented
      // Students will implement this in FirebaseService.createNote()
      _error = 'Note creation requires Firebase implementation. Please implement FirebaseService.createNote()';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to create note: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update an existing note
  Future<void> updateNote(Note note) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Call _firebaseService.updateNote(note)
      // await _firebaseService.updateNote(note);
      
      // TEMPORARY: For demo notes, allow local updates
      // Students will implement Firebase update in FirebaseService.updateNote()
      final index = _notes.indexWhere((n) => n.noteId == note.noteId);
      if (index != -1) {
        _notes[index] = note;
        _applyFilters();
      } else {
        _error = 'Note update requires Firebase implementation. Please implement FirebaseService.updateNote()';
      }
    } catch (e) {
      _error = 'Failed to update note: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete a note
  Future<void> deleteNote(String noteId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Call _firebaseService.deleteNote(noteId)
      // await _firebaseService.deleteNote(noteId);
      
      // TEMPORARY: For demo notes, allow local deletion
      // Students will implement Firebase delete in FirebaseService.deleteNote()
      _notes.removeWhere((note) => note.noteId == noteId);
      _applyFilters();
    } catch (e) {
      _error = 'Failed to delete note: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle pinned status
  Future<void> togglePinned(String noteId) async {
    final note = _notes.firstWhere((n) => n.noteId == noteId);
    final newPinnedStatus = !note.pinned;

    try {
      // TODO: Call _firebaseService.togglePinned(noteId, newPinnedStatus)
      // await _firebaseService.togglePinned(noteId, newPinnedStatus);
      
      // TEMPORARY: For demo notes, allow local toggle
      // Students will implement Firebase toggle in FirebaseService.togglePinned()
      final updatedNote = note.copyWith(pinned: newPinnedStatus);
      final index = _notes.indexWhere((n) => n.noteId == noteId);
      if (index != -1) {
        _notes[index] = updatedNote;
        _applyFilters();
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to toggle pinned: $e';
      notifyListeners();
    }
  }

  /// Filter by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  /// Filter by priority
  void filterByPriority(String priority) {
    _selectedPriority = priority;
    _applyFilters();
  }

  /// Filter by tag
  void filterByTag(String tag) {
    _selectedTag = tag.isEmpty ? '' : tag;
    _applyFilters();
  }

  /// Filter by date
  void filterByDate(String dateFilter) {
    _selectedDateFilter = dateFilter;
    _applyFilters();
  }

  /// Search notes
  void searchNotes(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  /// Clear all filters
  void clearFilters() {
    _selectedCategory = AppConstants.filterAll;
    _selectedPriority = AppConstants.filterAll;
    _selectedTag = '';
    _selectedDateFilter = AppConstants.filterAll;
    _searchQuery = '';
    _applyFilters();
  }

  /// Apply all active filters
  /// 
  /// TODO: Students will implement filtering logic
  /// This teaches client-side filtering vs server-side queries
  void _applyFilters() async {
    _filteredNotes = List<Note>.from(_notes);

    // TODO: Apply category filter
    // If _selectedCategory != AppConstants.filterAll, filter by category
    // Option 1: Filter client-side from _notes
    // Option 2: Call _firebaseService.getNotesByCategory() for server-side

    // TODO: Apply priority filter
    // If _selectedPriority != AppConstants.filterAll, filter by priority

    // TODO: Apply tag filter
    // If _selectedTag is not empty, filter by tag
    // Option 1: Filter client-side: note.tags.contains(_selectedTag)
    // Option 2: Call _firebaseService.getNotesByTag() for server-side

    // TODO: Apply date filter
    // If _selectedDateFilter == AppConstants.filterRecent, show last 7 days
    // If _selectedDateFilter == AppConstants.filterOld, show older than 30 days
    // If _selectedDateFilter == AppConstants.filterWithReminders, show notes with reminders
    // Option 1: Filter client-side
    // Option 2: Call appropriate FirebaseService method for server-side

    // TODO: Apply search query
    // If _searchQuery is not empty, filter by title or body
    // For title: note.title.toLowerCase().contains(_searchQuery.toLowerCase())
    // For body: note.body.toLowerCase().contains(_searchQuery.toLowerCase())
    // Or call _firebaseService.searchNotesByTitle/Body() for server-side

    notifyListeners();
  }

  /// Get unique tags from all notes
  List<String> getUniqueTags() {
    final tags = <String>{};
    for (var note in _notes) {
      tags.addAll(note.tags);
    }
    return tags.toList()..sort();
  }

  /// Get notes count by category
  Map<String, int> getNotesCountByCategory() {
    final counts = <String, int>{};
    for (var note in _notes) {
      counts[note.category] = (counts[note.category] ?? 0) + 1;
    }
    return counts;
  }
}

