// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metar_cache.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Metar _$MetarFromJson(Map<String, dynamic> json) => Metar()
  ..id = (json['id'] as num).toInt()
  ..raw = json['raw'] as String?
  ..stationId = json['Station Identifier'] as String?
  ..observationTime = json['Observation Date/time'] == null
      ? null
      : DateTime.parse(json['Observation Date/time'] as String)
  ..latitude = (json['latitude'] as num?)?.toDouble()
  ..longitude = (json['longitude'] as num?)?.toDouble()
  ..tempCelcius = (json['Temperature in Celsius'] as num?)?.toDouble()
  ..location = (json['location'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList()
  ..dewpointCelcius = (json['Dewpoint in Celsius'] as num?)?.toDouble()
  ..windDirection = (json['windDirection'] as num?)?.toInt()
  ..windSpeedKt = (json['windSpeedKt'] as num?)?.toInt()
  ..windGustKt = (json['windGustKt'] as num?)?.toInt()
  ..windDescription = json['Surface Wind Conditions'] as String?
  ..visibilityStatMi = (json['Visibility in Statute Miles'] as num?)?.toDouble()
  ..altimeterHg = (json['Altimeter Setting in Inches Mercury'] as num?)
      ?.toDouble()
  ..seaLevelPressureMb = (json['Sea Level Pressure in Millibars'] as num?)
      ?.toDouble()
  ..corrected = json['Corrected Flag'] as bool?
  ..auto = json['auto'] as bool?
  ..autoStation = json['autoStation'] as bool?
  ..maintenanceIndicatorOn = json['Maintenance Indicator'] as bool?
  ..noSignal = json['No Signal Indicator'] as bool?
  ..lightningSensorOff = json['Lightning Sensor Off'] as bool?
  ..freezingRainSensorOff = json['Freezing Rain Sensor Off'] as bool?
  ..presentWeatherSensorOff = json['Present Weather Sensor Off'] as bool?
  ..wxString = json['wxString'] as String?
  ..weatherDescription = json['Weather Description'] as String?
  ..skyCoverDescription = json['Sky Cover'] as String?
  ..skyCover = json['skyCover'] as String?
  ..cloudBaseFeetAgl = (json['cloudBaseFeetAgl'] as num?)?.toInt()
  ..skyCover2 = json['skyCover2'] as String?
  ..cloudBaseFeetAgl2 = (json['cloudBaseFeetAgl2'] as num?)?.toInt()
  ..skyCover3 = json['skyCover3'] as String?
  ..cloudBaseFeetAgl3 = (json['cloudBaseFeetAgl3'] as num?)?.toInt()
  ..skyCover4 = json['skyCover4'] as String?
  ..cloudBaseFeetAgl4 = (json['cloudBaseFeetAgl4'] as num?)?.toInt()
  ..flightCategory = json['flightCategory'] as String?
  ..flightCategoryDescription = json['Flight Category'] as String?
  ..threeHourPressureTendencyMb =
      (json['Three hour pressure tendency in millibars'] as num?)?.toDouble()
  ..maxTempCelcius = (json['Max temperature Celcius'] as num?)?.toDouble()
  ..minTempCelcius = (json['Min temperature Celcius'] as num?)?.toDouble()
  ..maxTemp24HourCelcius = (json['Max 24-hour temperature Celcius'] as num?)
      ?.toDouble()
  ..minTemp24HourCelcius = (json['Min 24-hour temperature Celcius'] as num?)
      ?.toDouble()
  ..precipitationInches = (json['Precipitation in inches'] as num?)?.toDouble()
  ..precipitation3HourInches = (json['3-hour precipitation in inches'] as num?)
      ?.toDouble()
  ..precipitation6HourInches = (json['6-hour precipitation in inches'] as num?)
      ?.toDouble()
  ..precipitation24HourInches =
      (json['24-hour precipitation in inches'] as num?)?.toDouble()
  ..snowInches = (json['Snow in inches'] as num?)?.toDouble()
  ..verticalVisibilityFeet = (json['Feet of vertical visibility'] as num?)
      ?.toInt()
  ..metarType = json['metarType'] as String?
  ..elevationInMeters = (json['Observation elevation in meters'] as num?)
      ?.toInt();

Map<String, dynamic> _$MetarToJson(Metar instance) => <String, dynamic>{
  'id': instance.id,
  'Station Identifier': instance.stationId,
  'Observation Date/time': instance.observationTime?.toIso8601String(),
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  if (instance.tempCelcius case final value?) 'Temperature in Celsius': value,
  if (instance.dewpointCelcius case final value?) 'Dewpoint in Celsius': value,
  if (instance.windDescription case final value?)
    'Surface Wind Conditions': value,
  if (instance.visibilityStatMi case final value?)
    'Visibility in Statute Miles': value,
  if (instance.altimeterHg case final value?)
    'Altimeter Setting in Inches Mercury': value,
  if (instance.seaLevelPressureMb case final value?)
    'Sea Level Pressure in Millibars': value,
  if (instance.corrected case final value?) 'Corrected Flag': value,
  if (instance.maintenanceIndicatorOn case final value?)
    'Maintenance Indicator': value,
  if (instance.noSignal case final value?) 'No Signal Indicator': value,
  if (instance.lightningSensorOff case final value?)
    'Lightning Sensor Off': value,
  if (instance.freezingRainSensorOff case final value?)
    'Freezing Rain Sensor Off': value,
  if (instance.presentWeatherSensorOff case final value?)
    'Present Weather Sensor Off': value,
  if (instance.weatherDescription case final value?)
    'Weather Description': value,
  if (instance.skyCoverDescription case final value?) 'Sky Cover': value,
  if (instance.flightCategoryDescription case final value?)
    'Flight Category': value,
  if (instance.threeHourPressureTendencyMb case final value?)
    'Three hour pressure tendency in millibars': value,
  if (instance.maxTempCelcius case final value?)
    'Max temperature Celcius': value,
  if (instance.minTempCelcius case final value?)
    'Min temperature Celcius': value,
  if (instance.maxTemp24HourCelcius case final value?)
    'Max 24-hour temperature Celcius': value,
  if (instance.minTemp24HourCelcius case final value?)
    'Min 24-hour temperature Celcius': value,
  if (instance.precipitationInches case final value?)
    'Precipitation in inches': value,
  if (instance.precipitation3HourInches case final value?)
    '3-hour precipitation in inches': value,
  if (instance.precipitation6HourInches case final value?)
    '6-hour precipitation in inches': value,
  if (instance.precipitation24HourInches case final value?)
    '24-hour precipitation in inches': value,
  if (instance.snowInches case final value?) 'Snow in inches': value,
  if (instance.verticalVisibilityFeet case final value?)
    'Feet of vertical visibility': value,
  if (instance.elevationInMeters case final value?)
    'Observation elevation in meters': value,
};
