import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kSkipScanPreview = 'skip_scan_preview';
const _kReverseSwipe = 'reverse_swipe';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main()');
});

class SettingsState {
  const SettingsState({
    this.skipScanPreview = false,
    this.reverseSwipe = false,
  });

  /// ON: スキャン後のプレビュー確認をスキップして即登録する
  final bool skipScanPreview;

  /// ON: スワイプ方向を反転する（デフォルトは右=覚えた/左=まだ）
  final bool reverseSwipe;

  SettingsState copyWith({bool? skipScanPreview, bool? reverseSwipe}) {
    return SettingsState(
      skipScanPreview: skipScanPreview ?? this.skipScanPreview,
      reverseSwipe: reverseSwipe ?? this.reverseSwipe,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  late final SharedPreferences _prefs;

  @override
  SettingsState build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    return SettingsState(
      skipScanPreview: _prefs.getBool(_kSkipScanPreview) ?? false,
      reverseSwipe: _prefs.getBool(_kReverseSwipe) ?? false,
    );
  }

  Future<void> setSkipScanPreview(bool value) async {
    await _prefs.setBool(_kSkipScanPreview, value);
    state = state.copyWith(skipScanPreview: value);
  }

  Future<void> setReverseSwipe(bool value) async {
    await _prefs.setBool(_kReverseSwipe, value);
    state = state.copyWith(reverseSwipe: value);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
