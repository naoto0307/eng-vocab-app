import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../word/data/word_generation_service.dart';
import '../../word/data/word_repository.dart';
import '../data/scan_service.dart';

class ScanPreviewScreen extends ConsumerStatefulWidget {
  const ScanPreviewScreen({super.key, required this.candidates});

  final List<ScanCandidate> candidates;

  @override
  ConsumerState<ScanPreviewScreen> createState() => _ScanPreviewScreenState();
}

class _ScanPreviewScreenState extends ConsumerState<ScanPreviewScreen> {
  late final List<bool> _included;
  late final List<TextEditingController> _controllers;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _included = widget.candidates.map((c) => !c.isDuplicate).toList();
    _controllers = widget.candidates.map((c) => TextEditingController(text: c.text)).toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _register() async {
    setState(() => _saving = true);
    final repo = ref.read(wordRepositoryProvider);
    final generator = ref.read(wordGenerationServiceProvider);
    var added = 0;

    for (var i = 0; i < widget.candidates.length; i++) {
      if (!_included[i]) continue;
      final text = _controllers[i].text.trim();
      if (text.isEmpty) continue;
      final needsReview = widget.candidates[i].needsReview;

      var meaning = '';
      var exampleEn = '';
      var exampleJa = '';
      var synonyms = const <String>[];
      String? imageUrl;

      if (!needsReview) {
        try {
          final draft = await generator.generate(text);
          meaning = draft.meaningJa;
          exampleEn = draft.exampleEn;
          exampleJa = draft.exampleJa;
          synonyms = draft.synonyms;
          imageUrl = draft.imageUrl;
        } catch (_) {
          // 自動生成に失敗しても登録は続行し、空欄のまま後で編集してもらう
        }
      }

      try {
        await repo.addWord(
          word: text,
          meaning: meaning,
          exampleEn: exampleEn,
          exampleJa: exampleJa,
          synonyms: synonyms,
          imageUrl: imageUrl,
          source: WordSource.markerScan,
          status: needsReview ? WordStatus.pendingReview : WordStatus.unstudied,
        );
        added++;
      } on DuplicateWordException {
        // 登録処理中に他の候補と重複した場合はスキップ
      }
    }

    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$added 件の単語を追加しました')),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('スキャン結果 (${widget.candidates.length}件)')),
      body: ListView.builder(
        itemCount: widget.candidates.length,
        itemBuilder: (context, i) {
          final c = widget.candidates[i];
          return CheckboxListTile(
            value: _included[i],
            onChanged: c.isDuplicate ? null : (v) => setState(() => _included[i] = v ?? false),
            title: TextField(
              controller: _controllers[i],
              enabled: !c.isDuplicate,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
            subtitle: Wrap(
              spacing: 8,
              children: [
                if (c.isDuplicate) const Chip(label: Text('登録済み')),
                if (c.needsReview) const Chip(label: Text('要確認')),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _saving ? null : _register,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('登録'),
          ),
        ),
      ),
    );
  }
}
