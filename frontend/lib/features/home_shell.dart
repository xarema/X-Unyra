import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'feature_screens.dart';
import '../core/providers_v2.dart';

/// App Shell avec navigation bottom
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _selectedIndex = 0;

  final List<({String label, IconData icon, Widget screen})> _screens = [
    (
      label: 'Q&A',
      icon: Icons.help,
      screen: const QnaScreen(),
    ),
    (
      label: 'Objectifs',
      icon: Icons.flag,
      screen: const GoalsScreen(),
    ),
    (
      label: 'Check-in',
      icon: Icons.favorite,
      screen: const CheckInsScreen(),
    ),
    (
      label: 'Lettres',
      icon: Icons.mail,
      screen: const LettersScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_selectedIndex].label),
        actions: [
          user.when(
            data: (userData) {
              if (userData == null) return SizedBox.shrink();
              return PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Se déconnecter'),
                    onTap: () async {
                      await ref.read(authNotifierProvider.notifier).logout();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    },
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    child: Text(
                      userData.username[0].toUpperCase(),
                    ),
                  ),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: _screens[_selectedIndex].screen,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: _screens
            .map(
              (s) => BottomNavigationBarItem(
                icon: Icon(s.icon),
                label: s.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
