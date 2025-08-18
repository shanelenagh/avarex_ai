import 'dart:io';

import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logging/logging.dart';
// ignore: unnecessary_import - Used by Objectbox code generation
import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';

import '../objectbox.g.dart';

part 'metar_cache.g.dart';

final log = Logger("avrex_ai:test");

class MetarCache {

  static const String _metarUrl = 'https://aviationweather.gov/data/cache/metars.cache.csv.gz';
  static final MetarCache _instance = MetarCache._create();
  
  MetarObjectBox? _ob;

  MetarCache._create();

  static Future<MetarCache> create() async {
    if (_instance._ob != null) {
      return _instance;
    }
    _instance._ob = await MetarObjectBox.create();
    return _instance;
  }

  static Future<List<Metar>> getMetars() async {
    log.info("Downloading METAR data from $_metarUrl");
    final metarStream = await _getMetarStream();
    log.info("Parsing METAR data");
    final metarDict = await parseMetarToDict(metarStream);
    log.info("Parsed METAR data into dictionary format of length ${metarDict.length}");
    final metars = metarDict.map((d) => Metar.fromDict(d)).toList();
    log.info("Converted METAR data to Metar objects of length ${metars.length}");
    
    return metars;
  }

  static Future<Stream<List<int>>> _getMetarStream() async {
    final client = http.Client();
    final request = http.Request('GET', Uri.parse(_metarUrl));
    final response = await client.send(request);
    if (response.statusCode != 200) {
      throw Exception("Failed to download METAR data; got status: ${response.statusCode} - ${response.reasonPhrase}");
    }
    return response.stream.transform(GZipCodec().decoder);
  }

  Future<void> updateMetarCache() async {
    _ob!.metarBox.putMany(await getMetars());    
  }

  List<Metar> getMetarsOnRoute(List<String> stationIds) {
    return _ob!.metarBox.query(
      Metar_.stationId.oneOf(stationIds),
    ).build().find();
  }  
}

@JsonSerializable() 
@Entity()
class Metar {
  @Id(assignable: true)
  int id = 0;

  String? raw;
  String? stationId;
  DateTime? observationTime;
  double? latitude, longitude;
  double? tempCelcius;
  @HnswIndex(dimensions: 2, distanceType: VectorDistanceType.geo)
  @Property(type: PropertyType.floatVector)  
  late List<double> location;
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
    latitude = double.tryParse(d["latitude"]) ?? 0,
    longitude = double.tryParse(d["longitude"]) ?? 0,
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
      id = ((stationId ?? "") + (metarType ?? "")).hashCode; //raw?.hashCode ?? 0; // Use hash code of raw text as ID
      location = [latitude!, longitude!];
    }

    Map<String, dynamic> toJson() => _$MetarToJson(this);
}

Future<List<Map<String, dynamic>>> parseMetarToDict(Stream<List<int>> metarStream) async {
  final metarLineStream = metarStream.transform(utf8.decoder).transform(LineSplitter());
  bool startCsv = false;
  List<Map<String, dynamic>> rows = [];
  late final List<String> headers;
  List<dynamic> splitLine = [];
  final CsvToListConverter csvConverter = CsvToListConverter(shouldParseNumbers: false);
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
      splitLine = csvConverter.convert(line)[0]; //.split(",");
      final lineMap = Map<String, dynamic>();
      for (int i = 0; i < splitLine.length; i++) {
        lineMap[headers[i]] = splitLine[i].toString();
      } 
      rows.add(lineMap);
    }
  }
  return rows;
}

class MetarObjectBox {
  /// The Store of this app.
  late final Store _store;
  late final Box<Metar> metarBox;
  static MetarObjectBox? _instance;
  
  MetarObjectBox._create(this._store) {
    // Add any additional setup code, e.g. build queries.
    metarBox = Box<Metar>(_store);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<MetarObjectBox> create() async {
    if (_instance != null) {
      return _instance!;
    } else {
      // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
      final store = openStore(directory: "obx-example");
      _instance = MetarObjectBox._create(store);
      return _instance!;
    }
  }
}

void main(List<String> args) async {
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.time} ${record.level.name} - ${record.message}');
  });  

  log.info("Creating metar cache instance");
  final metarCache = await MetarCache.create(); 
  log.info("Starting METAR cache update");
  await metarCache.updateMetarCache();
  log.info("Finished METAR cache update");
  log.info("Now there are ${metarCache._ob?.metarBox.count()} metars in DB");

  // final bStream = (await MetarCache._getMetarStream()).asBroadcastStream(); //response.stream.transform(GZipCodec().decoder).asBroadcastStream();
  // final sink = File("metars.csv").openWrite();
  // bStream.listen((List<int> data) {
  //   sink.add(data);
  // }, onDone: () {
  //   log.info("Finished writing METAR data to file");
  //   sink.close();
  // }, onError: (error) {
  //   log.severe("Error writing METAR data to file: $error");
  //   sink.close();
  // });
  // final metarDict = await parseMetarToDict(bStream); //response.stream.transform(GZipCodec().decoder).transform(utf8.decoder));
  // log.info("Parsed METAR data into dictionary format of length ${metarDict.length}");
  // log.info("First one is ${metarDict[0]['raw_text']}");
  // log.info("Last one is ${metarDict[metarDict.length-1]['raw_text']}");  

  log.info("Getting METARs for route");
  final metars = metarCache.getMetarsOnRoute(["KLNK"]);
  log.info("Found ${metars.length} metars for route");
  log.info("JSON for first ${metars[0].toJson()}");
}