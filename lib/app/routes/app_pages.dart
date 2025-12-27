import 'package:get/get.dart';
import 'app_routes.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/destination/destination_binding.dart';
import '../modules/destination/destination_view.dart';
import '../modules/itinerary/itinerary_binding.dart';
import '../modules/itinerary/itinerary_view.dart';
import '../modules/saved_trips/saved_trips_binding.dart';
import '../modules/saved_trips/saved_trips_view.dart';

/// App Pages - GetX route configuration
class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.destination,
      page: () => const DestinationView(),
      binding: DestinationBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.itinerary,
      page: () => const ItineraryView(),
      binding: ItineraryBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.savedTrips,
      page: () => const SavedTripsView(),
      binding: SavedTripsBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
