import 'dart:math' as math;

double percentile(List<double> values, double percent) {
  if (values.isEmpty) throw ArgumentError('No values');
  final sorted = [...values]..sort();
  final index = (sorted.length - 1) * percent / 100;
  final lo = index.floor();
  final hi = index.ceil();
  return sorted[lo] + (sorted[hi] - sorted[lo]) * (index - lo);
}

List<double> medianSmooth(List<double> values, int width) => [
  for (var i = 0; i < values.length; i++)
    percentile(
      values.sublist(
        math.max(0, i - width ~/ 2),
        math.min(values.length, i + width ~/ 2 + 1),
      ),
      50,
    ),
];

double semitones(double hz, double medianHz) =>
    12 * math.log(hz / medianHz) / math.ln2;
