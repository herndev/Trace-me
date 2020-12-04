import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:traceme/service/time.dart';

getCsv(data) async {
  var ti = Htime();
  var timestamp = ti.getTimeStamp();
  timestamp = timestamp.replaceAll(" ", "");

  //create an element rows of type list of list. All the above data set are stored in associate list
  //Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.

  List<List<dynamic>> rows = List<List<dynamic>>();
  for (int i = 0; i < data.length; i++) {
    //row refer to each column of a row in csv file and rows refer to each row in a file
    List<dynamic> row = List();
    row.add(data[i].userID);
    row.add(data[i].timestamp);
    row.add(data[i].temperature);
    rows.add(row);
  }

  // await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
  var status = await Permission.storage.request();
  // bool checkPermission = 
      // await SimplePermissions.checkPermission(Permission.WriteExternalStorage);
  if (status.isGranted) {
    //store file in documents folder

    String dir =
        (await getExternalStorageDirectory()).absolute.path + "/documents";
    var file = "$dir";

    print("FILE: " + file);
    
    File f = new File(file + "traceme$timestamp.csv");

    // convert rows to String and write as csv file

    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
  }
}
