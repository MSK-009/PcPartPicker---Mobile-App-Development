import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pc_part_picker/providers/list_provider.dart';
import 'package:pc_part_picker/providers/build_provider.dart';
import 'package:pc_part_picker/models/build.dart';
import 'package:pc_part_picker/widgets/app_bar.dart';
import 'package:pc_part_picker/widgets/footer_widget.dart';
import 'package:intl/intl.dart';

class FinalScreen extends StatelessWidget {
  const FinalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<ListProvider>(context);
    final hasSelectedItems = listProvider.hasSelectedItems;
    final totalPrice = listProvider.totalPrice;
    final formatter = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: const CustomAppBar(title: 'Final Build'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
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
                    'Your Custom PC Build',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    hasSelectedItems
                        ? 'Total Price: ${formatter.format(totalPrice)}'
                        : 'Start adding components to your build!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: hasSelectedItems
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Selected Components
                        const Text(
                          'Selected Components',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Components List
                        _buildComponentsList(context, listProvider),

                        const SizedBox(height: 30),

                        // Summary
                        const Text(
                          'Summary',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildSummaryCard(context, listProvider),

                        const SizedBox(height: 30),

                        // Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.delete),
                              label: const Text('Clear All'),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Clear All Components?'),
                                    content: const Text(
                                      'Are you sure you want to remove all components from your build? This action cannot be undone.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          listProvider.clearAllItems();
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'All components have been removed'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: const Text('Clear All'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 16),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.save),
                              label: const Text('Save Build'),
                              onPressed: () {
                                _showSaveBuildDialog(
                                    context, listProvider, totalPrice);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 16),
                              ),
                            ),
                            const SizedBox(width: 16),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.folder_open),
                              label: const Text('View Saved Builds'),
                              onPressed: () {
                                context.go('/builds');
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : _buildEmptyState(context),
            ),

            // Footer
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentsList(BuildContext context, ListProvider listProvider) {
    return Column(
      children: [
        // Processor
        if (listProvider.selectedProcessor != null)
          _buildComponentItem(
            context,
            'Processor',
            listProvider.selectedProcessor!.cpuName,
            listProvider.selectedProcessor!.price,
            listProvider.selectedProcessor!.image,
            () => context.go('/processors'),
            () => listProvider.removeProcessor(),
          ),

        // GPU
        if (listProvider.selectedGpu != null)
          _buildComponentItem(
            context,
            'Graphics Card',
            listProvider.selectedGpu!.gpuName,
            listProvider.selectedGpu!.price,
            listProvider.selectedGpu!.image,
            () => context.go('/gpu'),
            () => listProvider.removeGpu(),
          ),

        // Motherboard
        if (listProvider.selectedMotherboard != null)
          _buildComponentItem(
            context,
            'Motherboard',
            listProvider.selectedMotherboard!.chipset,
            listProvider.selectedMotherboard!.price,
            listProvider.selectedMotherboard!.image,
            () => context.go('/motherboard'),
            () => listProvider.removeMotherboard(),
          ),

        // RAM
        if (listProvider.selectedRam != null)
          _buildComponentItem(
            context,
            'RAM',
            listProvider.selectedRam!.ramName,
            listProvider.selectedRam!.price,
            listProvider.selectedRam!.image,
            () => context.go('/memory'),
            () => listProvider.removeRam(),
          ),

        // Storage
        if (listProvider.selectedSsd != null)
          _buildComponentItem(
            context,
            'Storage',
            listProvider.selectedSsd!.ssdName,
            listProvider.selectedSsd!.price,
            listProvider.selectedSsd!.image,
            () => context.go('/storage'),
            () => listProvider.removeSsd(),
          ),

        // Case
        if (listProvider.selectedCase != null)
          _buildComponentItem(
            context,
            'Case',
            listProvider.selectedCase!.caseName,
            listProvider.selectedCase!.price,
            listProvider.selectedCase!.image,
            () => context.go('/cases'),
            () => listProvider.removeCase(),
          ),

        // PSU
        if (listProvider.selectedPsu != null)
          _buildComponentItem(
            context,
            'Power Supply',
            listProvider.selectedPsu!.psuName,
            listProvider.selectedPsu!.price,
            listProvider.selectedPsu!.image,
            () => context.go('/psu'),
            () => listProvider.removePsu(),
          ),
      ],
    );
  }

  Widget _buildComponentItem(
    BuildContext context,
    String type,
    String name,
    String price,
    String imageUrl,
    VoidCallback onEdit,
    VoidCallback onRemove,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.image_not_supported, size: 40)),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Actions
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Colors.blue,
                  onPressed: onEdit,
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: onRemove,
                  tooltip: 'Remove',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, ListProvider listProvider) {
    final totalPrice = listProvider.totalPrice;
    final formatter = NumberFormat.currency(symbol: '\$');
    final missing = [
      if (listProvider.selectedProcessor == null) 'Processor',
      if (listProvider.selectedGpu == null) 'Graphics Card',
      if (listProvider.selectedMotherboard == null) 'Motherboard',
      if (listProvider.selectedRam == null) 'RAM',
      if (listProvider.selectedSsd == null) 'Storage',
      if (listProvider.selectedCase == null) 'Case',
      if (listProvider.selectedPsu == null) 'Power Supply',
    ];

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Price:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formatter.format(totalPrice),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text(
              'Build Status:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (missing.isEmpty)
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Your build is complete!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.warning,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Missing ${missing.length} component${missing.length > 1 ? 's' : ''}:',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...missing.map((item) => Padding(
                        padding: const EdgeInsets.only(left: 32, bottom: 4),
                        child: Text(
                          '• $item',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      )),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.computer_outlined,
            size: 100,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          const Text(
            'Your build is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Start adding components to create your custom PC',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Components'),
            onPressed: () => context.go('/processors'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String _formatDate(String value) {
    final date = DateTime.parse(value);
    final formatter = DateFormat('MMM d, yyyy');
    return formatter.format(date);
  }

  Future<void> _showSaveBuildDialog(BuildContext context,
      ListProvider listProvider, double totalPrice) async {
    final TextEditingController nameController =
        TextEditingController(text: 'My PC Build');

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Your Build'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Build Name',
                border: OutlineInputBorder(),
              ),
              maxLength: 50,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final String buildName = nameController.text.trim().isNotEmpty
                  ? nameController.text.trim()
                  : 'My PC Build';

              // Create build object
              final build = Build(
                name: buildName,
                processor: listProvider.selectedProcessor,
                gpu: listProvider.selectedGpu,
                motherboard: listProvider.selectedMotherboard,
                ram: listProvider.selectedRam,
                ssd: listProvider.selectedSsd,
                pcCase: listProvider.selectedCase,
                psu: listProvider.selectedPsu,
                totalPrice: totalPrice,
              );

              Navigator.of(context).pop();

              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Saving your build...'),
                    ],
                  ),
                ),
              );

              // Save the build
              final success =
                  await Provider.of<BuildProvider>(context, listen: false)
                      .saveBuild(build);

              // Close loading dialog
              Navigator.of(context).pop();

              // Show result
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Build "$buildName" saved successfully'),
                    backgroundColor: Colors.green,
                    action: SnackBarAction(
                      label: 'View Builds',
                      onPressed: () {
                        context.go('/builds');
                      },
                      textColor: Colors.white,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to save build'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
