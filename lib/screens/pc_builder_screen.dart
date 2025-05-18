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
        actions: [
          // Home button
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: 'Go to Home',
            onPressed: () {
              context.go('/');
            },
          ),
        ],
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
                    left: 20,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: FloatingActionButton(
                        heroTag: 'prevButton',
                        onPressed: _previousStep,
                        backgroundColor: Colors.grey[700],
                        child: const Icon(Icons.arrow_back, size: 36),
                      ),
                    ),
                  ),
                
                // Next button (right of screen)
                Positioned(
                  right: 20,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: FloatingActionButton(
                      heroTag: 'nextButton',
                      onPressed: nextStep,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        _currentStep < _buildSteps.length - 1 
                            ? Icons.arrow_forward 
                            : Icons.check,
                        size: 36,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous button
                ElevatedButton.icon(
                  onPressed: _currentStep > 0 ? _previousStep : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('PREVIOUS'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    disabledBackgroundColor: Colors.grey[400],
                  ),
                ),
                
                // Build summary button
                ElevatedButton.icon(
                  onPressed: () => _showBuildSummary(context, currentBuild),
                  icon: const Icon(Icons.list),
                  label: const Text('VIEW BUILD'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                
                // Next button
                ElevatedButton.icon(
                  onPressed: nextStep,
                  icon: Icon(_currentStep < _buildSteps.length - 1 ? Icons.arrow_forward : Icons.check),
                  label: Text(_currentStep < _buildSteps.length - 1 ? 'NEXT' : 'FINISH'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Show a dialog with the current build summary
  void _showBuildSummary(BuildContext context, Build? build) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double totalPrice = 0;
        
        if (build != null) {
          if (build.processor != null) totalPrice += double.tryParse(build.processor!.price) ?? 0;
          if (build.gpu != null) totalPrice += double.tryParse(build.gpu!.price) ?? 0;
          if (build.motherboard != null) totalPrice += double.tryParse(build.motherboard!.price) ?? 0;
          if (build.ram != null) totalPrice += double.tryParse(build.ram!.price) ?? 0;
          if (build.ssd != null) totalPrice += double.tryParse(build.ssd!.price) ?? 0;
          if (build.pcCase != null) totalPrice += double.tryParse(build.pcCase!.price) ?? 0;
          if (build.psu != null) totalPrice += double.tryParse(build.psu!.price) ?? 0;
        }
        
        return AlertDialog(
          title: const Text('Current Build'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSummaryItem('Processor', build?.processor?.cpuName ?? 'Not selected'),
                _buildSummaryItem('Graphics Card', build?.gpu?.gpuName ?? 'Not selected'),
                _buildSummaryItem('Motherboard', build?.motherboard?.manufacturer ?? 'Not selected'),
                _buildSummaryItem('RAM', build?.ram?.ramName ?? 'Not selected'),
                _buildSummaryItem('Storage', build?.ssd?.ssdName ?? 'Not selected'),
                _buildSummaryItem('Case', build?.pcCase?.caseName ?? 'Not selected'),
                _buildSummaryItem('Power Supply', build?.psu?.psuName ?? 'Not selected'),
                const Divider(),
                _buildSummaryItem('Total Price', '\$${totalPrice.toStringAsFixed(2)}', isTotal: true),
              ],
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 18 : 16,
              color: isTotal ? Theme.of(context).primaryColor : null,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : null,
              color: isTotal ? Theme.of(context).primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }
} 