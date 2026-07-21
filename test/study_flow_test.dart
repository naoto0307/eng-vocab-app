import 'package:drift/native.dart';
import 'package:eng_vocab_app/core/database/app_database.dart';
import 'package:eng_vocab_app/core/settings/settings_provider.dart';
import 'package:eng_vocab_app/features/home/presentation/home_screen.dart';
import 'package:eng_vocab_app/features/word/data/word_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension on WidgetTester {
  /// fl_chartのPieChartが常時アニメーションticker を保持し pumpAndSettle が
  /// タイムアウトするため、固定回数のpumpで安定させる
  Future<void> settle() async {
    for (var i = 0; i < 10; i++) {
      await pump(const Duration(milliseconds: 100));
    }
  }
}

void main() {
  testWidgets(
    '単語追加 → 学習（表裏切替・スワイプ判定） → 進捗反映までの一連の流れ',
    (tester) async {
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(
              AppDatabase.forTesting(NativeDatabase.memory()),
            ),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const MaterialApp(home: HomeScreen()),
        ),
      );
      await tester.settle();

      // 初期状態: 単語0件
      expect(find.text('まだ単語が登録されていません'), findsOneWidget);

      // 単語追加方法選択 → 手動入力
      await tester.tap(find.text('単語を追加'));
      await tester.settle();
      await tester.tap(find.text('手動入力'));
      await tester.settle();

      await tester.enterText(find.byKey(const Key('word_field')), 'apple');
      await tester.enterText(find.byKey(const Key('meaning_field')), 'りんご');
      await tester.enterText(
        find.byKey(const Key('example_en_field')),
        'I ate an apple this morning.',
      );
      await tester.enterText(
        find.byKey(const Key('example_ja_field')),
        '今朝りんごを食べた。',
      );
      await tester.pump();

      await tester.tap(find.text('保存'));
      await tester.settle();

      // ホームに戻り、進捗円グラフに反映される
      expect(find.text('0 / 1 語 (0.0%)'), findsOneWidget);

      // 学習開始
      await tester.tap(find.text('学習を始める'));
      await tester.settle();

      // 表面: 例文のみ表示、意味は非表示
      expect(find.textContaining('I ate an apple'), findsOneWidget);
      expect(find.text('りんご'), findsNothing);

      // タップで裏面へ
      await tester.tap(find.byType(GestureDetector).first);
      await tester.settle();
      expect(find.text('りんご'), findsOneWidget);

      // 右スワイプ = 覚えた
      await tester.drag(find.byType(Dismissible), const Offset(600, 0));
      await tester.settle();

      expect(find.textContaining('学習お疲れさまでした'), findsOneWidget);
      expect(find.textContaining('覚えた: 1 / 1'), findsOneWidget);

      // ホームに戻ると進捗が反映されている
      await tester.tap(find.text('ホームに戻る'));
      await tester.settle();
      expect(find.text('1 / 1 語 (100.0%)'), findsOneWidget);

      // ProviderScope破棄時にdriftのwatchストリームが後始末用Timerを積むため、
      // テスト終了前に明示的に破棄してからflushする
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 50));
    },
  );
}
