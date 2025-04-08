import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
  // This widget is the root of your application.

}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carina User Management',
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      home: const NavBarPage(initialPage: 'AddUsers'),
    );
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({Key? key, required this.initialPage}) : super(key: key);

  final String? initialPage;

  @override
  NavBarPageState createState() => NavBarPageState();
}

class NavBarPageState extends State<NavBarPage> {
  String _currentPage = 'AddUsers';

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage ?? _currentPage;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'AddUsers': const AddUsersWidget(),
      'ListUsers': const ListUsersWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPage);
    return Scaffold(
      body: tabs[_currentPage],
      extendBody: true,
      bottomNavigationBar: FloatingNavbar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => _currentPage = tabs.keys.toList()[i]),
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0x00000000),
        unselectedItemColor: const Color(0x00000000),
        selectedBackgroundColor: const Color(0x00000000),
        borderRadius: 8,
        itemBorderRadius: 8,
        margin: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        width: double.infinity,
        elevation: 0,
        items: [
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.group_add,
                  color:
                      currentIndex == 0 ? Color(0xFF8C1514) : Color(0xFF2E2D28),
                  size: 24,
                ),
                Text(
                  'Add New Users',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: currentIndex == 0
                        ? const Color(0xFF8C1514)
                        : const Color(0xFF2E2D28),
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.list,
                  color:
                      currentIndex == 1 ? Color(0xFF8C1514) : Color(0xFF2E2D28),
                  size: 24,
                ),
                Text(
                  'View All Users',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: currentIndex == 1
                        ? const Color(0xFF8C1514)
                        : const Color(0xFF2E2D28),
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
