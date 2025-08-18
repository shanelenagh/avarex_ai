// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metar_cache.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Metar _$MetarFromJson(Map<String, dynamic> json) => Metar()
  ..id = (json['id'] as num).toInt()
  ..raw = json['raw'] as String?
  ..stationId = json['stationId'] as String?
  ..observationTime = json['observationTime'] == null
      ? null
      : DateTime.parse(json['observationTime'] as String)
  ..latitude = (json['latitude'] as num?)?.toDouble()
  ..longitude = (json['longitude'] as num?)?.toDouble()
  ..tempCelcius = (json['tempCelcius'] as num?)?.toDouble()
  ..location = (json['location'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList()
  ..dewpointCelcius = (json['dewpointCelcius'] as num?)?.toDouble()
  ..windDirection = (json['windDirection'] as num?)?.toInt()
  ..windSpeedKt = (json['windSpeedKt'] as num?)?.toInt()
  ..windGustKt = (json['windGustKt'] as num?)?.toInt()
  ..visibilityStatMi = (json['visibilityStatMi'] as num?)?.toDouble()
  ..altimeterHg = (json['altimeterHg'] as num?)?.toDouble()
  ..seaLevelPressureMb = (json['seaLevelPressureMb'] as num?)?.toDouble()
  ..corrected = json['corrected'] as bool?
  ..auto = json['auto'] as bool?
  ..autoStation = json['autoStation'] as bool?
  ..maintenanceIndicatorOn = json['maintenanceIndicatorOn'] as bool?
  ..noSignal = json['noSignal'] as bool?
  ..lightningSensorOff = json['lightningSensorOff'] as bool?
  ..freezingRainSensorOff = json['freezingRainSensorOff'] as bool?
  ..presentWeatherSensorOff = json['presentWeatherSensorOff'] as bool?
  ..wxString = json['wxString'] as String?
  ..skyCover = json['skyCover'] as String?
  ..cloudBaseFeetAgl = (json['cloudBaseFeetAgl'] as num?)?.toInt()
  ..skyCover2 = json['skyCover2'] as String?
  ..cloudBaseFeetAgl2 = (json['cloudBaseFeetAgl2'] as num?)?.toInt()
  ..skyCover3 = json['skyCover3'] as String?
  ..cloudBaseFeetAgl3 = (json['cloudBaseFeetAgl3'] as num?)?.toInt()
  ..skyCover4 = json['skyCover4'] as String?
  ..cloudBaseFeetAgl4 = (json['cloudBaseFeetAgl4'] as num?)?.toInt()
  ..flightCategory = json['flightCategory'] as String?
  ..threeHourPressureTendencyMb = (json['threeHourPressureTendencyMb'] as num?)
      ?.toDouble()
  ..maxTempCelcius = (json['maxTempCelcius'] as num?)?.toDouble()
  ..minTempCelcius = (json['minTempCelcius'] as num?)?.toDouble()
  ..maxTemp24HourCelcius = (json['maxTemp24HourCelcius'] as num?)?.toDouble()
  ..minTemp24HourCelcius = (json['minTemp24HourCelcius'] as num?)?.toDouble()
  ..precipitationInches = (json['precipitationInches'] as num?)?.toDouble()
  ..precipitation3HourInches = (json['precipitation3HourInches'] as num?)
      ?.toDouble()
  ..precipitation6HourInches = (json['precipitation6HourInches'] as num?)
      ?.toDouble()
  ..precipitation24HourInches = (json['precipitation24HourInches'] as num?)
      ?.toDouble()
  ..snowInches = (json['snowInches'] as num?)?.toDouble()
  ..verticalVisibilityFeet = (json['verticalVisibilityFeet'] as num?)?.toInt()
  ..metarType = json['metarType'] as String?
  ..elevationInMeters = (json['elevationInMeters'] as num?)?.toInt();

Map<String, dynamic> _$MetarToJson(Metar instance) => <String, dynamic>{
  'id': instance.id,
  'raw': instance.raw,
  'stationId': instance.stationId,
  'observationTime': instance.observationTime?.toIso8601String(),
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'tempCelcius': instance.tempCelcius,
  'location': instance.location,
  'dewpointCelcius': instance.dewpointCelcius,
  'windDirection': instance.windDirection,
  'windSpeedKt': instance.windSpeedKt,
  'windGustKt': instance.windGustKt,
  'visibilityStatMi': instance.visibilityStatMi,
  'altimeterHg': instance.altimeterHg,
  'seaLevelPressureMb': instance.seaLevelPressureMb,
  'corrected': instance.corrected,
  'auto': instance.auto,
  'autoStation': instance.autoStation,
  'maintenanceIndicatorOn': instance.maintenanceIndicatorOn,
  'noSignal': instance.noSignal,
  'lightningSensorOff': instance.lightningSensorOff,
  'freezingRainSensorOff': instance.freezingRainSensorOff,
  'presentWeatherSensorOff': instance.presentWeatherSensorOff,
  'wxString': instance.wxString,
  'skyCover': instance.skyCover,
  'cloudBaseFeetAgl': instance.cloudBaseFeetAgl,
  'skyCover2': instance.skyCover2,
  'cloudBaseFeetAgl2': instance.cloudBaseFeetAgl2,
  'skyCover3': instance.skyCover3,
  'cloudBaseFeetAgl3': instance.cloudBaseFeetAgl3,
  'skyCover4': instance.skyCover4,
  'cloudBaseFeetAgl4': instance.cloudBaseFeetAgl4,
  'flightCategory': instance.flightCategory,
  'threeHourPressureTendencyMb': instance.threeHourPressureTendencyMb,
  'maxTempCelcius': instance.maxTempCelcius,
  'minTempCelcius': instance.minTempCelcius,
  'maxTemp24HourCelcius': instance.maxTemp24HourCelcius,
  'minTemp24HourCelcius': instance.minTemp24HourCelcius,
  'precipitationInches': instance.precipitationInches,
  'precipitation3HourInches': instance.precipitation3HourInches,
  'precipitation6HourInches': instance.precipitation6HourInches,
  'precipitation24HourInches': instance.precipitation24HourInches,
  'snowInches': instance.snowInches,
  'verticalVisibilityFeet': instance.verticalVisibilityFeet,
  'metarType': instance.metarType,
  'elevationInMeters': instance.elevationInMeters,
};
