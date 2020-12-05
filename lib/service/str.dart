class Hstring {
  String capitalizeW(String _word) {
    if (_word != "") {
      var str = _word;

      // Capitalized string
      str = str[0].toUpperCase() + str.substring(1, str.length);

      return str;
    }else{
      return "";
    }
  }

  String capitalizeS(String _sentence) {
    if (_sentence != "") {
      var tempStr = _sentence.toLowerCase();
      var str = [];

      // Capitalized every word in a string
      for (var s in tempStr.split(" ")) {
        str.add(capitalizeW(s));
      }

      return str.join(" ");
    }else{
      return "";
    }
  }

  String capitalizeFS(String _sentence) {
    if (_sentence != "") {
      var tempStr = _sentence.toLowerCase();
      var listTempStr = tempStr.split(" ");
      var str = [];

      // Capitalized first word in a string
      str.add(capitalizeW(listTempStr[0]));
      str.addAll(listTempStr.getRange(1, listTempStr.length));

      return str.join(" ");
    }else{
      return "";
    }
  }
}
