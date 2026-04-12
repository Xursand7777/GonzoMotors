import 'package:geolocator/geolocator.dart';


// String userDistanceAddress(Position? userPosition, Address? address) {
//   if (userPosition == null || address?.lat == null || address?.lng == null) {
//     return "-";
//   }
//   final distance = Geolocator.distanceBetween(
//     userPosition.latitude,
//     userPosition.longitude,
//     address!.lat!,
//     address.lng!,
//   );
//   final formattedDistance = _formatDistance(distance);
//   return formattedDistance;
// }
//
// _formatDistance(double distance) {
//   if (distance < 1000) {
//     return "${distance.toStringAsFixed(0)} m";
//   } else {
//     return "${(distance / 1000).toStringAsFixed(1)} km";
//   }
// }