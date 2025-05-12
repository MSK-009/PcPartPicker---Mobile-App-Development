import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:pc_part_picker/widgets/app_bar.dart';
import 'package:pc_part_picker/widgets/footer_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'PC Part Picker'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              decoration: BoxDecoration(
                color: Colors.black87,
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Theme.of(context).primaryColor.withOpacity(0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Welcome to '),
                                    TextSpan(
                                      text: 'PcPartPicker!',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'A place where you can build your own PC. That is truly yours.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Choose the components that suit your needs and create a custom build tailored to your',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: [
                                  AnimatedTextKit(
                                    animatedTexts: [
                                      TyperAnimatedText(
                                        'gaming',
                                        textStyle: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        speed: const Duration(milliseconds: 100),
                                      ),
                                      TyperAnimatedText(
                                        'productivity',
                                        textStyle: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        speed: const Duration(milliseconds: 100),
                                      ),
                                      TyperAnimatedText(
                                        'creative tasks',
                                        textStyle: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        speed: const Duration(milliseconds: 100),
                                      ),
                                    ],
                                    repeatForever: true,
                                  ),
                                  const Text(
                                    '.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: () => context.go('/processors'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Make Your Own PC',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.computer),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.computer,
                                size: 100,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Components Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'PC COMPONENTS',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      _buildComponentTile(
                        context,
                        'Processor',
                        Icons.memory,
                        '/processors',
                      ),
                      _buildComponentTile(
                        context,
                        'Graphics Card',
                        Icons.videogame_asset,
                        '/gpu',
                      ),
                      _buildComponentTile(
                        context,
                        'Motherboard',
                        Icons.dashboard,
                        '/motherboard',
                      ),
                      _buildComponentTile(
                        context,
                        'RAM',
                        Icons.storage,
                        '/memory',
                      ),
                      _buildComponentTile(
                        context,
                        'Storage',
                        Icons.sd_storage,
                        '/storage',
                      ),
                      _buildComponentTile(
                        context,
                        'Case',
                        Icons.cases,
                        '/cases',
                      ),
                      _buildComponentTile(
                        context,
                        'PSU',
                        Icons.bolt,
                        '/psu',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Footer
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentTile(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: 200,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => context.go(route),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('View Options'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}