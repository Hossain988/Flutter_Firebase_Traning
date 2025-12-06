import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Filter Chips Widget
/// 
/// Displays filter options for categories, priorities, tags, and date filters
class FilterChips extends StatelessWidget {
  final String selectedCategory;
  final String selectedPriority;
  final String selectedDateFilter;
  final Function(String) onCategoryChanged;
  final Function(String) onPriorityChanged;
  final Function(String) onDateFilterChanged;
  final VoidCallback onClearFilters;

  const FilterChips({
    super.key,
    required this.selectedCategory,
    required this.selectedPriority,
    required this.selectedDateFilter,
    required this.onCategoryChanged,
    required this.onPriorityChanged,
    required this.onDateFilterChanged,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Filter
          _buildFilterSection(
            title: 'Category',
            items: [AppConstants.filterAll, ...AppConstants.categories],
            selected: selectedCategory,
            onChanged: onCategoryChanged,
          ),
          const SizedBox(height: 8),
          
          // Priority Filter
          _buildFilterSection(
            title: 'Priority',
            items: [AppConstants.filterAll, ...AppConstants.priorities],
            selected: selectedPriority,
            onChanged: onPriorityChanged,
          ),
          const SizedBox(height: 8),
          
          // Date Filter
          _buildFilterSection(
            title: 'Date',
            items: AppConstants.dateFilters,
            selected: selectedDateFilter,
            onChanged: onDateFilterChanged,
          ),
          const SizedBox(height: 8),
          
          // Clear Filters Button
          if (selectedCategory != AppConstants.filterAll ||
              selectedPriority != AppConstants.filterAll ||
              selectedDateFilter != AppConstants.filterAll)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(Icons.clear_all, size: 16),
                label: const Text('Clear Filters'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<String> items,
    required String selected,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: items.map((item) {
              final isSelected = selected == item;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(item),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      onChanged(item);
                    }
                  },
                  selectedColor: Colors.blue.shade100,
                  checkmarkColor: Colors.blue,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

