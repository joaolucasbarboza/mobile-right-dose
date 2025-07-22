const Map<String, String> uomFrequencyMap = {
  'DAILY': 'dias',
  'HOURLY': 'horas',
};

String formatUomFrequency(String uomFrequency) {
  return uomFrequencyMap[uomFrequency] ?? uomFrequency.toLowerCase();
}

const Map<String, String> dosageUnitMap = {
  'MILLIGRAM': 'mg',
  'MICROGRAM': 'mcg',
  'GRAM': 'g',
  'KILOGRAM': 'kg',
  'MILLILITER': 'ml',
  'LITER': 'L',
  'UNIT': 'unidades',
  'DROP': 'gota(s)',
  'TABLET': 'comprimido(s)',
  'CAPSULE': 'cápsula(s)',
  'TEASPOON': 'colher de chá',
  'TABLESPOON': 'colher de sopa',
  'INHALATION': 'inalação',
  'PATCH': 'adesivo',
  'PUFF': 'borrifada(s)',
  'DOSE': 'dose(s)',
};

String formatDosageUnit(String dosageUnit) {
  return dosageUnitMap[dosageUnit] ?? dosageUnit.toLowerCase();
}