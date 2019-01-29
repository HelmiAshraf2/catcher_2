import 'dart:convert';
import 'dart:io';

import 'package:catcher/report.dart';
import 'package:catcher/handlers/report_handler.dart';

class FileHandler extends ReportHandler{

  final File file;
  bool isWritable;

  FileHandler(this.file);

  @override
  bool handle(Report report) {
    _writeNewLineToFile(report.toString());
    return true;
  }

  Future<bool> checkFile() async{
    try {
      bool exists = await file.exists();
      if (exists) {
        IOSink sink = file.openWrite(mode: FileMode.append);
        sink.write("");
        sink.flush();
        sink.close();
        return true;
      }
    } catch(exc,stackTrace){
      print(exc + " " + stackTrace);
    }
    return false;
  }

  @override
  log(String logString) async {
    if (isWritable) {
      _writeNewLineToFile(logString);
    }
  }

  _writeNewLineToFile(String text) async {
    IOSink sink = file.openWrite(mode: FileMode.append);
    sink.add(utf8.encode('$text\n'));
    await sink.flush();
    await sink.close();
  }


}