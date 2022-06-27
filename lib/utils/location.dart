import 'dart:math' show cos, sqrt, asin;

class LocationUtil {
  static double calculateDistanceInKM(
    latitude1,
    longitude1,
    latitude2,
    longitude2,
  ) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((latitude2 - latitude1) * p) / 2 +
        c(latitude1 * p) *
            c(latitude2 * p) *
            (1 - c((longitude2 - longitude1) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  static int calculateTimeInMinutes(
    latitude1,
    longitude1,
    latitude2,
    longitude2,
    double kmPerHour,
  ) {
    double distance = calculateDistanceInKM(
      latitude1,
      longitude1,
      latitude2,
      longitude2,
    );

    double kmPerMin = kmPerHour / 60;
    double timeInMinutes = distance / kmPerMin;

    return timeInMinutes.round();
  }
}
