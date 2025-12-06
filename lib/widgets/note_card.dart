import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';
import '../utils/constants.dart';

/// Note Card Widget
/// 
/// Displays a single note with all its properties
class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onTogglePinned;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.onTogglePinned,
  });

  Color _getPriorityColor() {
    switch (note.priority) {
      case AppConstants.priorityHigh:
        return Colors.red;
      case AppConstants.priorityMedium:
        return Colors.orange;
      case AppConstants.priorityLow:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: note.pinned ? 4 : 2,
      color: note.pinned ? Colors.amber.shade50 : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Pinned icon, Title, Priority
              Row(
                children: [
                  if (note.pinned)
                    IconButton(
                      icon: const Icon(Icons.push_pin, color: Colors.amber),
                      onPressed: onTogglePinned,
                      tooltip: 'Unpin',
                    ),
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Priority indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getPriorityColor().withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getPriorityColor(),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      note.priority.toUpperCase(),
                      style: TextStyle(
                        color: _getPriorityColor(),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Category
              Row(
                children: [
                  Icon(Icons.category, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    note.category,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Body preview
              Text(
                note.body,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // Tags
              if (note.tags.isNotEmpty)
                Wrap(
                  spacing: 4,
                  children: note.tags.map((tag) {
                    return Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(fontSize: 10),
                      ),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
              
              const SizedBox(height: 8),
              
              // Footer: Date and actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('MMM dd, yyyy • HH:mm').format(note.createdAt),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    children: [
                      if (!note.pinned)
                        IconButton(
                          icon: const Icon(Icons.push_pin_outlined),
                          onPressed: onTogglePinned,
                          tooltip: 'Pin',
                          iconSize: 20,
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: onDelete,
                        tooltip: 'Delete',
                        iconSize: 20,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
              
              // Reminder indicator
              if (note.reminderDate != null)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.notifications, size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 4),
                      Text(
                        'Reminder: ${DateFormat('MMM dd, yyyy • HH:mm').format(note.reminderDate!)}',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

