import 'package:flutter_riverpod/legacy.dart';

/// Currently selected bottom-tab index for [HomeScreen].
///
/// Lifted out of local widget state so overlays (e.g. the home quick-menu
/// sheet) can switch tabs — for example, "All settings" jumps to the last tab.
///
/// Tab order: 0 Home · 1 Assistant · 2 Tools · 3 Market · 4 Settings.
final homeTabIndexProvider = StateProvider<int>((ref) => 0);

/// Index of the Settings tab, referenced by the quick-menu shortcut.
const int kSettingsTabIndex = 4;
