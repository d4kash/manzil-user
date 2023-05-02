import 'dart:convert';

class RideHIstoryMode {
  final String time_slot;
  final String Date;
  final String vehicle;
  final String dest;
  final String pickup;
  final String payMethod;
  RideHIstoryMode({
    required this.time_slot,
    required this.Date,
    required this.vehicle,
    required this.dest,
    required this.pickup,
    required this.payMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'time_slot': time_slot,
      'Date': Date,
      'vehicle': vehicle,
      'dest': dest,
      'pickup': pickup,
      'payMethod': payMethod,
    };
  }

  factory RideHIstoryMode.fromMap(Map<String, dynamic> map) {
    return RideHIstoryMode(
      time_slot: map['time_slot'],
      Date: map['Date'],
      vehicle: map['vehicle'],
      dest: map['dest'],
      pickup: map['pickup'],
      payMethod: map['payMethod'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RideHIstoryMode.fromJson(String source) =>
      RideHIstoryMode.fromMap(json.decode(source));
}
