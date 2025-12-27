import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'home_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/api_constants.dart';
import '../../data/models/destination.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _header()),
            SliverToBoxAdapter(child: _searchBar()),
            SliverToBoxAdapter(
              child: Obx(() => controller.recentSearches.isNotEmpty
                  ? _recentSearches()
                  : const SizedBox()),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Text(
                  'Popular Destinations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
            Obx(() => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _destinationCard(controller.popularDestinations[index]),
                  childCount: controller.popularDestinations.length,
                ),
              ),
            )),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Explore', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
              const SizedBox(height: 4),
              Text('Travel Planner', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            ],
          ),
          IconButton(
            onPressed: controller.navigateToSavedTrips,
            icon: Icon(Icons.bookmark_border, color: AppTheme.primaryColor, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onChanged: (val) => controller.searchQuery.value = val,
        onSubmitted: controller.searchDestination,
        decoration: InputDecoration(
          hintText: 'Search cities...',
          prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _recentSearches() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: controller.recentSearches.map((q) => ActionChip(
              label: Text(q),
              onPressed: () => controller.searchDestination(q),
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              labelStyle: TextStyle(color: AppTheme.primaryColor),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _destinationCard(Destination dest) {
    return GestureDetector(
      onTap: () => controller.navigateToDestination(dest),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: dest.imageUrl ?? _getImage(dest.name),
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.grey[200]),
                errorWidget: (_, __, ___) => Container(color: Colors.grey[200], child: Icon(Icons.image, color: Colors.grey)),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dest.name, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(dest.country, style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getImage(String city) {
    final imgs = {
      'Paris': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400',
      'Tokyo': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400',
      'New York': 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400',
      'London': 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=400',
      'Dubai': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=400',
      'Mumbai': 'https://images.unsplash.com/photo-1566552881560-0be862a7c445?w=400',
    };
    return imgs[city] ?? ApiConstants.defaultCityImage;
  }
}
