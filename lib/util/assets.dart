import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset(String assetLocation) {
  return rootBundle.loadString(assetLocation);
}