import 'dart:io';
import 'dart:ffi' as ffi;
import 'native/llama_bindings.dart';
import 'package:path/path.dart' as path;



void main() {
  final String libPath;
  if (Platform.isWindows) {
    libPath = path.join(Directory.current.path, 'src', 'Debug', 'llama_api.dll');
  } else {
    throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
  }

  final addLib = ffi.DynamicLibrary.open(libPath);
  final add = addLib.lookupFunction<ffi.Int32 Function(ffi.Int32, ffi.Int32), int Function(int, int)>("add");

  stdout.write("hi: " + add(2,3).toString() + "\n");
}