import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

/// Add/Edit Note Screen
/// 
/// Screen for creating new notes or editing existing ones
class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  late TextEditingController _tagController;

  String _selectedCategory = AppConstants.categories[0];
  String _selectedPriority = AppConstants.priorityMedium;
  bool _pinned = false;
  List<String> _tags = [];
  DateTime? _reminderDate;

  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController = TextEditingController(text: widget.note!.title);
      _bodyController = TextEditingController(text: widget.note!.body);
      _selectedCategory = widget.note!.category;
      _selectedPriority = widget.note!.priority;
      _pinned = widget.note!.pinned;
      _tags = List<String>.from(widget.note!.tags);
      _reminderDate = widget.note!.reminderDate;
    } else {
      _titleController = TextEditingController();
      _bodyController = TextEditingController();
    }
    _tagController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  Future<void> _selectReminderDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _reminderDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null && mounted) {
        setState(() {
          _reminderDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      final notesProvider = context.read<NotesProvider>();
      final authProvider = context.read<AuthProvider>();
      
      // TODO: Students need to get current user ID from AuthProvider
      // Get user ID from authenticated user
      final currentUserId = authProvider.currentUser?.uid;
      
      if (currentUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be logged in to create notes'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final note = Note(
        noteId: isEditing ? widget.note!.noteId : '',
        uid: isEditing ? widget.note!.uid : currentUserId,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        category: _selectedCategory,
        tags: _tags,
        pinned: _pinned,
        priority: _selectedPriority,
        createdAt: isEditing ? widget.note!.createdAt : DateTime.now(),
        reminderDate: _reminderDate,
      );

      if (isEditing) {
        notesProvider.updateNote(note);
      } else {
        notesProvider.createNote(note);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
            tooltip: 'Save',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title Field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter note title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Body Field
            TextFormField(
              controller: _bodyController,
              decoration: const InputDecoration(
                labelText: 'Body',
                hintText: 'Enter note content',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 8,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: AppConstants.categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Priority Dropdown
            DropdownButtonFormField<String>(
              value: _selectedPriority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag),
              ),
              items: AppConstants.priorities.map((priority) {
                Color priorityColor;
                switch (priority) {
                  case AppConstants.priorityHigh:
                    priorityColor = Colors.red;
                    break;
                  case AppConstants.priorityMedium:
                    priorityColor = Colors.orange;
                    break;
                  case AppConstants.priorityLow:
                    priorityColor = Colors.green;
                    break;
                  default:
                    priorityColor = Colors.grey;
                }
                return DropdownMenuItem(
                  value: priority,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: priorityColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(priority.toUpperCase()),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPriority = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Pinned Toggle
            SwitchListTile(
              title: const Text('Pin Note'),
              subtitle: const Text('Pin this note to the top'),
              value: _pinned,
              onChanged: (value) {
                setState(() {
                  _pinned = value;
                });
              },
              secondary: const Icon(Icons.push_pin),
            ),
            const SizedBox(height: 16),

            // Tags Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tags',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _tagController,
                            decoration: InputDecoration(
                              hintText: 'Add a tag',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: _addTag,
                              ),
                            ),
                            onSubmitted: (_) => _addTag(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_tags.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: _tags.map((tag) {
                          return Chip(
                            label: Text(tag),
                            onDeleted: () => _removeTag(tag),
                            deleteIcon: const Icon(Icons.close, size: 18),
                          );
                        }).toList(),
                      ),
                    if (_tags.isEmpty)
                      Text(
                        'No tags added',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Reminder Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reminder',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      leading: const Icon(Icons.notifications),
                      title: Text(
                        _reminderDate != null
                            ? DateFormat('MMM dd, yyyy • HH:mm')
                                .format(_reminderDate!)
                            : 'No reminder set',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_reminderDate != null)
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _reminderDate = null;
                                });
                              },
                              tooltip: 'Remove reminder',
                            ),
                          ElevatedButton(
                            onPressed: _selectReminderDate,
                            child: Text(_reminderDate == null
                                ? 'Set Reminder'
                                : 'Change'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton.icon(
              onPressed: _saveNote,
              icon: const Icon(Icons.save),
              label: Text(isEditing ? 'Update Note' : 'Create Note'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

