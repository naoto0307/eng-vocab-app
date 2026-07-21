import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/settings/settings_provider.dart';
import '../../word/data/word_repository.dart';
import '../data/study_repository.dart';
import 'widgets/flashcard_card.dart';

class _JudgedEntry {
  _JudgedEntry({
    required this.word,
    required this.logId,
    required this.previousStatus,
    required this.result,
  });

  final Word word;
  final String logId;
  final WordStatus previousStatus;
  final StudyResult result;
}

class StudyScreen extends ConsumerStatefulWidget {
  const StudyScreen({super.key});

  @override
  ConsumerState<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends ConsumerState<StudyScreen> {
  List<Word>? _queue;
  int _index = 0;
  bool _showBack = false;
  String? _sessionId;
  final List<_JudgedEntry> _history = [];
  bool _finished = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final words = await ref.read(wordRepositoryProvider).getStudyableWords();
    final sessionId = await ref.read(studyRepositoryProvider).startSession();
    if (!mounted) return;
    setState(() {
      _queue = words;
      _sessionId = sessionId;
    });
  }

  Future<void> _finishSession() async {
    final total = _queue?.length ?? 0;
    final rememberedCount =
        _history.where((h) => h.result == StudyResult.remembered).length;
    final accuracy = total == 0 ? 0.0 : rememberedCount / total;
    if (_sessionId != null) {
      await ref.read(studyRepositoryProvider).endSession(
            sessionId: _sessionId!,
            wordCount: total,
            accuracy: accuracy,
          );
    }
    if (!mounted) return;
    setState(() => _finished = true);
  }

  Future<void> _judge(Word word, StudyResult result) async {
    if (_sessionId == null || _busy) return;
    setState(() => _busy = true);
    final logId = await ref.read(studyRepositoryProvider).recordResult(
          wordId: word.id,
          sessionId: _sessionId!,
          result: result,
        );
    _history.add(
      _JudgedEntry(
        word: word,
        logId: logId,
        previousStatus: word.status,
        result: result,
      ),
    );
    final next = _index + 1;
    if (!mounted) return;
    setState(() {
      _index = next;
      _showBack = false;
      _busy = false;
    });
    if (next >= (_queue?.length ?? 0)) {
      await _finishSession();
    }
  }

  Future<void> _undo() async {
    if (_history.isEmpty || _busy) return;
    setState(() => _busy = true);
    final last = _history.removeLast();
    await ref.read(studyRepositoryProvider).deleteLog(last.logId);
    await ref.read(wordRepositoryProvider).updateStatus(last.word.id, last.previousStatus);
    if (!mounted) return;
    setState(() {
      _index -= 1;
      _showBack = false;
      _finished = false;
      _busy = false;
    });
  }

  Future<void> _delete(Word word) async {
    await ref.read(wordRepositoryProvider).deleteWord(word.id);
    if (!mounted) return;
    setState(() {
      _queue!.removeAt(_index);
      _showBack = false;
    });
    if (_index >= (_queue?.length ?? 0)) {
      await _finishSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    final queue = _queue;
    return Scaffold(
      appBar: AppBar(
        title: Text(queue == null || _finished
            ? '学習'
            : '学習中 (${_index + 1}/${queue.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: '直前の判定を戻す',
            onPressed: _history.isEmpty ? null : _undo,
          ),
        ],
      ),
      body: _buildBody(queue),
    );
  }

  Widget _buildBody(List<Word>? queue) {
    if (queue == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (queue.isEmpty) {
      return const Center(child: Text('学習できる単語がありません'));
    }
    if (_finished) {
      final rememberedCount =
          _history.where((h) => h.result == StudyResult.remembered).length;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('学習お疲れさまでした！', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text('覚えた: $rememberedCount / ${queue.length}'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ホームに戻る'),
            ),
          ],
        ),
      );
    }

    final word = queue[_index];
    final reversed = ref.watch(settingsProvider).reverseSwipe;
    final startToEndResult = reversed ? StudyResult.notYet : StudyResult.remembered;
    final startToEndLabel = reversed ? 'まだ' : '覚えた';
    final startToEndColor = reversed ? Colors.red.shade400 : Colors.green.shade400;
    final endToStartLabel = reversed ? '覚えた' : 'まだ';
    final endToStartColor = reversed ? Colors.green.shade400 : Colors.red.shade400;

    return Dismissible(
      key: ValueKey(word.id),
      direction: DismissDirection.horizontal,
      dismissThresholds: const {
        DismissDirection.startToEnd: 0.35,
        DismissDirection.endToStart: 0.35,
      },
      background: Container(
        color: startToEndColor,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(startToEndLabel, style: const TextStyle(color: Colors.white, fontSize: 20)),
      ),
      secondaryBackground: Container(
        color: endToStartColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(endToStartLabel, style: const TextStyle(color: Colors.white, fontSize: 20)),
      ),
      confirmDismiss: (_) async => !_busy,
      onDismissed: (direction) {
        final result = direction == DismissDirection.startToEnd
            ? startToEndResult
            : (reversed ? StudyResult.remembered : StudyResult.notYet);
        _judge(word, result);
      },
      child: FlashcardCard(
        word: word,
        showBack: _showBack,
        onTap: () => setState(() => _showBack = !_showBack),
        onDelete: () => _delete(word),
      ),
    );
  }
}
