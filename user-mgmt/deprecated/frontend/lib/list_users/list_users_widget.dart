import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/user.dart';

enum UserMenu { update, deactivate, delete, activate }

class ListUsersWidget extends StatefulWidget {
  const ListUsersWidget({Key? key}) : super(key: key);

  @override
  ListUsersWidgetState createState() => ListUsersWidgetState();
}

class ListUsersWidgetState extends State<ListUsersWidget> {
  final String userManagementApiEndpoint = 'user-mgmt-api:5000';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<User>?> futureUsers;
  late List<User>? userList;
  var logger = Logger();

  Future<List<User>?> fetchUsers() async {
    final response = await http.get(
      Uri.parse('$userManagementApiEndpoint/users'),
      headers: {},
    );
    if (response.statusCode == 200) {
      final List responseArray = jsonDecode(response.body);
      for (var user in responseArray) {
        userList?.add(User.fromJson(user));
      }
      return userList;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user list');
    }
  }

  Future<String> deactivateUser(String userSunetId) async {
    final response = await http.post(
      Uri.parse('$userManagementApiEndpoint/deactivate/user/$userSunetId'),
    );
    if (response.statusCode == 200) {
      return 'SUCCESS';
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to deactivate user $userSunetId');
    }
  }

  Color getStatusColor(String? userStatus) {
    switch (userStatus) {
      case 'ACTIVE':
        {
          return const Color(0xFF309503);
        }
      case 'PENDING':
        {
          return const Color(0xFFC9B20C);
        }
      case 'DEACTIVATED':
        {
          return const Color(0xFF8C1514);
        }
      default:
        {
          return Colors.grey;
        }
    }
  }

  @override
  void initState() {
    super.initState();
    userList = [];
    futureUsers = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF8C1514),
        automaticallyImplyLeading: false,
        leadingWidth: 140.0,
        leading: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
          child: Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Image.asset(
              'assets/images/Stanford-Logo-White.png',
              width: 140,
              height: 60,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        titleSpacing: 10.0,
        title: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
          child: Text(
            'Carina User Management',
            textAlign: TextAlign.start,
            style: GoogleFonts.sourceSansPro(
                textStyle: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 28,
            )),
          ),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFFEEEEEE),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEEEEE),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color: const Color(0xFFFFFFFF),
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFFFFF),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20, 0, 20, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'User Status',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.sourceSansPro(
                                            textStyle: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 16,
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(10, 0, 0, 0),
                                          child: Text(
                                            'User Information',
                                            style: GoogleFonts.sourceSansPro(
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'User Options',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.sourceSansPro(
                                            textStyle: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  4, 10, 10, 4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFFFFF),
                              ),
                              child: FutureBuilder(
                                future: futureUsers,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    userList = snapshot.data as List<User>?;
                                    return ListView.builder(
                                      itemCount: userList?.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(20, 7, 20, 7),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFFFFF),
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 2,
                                                  color: Color(0xE4646363),
                                                  spreadRadius: 1,
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFFFFFFFF),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(0),
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(0),
                                                      ),
                                                    ),
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                          Icons.circle),
                                                      mouseCursor:
                                                          SystemMouseCursors
                                                              .basic,
                                                      color: getStatusColor(
                                                          userList![index]
                                                              .userStatus),
                                                      iconSize: 24,
                                                      tooltip: userList![index]
                                                          .userStatus,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 18,
                                                  child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFFFFFFFF),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              18, 0, 0, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                    18,
                                                                    0,
                                                                    0,
                                                                    0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                          0,
                                                                          10,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    '${userList![index].userFirstName} ${userList![index].userLastName}',
                                                                    style: GoogleFonts
                                                                        .sourceSansPro(
                                                                      textStyle:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            18.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: Color(
                                                                            0xFF2E2D28),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'SUNET ID: ${userList![index].userSunetId}',
                                                                  style: GoogleFonts
                                                                      .sourceSansPro(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          16.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color(
                                                                          0xFF8C1514),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                        0,
                                                                        10,
                                                                        0,
                                                                        0),
                                                                child: Text(
                                                                  'Job ID: ${userList![index].jobId}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: GoogleFonts
                                                                      .sourceSansPro(
                                                                    textStyle:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          18.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color(
                                                                          0xFF2E2D28),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                'Job Time: ${userList![index].jobTime}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: GoogleFonts
                                                                    .sourceSansPro(
                                                                  textStyle:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color(
                                                                        0xFF8C1514),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFFFFFFFF),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(0),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(0),
                                                        topRight:
                                                            Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: PopupMenuButton<
                                                        UserMenu>(
                                                      onSelected: (UserMenu
                                                          item) async {
                                                        if (item.index == 1) {
                                                          String
                                                              deactivateUserSunetId =
                                                              userList![index]
                                                                  .userSunetId;
                                                          String
                                                              deactivateUserResponse =
                                                              await deactivateUser(
                                                                  deactivateUserSunetId);
                                                          await showDialog(
                                                            context: context,
                                                            builder:
                                                                (alertDialogContext) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'User Deactivated'),
                                                                content: const Text(
                                                                    'Carina user deactivation script has started. Please wait a few moments before checking for completion in the Anthos cluster.'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            alertDialogContext),
                                                                    child:
                                                                        const Text(
                                                                            'Ok'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        }
                                                      },
                                                      offset:
                                                          const Offset(0, 40.0),
                                                      child: const Icon(
                                                        Icons.more_vert,
                                                        color: Colors.black,
                                                        size: 30,
                                                      ),
                                                      itemBuilder: (BuildContext
                                                              context) =>
                                                          <
                                                              PopupMenuEntry<
                                                                  UserMenu>>[
                                                        const PopupMenuItem<
                                                            UserMenu>(
                                                          value:
                                                              UserMenu.update,
                                                          child: Text('Update'),
                                                        ),
                                                        (userList![index]
                                                                    .userStatus ==
                                                                'DEACTIVATED')
                                                            ? const PopupMenuItem<
                                                                    UserMenu>(
                                                                value: UserMenu
                                                                    .activate,
                                                                child: Text(
                                                                    'Activate'))
                                                            : const PopupMenuItem<
                                                                    UserMenu>(
                                                                value: UserMenu
                                                                    .deactivate,
                                                                child: Text(
                                                                    'Deactivate')),
                                                        const PopupMenuItem<
                                                            UserMenu>(
                                                          value:
                                                              UserMenu.delete,
                                                          child: Text('Delete'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('${snapshot.error}');
                                  }

                                  // By default, show a loading spinner.
                                  return const Center(
                                      child: CircularProgressIndicator(
                                    color: Color(0xFF8C1514),
                                  ));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
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
