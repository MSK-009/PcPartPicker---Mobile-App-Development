import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pc_part_picker/providers/build_provider.dart';
import 'package:pc_part_picker/providers/list_provider.dart';
import 'package:pc_part_picker/models/build.dart';
import 'package:pc_part_picker/widgets/app_bar.dart';
import 'package:pc_part_picker/widgets/footer_widget.dart';

class BuildsScreen extends StatefulWidget {
  const BuildsScreen({Key? key}) : super(key: key);

  @override
  State<BuildsScreen> createState() => _BuildsScreenState();
}

class _BuildsScreenState extends State<BuildsScreen> {
  bool _isLoading = false;
  bool _hasLoadedBuilds = false;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  if (!_hasLoadedBuilds) {
    _loadBuilds().then((_) {
      // After initial load, try to refresh any builds with placeholders
      _refreshBuildsWithPlaceholders();
    });
    _hasLoadedBuilds = true;
  }
}

// Add this method to fetch full data for builds with placeholders
Future<void> _refreshBuildsWithPlaceholders() async {
  final buildProvider = Provider.of<BuildProvider>(context, listen: false);
  final builds = buildProvider.builds;
  
  // Only process a few builds at a time to avoid overwhelming the API
  final buildsToUpdate = builds.take(5).where((build) => 
    (build.processor?.cpuName == 'Loading...') ||
    (build.gpu?.gpuName == 'Loading...') ||
    (build.motherboard?.chipset == 'Loading...') ||
    (build.ram?.ramName == 'Loading...') ||
    (build.ssd?.ssdName == 'Loading...') ||
    (build.pcCase?.caseName == 'Loading...') ||
    (build.psu?.psuName == 'Loading...')
  ).toList();
  
  for (final build in buildsToUpdate) {
    if (build.id != null && mounted) {
      await buildProvider.updateBuildWithFullData(build.id!);
    }
  }
}

  Future<void> _loadBuilds() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<BuildProvider>(context, listen: false).fetchBuilds();
    } catch (e) {
      debugPrint('Error loading builds: $e');
      // Error is already handled in the provider
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final buildProvider = Provider.of<BuildProvider>(context);
    final builds = buildProvider.builds;
    final isLoading = buildProvider.isLoading || _isLoading;
    final error = buildProvider.error;
    final formatter = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: const CustomAppBar(title: 'Saved Builds'),
      body: RefreshIndicator(
        onRefresh: _loadBuilds,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      const Color(0xFF1C7C30),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Your Saved PC Builds',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      builds.isNotEmpty
                          ? '${builds.length} Build${builds.length == 1 ? '' : 's'} Saved'
                          : 'No builds saved yet',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Container(
                constraints: const BoxConstraints(minHeight: 400),
                padding: const EdgeInsets.all(20),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Error loading builds',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(error),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _loadBuilds,
                                  child: const Text('Try Again'),
                                ),
                              ],
                            ),
                          )
                        : builds.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.computer,
                                      color: Colors.grey,
                                      size: 64,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No Saved Builds Yet',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Start building your PC and save your configurations here',
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () => context.go('/'),
                                      child: const Text('Start Building'),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: builds.length,
                                itemBuilder: (context, index) {
                                  final build = builds[index];
                                  return _buildBuildCard(
                                      context, build, formatter);
                                },
                              ),
              ),

              // Footer
              const FooterWidget(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/final'),
        tooltip: 'Create New Build',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBuildCard(
      BuildContext context, Build build, NumberFormat formatter) {
    final buildProvider = Provider.of<BuildProvider>(context, listen: false);
    final listProvider = Provider.of<ListProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Build Name and Date
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        build.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (build.date != null)
                        Text(
                          'Saved on ${_formatDate(build.date!)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  formatter.format(build.totalPrice),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Build Components
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (build.processor != null)
                  _buildComponentItem('Processor', build.processor!.cpuName),
                if (build.gpu != null)
                  _buildComponentItem('Graphics Card', build.gpu!.gpuName),
                if (build.motherboard != null)
                  _buildComponentItem(
                      'Motherboard', build.motherboard!.chipset),
                if (build.ram != null)
                  _buildComponentItem('RAM', build.ram!.ramName),
                if (build.ssd != null)
                  _buildComponentItem('Storage', build.ssd!.ssdName),
                if (build.pcCase != null)
                  _buildComponentItem('Case', build.pcCase!.caseName),
                if (build.psu != null)
                  _buildComponentItem('Power Supply', build.psu!.psuName),
              ],
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, build);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Load Build'),
                  onPressed: () {
                    _loadBuildToEditor(context, build, listProvider);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentItem(String label, String value) {
    // Handle placeholder "Loading..." values by showing a loading indicator
    final bool isPlaceholder = value == 'Loading...';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: isPlaceholder
              ? Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                )
              : Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, Build build) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Build'),
        content: Text(
            'Are you sure you want to delete "${build.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();

              if (build.id != null) {
                setState(() {
                  _isLoading = true;
                });

                final success =
                    await Provider.of<BuildProvider>(context, listen: false)
                        .deleteBuild(build.id!);

                setState(() {
                  _isLoading = false;
                });

                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Build "${build.name}" has been deleted'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to delete build'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadBuildToEditor(
      BuildContext context, Build build, ListProvider listProvider) async {
    // Check if any component has placeholder data (Loading...)
    bool hasPlaceholders = false;
    if (build.processor != null && build.processor!.cpuName == 'Loading...') hasPlaceholders = true;
    if (build.gpu != null && build.gpu!.gpuName == 'Loading...') hasPlaceholders = true;
    if (build.motherboard != null && build.motherboard!.chipset == 'Loading...') hasPlaceholders = true;
    if (build.ram != null && build.ram!.ramName == 'Loading...') hasPlaceholders = true;
    if (build.ssd != null && build.ssd!.ssdName == 'Loading...') hasPlaceholders = true;
    if (build.pcCase != null && build.pcCase!.caseName == 'Loading...') hasPlaceholders = true;
    if (build.psu != null && build.psu!.psuName == 'Loading...') hasPlaceholders = true;
    
    if (hasPlaceholders && build.id != null) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading full component details...'),
            ],
          ),
        ),
      );
      
      try {
        // Fetch the full build data with component details
        await Provider.of<BuildProvider>(context, listen: false).fetchBuildById(build.id!);
        
        // Close loading dialog
        Navigator.of(context).pop();
        
        // Get the updated build with full component details
        final updatedBuild = Provider.of<BuildProvider>(context, listen: false).selectedBuild;
        
        if (updatedBuild != null) {
          // Use the updated build
          _populateComponents(context, updatedBuild, listProvider);
        } else {
          // If we couldn't fetch the updated build, use what we have
          _populateComponents(context, build, listProvider);
        }
      } catch (e) {
        // Close loading dialog
        Navigator.of(context).pop();
        
        // Show error and use what we have
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not load some component details'),
            backgroundColor: Colors.orange,
          ),
        );
        
        _populateComponents(context, build, listProvider);
      }
    } else {
      // No placeholders, use the build directly
      _populateComponents(context, build, listProvider);
    }
  }
  
  // Helper method to set all the components from a build into the list provider
  void _populateComponents(BuildContext context, Build build, ListProvider listProvider) {
    // Clear all components first
    listProvider.clearAllItems();
    
    // Set all components in the list provider
    if (build.processor != null) {
      listProvider.setProcessor(build.processor!);
    }

    if (build.gpu != null) {
      listProvider.setGpu(build.gpu!);
    }

    if (build.motherboard != null) {
      listProvider.setMotherboard(build.motherboard!);
    }

    if (build.ram != null) {
      listProvider.setRam(build.ram!);
    }

    if (build.ssd != null) {
      listProvider.setSsd(build.ssd!);
    }

    if (build.pcCase != null) {
      listProvider.setCase(build.pcCase!);
    }

    if (build.psu != null) {
      listProvider.setPsu(build.psu!);
    }

    // Navigate to the final build screen
    context.go('/final');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loaded build "${build.name}"'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    
    // Convert to Pakistan time zone (UTC+5)
    final pakistanTime = date.add(const Duration(hours: 5));
    
    // Format the date for display
    final formatter = DateFormat('MMM d, yyyy');
    return formatter.format(pakistanTime);
  }
}
