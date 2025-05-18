import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pc_part_picker/models/ssd.dart';
import 'package:pc_part_picker/providers/ssd_provider.dart';
import 'package:pc_part_picker/providers/list_provider.dart';
import 'package:pc_part_picker/widgets/app_bar.dart';
import 'package:pc_part_picker/widgets/search_widget.dart';
import 'package:pc_part_picker/widgets/component_card.dart';
import 'package:pc_part_picker/widgets/pagination_controls.dart';
import 'package:pc_part_picker/widgets/component_details_dialog.dart';
import 'package:pc_part_picker/widgets/footer_widget.dart';

class SsdScreen extends StatefulWidget {
  const SsdScreen({Key? key}) : super(key: key);

  @override
  State<SsdScreen> createState() => _SsdScreenState();
}

class _SsdScreenState extends State<SsdScreen> {
  int _page = 1;
  String _searchTerm = '';
  int _pageSize = 12;
  String _sortParameter = 'SSD_name';
  String _sortOrder = 'asc';
  bool _isLoading = false;
  bool _showFooter = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    Future.microtask(() => _loadSsds());
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

  Future<void> _loadSsds() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<SsdProvider>(context, listen: false).getSsds(
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
    _loadSsds();
  }

  void _onPageChanged(int page) {
    setState(() {
      _page = page;
    });
    _loadSsds();
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
    _loadSsds();
  }

  void _showSsdDetails(Ssd ssd) {
    final listProvider = Provider.of<ListProvider>(context, listen: false);
    final isSelected = listProvider.selectedSsd?.id == ssd.id;

    showDialog(
      context: context,
      builder: (context) => ComponentDetailsDialog(
        title: ssd.ssdName,
        imageUrl: ssd.image,
        details: [
          {'label': 'Capacity', 'value': ssd.capacity},
          {'label': 'Interface', 'value': ssd.interface},
          {'label': 'Price', 'value': ssd.price},
        ],
        onRemove: isSelected ? () => listProvider.removeSsd() : null,
        isSelected: isSelected,
      ),
    );
  }

  void _selectSsd(Ssd ssd) {
    Provider.of<ListProvider>(context, listen: false).setSsd(ssd);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${ssd.ssdName} added to your build'),
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
    final ssdProvider = Provider.of<SsdProvider>(context);
    final listProvider = Provider.of<ListProvider>(context);
    final ssds = ssdProvider.ssds;
    final totalResults = ssdProvider.totalResults;
    final totalPages = (totalResults / _pageSize).ceil();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Storage'),
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
                  hintText: 'Search storage devices...',
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
                      _sortParameter == 'SSD_name' && _sortOrder == 'asc',
                      () => _onSortChanged('SSD_name', 'asc'),
                    ),
                    const SizedBox(width: 8),
                    _buildSortButton(
                      'Name Z-A',
                      _sortParameter == 'SSD_name' && _sortOrder == 'desc',
                      () => _onSortChanged('SSD_name', 'desc'),
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
                : ssds.isEmpty
                    ? const Center(
                        child: Text('No storage devices found'),
                      )
                    : SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            children: [
                              // Grid of SSD Cards
                              AlignedGridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: ssds.length,
                                itemBuilder: (context, index) {
                                  final ssd = ssds[index];
                                  final isSelected =
                                      listProvider.selectedSsd?.id == ssd.id;

                                  return ComponentCard(
                                    image: ssd.image,
                                    name: ssd.ssdName,
                                    price: ssd.price,
                                    isSelected: isSelected,
                                    onTap: () {
                                      if (isSelected) {
                                        _showSsdDetails(ssd);
                                      } else {
                                        _selectSsd(ssd);
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
