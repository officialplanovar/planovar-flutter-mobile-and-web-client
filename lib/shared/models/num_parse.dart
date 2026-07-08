/// Parses a JSON value into a double, tolerating both numbers and strings.
/// Prisma `Decimal` fields serialize to STRINGS in JSON (e.g. "85000"), so
/// `as num` would throw or null out — use these helpers for money/amount fields.
double numToDouble(dynamic v, [double fallback = 0]) {
  if (v == null) return fallback;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? fallback;
}

double? numToDoubleOrNull(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}
