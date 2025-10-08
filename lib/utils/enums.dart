const Map<String, String> dosageUnitsMap = {
  'Miligrama': 'MILLIGRAM',
  'Micrograma': 'MICROGRAM',
  'Grama': 'GRAM',
  'Quilograma': 'KILOGRAM',
  'Mililitro': 'MILLILITER',
  'Litro': 'LITER',
  'Unidade': 'UNIT',
  'Gota': 'DROP',
  'Comprimido': 'TABLET',
  'Cápsula': 'CAPSULE',
  'Colher de chá': 'TEASPOON',
  'Colher de sopa': 'TABLESPOON',
  'Inalação': 'INHALATION',
  'Adesivo': 'PATCH',
  'Borrifada': 'PUFF',
  'Dose': 'DOSE',
};

String getDosageUnitLabel(String? unit) {
  if (unit == null) return "-";
  return dosageUnitsMap.entries.firstWhere((entry) => entry.value == unit, orElse: () => const MapEntry("-", "-")).key;
}

const Map<String, String> uomFrequencyMap = {
  'DAILY': 'dia(s)',
  'HOURLY': 'hora(s)',
};

String getUomFrequencyLabel(String? uom) {
  if (uom == null) return "-";
  return uomFrequencyMap.entries.firstWhere((entry) => entry.key == uom, orElse: () => const MapEntry("-", "-")).value;
}