import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pc_part_picker/providers/list_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showActions;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showActions = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<ListProvider>(context);
    
    return AppBar(
      title: Row(
        children: [
          Icon(Icons.computer, size: 30, color: Colors.white),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
      actions: showActions
          ? [
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => buildPartsListBottomSheet(context),
                      );
                    },
                  ),
                  if (listProvider.hasSelectedItems)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: const Text(
                          '•',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'home') {
                    context.go('/');
                  } else if (value == 'contact') {
                    context.go('/about');
                  } else if (value == 'final') {
                    context.go('/final');
                  } else if (value == 'builds') {
                    context.go('/builds');
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'home',
                    child: Row(
                      children: [
                        Icon(Icons.home, color: Colors.black),
                        SizedBox(width: 8),
                        Text('Home'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'contact',
                    child: Row(
                      children: [
                        Icon(Icons.contact_mail, color: Colors.black),
                        SizedBox(width: 8),
                        Text('Contact'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'final',
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.black),
                        SizedBox(width: 8),
                        Text('Final Build'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'builds',
                    child: Row(
                      children: [
                        Icon(Icons.folder, color: Colors.black),
                        SizedBox(width: 8),
                        Text('Saved Builds'),
                      ],
                    ),
                  ),
                ],
              ),
            ]
          : null,
    );
  }

  Widget buildPartsListBottomSheet(BuildContext context) {
    final listProvider = Provider.of<ListProvider>(context);
    final double totalPrice = listProvider.totalPrice;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Selected Parts',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Finalize'),
                    onPressed: listProvider.hasSelectedItems
                        ? () {
                            Navigator.pop(context);
                            context.go('/final');
                          }
                        : null,
                  ),
                ],
              ),
              const Divider(),
              listProvider.hasSelectedItems
                  ? Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          if (listProvider.selectedProcessor != null)
                            buildListTile(
                              'Processor',
                              listProvider.selectedProcessor!.cpuName,
                              listProvider.selectedProcessor!.price,
                              listProvider.selectedProcessor!.image,
                              () => listProvider.removeProcessor(),
                              '/processors',
                              context,
                            ),
                          if (listProvider.selectedGpu != null)
                            buildListTile(
                              'Graphics Card',
                              listProvider.selectedGpu!.gpuName,
                              listProvider.selectedGpu!.price,
                              listProvider.selectedGpu!.image,
                              () => listProvider.removeGpu(),
                              '/gpu',
                              context,
                            ),
                          if (listProvider.selectedMotherboard != null)
                            buildListTile(
                              'Motherboard',
                              listProvider.selectedMotherboard!.moboName,
                              listProvider.selectedMotherboard!.price,
                              listProvider.selectedMotherboard!.image,
                              () => listProvider.removeMotherboard(),
                              '/motherboard',
                              context,
                            ),
                          if (listProvider.selectedRam != null)
                            buildListTile(
                              'RAM',
                              listProvider.selectedRam!.ramName,
                              listProvider.selectedRam!.price,
                              listProvider.selectedRam!.image,
                              () => listProvider.removeRam(),
                              '/memory',
                              context,
                            ),
                          if (listProvider.selectedSsd != null)
                            buildListTile(
                              'Storage',
                              listProvider.selectedSsd!.ssdName,
                              listProvider.selectedSsd!.price,
                              listProvider.selectedSsd!.image,
                              () => listProvider.removeSsd(),
                              '/storage',
                              context,
                            ),
                          if (listProvider.selectedCase != null)
                            buildListTile(
                              'Case',
                              listProvider.selectedCase!.caseName,
                              listProvider.selectedCase!.price,
                              listProvider.selectedCase!.image,
                              () => listProvider.removeCase(),
                              '/cases',
                              context,
                            ),
                          if (listProvider.selectedPsu != null)
                            buildListTile(
                              'Power Supply',
                              listProvider.selectedPsu!.psuName,
                              listProvider.selectedPsu!.price,
                              listProvider.selectedPsu!.image,
                              () => listProvider.removePsu(),
                              '/psu',
                              context,
                            ),
                          const SizedBox(height: 16),
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
                                '\$${totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2FA44D),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              listProvider.clearAllItems();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Clear All Parts'),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.shopping_cart_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No parts selected',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                context.go('/processors');
                              },
                              child: const Text('Start Building Your PC'),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget buildListTile(
    String type,
    String name,
    String price,
    String imageUrl,
    VoidCallback onRemove,
    String route,
    BuildContext context,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => 
                const Icon(Icons.image_not_supported, size: 30),
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(type),
            Text(
              price,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.pop(context);
                context.go(route);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 