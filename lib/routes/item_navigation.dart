import 'package:flutter/widgets.dart';

import '../models/deal_progress.dart';
import 'route_constants.dart';

/// Opens the item screen on top of the app's root navigator, so Android back
/// returns to the screen that opened it.
Future<void> openItemDetail(BuildContext context, int itemId) {
  return Navigator.of(context, rootNavigator: true).pushNamed(
    itemDetailsScreenRoute,
    arguments: itemId,
  );
}

/// Opens the Deals screen on top of the current screen with [filter] chosen,
/// so back returns to the screen that opened it.
Future<void> openDealsFiltered(BuildContext context, DealFilter filter) {
  return Navigator.of(context, rootNavigator: true).pushNamed(
    dealsScreenRoute,
    arguments: filter,
  );
}
