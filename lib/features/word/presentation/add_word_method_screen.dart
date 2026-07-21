import 'package:flutter/material.dart';

import '../../scan/presentation/scan_screen.dart';
import 'add_word_screen.dart';

class AddWordMethodScreen extends StatelessWidget {
  const AddWordMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('単語を追加')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddWordScreen()),
                ),
                icon: const Icon(Icons.edit),
                label: const Text('手動入力'),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ScanScreen()),
                ),
                icon: const Icon(Icons.document_scanner),
                label: const Text('マーカースキャン'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
