import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
// import 'package:flutter/services.dart';
// import 'package:time_machine/time_machine.dart';
import 'package:traceme/service/query.dart';

class Htime{
  DateTime now = new DateTime.now();
  String dateTime;
  String date;
  String time;
  var que = Hquery();

  Htime(){
    this.dateTime = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
    this.date = DateFormat('yyyy-MM-dd').format(now);
    this.time = DateFormat('kk:mm:ss').format(now);
  }

  // DateTime format(DateTime _time){
  //   var _formatted = DateFormat('yyyy-MM-dd kk:mm:ss').format(_time);
  //   return _formatted;
  // }

  // Future<void> setupTime()async{
  //   await TimeMachine.initialize({
  //     'rootBundle': rootBundle,
  //   });

  //   var tzdb = await DateTimeZoneProviders.tzdb;
  //   var manila = await tzdb["Asia/Manila"];
  //   var nw = Instant.now();

  //   date = '${nw.inZone(manila).year}-${nw.inZone(manila).monthOfYear}-${nw.inZone(manila).dayOfMonth}';
  //   time = '${nw.inZone(manila).hourOfDay}:${nw.inZone(manila).minuteOfHour}:${nw.inZone(manila).secondOfMinute}';
  //   dateTime = "$date $time";
  // }

  String getTimeStamp(){
    // setupTime();
    return dateTime;
  }

  String getDate(){
    // setupTime();
    return date;
  }

  String getTime(){
    // setupTime();
    return time;
  }

  Map<String, dynamic> getDifference(DateTime _current, DateTime _past){
    Map<String, dynamic> _totalDef = {};
    Duration _def = _current.difference(_past);
    int _days = _def.inDays;
    int _hour = _days == 0 ? _def.inHours : (_def.inHours - (_def.inDays * 24)).truncate();
    int _minute = _hour == 0 ? _def.inMinutes : (_def.inMinutes - (_def.inHours * 60)).truncate();
    int _second = _minute == 0 ? _def.inSeconds : (_def.inSeconds - (_def.inMinutes * 60)).truncate();
    
    _totalDef = { 
      "different": _days != 0 || _hour != 0 || _minute != 0 || _second != 0 ? true : false,
      "days": _days,
      "hour": _hour,
      "minute": _minute,
      "second": _second
    };

    return _totalDef;
  }

  DateTime stringToDateTime(String _date){
    return DateTime.parse(_date);
  }

  Map stringTimestampToMap(String _timestamp){
    var date = _timestamp.substring(0, 10);
    var time = _timestamp.substring(10, 19);
    var _map = {
      "date": date,
      "time": time,
    };

    return _map;
  }

  String intToDuration(int _hour, int _minute, int _second){
    var _duration = '';
    
    _duration = _hour.toString().length == 1 ? "0" + _hour.toString() : _hour.toString();
    _duration += ":"; 
    _duration += _minute.toString().length == 1 ? "0" + _minute.toString() : _minute.toString();
    _duration += ":"; 
    _duration += _second.toString().length == 1 ? "0" + _second.toString() : _second.toString();
    
    return _duration;
  }

  DateTime readTimestamp(Timestamp _timestamp) {
    return (_timestamp).toDate();
  }

  Map<String, int> readDuration(String _duration) {
    Map<String, int> duration = {
      "hour": int.parse(_duration.substring(0, 2)),
      "minute": int.parse(_duration.substring(3, 5)),
      "second": int.parse(_duration.substring(6, 8)),
    };
    return duration;
  }

  int durationToSecond(String _duration){
    int _second = 0;
    _second += (int.parse(_duration.substring(0, 2)) * 3600);
    _second += (int.parse(_duration.substring(3, 5)) * 60);
    _second += int.parse(_duration.substring(6, 8));
    return _second;
  }

  Map<String, int> secondToDuration(int _second1) {
    int _second = _second1;
    int _hour = _second ~/ 3600;
    _second = _second - (_hour * 3600); 
    int _minute = _second ~/ 60;
    _second = _second - (_minute * 60);

    Map<String, int> _duration = {
      "hour": _hour,
      "minute": _minute,
      "second": _second,
    };

    return _duration;
  }



  Future<Map> getTaskTime(String taskId)async{
    var result = {
      "expired": false,
      "taskDurationVal": "00:00:00"
    };

    var task = await que.getDataByID("tasks", taskId);
    var taskDuration = task['taskDuration'];
    var dateTime = stringToDateTime(getTimeStamp());
    var str = readTimestamp(task['started']);
    var def = getDifference(dateTime, str);

    if (def['days'] != 0) {
      result['expired'] = true;
    } else {
      var secDuration = durationToSecond(taskDuration);
      var _diffDuration = intToDuration(def['hour'], def['minute'], def['second']);
      var secDiff = durationToSecond(_diffDuration);
      if((secDuration - secDiff) < 0){
        result['expired'] = true;
      }else{
        var mapDuration = secondToDuration(secDuration - secDiff);
        var timeUpdate = intToDuration(mapDuration['hour'], mapDuration['minute'], mapDuration['second']);
        result['taskDurationVal'] = timeUpdate;
      }
    }

    return result;
  }
}