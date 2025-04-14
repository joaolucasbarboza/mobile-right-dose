class DosagePerUnit {
  double dosageAmount;
  String dosageUnit;

  DosagePerUnit({
    required this.dosageAmount,
    required this.dosageUnit,
  });

  factory DosagePerUnit.fromMap(Map<String, dynamic> map) {
    return DosagePerUnit(
      dosageAmount: (map['dosageAmount'] as num).toDouble(),
      dosageUnit: map['dosageUnit'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dosageAmount': dosageAmount,
      'dosageUnit': dosageUnit,
    };
  }
}
