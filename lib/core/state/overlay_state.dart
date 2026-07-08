import 'package:flutter/foundation.dart';

/// Tracks how many bottom sheets (or other overlays) are currently open.
/// Increment when opening, decrement when closing. Nav bar hides when > 0.
final bottomSheetCount = ValueNotifier<int>(0);

/// Bumped whenever events change (created, or a vendor added). Screens showing
/// event lists listen to this and refetch, so the data stays fresh on focus.
final eventsChanged = ValueNotifier<int>(0);
void notifyEventsChanged() => eventsChanged.value++;
