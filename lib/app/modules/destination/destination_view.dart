import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'destination_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/weather_widget.dart';

class DestinationView extends GetView<DestinationController> {
  const DestinationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(controller.destination.name),
              background: CachedNetworkImage(
                imageUrl: controller.destination.imageUrl ?? 'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=800',
                fit: BoxFit.cover,
                color: Colors.black26,
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => controller.weather.value != null
                      ? WeatherWidget(weather: controller.weather.value!)
                      : _loadingCard()),
                  const SizedBox(height: 20),
                  _categoryFilters(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Obx(() {
            if (controller.isLoadingPlaces.value) {
              return SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
            }
            if (controller.places.isEmpty) {
              return SliverFillRemaining(child: Center(child: Text('No places found')));
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _placeItem(i),
                childCount: controller.places.length,
              ),
            );
          }),
        ],
      ),
      floatingActionButton: Obx(() => controller.selectedCount > 0
          ? FloatingActionButton.extended(
              onPressed: controller.goToItinerary,
              label: Text('Plan Trip (${controller.selectedCount})'),
              icon: Icon(Icons.map),
              backgroundColor: AppTheme.primaryColor,
            )
          : const SizedBox()),
    );
  }

  Widget _loadingCard() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _categoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(() => Row(
        children: controller.categories.map((cat) {
          final selected = controller.selectedCategory.value == cat['key'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text('${cat['icon']} ${cat['label']}'),
              selected: selected,
              onSelected: (_) => controller.filterByCategory(cat['key']!),
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            ),
          );
        }).toList(),
      )),
    );
  }

  Widget _placeItem(int index) {
    final place = controller.places[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () => controller.togglePlaceSelection(place),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: place.isSelected ? AppTheme.primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: place.imageUrl ?? 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=200',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(width: 60, height: 60, color: Colors.grey[300]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(place.primaryCategory, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              Icon(
                place.isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: place.isSelected ? AppTheme.primaryColor : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
