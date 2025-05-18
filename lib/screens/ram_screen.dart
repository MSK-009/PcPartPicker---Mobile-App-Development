import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pc_part_picker/models/ram.dart';
import 'package:pc_part_picker/providers/ram_provider.dart';
import 'package:pc_part_picker/providers/list_provider.dart';
import 'package:pc_part_picker/widgets/app_bar.dart';
import 'package:pc_part_picker/widgets/search_widget.dart';
import 'package:pc_part_picker/widgets/component_card.dart';
import 'package:pc_part_picker/widgets/pagination_controls.dart';
import 'package:pc_part_picker/widgets/component_details_dialog.dart';
import 'package:pc_part_picker/widgets/footer_widget.dart';
import 'package:pc_part_picker/screens/pc_builder_screen.dart';

class RamScreen extends StatefulWidget {
  final bool isBuilderMode;
  
  const RamScreen({
    Key? key,
    this.isBuilderMode = false,
  }) : super(key: key);

  @override
  State<RamScreen> createState() => _RamScreenState();
}

class _RamScreenState extends State<RamScreen> {
  int _page = 1;
  String _searchTerm = '';
  int _pageSize = 12;
  String _sortParameter = 'RAM_name';
  String _sortOrder = 'asc';
  bool _isLoading = false;
  bool _showFooter = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    Future.microtask(() => _loadRams());
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

  Future<void> _loadRams() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<RamProvider>(context, listen: false).getRams(
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
    _loadRams();
  }

  void _onPageChanged(int page) {
    setState(() {
      _page = page;
    });
    _loadRams();
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
    _loadRams();
  }

  void _showRamDetails(Ram ram) {
    final listProvider = Provider.of<ListProvider>(context, listen: false);
    final isSelected = listProvider.selectedRam?.id == ram.id;

    showDialog(
      context: context,
      builder: (context) => ComponentDetailsDialog(
        title: ram.ramName,
        imageUrl: ram.image,
        details: [
          {'label': 'Latency', 'value': ram.latency},
          {'label': 'Multicore R/W', 'value': ram.multicore},
          {'label': 'Singlecore R/W', 'value': ram.singlecore},
          {'label': 'Released', 'value': ram.released},
          {'label': 'Price', 'value': ram.price},
        ],
        onRemove: isSelected ? () => listProvider.removeRam() : null,
        isSelected: isSelected,
      ),
    );
  }

  void _selectRam(Ram ram) {
    Provider.of<ListProvider>(context, listen: false).setRam(ram);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${ram.ramName} added to your build'),
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
    final ramProvider = Provider.of<RamProvider>(context);
    final listProvider = Provider.of<ListProvider>(context);
    final rams = ramProvider.rams;
    final totalResults = ramProvider.totalResults;
    final totalPages = (totalResults / _pageSize).ceil();

    final screenWidget = Scaffold(
      appBar: widget.isBuilderMode ? null : const CustomAppBar(title: 'RAM'),
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
                  hintText: 'Search memory...',
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
                      _sortParameter == 'RAM_name' && _sortOrder == 'asc',
                      () => _onSortChanged('RAM_name', 'asc'),
                    ),
                    const SizedBox(width: 8),
                    _buildSortButton(
                      'Name Z-A',
                      _sortParameter == 'RAM_name' && _sortOrder == 'desc',
                      () => _onSortChanged('RAM_name', 'desc'),
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
                : rams.isEmpty
                    ? const Center(
                        child: Text('No RAM modules found'),
                      )
                    : SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            children: [
                              // Grid of RAM Cards
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: AlignedGridView.count(
                                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: rams.length,
                                  itemBuilder: (context, index) {
                                    final ram = rams[index];
                                    final isSelected =
                                        listProvider.selectedRam?.id == ram.id;

                                    return ComponentCard(
                                      image: ram.image,
                                      name: ram.ramName,
                                      price: ram.price,
                                      isSelected: isSelected,
                                      onTap: () {
                                        if (isSelected) {
                                          // If already selected, show details
                                          _showRamDetails(ram);
                                        } else if (widget.isBuilderMode) {
                                          // Only allow selection in builder mode
                                          _selectRam(ram);
                                          
                                          // Show confirmation dialog and automatically proceed to next step
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) => AlertDialog(
                                              title: const Text('RAM Selected'),
                                              content: Text('${ram.ramName} has been added to your build.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    // Find the parent PcBuilderScreen and call its nextStep method
                                                    final ancestor = context.findAncestorStateOfType<PcBuilderScreenState>();
                                                    if (ancestor != null) {
                                                      ancestor.nextStep();
                                                    }
                                                  },
                                                  child: const Text('NEXT'),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          // In browse mode, just show details instead of selecting
                                          _showRamDetails(ram);
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),

                              // Pagination
                              const SizedBox(height: 20),
                              PaginationControls(
                                currentPage: _page,
                                totalPages: totalPages,
                                onPageChanged: _onPageChanged,
                              ),
                              const SizedBox(height: 30),

                              // Footer (only show if not in builder mode)
                              if (!widget.isBuilderMode)
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
    
    return screenWidget;
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
