import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'saved_trips_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';

class SavedTripsView extends GetView<SavedTripsController> {
  const SavedTripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('My Trips'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.trips.isEmpty) {
          return _emptyState();
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.trips.length,
          itemBuilder: (_, i) => _tripCard(i),
        );
      }),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.luggage, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('No saved trips', style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
          const SizedBox(height: 8),
          Text('Start planning your adventure!', style: TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _tripCard(int index) {
    final trip = controller.trips[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(trip.destinationName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                  onPressed: () => controller.confirmDelete(trip),
                ),
              ],
            ),
            Text(trip.destinationCountry, style: TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 6),
                Text(Helpers.formatDateRange(trip.startDate, trip.endDate), style: TextStyle(fontSize: 13)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.place, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 6),
                Text('${trip.placesCount} places', style: TextStyle(fontSize: 13)),
              ],
            ),
            if (trip.notes != null && trip.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(trip.notes!, style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontStyle: FontStyle.italic)),
            ],
          ],
        ),
      ),
    );
  }
}
