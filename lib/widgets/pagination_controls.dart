import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;
  final int maxVisiblePages;

  const PaginationControls({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.maxVisiblePages = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    final actualMaxVisible = maxVisiblePages.clamp(3, 9);
    final halfVisible = actualMaxVisible ~/ 2;
    
    int startPage = (currentPage - halfVisible).clamp(1, totalPages);
    int endPage = (startPage + actualMaxVisible - 1).clamp(1, totalPages);
    
    // Adjust startPage if endPage is at max
    if (endPage == totalPages) {
      startPage = (endPage - actualMaxVisible + 1).clamp(1, totalPages);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous button
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: currentPage > 1
                ? () => onPageChanged(currentPage - 1)
                : null,
            color: Theme.of(context).primaryColor,
          ),
          
          // First page button if not visible
          if (startPage > 1) ...[
            _buildPageButton(context, 1),
            if (startPage > 2)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '...',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
          
          // Visible page buttons
          for (int i = startPage; i <= endPage; i++)
            _buildPageButton(context, i),
          
          // Last page button if not visible
          if (endPage < totalPages) ...[
            if (endPage < totalPages - 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '...',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            _buildPageButton(context, totalPages),
          ],
          
          // Next button
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(BuildContext context, int page) {
    final isSelected = page == currentPage;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: isSelected ? null : () => onPageChanged(page),
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '$page',
            style: TextStyle(
              color: isSelected ? Colors.white : Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
} 