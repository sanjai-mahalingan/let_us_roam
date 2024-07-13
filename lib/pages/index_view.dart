import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:let_us_roam/pages/initial_view.dart';
import 'package:let_us_roam/widgets/side_nav.dart';

class IndexView extends ConsumerStatefulWidget {
  const IndexView({super.key});

  @override
  ConsumerState<IndexView> createState() => _IndexView();
}

class _IndexView extends ConsumerState<IndexView> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userSession);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Let Us Roam'),
      ),
      drawer: Drawer(
        child: SideNav(
          user: user,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            user != null
                ? Text('Let Us Roam ${user.email}')
                : const Text('Let Us Roam'),
          ],
        ),
      ),
    );
  }
}
