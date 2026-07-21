import 'package:drift/native.dart';
import 'package:eng_vocab_app/core/database/app_database.dart';
import 'package:eng_vocab_app/features/word/data/word_generation_service.dart';
import 'package:eng_vocab_app/features/word/data/word_repository.dart';
import 'package:eng_vocab_app/features/word/presentation/add_word_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeWordGenerationService implements WordGenerationService {
  @override
  Future<GeneratedWordDraft> generate(String word) async {
    return GeneratedWordDraft(
      meaningJa: '幸せな',
      exampleEn: 'She is happy.',
      exampleJa: '彼女は幸せです。',
      synonyms: const ['glad', 'joyful'],
      imageUrl: null,
    );
  }
}

void main() {
  testWidgets('自動生成ボタンでフォームが自動入力される', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(
            AppDatabase.forTesting(NativeDatabase.memory()),
          ),
          wordGenerationServiceProvider.overrideWithValue(_FakeWordGenerationService()),
        ],
        child: const MaterialApp(home: AddWordScreen()),
      ),
    );
    await tester.pump();

    await tester.enterText(find.byKey(const Key('word_field')), 'happy');
    await tester.tap(find.text('自動生成'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('幸せな'), findsOneWidget);
    expect(find.text('She is happy.'), findsOneWidget);
    expect(find.text('彼女は幸せです。'), findsOneWidget);
    expect(find.text('glad, joyful'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 50));
  });
}
