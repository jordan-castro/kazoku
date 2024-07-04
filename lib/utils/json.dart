typedef JSON = Map<String, dynamic>;

/// For working with JSON
int? toIntOrNull(dynamic value) {
  if (value is String) {
    return int.parse(value);
  }

  if (value is int) {
    return value;
  }

  return null;
}
