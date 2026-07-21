import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_service.dart';
import '../../../core/settings/settings_provider.dart';
import '../../../core/sync/sync_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _syncing = false;

  Future<void> _syncNow() async {
    final sync = ref.read(syncServiceProvider);
    if (sync == null) return;
    setState(() => _syncing = true);
    try {
      await sync.syncAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('同期が完了しました')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('同期に失敗しました: $e')));
      }
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        children: [
          if (user != null) ...[
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text(user.displayName ?? user.email ?? 'ログイン中'),
              subtitle: const Text('クラウド同期が有効です'),
            ),
            ListTile(
              leading: _syncing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.sync),
              title: const Text('今すぐ同期'),
              onTap: _syncing ? null : _syncNow,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('ログアウト'),
              onTap: () => ref.read(authServiceProvider).signOut(),
            ),
            const Divider(),
          ],
          SwitchListTile(
            title: const Text('スキャン確認をスキップ'),
            subtitle: const Text('ONにすると、スキャンした単語をプレビューなしで即登録します'),
            value: settings.skipScanPreview,
            onChanged: notifier.setSkipScanPreview,
          ),
          SwitchListTile(
            title: const Text('スワイプ方向を反転'),
            subtitle: const Text('ONにすると、左=覚えた／右=まだ になります（デフォルトは右=覚えた／左=まだ）'),
            value: settings.reverseSwipe,
            onChanged: notifier.setReverseSwipe,
          ),
        ],
      ),
    );
  }
}
