import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'itinerary_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';

class ItineraryView extends GetView<ItineraryController> {
  const ItineraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Plan Trip'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _destinationInfo(),
                  const SizedBox(height: 20),
                  _dateSection(context),
                  const SizedBox(height: 20),
                  _placesList(),
                  const SizedBox(height: 16),
                  _notesField(),
                ],
              ),
            ),
          ),
          _saveButton(),
        ],
      ),
    );
  }

  Widget _destinationInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.flight, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(controller.destination.name, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                Text(controller.destination.country, style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
            child: Text('${controller.tripDuration} days', style: TextStyle(color: Colors.white)),
          )),
        ],
      ),
    );
  }

  Widget _dateSection(BuildContext ctx) {
    return Row(
      children: [
        Expanded(child: _datePicker('From', controller.startDate, () => controller.pickStartDate(ctx))),
        const SizedBox(width: 12),
        Expanded(child: _datePicker('To', controller.endDate, () => controller.pickEndDate(ctx))),
      ],
    );
  }

  Widget _datePicker(String label, Rx<DateTime> date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            const SizedBox(height: 4),
            Obx(() => Text(Helpers.formatDate(date.value), style: TextStyle(fontWeight: FontWeight.w500))),
          ],
        ),
      ),
    );
  }

  Widget _placesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Itinerary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Obx(() => Text('${controller.orderedPlaces.length} places', style: TextStyle(color: AppTheme.textSecondary))),
          ],
        ),
        const SizedBox(height: 10),
        Obx(() => controller.orderedPlaces.isEmpty
            ? Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text('No places added', style: TextStyle(color: AppTheme.textSecondary))),
              )
            : ReorderableListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.orderedPlaces.length,
                onReorder: controller.reorderPlaces,
                itemBuilder: (_, i) {
                  final place = controller.orderedPlaces[i];
                  return Card(
                    key: ValueKey(place.xid),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: AppTheme.primaryColor, child: Text('${i + 1}', style: TextStyle(color: Colors.white))),
                      title: Text(place.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(place.primaryCategory),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: Icon(Icons.delete_outline, color: Colors.red), onPressed: () => controller.removePlace(i)),
                          Icon(Icons.drag_handle, color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              )),
      ],
    );
  }

  Widget _notesField() {
    return TextField(
      onChanged: controller.updateNotes,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Add notes (optional)',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _saveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Obx(() => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.isSaving.value ? null : controller.saveTrip,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: controller.isSaving.value
              ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Text('Save Trip', style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      )),
    );
  }
}
