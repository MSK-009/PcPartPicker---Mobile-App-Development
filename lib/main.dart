import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:pc_part_picker/providers/list_provider.dart';
import 'package:pc_part_picker/providers/processor_provider.dart';
import 'package:pc_part_picker/providers/gpu_provider.dart';
import 'package:pc_part_picker/providers/motherboard_provider.dart';
import 'package:pc_part_picker/providers/ram_provider.dart';
import 'package:pc_part_picker/providers/ssd_provider.dart';
import 'package:pc_part_picker/providers/case_provider.dart';
import 'package:pc_part_picker/providers/psu_provider.dart';
import 'package:pc_part_picker/providers/build_provider.dart';
import 'package:pc_part_picker/screens/home_screen.dart';
import 'package:pc_part_picker/screens/contact_screen.dart';
import 'package:pc_part_picker/screens/processors_screen.dart';
import 'package:pc_part_picker/screens/graphics_screen.dart';
import 'package:pc_part_picker/screens/motherboard_screen.dart';
import 'package:pc_part_picker/screens/ram_screen.dart';
import 'package:pc_part_picker/screens/ssd_screen.dart';
import 'package:pc_part_picker/screens/cases_screen.dart';
import 'package:pc_part_picker/screens/power_screen.dart';
import 'package:pc_part_picker/screens/final_screen.dart';
import 'package:pc_part_picker/screens/builds_screen.dart';
import 'package:pc_part_picker/screens/pc_builder_screen.dart';
import 'package:pc_part_picker/helpers/fix_cors_and_rendering_issues.dart';

void main() {
  // Print helpful debug information
  CorsHelper.printDebugInfo();
  LayoutHelper.printDebugInfo();
  
  runApp(const MyApp());
}

// Scaffold with bottom navigation bar
class MainScaffold extends StatelessWidget {
  final Widget child;
  final String currentPath;

  const MainScaffold({
    Key? key,
    required this.child,
    required this.currentPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getSelectedIndex(currentPath),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.computer),
            label: 'Build PC',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.memory),
            label: 'Components',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Builds',
          ),
        ],
        onTap: (index) {
          // Navigate based on index
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/pc-builder');
              break;
            case 2:
              context.go('/processors'); // Components start with processors
              break;
            case 3:
              context.go('/builds');
              break;
          }
        },
      ),
    );
  }

  int _getSelectedIndex(String path) {
    if (path == '/') return 0;
    if (path == '/pc-builder') return 1;
    if (path.contains('/processor') || 
        path.contains('/gpu') || 
        path.contains('/motherboard') || 
        path.contains('/memory') || 
        path.contains('/storage') || 
        path.contains('/cases') || 
        path.contains('/psu')) return 2;
    if (path == '/builds') return 3;
    return 0; // Default to home
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ListProvider()),
        ChangeNotifierProvider(create: (_) => ProcessorProvider()),
        ChangeNotifierProvider(create: (_) => GpuProvider()),
        ChangeNotifierProvider(create: (_) => MotherboardProvider()),
        ChangeNotifierProvider(create: (_) => RamProvider()),
        ChangeNotifierProvider(create: (_) => SsdProvider()),
        ChangeNotifierProvider(create: (_) => CaseProvider()),
        ChangeNotifierProvider(create: (_) => PsuProvider()),
        ChangeNotifierProvider(create: (_) => BuildProvider()),
      ],
      child: MaterialApp.router(
        title: 'PC Part Picker',
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: const Color(0xFF2FA44D),
          scaffoldBackgroundColor: Colors.grey.shade100,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2FA44D),
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2FA44D),
              foregroundColor: Colors.white,
            ),
          ),
          textTheme: ThemeData.light().textTheme.copyWith(
                headlineMedium: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: const Color(0xFF2FA44D),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF2FA44D),
            secondary: Color(0xFF2FA44D),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2FA44D),
              foregroundColor: Colors.white,
            ),
          ),
        ),
        themeMode: ThemeMode.system,
        routerConfig: _router,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(
          child: child,
          currentPath: state.uri.path,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const ContactScreen(),
        ),
        GoRoute(
          path: '/pc-builder',
          builder: (context, state) => const PcBuilderScreen(),
        ),
        GoRoute(
          path: '/processors',
          builder: (context, state) => const ProcessorsScreen(),
        ),
        GoRoute(
          path: '/gpu',
          builder: (context, state) => const GraphicsScreen(),
        ),
        GoRoute(
          path: '/motherboard',
          builder: (context, state) => const MotherboardScreen(),
        ),
        GoRoute(
          path: '/memory',
          builder: (context, state) => const RamScreen(),
        ),
        GoRoute(
          path: '/storage',
          builder: (context, state) => const SsdScreen(),
        ),
        GoRoute(
          path: '/cases',
          builder: (context, state) => const CasesScreen(),
        ),
        GoRoute(
          path: '/psu',
          builder: (context, state) => const PowerScreen(),
        ),
        GoRoute(
          path: '/final',
          builder: (context, state) => const FinalScreen(),
        ),
        GoRoute(
          path: '/builds',
          builder: (context, state) => const BuildsScreen(),
        ),
      ],
    ),
  ],
); 