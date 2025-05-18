import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pc_part_picker/models/motherboard.dart';
import 'package:pc_part_picker/providers/motherboard_provider.dart';
import 'package:pc_part_picker/providers/list_provider.dart';
import 'package:pc_part_picker/widgets/app_bar.dart';
import 'package:pc_part_picker/widgets/search_widget.dart';
import 'package:pc_part_picker/widgets/component_card.dart';
import 'package:pc_part_picker/widgets/pagination_controls.dart';
import 'package:pc_part_picker/widgets/component_details_dialog.dart';
import 'package:pc_part_picker/widgets/footer_widget.dart';

class MotherboardScreen extends StatefulWidget {
  const MotherboardScreen({Key? key}) : super(key: key);

  @override
  State<MotherboardScreen> createState() => _MotherboardScreenState();
}

class _MotherboardScreenState extends State<MotherboardScreen> {
  int _page = 1;
  String _searchTerm = '';
  int _pageSize = 12;
  String _sortParameter = 'Manufacturer';
  String _sortOrder = 'asc';
  bool _isLoading = false;
  bool _showFooter = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    Future.microtask(() => _loadMotherboards());
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

  Future<void> _loadMotherboards() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<MotherboardProvider>(context, listen: false)
        .getMotherboards(
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
    _loadMotherboards();
  }

  void _onPageChanged(int page) {
    setState(() {
      _page = page;
    });
    _loadMotherboards();
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
    _loadMotherboards();
  }

  void _showMotherboardDetails(Motherboard motherboard) {
    final listProvider = Provider.of<ListProvider>(context, listen: false);
    final isSelected = listProvider.selectedMotherboard?.id == motherboard.id;

    showDialog(
      context: context,
      builder: (context) => ComponentDetailsDialog(
        title: '${motherboard.manufacturer} ${motherboard.chipset}',
        imageUrl: motherboard.image,
        details: [
          {'label': 'Socket', 'value': motherboard.socket},
          {'label': 'Chipset', 'value': motherboard.chipset},
          {'label': 'Form Factor', 'value': motherboard.formFactor},
          {'label': 'Memory Slots', 'value': motherboard.memorySlots},
          {'label': 'Memory Type', 'value': motherboard.memoryType},
          {'label': 'Manufacturer', 'value': motherboard.manufacturer},
          {'label': 'Price', 'value': '\$${motherboard.price}'},
        ],
        onRemove: isSelected ? () => listProvider.removeMotherboard() : null,
        isSelected: isSelected,
      ),
    );
  }

  void _selectMotherboard(Motherboard motherboard) {
    Provider.of<ListProvider>(context, listen: false)
        .setMotherboard(motherboard);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${motherboard.chipset} added to your build'),
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
    final motherboardProvider = Provider.of<MotherboardProvider>(context);
    final listProvider = Provider.of<ListProvider>(context);
    final motherboards = motherboardProvider.motherboards;
    final totalResults = motherboardProvider.totalResults;
    final totalPages = (totalResults / _pageSize).ceil();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Motherboards'),
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
                  hintText: 'Search motherboards...',
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
                      _sortParameter == 'Manufacturer' && _sortOrder == 'asc',
                      () => _onSortChanged('Manufacturer', 'asc'),
                    ),
                    const SizedBox(width: 8),
                    _buildSortButton(
                      'Name Z-A',
                      _sortParameter == 'Manufacturer' && _sortOrder == 'desc',
                      () => _onSortChanged('Manufacturer', 'desc'),
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
                : motherboards.isEmpty
                    ? const Center(
                        child: Text('No motherboards found'),
                      )
                    : SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            children: [
                              // Grid of Motherboard Cards
                              AlignedGridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: motherboards.length,
                                itemBuilder: (context, index) {
                                  final motherboard = motherboards[index];
                                  final isSelected =
                                      listProvider.selectedMotherboard?.id ==
                                          motherboard.id;

                                  return ComponentCard(
                                    image: motherboard.image,
                                    name:
                                        '${motherboard.manufacturer} ${motherboard.chipset}',
                                    price: '\$${motherboard.price}',
                                    isSelected: isSelected,
                                    onTap: () {
                                      if (isSelected) {
                                        _showMotherboardDetails(motherboard);
                                      } else {
                                        _selectMotherboard(motherboard);
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

                              // 👇 Move footer here
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
