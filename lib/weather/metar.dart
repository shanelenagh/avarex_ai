import 'dart:convert';
import 'package:objectbox/objectbox.dart';
import 'dart:io' as io;

@Entity()
class Metar {
  @Id()
  int id = 0;

  String? raw;
  String? stationId;
  DateTime? observationTime;
  double? latitude, longitude;
  double? tempCelcius;
  double? dewpointCelcius;
  int? windDirection;
  int? windSpeedKt;
  int? windGustKt;
  double? visibilityStatMi;
  double? altimeterHg;
  double? seaLevelPressureMb;
  bool? corrected;
  bool? auto;
  bool? autoStation;
  bool? maintenanceIndicatorOn;
  bool? noSignal;
  bool? lightningSensorOff;
  bool? freezingRainSensorOff;
  bool? presentWeatherSensorOff;
  String? wxString;
  String? skyCover;
  int? cloudBaseFeetAgl;
  String? skyCover2;
  int? cloudBaseFeetAgl2;
  String? skyCover3;
  int? cloudBaseFeetAgl3;
  String? skyCover4;
  int? cloudBaseFeetAgl4;
  String? flightCategory;
  double? threeHourPressureTendencyMb;
  double? maxTempCelcius;
  double? minTempCelcius;
  double? maxTemp24HourCelcius;
  double? minTemp24HourCelcius;
  double? precipitationInches;
  double? precipitation3HourInches;
  double? precipitation6HourInches;
  double? precipitation24HourInches;
  double? snowInches;
  int? verticalVisibilityFeet;
  String? metarType;
  int? elevationInMeters;

  Metar.fromDict(Map<String, dynamic> d):
    raw = d["raw_text"],
    stationId = d["station_id"],
    observationTime = DateTime.parse(d["observation_time"]),
    latitude = double.tryParse(d["latitude"]),
    longitude = double.tryParse(d["longitude"]),
    tempCelcius = double.tryParse(d["temp_c"]),
    dewpointCelcius = double.tryParse(d["dewpoint_c"]),
    windDirection = int.tryParse(d["wind_dir_degrees"]),
    windSpeedKt = int.tryParse(d["wind_speed_kt"]),
    windGustKt = int.tryParse(d["wind_gust_kt"]),
    visibilityStatMi = double.tryParse(d["visibility_statute_mi"]),
    altimeterHg = double.tryParse(d["altim_in_hg"]),
    seaLevelPressureMb = double.tryParse(d["sea_level_pressure_mb"]),
    corrected = bool.tryParse(d["corrected"], caseSensitive: false),
    auto = bool.tryParse(d["auto"], caseSensitive: false),
    autoStation = bool.tryParse(d["auto_station"], caseSensitive: false),
    maintenanceIndicatorOn = bool.tryParse(d["maintenance_indicator_on"], caseSensitive: false),
    noSignal = bool.tryParse(d["no_signal"], caseSensitive: false),
    lightningSensorOff = bool.tryParse(d["lightning_sensor_off"], caseSensitive: false),
    freezingRainSensorOff = bool.tryParse(d["freezing_rain_sensor_off"], caseSensitive: false),
    presentWeatherSensorOff = bool.tryParse(d["present_weather_sensor_off"], caseSensitive: false),
    wxString = d["wx_string"],
    skyCover = d["sky_cover"],
    cloudBaseFeetAgl = int.tryParse(d["cloud_base_ft_agl"]),
    skyCover2 = d["sky_cover2"],
    cloudBaseFeetAgl2 = int.tryParse(d["cloud_base_ft_agl2"]),
    skyCover3 = d["sky_cover3"],
    cloudBaseFeetAgl3 = int.tryParse(d["cloud_base_ft_agl3"]),
    skyCover4 = d["sky_cover4"],
    cloudBaseFeetAgl4 = int.tryParse(d["cloud_base_ft_agl4"]),
    flightCategory = d["flight_category"],
    threeHourPressureTendencyMb = double.tryParse(d["flight_category"]),
    maxTempCelcius = double.tryParse(d["maxT_c"]),
    minTempCelcius = double.tryParse(d["minT_c"]),
    maxTemp24HourCelcius = double.tryParse(d["maxT24hr_c"]),
    minTemp24HourCelcius = double.tryParse(d["minT24hr_c"]),
    precipitationInches = double.tryParse(d["precip_in"]),
    precipitation3HourInches = double.tryParse(d["pcp3hr_in"]),
    precipitation6HourInches = double.tryParse(d["pcp6hr_in"]),
    precipitation24HourInches = double.tryParse(d["pcp24hr_in"]),
    snowInches = double.tryParse(d["snow_in"]),
    verticalVisibilityFeet = int.tryParse(d["vert_vis_ft"]),
    metarType = d["metar_type"],
    elevationInMeters = int.tryParse(d["elevation_m"]);
}

void main(List<String> args) async {
  if (args.isEmpty || args[0].isEmpty || !io.File(args[0]).existsSync()) {
    io.stderr.writeln("Pass CSV file as single argument to program");
    io.exit(1);
  }
  List<Map<String, dynamic>> metarRows = await parseMetarToDict(io.File(args[0]));
  //print(jsonEncode(metarRows));
  for (Map<String, dynamic> row in metarRows) {
    final m = Metar.fromDict(row);
    print("Station ${m.stationId} at time ${m.observationTime} has raw metar: ${m.raw} and auto ${m.auto} and type ${m.metarType}");
  }
}

Future<List<Map<String, dynamic>>> parseMetarToDict(io.File metarFile) async {
  final metarLineStream = metarFile.openRead()
    .transform(utf8.decoder)
    .transform(LineSplitter());
  bool startCsv = false;
  List<Map<String, dynamic>> rows = [];
  late final List<String> headers;
  List<String>? splitLine;
  await for(var line in metarLineStream) {
    if (!startCsv) {
      if (line.startsWith("raw_text")) {
        startCsv = true;
        final List<String> rawHeaders = line.split(",");
        headers = [];
        for (String header in rawHeaders) {
          if (headers.contains(header)) {
            int i = 2;
            while (headers.contains(header+i.toString())) {
              i++;
            }
            headers.add(header+i.toString());
          } else {
            headers.add(header);
          }
        }
      }
    } else {
      splitLine = line.split(",");
      final lineMap = Map<String, dynamic>();
      for (int i = 0; i < splitLine.length; i++) {
        lineMap[headers[i]] = splitLine[i];
      } 
      rows.add(lineMap);
    }
  }
  return rows;
}