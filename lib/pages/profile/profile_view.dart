import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:let_us_roam/pages/initial_view.dart';
import 'package:let_us_roam/pages/models/country_state.dart';
import 'package:let_us_roam/widgets/go_to_home.dart';
import 'package:let_us_roam/widgets/loader.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileView();
}

class _ProfileView extends ConsumerState<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storageRef = FirebaseStorage.instance;
  FilePickerResult? fileResult;
  File? imageFile;
  String? networkImageFile;
  String? existingImageFile;
  String? newImageFile;

  TextEditingController image = TextEditingController();
  TextEditingController displayName = TextEditingController();
  TextEditingController phone1 = TextEditingController();
  TextEditingController phone2 = TextEditingController();
  TextEditingController displayPhoto = TextEditingController();
  TextEditingController addressLine1 = TextEditingController();
  TextEditingController addressLine2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zipCode = TextEditingController();
  String? state;
  String country = 'India';

  void _openFilePicker() async {
    fileResult = await FilePicker.platform.pickFiles();
    if (fileResult != null) {
      setState(() {
        final finalImage = File(fileResult!.files.single.path.toString());
        final bytes = finalImage.readAsBytesSync().lengthInBytes;
        final kb = bytes / 1024;
        if (kb > 150) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Image file should be less than 150kb'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 100,
                  right: 20,
                  left: 20),
            ),
          );
          imageFile = null;
        } else {
          imageFile = File(fileResult!.files.single.path.toString());
        }
      });
    }
  }

  onProfileUpdate() async {
    setState(() {
      isLoading = true;
    });

    final currentUser = ref.watch(userSession);
    if (_formKey.currentState!.validate()) {
      try {
        // Prepare for Image upload and get the image url and assign to the ImageURL
        String? imageURL;
        if (imageFile != null) {
          newImageFile = currentUser!.uid;
          final storageRef_ =
              storageRef.ref().child('profileImages/$newImageFile.jpg');
          UploadTask uploadTask = storageRef_.putFile(imageFile!);
          imageURL = await (await uploadTask).ref.getDownloadURL();
        } else {
          imageURL = null;
        }

        var data = {
          "uid": currentUser!.uid,
          "organizerName": displayName.text,
          "primaryPhone": phone1.text,
          "secondaryPhone": phone2.text,
          "addressLine1": addressLine1.text,
          "addressLine2": addressLine2.text,
          "city": city.text,
          "state": state,
          "zipCode": zipCode.text,
          "country": country
        };
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Some thing went wrong. Try later'),
            ),
          );
        }
        return;
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 55, 88, 119),
        foregroundColor: Colors.white,
        title: Text(
          'Profile',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
        centerTitle: true,
        actions: const [GoToHome()],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Card(
                child: imageFile != null
                    ? Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Image.file(
                                imageFile!,
                                height: 100,
                                width: 100,
                              ),
                            ),
                            IconButton(
                              splashColor: Colors.amber,
                              splashRadius: 10.0,
                              onPressed: () {
                                setState(() {
                                  imageFile = null;
                                });
                              },
                              icon: const Icon(Icons.clear),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            TextButton.icon(
                              onPressed: _openFilePicker,
                              icon: const Icon(Icons.file_upload),
                              label: const Text('Upload Business Image/Logo'),
                            ),
                            const Text('Image file should be less than 150kb')
                          ],
                        ),
                      ),
              ),
              Form(
                key: _formKey,
                child: Card(
                  shadowColor: Colors.black,
                  surfaceTintColor: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: displayName,
                          decoration: const InputDecoration(
                              labelText: 'Organizer Display Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter name to display";
                            }
                            if (value.isNotEmpty && value.length <= 3) {
                              return "Display name should be more then 3 characters";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: phone1,
                          decoration:
                              const InputDecoration(labelText: 'Primary Phone'),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your phone number";
                            }
                            if (value.isNotEmpty && value.length < 10) {
                              return "Enter valid phone number";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: phone2,
                          decoration: const InputDecoration(
                              labelText: 'Secondary Phone'),
                          keyboardType: TextInputType.phone,
                        ),
                        TextFormField(
                          controller: addressLine1,
                          decoration: const InputDecoration(
                              labelText: "Address Line 1"),
                        ),
                        TextFormField(
                          controller: addressLine2,
                          decoration: const InputDecoration(
                              labelText: "Address Line 2"),
                        ),
                        TextFormField(
                          controller: city,
                          decoration: const InputDecoration(labelText: "City"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Expanded(
                              child: Text(
                                'State',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Expanded(
                              child: DropdownButton(
                                isExpanded: true,
                                value: state,
                                items: indiaStateList.map((value) {
                                  return DropdownMenuItem(
                                      value: value, child: Text(value));
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    state = value;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                        TextFormField(
                          controller: zipCode,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: "ZipCode"),
                          validator: (value) {
                            if (value!.isNotEmpty && value.length < 6) {
                              return "Please enter valid Zip Code";
                            }
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Text(
                                'Country',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Expanded(
                              child: DropdownButton(
                                isExpanded: true,
                                value: country,
                                items: currentCountryList.map((value) {
                                  return DropdownMenuItem(
                                      value: value, child: Text(value));
                                }).toList(),
                                onChanged: null,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        isLoading
                            ? const Loader(size: 28)
                            : OutlinedButton(
                                onPressed: () {
                                  onProfileUpdate();
                                },
                                child: const Text('Update'),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
