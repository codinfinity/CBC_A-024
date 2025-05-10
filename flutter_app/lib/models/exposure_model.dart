class ExposureModel {
  final String uid;
  final String date; // Format: YYYY-MM-DD
  final double uvIndex;
  final double exposureTime; // in minutes or seconds

  ExposureModel({
    required this.uid,
    required this.date,
    required this.uvIndex,
    required this.exposureTime,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'date': date,
    'uvIndex': uvIndex,
    'exposureTime': exposureTime,
  };

  factory ExposureModel.fromMap(Map<String, dynamic> map) => ExposureModel(
    uid: map['uid'],
    date: map['date'],
    uvIndex: (map['uvIndex'] ?? 0).toDouble(),
    exposureTime: (map['exposureTime'] ?? 0).toDouble(),
  );
}
