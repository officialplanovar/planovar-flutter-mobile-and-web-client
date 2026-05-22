import 'package:flutter/foundation.dart';

/// Tracks how many bottom sheets (or other overlays) are currently open.
/// Increment when opening, decrement when closing. Nav bar hides when > 0.
final bottomSheetCount = ValueNotifier<int>(0);
