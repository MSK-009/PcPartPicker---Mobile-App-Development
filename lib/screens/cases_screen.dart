import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pc_part_picker/models/case.dart';
import 'package:pc_part_picker/providers/case_provider.dart';
import 'package:pc_part_picker/providers/list_provider.dart';
import 'package:pc_part_picker/widgets/app_bar.dart';
import 'package:pc_part_picker/widgets/search_widget.dart';
import 'package:pc_part_picker/widgets/component_card.dart';
import 'package:pc_part_picker/widgets/pagination_controls.dart';
import 'package:pc_part_picker/widgets/component_details_dialog.dart';
import 'package:pc_part_picker/widgets/footer_widget.dart';

class CasesScreen extends StatefulWidget {
  const CasesScreen({Key? key}) : super(key: key);

  @override
  State<CasesScreen> createState() => _CasesScreenState();
}

class _CasesScreenState extends State<CasesScreen> {
  int _page = 1;
  String _searchTerm = '';
  int _pageSize = 12;
  String _sortParameter = 'CASE_name';
  String _sortOrder = 'asc';
  bool _isLoading = false;
  bool _showFooter = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    Future.microtask(() => _loadCases());
  }

  void _handleScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Show footer when near bottom (e.g., within 200px)
    if (currentScroll >= maxScroll - 200) {
      if (!_showFooter) {
        setState(() {
          _showFooter = true;
        });
      }
    } else {
      if (_showFooter) {
        setState(() {
          _showFooter = false;
        });
      }
    }
  }

  Future<void> _loadCases() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<CaseProvider>(context, listen: false).getCases(
      pageSize: _pageSize,
      page: _page,
      searchTerm: _searchTerm,
      sortParameter: _sortParameter,
      sortOrder: _sortOrder,
    );

    setState(() {
      _isLoading = false;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchTerm = value;
      _page = 1; // Reset to first page when search changes
    });
    _loadCases();
  }

  void _onPageChanged(int page) {
    setState(() {
      _page = page;
    });
    _loadCases();
    // Scroll to top when page changes
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _onSortChanged(String parameter, String order) {
    setState(() {
      _sortParameter = parameter;
      _sortOrder = order;
      _page = 1; // Reset to first page when sort changes
    });
    _loadCases();
  }

  void _showCaseDetails(Case caseItem) {
    final listProvider = Provider.of<ListProvider>(context, listen: false);
    final isSelected = listProvider.selectedCase?.id == caseItem.id;

    showDialog(
      context: context,
      builder: (context) => ComponentDetailsDialog(
        title: caseItem.caseName,
        imageUrl: caseItem.image,
        details: [
          {'label': 'Type', 'value': caseItem.type},
          {'label': 'Color', 'value': caseItem.color},
          {'label': 'Price', 'value': caseItem.price},
        ],
        onRemove: isSelected ? () => listProvider.removeCase() : null,
        isSelected: isSelected,
      ),
    );
  }

  void _selectCase(Case caseItem) {
    Provider.of<ListProvider>(context, listen: false).setCase(caseItem);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${caseItem.caseName} added to your build'),
        backgroundColor: Theme.of(context).primaryColor,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW',
          onPressed: () {
            // Show the parts list
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => CustomAppBar(
                title: '',
                showActions: false,
              ).buildPartsListBottomSheet(context),
            );
          },
          textColor: Colors.white,
        ),
      ),
    );
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final caseProvider = Provider.of<CaseProvider>(context);
    final listProvider = Provider.of<ListProvider>(context);
    final cases = caseProvider.cases;
    final totalResults = caseProvider.totalResults;
    final totalPages = (totalResults / _pageSize).ceil();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Cases'),
      body: Column(
        children: [
          // Filter and Sort Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Field
                SearchWidget(
                  searchTerm: _searchTerm,
                  onSearchChanged: _onSearchChanged,
                  hintText: 'Search cases...',
                ),

                const SizedBox(height: 16),

                // Sort Options
                Row(
                  children: [
                    const Text(
                      'Sort by:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildSortButton(
                      'Price ↑',
                      _sortParameter == 'Price' && _sortOrder == 'asc',
                      () => _onSortChanged('Price', 'asc'),
                    ),
                    const SizedBox(width: 8),
                    _buildSortButton(
                      'Price ↓',
                      _sortParameter == 'Price' && _sortOrder == 'desc',
                      () => _onSortChanged('Price', 'desc'),
                    ),
                    const SizedBox(width: 8),
                    _buildSortButton(
                      'Name A-Z',
                      _sortParameter == 'CASE_name' && _sortOrder == 'asc',
                      () => _onSortChanged('CASE_name', 'asc'),
                    ),
                    const SizedBox(width: 8),
                    _buildSortButton(
                      'Name Z-A',
                      _sortParameter == 'CASE_name' && _sortOrder == 'desc',
                      () => _onSortChanged('CASE_name', 'desc'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : cases.isEmpty
                    ? const Center(
                        child: Text('No cases found'),
                      )
                    : SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding:
                              const EdgeInsets.all(0), //mcmdcmdckmdckmdcdmco
                          child: Column(
                            children: [
                              // Grid of Case Cards
                              AlignedGridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: cases.length,
                                itemBuilder: (context, index) {
                                  final caseItem = cases[index];
                                  final isSelected =
                                      listProvider.selectedCase?.id ==
                                          caseItem.id;

                                  return ComponentCard(
                                    image: caseItem.image,
                                    name: caseItem.caseName,
                                    price: caseItem.price,
                                    isSelected: isSelected,
                                    onTap: () {
                                      if (isSelected) {
                                        _showCaseDetails(caseItem);
                                      } else {
                                        _selectCase(caseItem);
                                      }
                                    },
                                  );
                                },
                              ),

                              // Pagination
                              const SizedBox(height: 20),
                              PaginationControls(
                                currentPage: _page,
                                totalPages: totalPages,
                                onPageChanged: _onPageChanged,
                              ),
                              const SizedBox(height: 30),

                              AnimatedSlide(
                                offset: _showFooter
                                    ? Offset.zero
                                    : const Offset(0, 0.1),
                                duration: const Duration(milliseconds: 300),
                                child: AnimatedOpacity(
                                  opacity: _showFooter ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: const FooterWidget(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
          )
        ],
      ),
    );
  }

  Widget _buildSortButton(
      String text, bool isSelected, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? Theme.of(context).primaryColor : Colors.grey.shade200,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(text),
    );
  }
}
