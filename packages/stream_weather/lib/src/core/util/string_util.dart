String formatSeconds(int seconds) {
  final m = (seconds / 60).floor();
  final s = seconds - m * 60;

  String minutesFormatted;
  String secondsFormatted;

  if (m < 10) {
    minutesFormatted = '0$m';
  } else {
    minutesFormatted = m.toString();
  }

  if (s < 10) {
    secondsFormatted = '0$s';
  } else {
    secondsFormatted = s.toString();
  }

  return '$minutesFormatted:$secondsFormatted';
}

List<double> decomposeDouble(double value, [int decimals = 1]) {
  final intPart = value.floor();
  var decPart = value - intPart;
  decPart = double.parse(decPart.toStringAsFixed(decimals));

  if (decPart >= 1.0) {
    decPart = 0.9;
  }

  return [intPart.toDouble(), decPart];
}

String truncateWithEllipsis(String str, int cutoff) {
  return (str.length <= cutoff) ? str : '${str.substring(0, cutoff)}...';
}
