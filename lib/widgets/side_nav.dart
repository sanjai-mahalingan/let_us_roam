import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:let_us_roam/pages/initial_view.dart';

class SideNav extends ConsumerStatefulWidget {
  const SideNav({super.key, required this.user});

  final User? user;

  @override
  ConsumerState<SideNav> createState() => _SideNav();
}

class _SideNav extends ConsumerState<SideNav> {
  onLogout() async {
    await FirebaseAuth.instance.signOut();
    ref.read(userSession.notifier).state = null;
    if (mounted) {
      Navigator.popAndPushNamed(context, 'initialView');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerHeader(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 55, 88, 119),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 55, 88, 119),
                spreadRadius: 10,
                blurRadius: 5,
                // offset: Offset(5
                //, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.user != null
                  ? Text(
                      'Hi, ${widget.user!.displayName}',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white),
                    )
                  : const Text('Hi'),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.outlined(
                    onPressed: () {
                      onLogout();
                    },
                    icon: const Icon(Icons.logout_outlined),
                    color: Colors.white,
                  ),
                  IconButton.outlined(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, 'profileView');
                    },
                    icon: const Icon(Icons.account_circle_outlined),
                    color: Colors.white,
                  ),
                ],
              )
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.bookmark_added),
          hoverColor: Colors.amber[600],
          title: Text(
            'My Favorites',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          onTap: () {
            Navigator.popAndPushNamed(context, 'favoriteView');
          },
        ),
        ListTile(
          leading: const Icon(Icons.add),
          title: Text(
            'Create New Trip',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          onTap: () {
            Navigator.popAndPushNamed(context, 'createTripView');
          },
        )
      ],
    );
  }
}
