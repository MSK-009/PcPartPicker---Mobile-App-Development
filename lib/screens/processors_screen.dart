import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pc_part_picker/models/processor.dart';
import 'package:pc_part_picker/providers/processor_provider.dart';
import 'package:pc_part_picker/providers/list_provider.dart';
import 'package:pc_part_picker/providers/build_provider.dart';
import 'package:pc_part_picker/widgets/app_bar.dart';
import 'package:pc_part_picker/widgets/search_widget.dart';
import 'package:pc_part_picker/widgets/component_card.dart';
import 'package:pc_part_picker/widgets/pagination_controls.dart';
import 'package:pc_part_picker/widgets/component_details_dialog.dart';
import 'package:pc_part_picker/widgets/footer_widget.dart';
import 'package:pc_part_picker/screens/pc_builder_screen.dart';
import 'package:go_router/go_router.dart';

class ProcessorsScreen extends StatefulWidget {
  final bool isBuilderMode;
  
  const ProcessorsScreen({
    Key? key, 
    this.isBuilderMode = false,
  }) : super(key: key);

  @override
  State<ProcessorsScreen> createState() => _ProcessorsScreenState();
}

class _ProcessorsScreenState extends State<ProcessorsScreen> {
  int _page = 1;
  String _searchTerm = '';
  int _pageSize = 12;
  String _sortParameter = 'CPU_name';
  String _sortOrder = 'asc';
  bool _isLoading = false;
  bool _showFooter = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    Future.microtask(() => _loadProcessors());
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

  Future<void> _loadProcessors() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<ProcessorProvider>(context, listen: false).getProcessors(
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
    _loadProcessors();
  }

  void _onPageChanged(int page) {
    setState(() {
      _page = page;
    });
    _loadProcessors();
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
    _loadProcessors();
  }

  void _showProcessorDetails(Processor processor) {
    final listProvider = Provider.of<ListProvider>(context, listen: false);
    final isSelected = listProvider.selectedProcessor?.id == processor.id;

    showDialog(
      context: context,
      builder: (context) => ComponentDetailsDialog(
        title: processor.cpuName,
        imageUrl: processor.image,
        details: [
          {'label': 'Cores', 'value': processor.cores},
          {'label': 'Threads', 'value': processor.threads},
          {'label': 'Base Clock', 'value': processor.baseClock},
          {'label': 'Boost Clock', 'value': processor.turboClock},
          {'label': 'TDP', 'value': processor.tdp},
          {'label': 'Released', 'value': processor.released},
          {'label': 'Price', 'value': processor.price},
        ],
        onRemove: isSelected ? () => listProvider.removeProcessor() : null,
        isSelected: isSelected,
      ),
    );
  }

  void _selectProcessor(Processor processor) {
    final listProvider = Provider.of<ListProvider>(context, listen: false);
    
    // Set the processor in the ListProvider
    listProvider.setProcessor(processor);
    
    // If in builder mode, also add it to the current build
    if (widget.isBuilderMode) {
      // Get the current build from BuildProvider
      final buildProvider = Provider.of<BuildProvider>(context, listen: false);
      
      // Create a new build or update the existing one
      final currentBuild = buildProvider.selectedBuild ?? 
        (buildProvider.builds.isNotEmpty ? buildProvider.builds.first : null);
      
      if (currentBuild != null) {
        // Update the build with the selected processor
        // This is a simplified example; you might need to adjust based on your Build model
        final updatedBuild = currentBuild;
        // You would update the processor here
        
        // Update the selectedBuild in the provider
        buildProvider.setSelectedBuild(updatedBuild);
      }
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${processor.cpuName} added to your build'),
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
    final processorProvider = Provider.of<ProcessorProvider>(context);
    final listProvider = Provider.of<ListProvider>(context);
    final processors = processorProvider.processors;
    final totalResults = processorProvider.totalResults;
    final totalPages = (totalResults / _pageSize).ceil();

    // In builder mode, we don't need to show the full app bar
    final screenWidget = Scaffold(
      appBar: widget.isBuilderMode ? null : CustomAppBar(
        title: 'Processors',
      ),
      body: Column(
        children: [
          // Information banner for browse mode
          if (!widget.isBuilderMode)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.blue.withOpacity(0.1),
              width: double.infinity,
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Browse Mode',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'You can view component details here but to select components for your build, use the "BUILD PC" button in the app bar.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/pc-builder'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('BUILD PC'),
                  ),
                ],
              ),
            ),
            
          // Only show filter/sort in normal mode
          if (!widget.isBuilderMode)
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
                    hintText: 'Search processors...',
                  ),

                  const SizedBox(height: 16),

                  // Sort Options - Make it scrollable to avoid overflow
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
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
                          _sortParameter == 'CPU_name' && _sortOrder == 'asc',
                          () => _onSortChanged('CPU_name', 'asc'),
                        ),
                        const SizedBox(width: 8),
                        _buildSortButton(
                          'Name Z-A',
                          _sortParameter == 'CPU_name' && _sortOrder == 'desc',
                          () => _onSortChanged('CPU_name', 'desc'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Builder mode instructions
          if (widget.isBuilderMode)
            Container(
              padding: const EdgeInsets.all(12),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              width: double.infinity,
              child: Text(
                'Select a processor for your build',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // Main Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : processors.isEmpty
                    ? const Center(
                        child: Text('No processors found'),
                      )
                    : SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Grid of Processor Cards
                              AlignedGridView.count(
                                crossAxisCount: widget.isBuilderMode ? 2 : 3,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: processors.length,
                                itemBuilder: (context, index) {
                                  final processor = processors[index];
                                  final isSelected =
                                      listProvider.selectedProcessor?.id ==
                                          processor.id;

                                  return ComponentCard(
                                    image: processor.image,
                                    name: processor.cpuName,
                                    price: processor.price,
                                    isSelected: isSelected,
                                    onTap: () {
                                      if (isSelected) {
                                        // If already selected, show details
                                        _showProcessorDetails(processor);
                                      } else if (widget.isBuilderMode) {
                                        // Only allow selection in builder mode
                                        _selectProcessor(processor);
                                        
                                        // Show confirmation dialog and automatically proceed to next step
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Processor Selected'),
                                            content: Text('${processor.cpuName} has been added to your build.'),
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
                                        _showProcessorDetails(processor);
                                      }
                                    },
                                  );
                                },
                              ),

                              // Only show pagination in normal mode
                              if (!widget.isBuilderMode) ...[
                                const SizedBox(height: 20),
                                PaginationControls(
                                  currentPage: _page,
                                  totalPages: totalPages,
                                  onPageChanged: _onPageChanged,
                                ),
                                const SizedBox(height: 30),
                              ],

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
