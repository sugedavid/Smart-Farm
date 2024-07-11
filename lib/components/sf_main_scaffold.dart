import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_farm/data/models/user.dart';
import 'package:smart_farm/utils/firebase/user_utils.dart';
import 'package:smart_farm/utils/responsiveness.dart';
import 'package:smart_farm/views/email_verification/email_verification_page.dart';
import 'package:smart_farm/views/home/home_page.dart';
import 'package:smart_farm/views/settings/settings_page.dart';

import '../utils/colors.dart';

class SFMainScaffold extends StatefulWidget {
  const SFMainScaffold({super.key});

  @override
  State<SFMainScaffold> createState() => _SFMainScaffoldState();
}

class _SFMainScaffoldState extends State<SFMainScaffold> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = [];

  NavigationRailLabelType labelType = NavigationRailLabelType.all;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  UserModel userData = UserModel.toEmpty();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // fetch user data
  void fetchUserData() async {
    toggleLoading();
    UserModel fetchedUserData = await authUserInfo(context);
    User? user = authUser();
    setState(() {
      userData = fetchedUserData;

      if (!(user?.emailVerified ?? false)) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => EmailVerificationPage(
                userModel: userData,
              ),
            ),
            (route) => false);
      }
      _widgetOptions = <Widget>[
        HomePage(
          userData: userData,
        ),
        HomePage(
          userData: userData,
        ),
        SettingsPage(
          userData: userData,
        ),
        // TransactionsPage(
        //   userData: userData,
        //   bankAccounts: bankAccounts,
        // ),
        // ProfilePage(
        //   userData: userData,
        // ),
      ];
    });
    toggleLoading();
  }

  // toggle loading
  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Widget title() {
    if (_selectedIndex == 0) {
      return const Text(
        'Home',
        style: TextStyle(fontWeight: FontWeight.w400),
      );
    } else if (_selectedIndex == 1) {
      return const Text(
        'Diagnosis',
        style: TextStyle(fontWeight: FontWeight.w400),
      );
    } else {
      return const Text(
        'Settings',
        style: TextStyle(fontWeight: FontWeight.w400),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: title(),
        actions: [
          // edit profile
          if (_selectedIndex == 2)
            IconButton(
              onPressed: () async {
                // final result = await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => EditProfilePage(
                //       userData: userData,
                //     ),
                //   ),
                // );

                // if (result != null && result) {
                //   fetchUserData();
                // }
              },
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
      body: _isLoading
          ? const LinearProgressIndicator(
              color: AppColors.primaryColor,
            )
          : Row(
              children: [
                // master
                if (kIsWeb && isLargeScreen(context)) ...{
                  NavigationRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (int index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      labelType: NavigationRailLabelType.all,
                      destinations: <NavigationRailDestination>[
                        NavigationRailDestination(
                          icon: Icon(
                            _selectedIndex == 0
                                ? Icons.home
                                : Icons.home_outlined,
                          ),
                          label: const Text(
                            'Home',
                          ),
                        ),
                        NavigationRailDestination(
                          icon: Icon(
                            _selectedIndex == 1
                                ? Icons.auto_awesome
                                : Icons.auto_awesome_outlined,
                          ),
                          label: const Text(
                            'Diagnosis',
                          ),
                        ),
                        NavigationRailDestination(
                          icon: Icon(
                            _selectedIndex == 2
                                ? Icons.settings
                                : Icons.settings_outlined,
                          ),
                          label: const Text(
                            'Settings',
                          ),
                        ),
                      ]),
                },

                // detail
                Expanded(
                  child: Container(
                    alignment: kIsWeb && isLargeScreen(context)
                        ? Alignment.center
                        : null,
                    child: SizedBox(
                      width: kIsWeb ? 400 : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 20.0),
                        child: _widgetOptions.elementAt(_selectedIndex),
                      ),
                    ),
                  ),
                ),
              ],
            ),

      // bottom nav bar
      bottomNavigationBar: kIsWeb && isLargeScreen(context)
          ? null
          : NavigationBarTheme(
              data: NavigationBarThemeData(
                labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                  (states) {
                    // Define the text style for different states
                    return TextStyle(
                        fontSize: 13,
                        fontWeight: states.contains(MaterialState.selected)
                            ? FontWeight.w600
                            : FontWeight.w400);
                  },
                ),
              ),
              child: NavigationBar(
                surfaceTintColor: Theme.of(context).colorScheme.surface,
                destinations: <Widget>[
                  NavigationDestination(
                    icon: Icon(
                      _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                    ),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      _selectedIndex == 1
                          ? Icons.auto_awesome
                          : Icons.auto_awesome_outlined,
                    ),
                    label: 'Diagnosis',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      _selectedIndex == 2
                          ? Icons.settings
                          : Icons.settings_outlined,
                    ),
                    label: 'Settings',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onItemTapped,
              ),
            ),

      // floating too
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.camera_alt_rounded),
      ),
    );
  }
}
