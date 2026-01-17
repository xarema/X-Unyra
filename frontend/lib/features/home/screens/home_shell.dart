import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../goals/goals_page.dart';
import '../../qna/qna_page.dart';
import '../../checkins/checkins_page.dart';
import '../../letters/letters_page.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  final List<Widget> _pages = const [
    GoalsPage(),
    QnaPage(),
    CheckinsPage(),
    LettersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.flag), label: 'Goals'),
          NavigationDestination(icon: Icon(Icons.question_answer), label: 'Q&A'),
          NavigationDestination(icon: Icon(Icons.mood), label: 'Check-in'),
          NavigationDestination(icon: Icon(Icons.mail), label: 'Letter'),
        ],
      ),
    );
  }
}
