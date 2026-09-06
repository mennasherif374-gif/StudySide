import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:study_side/services/firestore_services.dart';

import '../../model/profile_model.dart';

class ProfileViewModel extends ChangeNotifier {
  final FirestoreService firestoreService;

  ProfileViewModel({
    required this.firestoreService,
  });

  ProfileModel _profile = ProfileModel(
    name: 'Student',
    email: '',
  );

  ProfileModel get profile => _profile;

  bool isLoading = true;

  Future<void> loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final data =
      await firestoreService.getUser(user.uid);

      if (data != null) {
        _profile = ProfileModel.fromMap(data);
      } else {
        _profile = ProfileModel(
          name: user.displayName ?? 'Student',
          email: user.email ?? '',
        );
      }
    } catch (e) {
      debugPrint(
        'Profile error: $e',
      );
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await firestoreService.updateUser(
      user.uid,
      {
        'name': name,
      },
    );

    await user.updateDisplayName(name);

    _profile = ProfileModel(
      name: name,
      email: _profile.email,
      role: _profile.role,
      imageUrl: _profile.imageUrl,
    );

    notifyListeners();
  }
}