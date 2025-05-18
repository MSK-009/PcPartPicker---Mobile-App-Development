import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pc_part_picker/models/build.dart';
import 'package:pc_part_picker/providers/build_provider.dart';
import 'package:pc_part_picker/providers/processor_provider.dart';
import 'package:pc_part_picker/providers/gpu_provider.dart';
import 'package:pc_part_picker/providers/motherboard_provider.dart';
import 'package:pc_part_picker/providers/ram_provider.dart';
import 'package:pc_part_picker/providers/ssd_provider.dart';
import 'package:pc_part_picker/providers/case_provider.dart';
import 'package:pc_part_picker/providers/psu_provider.dart';
import 'package:pc_part_picker/screens/processors_screen.dart';
import 'package:pc_part_picker/screens/graphics_screen.dart';
import 'package:pc_part_picker/screens/motherboard_screen.dart';
import 'package:pc_part_picker/screens/ram_screen.dart';
import 'package:pc_part_picker/screens/ssd_screen.dart';
import 'package:pc_part_picker/screens/cases_screen.dart';
import 'package:pc_part_picker/screens/power_screen.dart';
import 'package:pc_part_picker/widgets/app_bar.dart';
import 'package:pc_part_picker/providers/list_provider.dart';

class PcBuilderScreen extends StatefulWidget {
  const PcBuilderScreen({Key? key}) : super(key: key);

  @override
  State<PcBuilderScreen> createState() => PcBuilderScreenState();
}

class PcBuilderScreenState extends State<PcBuilderScreen> {
  int _currentStep = 0;
  
  // List of steps in the PC building process
  final List<String> _buildSteps = [
    'Processor',
    'Graphics Card',
    'Motherboard',
    'RAM',
    'Storage',
    'Case',
    'Power Supply'
  ];

  // Get the appropriate screen widget based on current step
  Widget _getStepScreen(int step) {
    switch (step) {
      case 0:
        return const ProcessorsScreen(isBuilderMode: true);
      case 1:
        return const GraphicsScreen(isBuilderMode: true);
      case 2:
        return const MotherboardScreen(isBuilderMode: true);
      case 3:
        return const RamScreen(isBuilderMode: true);
      case 4:
        return const SsdScreen(isBuilderMode: true);
      case 5:
        return const CasesScreen(isBuilderMode: true);
      case 6:
        return const PowerScreen(isBuilderMode: true);
      default:
        return const Center(child: Text('Unknown step'));
    }
  }

  // Go to previous step if possible
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  // Go to next step if possible
  void nextStep() {
    if (_currentStep < _buildSteps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Finish build process and navigate to final screen
      context.go('/final');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current build progress
    final buildProvider = Provider.of<BuildProvider>(context);
    final currentBuild = buildProvider.selectedBuild;
    
    // Calculate the progress percentage
    double progressPercentage = (_currentStep / (_buildSteps.length - 1));
    
    return Scaffold(
      appBar: AppBar(
        title: Text('PC Builder - ${_buildSteps[_currentStep]}'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Go back to home when clicked
            context.go('/');
          },
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[200],
            child: Column(
              children: [
                // Step indicator row
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'STEP ${_currentStep + 1} OF ${_buildSteps.length}: ${_buildSteps[_currentStep].toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Visual progress bar
                LinearProgressIndicator(
                  value: progressPercentage,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
          
          // Component selection screen
          Expanded(
            child: Stack(
              children: [
                // Main content area
                Positioned.fill(
                  child: _getStepScreen(_currentStep),
                ),
                
                // Back button (left of screen)
                if (_currentStep > 0)
                  Positioned(
                    left: 12,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: FloatingActionButton(
                        heroTag: 'prevButton',
                        onPressed: _previousStep,
                        backgroundColor: Colors.grey[700],
                        elevation: 6.0,
                        child: const Icon(Icons.arrow_back, size: 36, color: Colors.white),
                      ),
                    ),
                  ),
                
                // Next button (right of screen)
                Positioned(
                  right: 12,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: FloatingActionButton(
                      heroTag: 'nextButton',
                      onPressed: nextStep,
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 6.0,
                      child: Icon(
                        _currentStep < _buildSteps.length - 1 
                            ? Icons.arrow_forward 
                            : Icons.check,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom navigation bar
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () => _showBuildSummary(context, currentBuild),
                icon: const Icon(Icons.list),
                label: const Text('VIEW BUILD'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Show a dialog with the current build summary
  void _showBuildSummary(BuildContext context, Build? build) {
    final listProvider = Provider.of<ListProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Use the ListProvider's totalPrice calculation which now properly handles all formats
        double totalPrice = listProvider.totalPrice;
        
        return AlertDialog(
          title: const Text('Current Build', style: TextStyle(fontWeight: FontWeight.bold)),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          content: Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSummaryItem('Processor:', listProvider.selectedProcessor?.cpuName ?? 'Not selected'),
                  _buildSummaryItem('Graphics Card:', listProvider.selectedGpu?.gpuName ?? 'Not selected'),
                  _buildSummaryItem('Motherboard:', listProvider.selectedMotherboard?.chipset ?? 'Not selected'),
                  _buildSummaryItem('RAM:', listProvider.selectedRam?.ramName ?? 'Not selected'),
                  _buildSummaryItem('Storage:', listProvider.selectedSsd?.ssdName ?? 'Not selected'),
                  _buildSummaryItem('Case:', listProvider.selectedCase?.caseName ?? 'Not selected'),
                  _buildSummaryItem('Power Supply:', listProvider.selectedPsu?.psuName ?? 'Not selected'),
                  const Divider(height: 24, thickness: 1),
                  _buildSummaryItem('Total Price:', '\$${totalPrice.toStringAsFixed(2)}', isTotal: true),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
  
  // Helper method to build summary items
  Widget _buildSummaryItem(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - label
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isTotal ? 18 : 16,
                color: isTotal ? Theme.of(context).primaryColor : null,
              ),
            ),
          ),
          
          // Right side - value
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                fontSize: isTotal ? 18 : 16,
                fontWeight: isTotal ? FontWeight.bold : null,
                color: isTotal ? Theme.of(context).primaryColor : null,
              ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
} 