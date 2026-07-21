import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_service.dart';
import '../../../core/sync/sync_service.dart';
import '../../home/presentation/home_screen.dart';
import 'login_screen.dart';

/// ログイン状態に応じてLoginScreen/HomeScreenを出し分け、
/// サインイン直後に一度だけクラウドとの同期を行う
class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool _syncing = false;

  Future<void> _runInitialSync() async {
    final sync = ref.read(syncServiceProvider);
    if (sync == null) return;
    setState(() => _syncing = true);
    try {
      await sync.syncAll();
    } catch (_) {
      // オフライン等で失敗しても致命的ではないため、ログインは維持したまま黙って続行する
    } finally {
      if (mounted) setState(() => _syncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<User?>>(authStateProvider, (previous, next) {
      final wasSignedOut = previous?.value == null;
      final isSignedIn = next.value != null;
      if (wasSignedOut && isSignedIn) {
        _runInitialSync();
      }
    });

    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('エラー: $err'))),
      data: (user) {
        if (user == null) return const LoginScreen();
        if (_syncing) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('データを同期中...'),
                ],
              ),
            ),
          );
        }
        return const HomeScreen();
      },
    );
  }
}
