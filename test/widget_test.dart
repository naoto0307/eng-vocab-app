import 'package:drift/native.dart';
import 'package:eng_vocab_app/core/database/app_database.dart';
import 'package:eng_vocab_app/features/home/presentation/home_screen.dart';
import 'package:eng_vocab_app/features/word/data/word_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home screen shows title and add button', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(
            AppDatabase.forTesting(NativeDatabase.memory()),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('英単語帳'), findsOneWidget);
    expect(find.text('単語を追加'), findsOneWidget);

    // driftのwatchストリーム後始末Timerをflushしてから終了する
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });
}
