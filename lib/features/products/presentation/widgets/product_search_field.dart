
import 'package:flutter/material.dart';

class ProductSearchField extends StatefulWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  const ProductSearchField({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  State<ProductSearchField> createState() => _ProductSearchFieldState();
}

class _ProductSearchFieldState extends State<ProductSearchField> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void didUpdateWidget(covariant ProductSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.searchQuery != _searchController.text) {
      _searchController.value = TextEditingValue(
        text: widget.searchQuery,
        selection: TextSelection.collapsed(
          offset: widget.searchQuery.length,
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: _searchController,
      onChanged: widget.onSearchChanged,
      style: TextStyle(color: colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                tooltip: 'Clear search',
                onPressed: () {
                  _searchController.clear();
                  widget.onSearchChanged('');
                },
                icon: const Icon(Icons.close),
              )
            : null,
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
