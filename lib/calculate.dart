import 'dart:math' as math;

class SunCalc {
  static const double PI = math.pi;
  static const double rad = PI / 180.0;
  static const double dayMs = 1000 * 60 * 60 * 24;
  static const double J1970 = 2440588;
  static const double J2000 = 2451545;
  static const double e = rad * 23.4397; // obliquity of the Earth

  // Converts a date to Julian date
  static double toJulian(DateTime date) => date.millisecondsSinceEpoch / dayMs - 0.5 + J1970;

  // Converts Julian date to a DateTime
  static DateTime fromJulian(double j) => DateTime.fromMillisecondsSinceEpoch(((j + 0.5 - J1970) * dayMs).round());

  // Converts a date to days since J2000.0
  static double toDays(DateTime date) => toJulian(date) - J2000;

  // Calculates the right ascension
  static double rightAscension(double l, double b) => math.atan2(math.sin(l) * math.cos(e) - math.tan(b) * math.sin(e), math.cos(l));

  // Calculates the declination
  static double declination(double l, double b) => math.asin(math.sin(b) * math.cos(e) + math.cos(b) * math.sin(e) * math.sin(l));

  // Calculates the azimuth
  static double azimuth(double H, double phi, double dec) => math.atan2(math.sin(H), math.cos(H) * math.sin(phi) - math.tan(dec) * math.cos(phi));

  // Calculates the altitude
  static double altitude(double H, double phi, double dec) => math.asin(math.sin(phi) * math.sin(dec) + math.cos(phi) * math.cos(dec) * math.cos(H));

  // Calculates the sidereal time
  static double siderealTime(double d, double lw) => rad * (280.16 + 360.9856235 * d) - lw;

  // Calculates the astro refraction
  static double astroRefraction(double h) {
    if (h < 0) h = 0; // the formula works for positive altitudes only.
    return 0.0002967 / math.tan(h + 0.00312536 / (h + 0.08901179));
  }

  // Calculates the solar mean anomaly
  static double solarMeanAnomaly(double d) => rad * (357.5291 + 0.98560028 * d);

  // Calculates the ecliptic longitude
  static double eclipticLongitude(double M) {
    var C = rad * (1.9148 * math.sin(M) + 0.02 * math.sin(2 * M) + 0.0003 * math.sin(3 * M)); // equation of center
    var P = rad * 102.9372; // perihelion of the Earth
    return M + C + P + PI;
  }

  // Calculates sun coordinates
  static Map<String, double> sunCoords(double d) {
    var M = solarMeanAnomaly(d);
    var L = eclipticLongitude(M);
    return {
      'dec': declination(L, 0),
      'ra': rightAscension(L, 0),
    };
  }

// This is a simplified conversion focusing on the core calculations.
// Further adaptation is needed to fully implement all functionalities and calculations provided by the original SunCalc library.
}
