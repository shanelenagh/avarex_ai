import 'dart:convert';
import 'package:objectbox/objectbox.dart';
import 'package:logging/logging.dart';
import 'dart:io' as io;
import '../objectbox.g.dart';

final log = Logger("avrex_ai:test");


@Entity()
class Metar {
  @Id()
  int id = 0;

  String? raw;
  String? stationId;
  DateTime? observationTime;
  double? latitude, longitude;
  double? tempCelcius;
  @HnswIndex(dimensions: 2, distanceType: VectorDistanceType.geo)
  @Property(type: PropertyType.floatVector)  
  List<double?>? location;
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

  Metar();

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
    elevationInMeters = int.tryParse(d["elevation_m"]) 
    {
      location = [latitude, longitude];
    }
}

void main(List<String> args) async {
  if (args.isEmpty || args[0].isEmpty || !io.File(args[0]).existsSync()) {
    io.stderr.writeln("Pass CSV file as single argument to program");
    io.exit(1);
  }
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });  
  log.info("Parse started");
  List<Map<String, dynamic>> metarRows = await parseMetarToDict(io.File(args[0]));
  log.info("Dict parse done, now mapping to Metars");
  List<Metar> metars = metarRows.map((d) => Metar.fromDict(d)).toList();
  log.info("METAR mapping done, now going to print them out");
  //print(jsonEncode(metarRows));
  for (Metar m in metars) {
    print("Station ${m.stationId} at ${m.observationTime}: wx=${m.wxString}, auto=${m.auto}, type=${m.metarType}, skyCover=${m.skyCover}");
  }
  log.info("Parse test finished");

  final ObjectBox objectbox = await ObjectBox.create();
  objectbox.metarBox.putMany(metars);




}

Future<List<Map<String, dynamic>>> parseMetarToDict(io.File metarFile) async {
  log.info("Starting METAR processing");
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
        // Metars have non-unique column names for multiple elements (e.g., sky cover at different altitudes), so make col names unique
        for (String header in rawHeaders) {
          if (headers.contains(header)) {
            int i = 2;
            for ( ; headers.contains(header+i.toString()); i++); // increment until header name is unique
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
  log.info("Parsed METAR into dict");
  return rows;
}

class ObjectBox {
  /// The Store of this app.
  late final Store _store;
  late final Box<Metar> metarBox;
  static ObjectBox? _instance;
  
  ObjectBox._create(this._store) {
    // Add any additional setup code, e.g. build queries.
    metarBox = Box<Metar>(_store);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    if (_instance != null) {
      return _instance!;
    } else {
      // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
      final store = await openStore(directory: "obx-example");
      _instance = ObjectBox._create(store);
      return _instance!;
    }
  }
}