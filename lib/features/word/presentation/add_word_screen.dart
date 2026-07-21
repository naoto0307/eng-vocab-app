import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dictionary_service.dart';
import '../data/word_generation_service.dart';
import '../data/word_repository.dart';

class AddWordScreen extends ConsumerStatefulWidget {
  const AddWordScreen({super.key});

  @override
  ConsumerState<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends ConsumerState<AddWordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _wordController = TextEditingController();
  final _meaningController = TextEditingController();
  final _exampleEnController = TextEditingController();
  final _exampleJaController = TextEditingController();
  final _synonymsController = TextEditingController();
  final _etymologyController = TextEditingController();
  final _tagsController = TextEditingController();
  bool _saving = false;
  bool _generating = false;
  String? _generatedImageUrl;

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    _exampleEnController.dispose();
    _exampleJaController.dispose();
    _synonymsController.dispose();
    _etymologyController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  List<String> _splitList(String raw) => raw
      .split(',')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  Future<void> _generate() async {
    final word = _wordController.text.trim();
    if (word.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('先に単語を入力してください')),
      );
      return;
    }
    setState(() {
      _generating = true;
      _generatedImageUrl = null;
    });
    try {
      final draft = await ref.read(wordGenerationServiceProvider).generate(word);
      _meaningController.text = draft.meaningJa;
      _exampleEnController.text = draft.exampleEn;
      _exampleJaController.text = draft.exampleJa;
      _synonymsController.text = draft.synonyms.join(', ');
      setState(() => _generatedImageUrl = draft.imageUrl);
      if (draft.exampleEn.isEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('例文は自動取得できませんでした。手動で入力してください')),
        );
      }
    } on WordNotFoundException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('「$word」は辞書に見つかりませんでした。手動で入力してください')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('自動生成に失敗しました。しばらくしてから再度お試しください')),
        );
      }
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(wordRepositoryProvider).addWord(
            word: _wordController.text,
            meaning: _meaningController.text.trim(),
            exampleEn: _exampleEnController.text.trim(),
            exampleJa: _exampleJaController.text.trim(),
            synonyms: _splitList(_synonymsController.text),
            etymology: _etymologyController.text.trim().isEmpty
                ? null
                : _etymologyController.text.trim(),
            imageUrl: _generatedImageUrl,
            tags: _splitList(_tagsController.text),
          );
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } on DuplicateWordException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('「${e.word}」は既に登録されています')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('単語を追加')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    key: const Key('word_field'),
                    controller: _wordController,
                    decoration: const InputDecoration(labelText: '単語 *'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? '単語を入力してください' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: FilledButton.tonalIcon(
                    onPressed: _generating ? null : _generate,
                    icon: _generating
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_awesome),
                    label: const Text('自動生成'),
                  ),
                ),
              ],
            ),
            if (_generatedImageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _generatedImageUrl!,
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            ],
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('meaning_field'),
              controller: _meaningController,
              decoration: const InputDecoration(labelText: '意味 *'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '意味を入力してください' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('example_en_field'),
              controller: _exampleEnController,
              decoration: const InputDecoration(labelText: '例文（英語） *'),
              maxLines: 2,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '例文を入力してください' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('example_ja_field'),
              controller: _exampleJaController,
              decoration: const InputDecoration(labelText: '例文の日本語訳 *'),
              maxLines: 2,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '例文の訳を入力してください' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _synonymsController,
              decoration: const InputDecoration(
                labelText: '類語（カンマ区切り、任意）',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _etymologyController,
              decoration: const InputDecoration(labelText: '語源・豆知識（任意）'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'タグ（カンマ区切り、任意）',
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
