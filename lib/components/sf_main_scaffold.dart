import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_farm/components/sf_dialog.dart';
import 'package:smart_farm/components/sf_toast_notification.dart';
import 'package:smart_farm/data/helper/chat_manager.dart';
import 'package:smart_farm/data/models/message.dart';
import 'package:smart_farm/data/models/user.dart';
import 'package:smart_farm/utils/firebase/user_utils.dart';
import 'package:smart_farm/utils/responsiveness.dart';
import 'package:smart_farm/views/ai/chat_page.dart';
import 'package:smart_farm/views/diagnosis_history/diagnosis_history_page.dart';
import 'package:smart_farm/views/email_verification/email_verification_page.dart';
import 'package:smart_farm/views/home/home_page.dart';
import 'package:smart_farm/views/settings/edit_profile_page.dart';
import 'package:smart_farm/views/settings/settings_page.dart';

import '../utils/colors.dart';

class SFMainScaffold extends StatefulWidget {
  const SFMainScaffold({super.key, this.selectedIndex = 0});

  final int selectedIndex;

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

  ChatManager chatManager = ChatManager();
  var messages = <MessageModel>[];

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
        // home page
        HomePage(
          userData: userData,
        ),
        // AI page
        ChatPage(
          onMessageAdded: () {
            setState(() {
              getMessages();
            });
          },
        ),
        // diagnosis page
        const DiagnosisHistoryPage(),
        // settings page
        SettingsPage(
          userData: userData,
        ),
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
        'AI Chatbot',
        style: TextStyle(fontWeight: FontWeight.w400),
      );
    } else if (_selectedIndex == 2) {
      return const Text(
        'Diagnosis History',
        style: TextStyle(fontWeight: FontWeight.w400),
      );
    } else {
      return const Text(
        'Settings',
        style: TextStyle(fontWeight: FontWeight.w400),
      );
    }
  }

  // reload page
  void reloadPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SFMainScaffold(
          selectedIndex: index,
        ),
      ),
    );
  }

  Future<void> getMessages() async {
    messages = await chatManager.getChats();
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    fetchUserData();
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: title(),
              automaticallyImplyLeading: false,
              floating: true,
              actions: [
                // chat
                if (_selectedIndex == 1 && messages.isNotEmpty)
                  IconButton(
                    onPressed: () => SFDialog.showSFDialog(
                      context: context,
                      title: 'Delete Chat',
                      content: const Text(
                          'Are you sure you want to delete this chat?'),
                      okText: 'CONFIRM',
                      cancelText: 'CANCEL',
                      onOk: () async {
                        Navigator.pop(context);
                        setState(() {
                          chatManager.deleteChats();
                        });
                        reloadPage(1);
                        if (context.mounted) {
                          showToast('Chat deleted', context,
                              status: Status.success);
                        }
                      },
                      onCancel: () => Navigator.pop(context),
                    ),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),

                // edit profile
                if (_selectedIndex == 3)
                  IconButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            userData: userData,
                          ),
                        ),
                      );

                      if (result != null && result) {
                        fetchUserData();
                      }
                    },
                    icon: const Icon(Icons.edit_outlined),
                  ),
              ],
            )
          ];
        },
        body: Row(
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
                      _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
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
                      'AI Chatbot',
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(
                      _selectedIndex == 2
                          ? Icons.analytics
                          : Icons.analytics_outlined,
                    ),
                    label: const Text(
                      'Diagnosis',
                    ),
                  ),
                  NavigationRailDestination(
                    icon: Icon(
                      _selectedIndex == 3
                          ? Icons.settings
                          : Icons.settings_outlined,
                    ),
                    label: const Text(
                      'Settings',
                    ),
                  ),
                ],
              ),
            },

            // detail
            Expanded(
              child: Container(
                alignment:
                    kIsWeb && isLargeScreen(context) ? Alignment.center : null,
                child: SizedBox(
                  width: kIsWeb ? 400 : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 0.0),
                    child: _isLoading
                        ? const Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : _widgetOptions.elementAt(_selectedIndex),
                  ),
                ),
              ),
            ),
          ],
        ),
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
                surfaceTintColor: Theme.of(context).colorScheme.background,
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
                    label: 'AI Chatbot',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      _selectedIndex == 2
                          ? Icons.analytics
                          : Icons.analytics_outlined,
                    ),
                    label: 'Diagnosis',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      _selectedIndex == 3
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
    );
  }
}
