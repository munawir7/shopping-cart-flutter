import 'package:flutter/material.dart';

class CategoryFilter extends StatelessWidget {
final List<String> categories;
final String selectedCategory;
final ValueChanged<String> onCategorySelected;

const CategoryFilter({
super.key,
required this.categories,
required this.selectedCategory,
required this.onCategorySelected,
});

@override
Widget build(BuildContext context) {
return SizedBox(
height: 44,
child: ListView.separated(
scrollDirection: Axis.horizontal,
itemCount: categories.length,
separatorBuilder: (_, index) => const SizedBox(width: 8),
itemBuilder: (context, index) {
final category = categories[index];
final isSelected = category == selectedCategory;


      return ChoiceChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (_) => onCategorySelected(category),
      );
    },
  ),
);


}
}
