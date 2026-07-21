import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/study_record_repository.dart';

const _weekdayLabels = ['日', '月', '火', '水', '木', '金', '土'];

class StudyRecordScreen extends ConsumerStatefulWidget {
  const StudyRecordScreen({super.key});

  @override
  ConsumerState<StudyRecordScreen> createState() => _StudyRecordScreenState();
}

class _StudyRecordScreenState extends ConsumerState<StudyRecordScreen> {
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
  }

  void _changeMonth(int diff) {
    setState(() => _month = DateTime(_month.year, _month.month + diff));
  }

  @override
  Widget build(BuildContext context) {
    final recordsAsync = ref.watch(monthlyStudyRecordsProvider(_month));
    final streakAsync = ref.watch(currentStreakProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('学習記録')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _changeMonth(-1),
                ),
                Text(
                  '${_month.year}年${_month.month}月',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),
            const SizedBox(height: 8),
            recordsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => Padding(
                padding: const EdgeInsets.all(24),
                child: Text('エラー: $err'),
              ),
              data: (records) => _CalendarSection(month: _month, records: records),
            ),
            const SizedBox(height: 16),
            streakAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (streak) => Center(
                child: Text(
                  '連続学習日数: $streak days',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarSection extends StatelessWidget {
  const _CalendarSection({required this.month, required this.records});

  final DateTime month;
  final List<DailyStudyRecord> records;

  @override
  Widget build(BuildContext context) {
    final byDay = {for (final r in records) r.day: r.duration};
    final totalMinutes = records.fold<int>(0, (sum, r) => sum + r.duration.inMinutes);
    final totalHours = totalMinutes ~/ 60;
    final totalRemainMinutes = totalMinutes % 60;
    final maxMinutes = records.isEmpty
        ? 0
        : records.map((r) => r.duration.inMinutes).reduce((a, b) => a > b ? a : b);

    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingEmpty = firstDayOfMonth.weekday % 7;

    final cells = <DateTime?>[
      ...List.filled(leadingEmpty, null),
      for (var d = 1; d <= daysInMonth; d++) DateTime(month.year, month.month, d),
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          '月間合計: $totalHours' 'h$totalRemainMinutes' 'min',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Row(
          children: _weekdayLabels
              .map(
                (w) => Expanded(
                  child: Center(child: Text(w, style: theme.textTheme.labelMedium)),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 4),
        for (var week = 0; week < cells.length ~/ 7; week++)
          Row(
            children: List.generate(7, (i) {
              final day = cells[week * 7 + i];
              if (day == null) return const Expanded(child: SizedBox(height: 52));

              final duration = byDay[day];
              final minutes = duration?.inMinutes ?? 0;
              final ratio = maxMinutes == 0 ? 0.0 : (minutes / maxMinutes).clamp(0.0, 1.0);
              final bgColor = minutes > 0
                  ? theme.colorScheme.primary.withValues(alpha: 0.15 + 0.6 * ratio)
                  : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
              final isToday = _isSameDay(day, DateTime.now());

              return Expanded(
                child: Container(
                  height: 52,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday ? Border.all(color: theme.colorScheme.primary) : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${day.day}', style: theme.textTheme.bodySmall),
                      if (minutes > 0)
                        Text(
                          '$minutes' 'min',
                          style: theme.textTheme.labelSmall,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
