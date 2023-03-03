PVector[] loadOutline(String path) {
  var lines = loadStrings(path);
  var v = new PVector[lines.length];
  for (var i = 0; i < v.length; i++) {
    var units = splitTokens(lines[i], ", ");
    v[i] = new PVector(float(units[0]), float(units[1]));
  }
  return v;
}
