class Customer{
  final userID;
  final timestamp;
  final temperature;

  Customer({this.userID, this.timestamp, this.temperature});
}


class Person{
  final userID;
  final userType;
  final company;
  final position;
  final name;

  Person({this.userID, this.name, this.position, this.company, this.userType});
}

class Company{
  final company;
  final employees;
  final address;

  Company({this.company, this.employees, this.address});
}


class Traced{
  final traceID;
  final name;
  final company;
  final timestamp;

  Traced({this.traceID, this.name, this.company, this.timestamp});
}