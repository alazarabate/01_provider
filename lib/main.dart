import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(child: TimerApp()));

/* ---------- 1. 500 ms STREAM ---------- */
Stream<int> tick() async* {
  int i = 0;
  while (true) {
    await Future.delayed(const Duration(milliseconds: 500));
    yield i++;
  }
}

/* ---------- 2. LAST NUMBER ---------- */
final counterProvider = StateProvider<int>((ref) => 0);

/* ---------- 3. PAUSE FLAG ---------- */
final isPausedProvider = StateProvider<bool>((ref) => false);

/* ---------- 4. STREAM PROVIDER ---------- */
final rawStreamProvider = StreamProvider<int>((ref) => tick());

/* ---------- UI ---------- */
class TimerApp extends StatelessWidget {
  const TimerApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(home: TimerPage());
}

class TimerPage extends ConsumerWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // listen to the stream but IGNORE values while paused
    ref.listen(rawStreamProvider, (previous, next) {
      next.whenData((n) {
        if (!ref.read(isPausedProvider)) {   // <-- soft pause
          ref.read(counterProvider.notifier).state = n;
        }
      });
    });

    final count = ref.watch(counterProvider);
    final isPaused = ref.watch(isPausedProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Stream Pause/Resume')),
      body: Center(
        child: Text('$count', style: const TextStyle(fontSize: 72)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(isPausedProvider.notifier).state = !isPaused,
        child: Icon(isPaused ? Icons.play_arrow : Icons.pause),
      ),
    );
  }
}