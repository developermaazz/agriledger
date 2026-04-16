DateTime startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime endOfDay(DateTime d) =>
    DateTime(d.year, d.month, d.day, 23, 59, 59, 999);

bool isInRange(DateTime d, DateTime from, DateTime to) {
  return !d.isBefore(from) && !d.isAfter(to);
}
