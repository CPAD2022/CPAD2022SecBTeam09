import 'package:flutter/material.dart';
import 'package:news/src/models/category/category_tile.dart';

var categories = [
  CategoryTile(
    title: 'business',
    icon: Icons.business,
  ),
  CategoryTile(
    title: 'entertainment',
    icon: Icons.sports_esports,
  ),
  CategoryTile(
    title: 'general',
    icon: Icons.home,
  ),
  CategoryTile(
    title: 'health',
    icon: Icons.local_hospital,
  ),
  CategoryTile(
    title: 'science',
    icon: Icons.science,
  ),
  CategoryTile(
    title: 'sports',
    icon: Icons.sports_soccer,
  ),
  CategoryTile(
    title: 'technology',
    icon: Icons.computer,
  ),
];

IconData getIconOfCategory(String title) {
  CategoryTile category =
      categories.firstWhere((element) => element.title == title);
  return category.icon;
}
