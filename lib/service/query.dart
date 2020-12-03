import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

class Hquery {
  String id;
  final db = FirebaseFirestore.instance;
  // final dbs = FirebaseStorage.instance;

  Future<String> push(root, data) async {
    DocumentReference ref = await db.collection(root).add(data);
    id = ref.id;
    return ref.id.toString();
  }

  // Future<bool> pushf(file, fileName, {folder:""}) async {
  //   var dir = folder.length == 0 ? folder : "/" + folder + "/";
  //   var fsr = dbs.ref().child(dir + fileName);
  //   var task = fsr.putFile(file);
  //   await task.whenComplete(() => null);
  //   return true;
  // }

  Future<Map> getDataByID(root, key) async {
    DocumentSnapshot snapshot = await db.collection(root).doc(key).get();
    return snapshot.data();
  }

  Future<dynamic> getKeyByData(root, key, value) async {
    var ids = await getIDs(root);

    for (var i in ids) {
      var d = await getDataByID(root, i);

      try {
        if (d[key] == value) {
          return i;
        }
      } catch (e) {
        print(e);
      }
    }

    return null;
  }

  Future<dynamic> getDataByData(root, key, value) async {
    var ids = await getIDs(root);

    for (var i in ids) {
      var d = await getDataByID(root, i);

      try {
        if (d[key] == value) {
          return d;
        }
      } catch (e) {
        print(e);
      }
    }

    return null;
  }

  // Future<String> getUrl(file, {folder:""}) async {
  //   var dir = folder.length == 0 ? folder : "/" + folder + "/";
  //   var rf = dbs.ref().child(dir + file);
  //   var url = await rf.getDownloadURL();

  //   return url;
  // }

  Future<List> getIDs(root) async {
    QuerySnapshot snapshot = await db.collection(root).get();
    List<String> ids = [];

    // Loop through items
    for (DocumentSnapshot item in snapshot.docs) {
      ids.add(item.id);
    }

    return ids;
  }

  Future<bool> checkID(root, key) async {
    DocumentSnapshot snapshot = await db.collection(root).doc(key).get();
    return snapshot.exists;
  }

  Future<bool> update(root, key, data) async {
    await db.collection(root).doc(key).update(data).whenComplete(() => null);
    return true;
  }

  Future<bool> deleteByID(root, key) async {
    await db.collection(root).doc(key).delete();
    return true;
  }

  Future<bool> deleteByIDKeys(root, key, ids) async {
    var data = await getDataByID(root, key);

    for (var i in ids) {
      if (data.keys.contains(i)) {
        data[i] = FieldValue.delete();
      }
    }

    await update(root, key, data);
    return true;
  }

  // Future<bool> downloadFromUrl(url, fileName)async{
  //   var status = await Permission.storage.request();
  //   if(status.isGranted){

  //     var exdir = await getExternalStorageDirectory();

  //     await FlutterDownloader.enqueue(
  //       url: url,
  //       savedDir: exdir.path,
  //       fileName: fileName,
  //       showNotification: true,
  //       openFileFromNotification: true
  //     );

  //     return true;

  //   }else{
  //     return false;
  //   }
  // }

  Stream getSnap(String root) {
    return FirebaseFirestore.instance.collection(root).snapshots();
  }

  Stream getSnapSorted(String root, String by) {
    return FirebaseFirestore.instance.collection(root).orderBy(by).snapshots();
  }

  Stream getSnapSortedR(String root, String by) {
    return FirebaseFirestore.instance
        .collection(root)
        .orderBy(by, descending: true)
        .snapshots();
  }

  Stream getSnapByID(String root, String key) {
    return FirebaseFirestore.instance.collection(root).doc(key).snapshots();
  }
}





