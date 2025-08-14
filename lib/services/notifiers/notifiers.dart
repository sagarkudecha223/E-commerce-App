import 'dart:async';
import 'package:injectable/injectable.dart';

import '../../core/enum.dart';

@singleton
class ValueNotifiers {
  final foodMenuStreamer = StreamController<FoodMenuOptions>.broadcast();
}
