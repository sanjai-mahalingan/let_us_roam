import 'package:cloud_firestore/cloud_firestore.dart';
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
  FirebaseFirestore storage_ref = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final argument = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final arg_value = argument["newUser"];
    if (arg_value != null && arg_value == true) {
      final currentUser = ref.watch(userSession);
      var profileData = {
        "uid": currentUser!.uid,
        "imageURL": '',
        "displayName": '',
        "primaryPhone": '',
        "secondaryPhone": '',
        "addressLine1": '',
        "addressLine2": '',
        "city": '',
        "state": '',
        "zipCode": '',
        "country": '',
        "createdOn": DateTime.now()
      };
      await storage_ref
          .collection('profiles')
          .doc(currentUser!.uid)
          .set(profileData);
    }
  }

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
