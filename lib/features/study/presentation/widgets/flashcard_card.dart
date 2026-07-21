import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/tts/tts_provider.dart';

/// 例文中の対象単語を色分け強調して表示する
List<InlineSpan> highlightWord({
  required String example,
  required String word,
  required TextStyle base,
  required TextStyle highlight,
}) {
  if (word.trim().isEmpty) return [TextSpan(text: example, style: base)];
  final pattern = RegExp(RegExp.escape(word.trim()), caseSensitive: false);
  final spans = <InlineSpan>[];
  var cursor = 0;
  for (final match in pattern.allMatches(example)) {
    if (match.start > cursor) {
      spans.add(TextSpan(text: example.substring(cursor, match.start), style: base));
    }
    spans.add(TextSpan(text: example.substring(match.start, match.end), style: highlight));
    cursor = match.end;
  }
  if (cursor < example.length) {
    spans.add(TextSpan(text: example.substring(cursor), style: base));
  }
  return spans;
}

class FlashcardCard extends ConsumerWidget {
  const FlashcardCard({
    super.key,
    required this.word,
    required this.showBack,
    required this.onTap,
    required this.onDelete,
  });

  final Word word;
  final bool showBack;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.headlineSmall ?? const TextStyle(fontSize: 22);
    final highlightStyle = baseStyle.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showBack && word.imageUrl != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      word.imageUrl!,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Text.rich(
                  TextSpan(
                    children: highlightWord(
                      example: word.exampleEn,
                      word: word.word,
                      base: baseStyle.copyWith(color: theme.colorScheme.onSurface),
                      highlight: highlightStyle,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  tooltip: '例文を読み上げる',
                  onPressed: () => ref.read(ttsProvider).speak(word.exampleEn),
                ),
                if (showBack) ...[
                  const Divider(height: 32),
                  Text(word.exampleJa, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        word.word,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        tooltip: '単語を読み上げる',
                        onPressed: () => ref.read(ttsProvider).speak(word.word),
                      ),
                    ],
                  ),
                  Text(word.meaning, style: theme.textTheme.bodyLarge),
                  if (word.synonyms.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text('類語: ${word.synonyms.join(", ")}', style: theme.textTheme.bodyMedium),
                  ],
                  if (word.etymology != null && word.etymology!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text('語源: ${word.etymology}', style: theme.textTheme.bodyMedium),
                  ],
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                      label: Text('削除', style: TextStyle(color: theme.colorScheme.error)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
