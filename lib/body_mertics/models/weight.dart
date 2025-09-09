class WeightEntry {
  final double value;
  final DateTime createdAt;

  WeightEntry({required this.value, required this.createdAt});

  factory WeightEntry.fromJson(Map<String, dynamic> json) {
    return WeightEntry(
      value: (json['value'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
