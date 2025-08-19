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

   List<ObjectWithScore<Metar>> getMetarsNearMe(List<double> latLong, int neighborCount) {
    return _ob!.metarBox.query(Metar_.location.nearestNeighborsF32(latLong, neighborCount)).build().findWithScores();
  } 


}

@JsonSerializable() 
@Entity()
class Metar {
  @Id(assignable: true)
  int id = 0;

  @JsonKey(includeToJson: false)
  String? raw;
  @JsonKey(name: "Station Identifier")
  String? stationId;
  @JsonKey(name: "Observation Date/time")
  DateTime? observationTime;
  double? latitude;
  double? longitude;
  @JsonKey(name: "Temperature in Celsius", includeIfNull: false)
  double? tempCelcius;
  @HnswIndex(dimensions: 2, distanceType: VectorDistanceType.geo)
  @Property(type: PropertyType.floatVector)  
  @JsonKey(includeToJson: false)
  late List<double> location;
  @JsonKey(name: "Dewpoint in Celsius", includeIfNull: false)
  double? dewpointCelcius;
  @JsonKey(includeToJson: false)
  int? windDirection;
  @JsonKey(includeToJson: false)
  int? windSpeedKt;
  @JsonKey(includeToJson: false)
  int? windGustKt;
  @JsonKey(name: "Surface Wind Conditions", includeIfNull: false)
  String? windDescription;
  @JsonKey(name: "Visibility in Statute Miles", includeIfNull: false)
  double? visibilityStatMi;
  @JsonKey(name: "Altimeter Setting in Inches Mercury", includeIfNull: false)
  double? altimeterHg;
  @JsonKey(name: "Sea Level Pressure in Millibars", includeIfNull: false)
  double? seaLevelPressureMb;
  @JsonKey(name: "Corrected Flag", includeIfNull: false)
  bool? corrected;
  @JsonKey(includeToJson: false)
  bool? auto;
  @JsonKey(includeToJson: false)
  bool? autoStation;
  @JsonKey(name: "Maintenance Indicator", includeIfNull: false)
  bool? maintenanceIndicatorOn;
  @JsonKey(name: "No Signal Indicator", includeIfNull: false)
  bool? noSignal;
  @JsonKey(name: "Lightning Sensor Off", includeIfNull: false)
  bool? lightningSensorOff;
  @JsonKey(name: "Freezing Rain Sensor Off", includeIfNull: false)
  bool? freezingRainSensorOff;
  @JsonKey(name: "Present Weather Sensor Off", includeIfNull: false)
  bool? presentWeatherSensorOff;
  @JsonKey(includeToJson: false)
  String? wxString;
  @JsonKey(name: "Weather Description", includeIfNull: false)
  String? weatherDescription;
  @JsonKey(name: "Sky Cover", includeIfNull: false)
  String? skyCoverDescription;
  @JsonKey(includeToJson: false)
  String? skyCover;
  @JsonKey(includeToJson: false)
  int? cloudBaseFeetAgl;
  @JsonKey(includeToJson: false)
  String? skyCover2;
  @JsonKey(includeToJson: false)
  int? cloudBaseFeetAgl2;
  @JsonKey(includeToJson: false)
  String? skyCover3;
  @JsonKey(includeToJson: false)
  int? cloudBaseFeetAgl3;
  @JsonKey(includeToJson: false)
  String? skyCover4;
  @JsonKey(includeToJson: false)
  int? cloudBaseFeetAgl4;
  @JsonKey(includeToJson: false)
  String? flightCategory;
  @JsonKey(name: "Flight Category", includeIfNull: false)
  String? flightCategoryDescription;
  @JsonKey(name: "Three hour pressure tendency in millibars", includeIfNull: false)
  double? threeHourPressureTendencyMb;
  @JsonKey(name: "Max temperature Celcius", includeIfNull: false)
  double? maxTempCelcius;
  @JsonKey(name: "Min temperature Celcius", includeIfNull: false)
  double? minTempCelcius;
  @JsonKey(name: "Max 24-hour temperature Celcius", includeIfNull: false)
  double? maxTemp24HourCelcius;
  @JsonKey(name: "Min 24-hour temperature Celcius", includeIfNull: false)
  double? minTemp24HourCelcius;
  @JsonKey(name: "Precipitation in inches", includeIfNull: false)
  double? precipitationInches;
  @JsonKey(name: "3-hour precipitation in inches", includeIfNull: false)
  double? precipitation3HourInches;
  @JsonKey(name: "6-hour precipitation in inches", includeIfNull: false)
  double? precipitation6HourInches;
  @JsonKey(name: "24-hour precipitation in inches", includeIfNull: false)
  double? precipitation24HourInches;
  @JsonKey(name: "Snow in inches", includeIfNull: false)
  double? snowInches;
  @JsonKey(name: "Feet of vertical visibility", includeIfNull: false)
  int? verticalVisibilityFeet;
  @JsonKey(includeToJson: false)
  String? metarType;
  @JsonKey(name: "Observation elevation in meters", includeIfNull: false)
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
      id = "${stationId??''} ${latitude.toString()}, ${longitude.toString()}".hashCode;
      location = [latitude!, longitude!];
      weatherDescription = _getWeatherDescription(wxString);
      skyCoverDescription = _getSkyCoverDescription();
      flightCategoryDescription = flightCategoryDescriptor[flightCategory];
      windDescription = _getWindDescription();
    }

    String? _getWindDescription() {
      if (windSpeedKt == null) {
        return null;
      }
      String windDescription = "$windSpeedKt knots";
      if (windDirection != null) {
        windDescription += " from $windDirection degrees";
      }
      if (windGustKt != null) {
        windDescription += ", gusting to $windGustKt knots";
      }
      return windDescription;
    }

    String? _getSkyCoverDescription() {
      String? skyCoverDescription;
      if (skyCover != null && skyCover!.isNotEmpty) {
        skyCoverDescription = "${skyCoverDescriptor[skyCover]} at $cloudBaseFeetAgl feet";
      }
      if (skyCover2 != null && skyCover2!.isNotEmpty) {
        skyCoverDescription = skyCoverDescription != null ? "$skyCoverDescription, " : "";
        skyCoverDescription += "${skyCoverDescriptor[skyCover2]} at $cloudBaseFeetAgl2 feet";
      }
      if (skyCover3 != null && skyCover3!.isNotEmpty) {
        skyCoverDescription = skyCoverDescription != null ? "$skyCoverDescription, " : "";
        skyCoverDescription += "${skyCoverDescriptor[skyCover3]} at $cloudBaseFeetAgl3 feet";
      }      
      return skyCoverDescription;
    }

    static String? _getWeatherDescription(String? wxString) {
      if (wxString == null || wxString.trim().isEmpty) {
        return null;
      }
      String wxDescription = "";
      while (wxString!.isNotEmpty) {
        wxString = wxString.trim();
        String newWeather = "";
        if (wxString[0] == "+") {
          newWeather = "Heavy ";
          wxString = wxString.substring(1);
        } else if (wxString[0] == "-") {
          newWeather = "Light ";
          wxString = wxString.substring(1);
        }        
        if (recencyDescriptor.containsKey(wxString.substring(0,2))) {
          newWeather += "${recencyDescriptor[wxString.substring(0,2)]!} ";
          wxString = wxString.substring(2);
          if (phenomenonDescriptor.containsKey(wxString.substring(0,2))) {
            newWeather += phenomenonDescriptor[wxString.substring(0,2)]!;
            wxString = wxString.substring(2);
          }           
        } else if (phenomenonDescriptor.containsKey(wxString.substring(0,2))) {
          newWeather += phenomenonDescriptor[wxString.substring(0,2)]!;
          wxString = wxString.substring(2);
        }      
        if (newWeather.isEmpty) {
          //throw Exception("Can't interpret rest of weather string: $wxString and segment ${wxString.substring(0,1)} with phenom bool ${phenomenonDescriptor.containsKey(wxString.substring(0,1))}");
          break;
        } else {
          wxDescription = wxDescription.isEmpty ? newWeather : "$wxDescription, $newWeather";
        }
      }

      return wxDescription;
    }

    static final recencyDescriptor = { 
      "VC": "Visible", 
      "RE": "Residual" 
    };
    static final phenomenonDescriptor = {
      "TS": "Thuderstorm",
      "MI": "Shallow fog",
      "PR": "Partial fog",
      "BC": "Patches of fog",
      "DR": "Low drifting fog",
      "BL": "Blowing eye level fog",
      "SH": "Showers",
      "FZ": "Freezing",
      "DZ": "Drizzle",
      "RA": "Rain",
      "SN": "Snow",
      "SG": "Snow grains",
      "GS": "Graupel/small hail",
      "GR": "Hail",
      "PL": "Ice pellets",
      "IC": "Ice crystals",
      "UP": "Unknown prcipitation",
      "FG": "Fog",
      "BR": "Mist",
      "HZ": "Haze",
      "VA": "Volcanic ash",
      "DU": "Widespread dust",
      "FU": "Smoke",
      "SA": "Sand",
      "PY": "Spray",
      "SQ": "Squall",
      "PO": "Dust or sand whirls",
      "DS": "Dust storm",
      "SS": "Sand storm",
      "FC": "Funnel cloud"
    };
    static final skyCoverDescriptor = {
      "CLR": "Clear",
      "SKC": "No clouds, sky clear",
      "NCD": "Nil clouds detected",
      "NSD": "No significant clouds",
      "FEW": "Few clouds",
      "SCT": "Scattered clouds",
      "BKN": "Broken clouds",
      "OVC": "Overcast",
      "TCU": "Towering cumulus clouds",
      "CB": "Cumulonimbus clouds",
      "VV": "Vertical visibility prevented"
    };
    static final flightCategoryDescriptor = {
      "VFR": "Visual Flight Rules",
      "IFR": "Instrument Flight Rules",
      "LIFR": "Low Instrument Flight Rules",
      "MVFR": "Marginal Visual Flight Rules"
    };

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
      final lineMap = <String, dynamic>{};
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

  log.info("Getting METARs for route");
  final metars = metarCache.getMetarsOnRoute(["SUMU", "LFRJ", "NTTB", "CYXU"]);
  log.info("Found ${metars.length} metars for route");
  for (int i = 0; i < metars.length; i++) {
    log.info("METAR $i for route: ${metars[i].toJson()}");
  }
  log.info("Now going to search for METAR near Bellvue, NE");
  final nearMe = metarCache.getMetarsNearMe([41.18451703151091, -95.96258884989884], 3);
  log.info("Found ${nearMe.length} metars near me");
  for (ObjectWithScore<Metar> m in nearMe) {
    log.info("METAR within ${m.score}km of me: ${m.object.toJson()}");
  }
  log.info("done");
}