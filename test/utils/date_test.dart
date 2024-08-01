import 'package:flutter_test/flutter_test.dart';
import 'package:smart_farm/utils/date.dart';

void main() {
  final fixedCurrentDate = DateTime(2024, 8, 1, 12, 30);

  test('formats date for today correctly', () {
    const dateString = '2024-08-01T08:30:00'; // August 1, 2024, 08:30 AM
    final formattedDate =
        formatDateString(dateString, currentDate: fixedCurrentDate);
    expect(formattedDate, '08:30 AM');
  });

  test('formats date for current year but not today correctly', () {
    const dateString = '2024-07-15T09:15:00'; // July 15, 2024, 09:15 AM
    final formattedDate =
        formatDateString(dateString, currentDate: fixedCurrentDate);
    expect(formattedDate, '15th Jul at 09:15 AM');
  });

  test('formats date for previous year correctly', () {
    const dateString = '2023-12-25T14:45:00'; // December 25, 2023, 02:45 PM
    final formattedDate =
        formatDateString(dateString, currentDate: fixedCurrentDate);
    expect(formattedDate, '25th Dec 2023 at 02:45 PM');
  });

  test('handles edge cases for ordinal suffix correctly', () {
    expect(getOrdinalSuffix(1), 'st');
    expect(getOrdinalSuffix(2), 'nd');
    expect(getOrdinalSuffix(3), 'rd');
    expect(getOrdinalSuffix(4), 'th');
    expect(getOrdinalSuffix(11), 'th');
    expect(getOrdinalSuffix(12), 'th');
    expect(getOrdinalSuffix(13), 'th');
    expect(getOrdinalSuffix(21), 'st');
    expect(getOrdinalSuffix(22), 'nd');
    expect(getOrdinalSuffix(23), 'rd');
  });
}
