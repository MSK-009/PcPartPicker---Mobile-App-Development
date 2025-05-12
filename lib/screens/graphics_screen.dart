import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pc_part_picker/models/gpu.dart';
import 'package:pc_part_picker/providers/gpu_provider.dart';
import 'package:pc_part_picker/providers/list_provider.dart';
import 'package:pc_part_picker/widgets/app_bar.dart';
import 'package:pc_part_picker/widgets/search_widget.dart';
import 'package:pc_part_picker/widgets/component_card.dart';
import 'package:pc_part_picker/widgets/pagination_controls.dart';
import 'package:pc_part_picker/widgets/component_details_dialog.dart';
import 'package:pc_part_picker/widgets/footer_widget.dart';

class GraphicsScreen extends StatefulWidget {
  const GraphicsScreen({Key? key}) : super(key: key);

  @override
  State<GraphicsScreen> createState() => _GraphicsScreenState();
}

class _GraphicsScreenState extends State<GraphicsScreen> {
  int _page = 1;
  String _searchTerm = '';
  int _pageSize = 12;
  String _sortParameter = 'GPU_name';
  String _sortOrder = 'asc';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadGpus());
  }

  Future<void> _loadGpus() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<GpuProvider>(context, listen: false).getGpus(
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
    _loadGpus();
  }

  void _onPageChanged(int page) {
    setState(() {
      _page = page;
    });
    _loadGpus();
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
    _loadGpus();
  }

  void _showGpuDetails(Gpu gpu) {
    final listProvider = Provider.of<ListProvider>(context, listen: false);
    final isSelected = listProvider.selectedGpu?.id == gpu.id;

    showDialog(
      context: context,
      builder: (context) => ComponentDetailsDialog(
        title: gpu.gpuName,
        imageUrl: gpu.image,
        details: [
          {'label': 'Base Clock', 'value': gpu.baseClock},
          {'label': 'Boost Clock', 'value': gpu.boostClock},
          {'label': 'Memory', 'value': gpu.memory},
          {'label': 'TDP', 'value': gpu.tdp},
          {'label': 'Price', 'value': gpu.price},
        ],
        onRemove: isSelected ? () => listProvider.removeGpu() : null,
        isSelected: isSelected,
      ),
    );
  }

  void _selectGpu(Gpu gpu) {
    Provider.of<ListProvider>(context, listen: false).setGpu(gpu);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${gpu.gpuName} added to your build'),
        backgroundColor: Theme.of(context).primaryColor,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW',
          onPressed: () {
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
    final gpuProvider = Provider.of<GpuProvider>(context);
    final listProvider = Provider.of<ListProvider>(context);
    final gpus = gpuProvider.gpus;
    final totalResults = gpuProvider.totalResults;
    final totalPages = (totalResults / _pageSize).ceil();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Graphics Cards'),
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
                  hintText: 'Search graphics cards...',
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
                      _sortParameter == 'GPU_name' && _sortOrder == 'asc',
                      () => _onSortChanged('GPU_name', 'asc'),
                    ),
                    const SizedBox(width: 8),
                    _buildSortButton(
                      'Name Z-A',
                      _sortParameter == 'GPU_name' && _sortOrder == 'desc',
                      () => _onSortChanged('GPU_name', 'desc'),
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
                : gpus.isEmpty
                    ? const Center(
                        child: Text('No graphics cards found'),
                      )
                    : SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Grid of GPU Cards
                              AlignedGridView.count(
                                crossAxisCount: 3,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: gpus.length,
                                itemBuilder: (context, index) {
                                  final gpu = gpus[index];
                                  final isSelected = listProvider.selectedGpu?.id == gpu.id;
                                  
                                  return SizedBox(
                                    height: 280, // Fixed height for each card
                                    child: ComponentCard(
                                      image: gpu.image,
                                      name: gpu.gpuName,
                                      price: gpu.price,
                                      isSelected: isSelected,
                                      onTap: () {
                                        if (isSelected) {
                                          _showGpuDetails(gpu);
                                        } else {
                                          _selectGpu(gpu);
                                        }
                                      },
                                    ),
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
                            ],
                          ),
                        ),
                      ),
          ),
          
          // Footer
          const FooterWidget(),
        ],
      ),
    );
  }

  Widget _buildSortButton(String text, bool isSelected, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).primaryColor
            : Colors.grey.shade200,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(text),
    );
  }
} 