/// Formatea una fecha y hora a un formato legible
String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (date == today) {
    return "Hoy ${dateTime.hour.toString().padLeft(2, "0")}:${dateTime.minute.toString().padLeft(2, "0")}";
  } else if (date == yesterday) {
    return "Ayer ${dateTime.hour.toString().padLeft(2, "0")}:${dateTime.minute.toString().padLeft(2, "0")}";
  } else {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }
}

/// Trunca una cadena a una longitud máxima
String truncateString(String text, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  }
  return "${text.substring(0, maxLength)}...";
}

/// Valida si una cadena está vacía o es nula
bool isEmptyOrNull(String? text) {
  return text == null || text.trim().isEmpty;
}
