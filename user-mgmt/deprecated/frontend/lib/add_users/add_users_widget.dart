import 'dart:convert';
import 'dart:developer';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../flutter_flow/flutter_flow_widgets.dart';
import '../models/user.dart';
import '../models/user_membership.dart';

class AddUsersWidget extends StatefulWidget {
  const AddUsersWidget({
    Key? key,
    this.newUsers,
  }) : super(key: key);

  final dynamic newUsers;

  @override
  AddUsersWidgetState createState() => AddUsersWidgetState();
}

class AddUsersWidgetState extends State<AddUsersWidget> {
  final String userManagementApiEndpoint = 'user-mgmt-api:5000';
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController userSunetIdTextController = TextEditingController();
  TextEditingController userFirstNameTextController = TextEditingController();
  TextEditingController userLastNameTextController = TextEditingController();
  TextEditingController piSunetIdTextController = TextEditingController();
  List<UserMembership> jobRoster = [];
  int maxUsers = 10;
  var logger = Logger();

  Future<String> addUsers(List<UserMembership> newUserMemberships) async {
    Map<String, dynamic> newUserRequest = {'users': newUserMemberships};
    final response = await http.post(
      Uri.parse('$userManagementApiEndpoint/create'),
      headers: {'Content-type': 'application/json'},
      body: jsonEncode(newUserRequest),
    );
    if (response.statusCode == 200) {
      return 'SUCCESS';
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to submit user list');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Color getPrimaryColor(Set<MaterialState> states) {
    return const Color(0xFF8C1514);
  }

  Color getSecondaryColor(Set<MaterialState> states) {
    return const Color(0xFF2E2D28);
  }

  TextStyle getButtonTextStyle(Set<MaterialState> states) {
    return GoogleFonts.sourceSansPro(
        color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w600);
  }

  Size getButtonSize(Set<MaterialState> states) {
    return const Size(240.0, 40.0);
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
            style:
                GoogleFonts.sourceSansPro(color: Colors.white, fontSize: 28.0),
          ),
        ),
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFFEEEEEE),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEEEEE),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
                          child: Container(
                            width: 100,
                            height: MediaQuery.of(context).size.height * 1,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEEEEEE),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20, 20, 20, 20),
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: const Color(0xFFFFFFFF),
                                elevation: 12,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Form(
                                  key: formKey,
                                  autovalidateMode: AutovalidateMode.disabled,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            40, 20, 40, 0),
                                        child: Text(
                                          'Carina User Membership | Task',
                                          style: TextStyle(
                                              color: Color(0xFF2E2D28),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 24.0,
                                              fontFamily: 'Source Sans Pro'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFFFFFFF),
                                          ),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          40, 4, 40, 0),
                                                  child: Text(
                                                    'Please enter the Carina user\'s SUNET ID, first name and last name and the SUNET ID of the PI that the user will work with. \n Click "Add User Membership" to move the user task to the Job Roster on the right. Currently each job has a limit of ${maxUsers} tasks.',
                                                    style: GoogleFonts
                                                        .sourceSansPro(
                                                      textStyle:
                                                          const TextStyle(
                                                        color:
                                                            Color(0xFF2E2D28),
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          40, 10, 40, 0),
                                                  child: Text(
                                                    'If the user and/or PI group does not exist yet, this process will create them and make them available for future use.',
                                                    style: GoogleFonts
                                                        .sourceSansPro(
                                                      textStyle:
                                                          const TextStyle(
                                                        color:
                                                            Color(0xFF2E2D28),
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          40, 30, 40, 0),
                                                  child: Text(
                                                    'Add the following user...',
                                                    style: GoogleFonts
                                                        .sourceSansPro(
                                                      textStyle:
                                                          const TextStyle(
                                                        color:
                                                            Color(0xFF8C1514),
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          40, 10, 40, 0),
                                                  child: TextFormField(
                                                    controller:
                                                        userSunetIdTextController,
                                                    onChanged: (_) =>
                                                        EasyDebounce.debounce(
                                                      'userSunetIdTextController',
                                                      const Duration(
                                                          milliseconds: 2000),
                                                      () => setState(() {}),
                                                    ),
                                                    autofocus: true,
                                                    obscureText: false,
                                                    cursorColor:
                                                        const Color(0xFF8C1514),
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'User\'s SUNET ID',
                                                      labelStyle: GoogleFonts
                                                          .sourceSansPro(
                                                        textStyle:
                                                            const TextStyle(
                                                          color:
                                                              Color(0xFF2E2D28),
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      hintText:
                                                          'Enter the user\'s SUNETID',
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Color(0xE4646363),
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Color(0xE4646363),
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    style: GoogleFonts
                                                        .sourceSansPro(
                                                      textStyle:
                                                          const TextStyle(
                                                        color:
                                                            Color(0xFF2E2D28),
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          40, 20, 40, 0),
                                                  child: TextFormField(
                                                    controller:
                                                        userFirstNameTextController,
                                                    onChanged: (_) =>
                                                        EasyDebounce.debounce(
                                                      'userFirstNameTextController',
                                                      const Duration(
                                                          milliseconds: 2000),
                                                      () => setState(() {}),
                                                    ),
                                                    autofocus: true,
                                                    obscureText: false,
                                                    cursorColor:
                                                        const Color(0xFF8C1514),
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'User\'s First Name',
                                                      labelStyle:
                                                          const TextStyle(
                                                        color:
                                                            Color(0xFF2E2D28),
                                                        fontFamily:
                                                            'Source Sans Pro',
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      hintText:
                                                          'Enter the user\'s first name',
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Color(0xFF646363),
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Color(0xFF646363),
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    style: GoogleFonts
                                                        .sourceSansPro(
                                                            textStyle:
                                                                const TextStyle(
                                                      color: Color(0xFF2E2D28),
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          40, 20, 40, 0),
                                                  child: TextFormField(
                                                    controller:
                                                        userLastNameTextController,
                                                    onChanged: (_) =>
                                                        EasyDebounce.debounce(
                                                      'userLastNameTextController',
                                                      const Duration(
                                                          milliseconds: 2000),
                                                      () => setState(() {}),
                                                    ),
                                                    autofocus: true,
                                                    obscureText: false,
                                                    cursorColor:
                                                        const Color(0xFF8C1514),
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'User\'s Last Name',
                                                      labelStyle:
                                                          const TextStyle(
                                                        color:
                                                            Color(0xFF2E2D28),
                                                        fontFamily:
                                                            'Source Sans Pro',
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      hintText:
                                                          'Enter the user\'s last name',
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Color(0xFF646363),
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Color(0xFF646363),
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    style: GoogleFonts
                                                        .sourceSansPro(
                                                      textStyle:
                                                          const TextStyle(
                                                        color:
                                                            Color(0xFF2E2D28),
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          40, 30, 40, 0),
                                                  child: Text(
                                                    'To the following PI group...',
                                                    style: GoogleFonts
                                                        .sourceSansPro(
                                                            textStyle:
                                                                const TextStyle(
                                                      color: Color(0xFF8C1514),
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          40, 10, 40, 0),
                                                  child: TextFormField(
                                                    controller:
                                                        piSunetIdTextController,
                                                    onChanged: (_) =>
                                                        EasyDebounce.debounce(
                                                      'piSunetIdTextController',
                                                      const Duration(
                                                          milliseconds: 2000),
                                                      () => setState(() {}),
                                                    ),
                                                    autofocus: true,
                                                    obscureText: false,
                                                    cursorColor:
                                                        const Color(0xFF8C1514),
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'PI\'s SUNET ID',
                                                      labelStyle:
                                                          const TextStyle(
                                                        color:
                                                            Color(0xFF2E2D28),
                                                        fontFamily:
                                                            'Source Sans Pro',
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      hintText:
                                                          'Enter the SUNET ID of the user\'s PI',
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Color(0xFF646363),
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color:
                                                              Color(0xFF646363),
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    style: GoogleFonts
                                                        .sourceSansPro(
                                                            textStyle:
                                                                const TextStyle(
                                                      color: Color(0xFF2E2D28),
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 20, 0, 0),
                                        child: Container(
                                          width: 200,
                                          height: 60,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFFFFFFF),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 20),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0, 0),
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      if (jobRoster.length <
                                                          maxUsers) {
                                                        User newUser = User(
                                                          userSunetIdTextController
                                                              .text,
                                                          userFirstNameTextController
                                                              .text,
                                                          userLastNameTextController
                                                              .text,
                                                        );

                                                        UserMembership
                                                            newUserMembership =
                                                            UserMembership(
                                                                newUser,
                                                                piSunetIdTextController
                                                                    .text);

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'User membership task added to the Job Roster.',
                                                              style: GoogleFonts
                                                                  .getFont(
                                                                'Source Sans Pro',
                                                                color: const Color(
                                                                    0xFFFFFFFF),
                                                                fontSize: 26,
                                                              ),
                                                            ),
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        4000),
                                                            backgroundColor:
                                                                const Color(
                                                                    0xFF2E2D28),
                                                          ),
                                                        );

                                                        setState(() {
                                                          jobRoster.add(
                                                              newUserMembership);
                                                          userSunetIdTextController
                                                              .clear();
                                                          userFirstNameTextController
                                                              .clear();
                                                          userLastNameTextController
                                                              .clear();
                                                          piSunetIdTextController
                                                              .clear();
                                                        });
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'The Job Roster has reached the limit of ${maxUsers} task(s). Please click "Submit Job".',
                                                              style: GoogleFonts
                                                                  .getFont(
                                                                'Source Sans Pro',
                                                                color: const Color(
                                                                    0xFFFFFFFF),
                                                                fontSize: 26,
                                                              ),
                                                            ),
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        4000),
                                                            backgroundColor:
                                                                const Color(
                                                                    0xFF8C1514),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getSecondaryColor),
                                                      textStyle:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getButtonTextStyle),
                                                      fixedSize:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  getButtonSize),
                                                    ),
                                                    child: const Text(
                                                      'Add User Membership',
                                                    ),
                                                  ),
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
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
                          child: Container(
                            width: 100,
                            height: MediaQuery.of(context).size.height * 1,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEEEEEE),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20, 20, 20, 20),
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: const Color(0xFFFFFFFF),
                                elevation: 12,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              40, 20, 40, 0),
                                      child: Text(
                                        'Carina User Membership | Job Roster',
                                        style: GoogleFonts.sourceSansPro(
                                          textStyle: const TextStyle(
                                            color: Color(0xFF2E2D28),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 24.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFFFFFFF),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(40, 4, 40, 0),
                                              child: Text(
                                                'Each of the below tasks in this job roster will run asynchronously after clicking "Submit Job" below. If an error occurs during any of the tasks, it will be displayed, along with the task affected. Please re-submit just the errored task in a separate job.',
                                                style:
                                                    GoogleFonts.sourceSansPro(
                                                        textStyle:
                                                            const TextStyle(
                                                  color: Color(0xFF2E2D28),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                )),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(40, 10, 40, 0),
                                              child: Text(
                                                'There is currently a limit of ${maxUsers} task(s) until the process has been tested/optimized for performance.',
                                                style:
                                                    GoogleFonts.sourceSansPro(
                                                  textStyle: const TextStyle(
                                                    color: Color(0xFF2E2D28),
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(40, 10, 40, 0),
                                              child: Builder(
                                                builder: (context) {
                                                  return ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount: jobRoster.length,
                                                    itemBuilder: (context,
                                                        jobRosterIndex) {
                                                      final jobRosterTask =
                                                          jobRoster[
                                                              jobRosterIndex];

                                                      return Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                6, 14, 6, 0),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          height: 70,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                0xFFF1F4F8),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                blurRadius: 2,
                                                                color: Color(
                                                                    0xE4646363),
                                                                spreadRadius: 1,
                                                              )
                                                            ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  width: 100,
                                                                  height: 100,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: Color(
                                                                        0xFFFFFFFF),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              10),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              0),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              10),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              0),
                                                                    ),
                                                                  ),
                                                                  child: Align(
                                                                    alignment:
                                                                        const AlignmentDirectional(
                                                                            0,
                                                                            0),
                                                                    child: Text(
                                                                      (jobRosterIndex +
                                                                              1)
                                                                          .toString(),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: GoogleFonts
                                                                          .sourceSansPro(
                                                                        textStyle: const TextStyle(
                                                                            color: Color(
                                                                                0xFF8C1514),
                                                                            fontSize:
                                                                                20.0,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 8,
                                                                child:
                                                                    Container(
                                                                  width: 100,
                                                                  height: 100,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: Color(
                                                                        0xFFFFFFFF),
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Text(
                                                                          'Add Carina User: ${jobRosterTask.user.userFirstName} ${jobRosterTask.user.userLastName} (${jobRosterTask.user.userSunetId})...',
                                                                          style:
                                                                              GoogleFonts.sourceSansPro(
                                                                            textStyle:
                                                                                const TextStyle(
                                                                              fontSize: 18.0,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Color(0xFF2E2D28),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '...to the PI Group: ${jobRosterTask.piSunetId}',
                                                                        style: GoogleFonts
                                                                            .sourceSansPro(
                                                                          textStyle:
                                                                              const TextStyle(
                                                                            fontStyle:
                                                                                FontStyle.italic,
                                                                            fontSize:
                                                                                16.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Color(0xFF8C1514),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  width: 100,
                                                                  height: 100,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    color: Color(
                                                                        0xFFFFFFFF),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              0),
                                                                      bottomRight:
                                                                          Radius.circular(
                                                                              10),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              0),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      IconButton(
                                                                    iconSize:
                                                                        30.0,
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .more_vert,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      logger.d(
                                                                          'IconButton pressed ...');
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 20, 0, 0),
                                      child: Container(
                                        width: 100,
                                        height: 60,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFFFFFFF),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 0, 20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  String addUserResponse =
                                                      await addUsers(jobRoster);
                                                  log('Add User Response: $addUserResponse');
                                                  await showDialog(
                                                    context: context,
                                                    builder:
                                                        (alertDialogContext) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Job Started'),
                                                        content: const Text(
                                                            'Carina user creation script has started. Please wait a few moments before checking for completion in the Anthos cluster.'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    alertDialogContext),
                                                            child: const Text(
                                                                'Ok'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                options: FFButtonOptions(
                                                  buttonColor:
                                                      MaterialStateProperty
                                                          .resolveWith(
                                                              getPrimaryColor),
                                                  textStyle:
                                                      GoogleFonts.sourceSansPro(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                  height: 40,
                                                  width: 240,
                                                ),
                                                text: 'Submit Job',
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
                          ),
                        ),
                      ),
                    ],
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
