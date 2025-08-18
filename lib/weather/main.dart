import 'package:logging/logging.dart';
import 'dart:io' as io;

import 'metar_cache.dart' show MetarObjectBox, Metar, parseMetarToDict;

final log = Logger("avrex_ai:test");


void main(List<String> args) async {
  if (args.isEmpty || args[0].isEmpty || !io.File(args[0]).existsSync()) {
    io.stderr.writeln("Pass CSV file as single argument to program");
    io.exit(1);
  }
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.time} ${record.level.name} - ${record.message}');
  });  
  log.info("Parse started");
  List<Map<String, dynamic>> metarRows = await parseMetarToDict(io.File(args[0]).openRead());
  log.info("Dict parse done, now mapping to Metars");
  List<Metar> metars = metarRows.map((d) => Metar.fromDict(d)).toList();
  log.info("METAR mapping done, now going to print them out");
  //print(jsonEncode(metarRows));
  for (Metar m in metars) {
    log.info("Station ${m.stationId} at ${m.observationTime}: wx=${m.wxString}, auto=${m.auto}, type=${m.metarType}, skyCover=${m.skyCover}");
  }
  log.info("Parse test finished; creating objectbox instance");
  final MetarObjectBox ob = await MetarObjectBox.create();
  log.info("About to put metars in DB");
  ob.metarBox.putMany(metars);
  log.info("Finished putting ${ob.metarBox.count()} metars in DB");
}