import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../record/presentation/study_record_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../study/presentation/study_screen.dart';
import '../../word/data/word_repository.dart';
import '../../word/presentation/add_word_method_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsAsync = ref.watch(wordListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('英単語帳'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: '学習記録',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const StudyRecordScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: '設定',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: wordsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('エラー: $err')),
        data: (words) => _HomeBody(words: words),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddWordMethodScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('単語を追加'),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({required this.words});

  final List<Word> words;

  @override
  Widget build(BuildContext context) {
    final total = words.length;
    final remembered = words.where((w) => w.status == WordStatus.remembered).length;
    final notYet = words.where((w) => w.status == WordStatus.notYet).length;
    final unstudied = words.where((w) => w.status == WordStatus.unstudied).length;
    final percent = total == 0 ? 0.0 : remembered / total * 100;

    return Column(
      children: [
        const SizedBox(height: 24),
        SizedBox(
          height: 220,
          child: total == 0
              ? const Center(child: Text('まだ単語が登録されていません'))
              : PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 48,
                    sections: [
                      PieChartSectionData(
                        value: remembered.toDouble(),
                        color: Colors.green.shade400,
                        title: remembered > 0 ? '$remembered' : '',
                        radius: 60,
                      ),
                      PieChartSectionData(
                        value: notYet.toDouble(),
                        color: Colors.orange.shade400,
                        title: notYet > 0 ? '$notYet' : '',
                        radius: 60,
                      ),
                      PieChartSectionData(
                        value: unstudied.toDouble(),
                        color: Colors.grey.shade400,
                        title: unstudied > 0 ? '$unstudied' : '',
                        radius: 60,
                      ),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          children: [
            _Legend(color: Colors.green.shade400, label: '覚えた'),
            _Legend(color: Colors.orange.shade400, label: 'まだ'),
            _Legend(color: Colors.grey.shade400, label: '未学習'),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          '$remembered / $total 語 (${percent.toStringAsFixed(1)}%)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: total == 0
              ? null
              : () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const StudyScreen()),
                  ),
          icon: const Icon(Icons.school),
          label: const Text('学習を始める'),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
