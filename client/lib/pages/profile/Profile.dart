import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:app_1riel/pages/profile/Update_Data.dart';
import 'package:app_1riel/Environment.dart';
import 'package:app_1riel/utilities/Debug.dart';
import 'package:app_1riel/pages/profile/Sign_In.dart';
import 'package:app_1riel/navigators/Routes.dart';
import 'package:app_1riel/themes/Theme_Data.dart';
import 'package:app_1riel/navigators/Main_Drawer.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: TITLE, //
      theme: Theme_Data.get_theme(),
      home: const Profile_Page(),
      routes: Routes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Profile_Page extends StatefulWidget {
  const Profile_Page({super.key});

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page> {
  String VERSION = '0.0.0+0';

  FlutterSecureStorage secure_storage = FlutterSecureStorage();
  String? access_token;

  String? name;
  String? phone_number;
  String? address;
  String? username;
  String? password;
  String? telegram_id;
  String? profile_image;
  String? background_image;

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: API_HOST, //
      connectTimeout: Duration(seconds: 10), //
      sendTimeout: Duration(seconds: 10), //
      receiveTimeout: Duration(seconds: 10), //
    ),
  );

  @override
  void initState() {
    super.initState();
    debug('Profile Page Loaded');
    init();
  }

  void init() async {
    final info = await PackageInfo.fromPlatform();
    VERSION = '${info.version}+${info.buildNumber}';

    name = null;
    phone_number = null;
    address = null;
    username = null;
    password = null;
    telegram_id = null;
    profile_image = null;
    background_image = null;

    access_token = await secure_storage.read(key: 'access_token');
    debug('Access Token: $access_token');

    if (access_token != null) {
      dio.options.headers['Authorization'] = 'Bearer $access_token';

      await dio
          .post(
            '/credential/read', //
            data: FormData.fromMap({}),
          )
          .then((r) {
            debug('Credential Data: ${r.data}');
            name = r.data['name'];
            phone_number = r.data['phone_number'];
            address = r.data['address'];
            username = r.data['username'];
            password = r.data['password_hash'];
            telegram_id = r.data['telegram_id'];
            profile_image = r.data['profile_image'];
            background_image = r.data['background_image'];
            debug(background_image!);
            setState(() {});
          })
          .catchError((e) {});
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profile'), //
            Text(
              VERSION,
              style: const TextStyle(
                fontSize: 12, //
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ), //
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  // background and profile
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          SizedBox(
                            width: 600,
                            height: 200, //
                            child: background_image == null
                                ? Image.network('$MINIO_PUBLIC/200/assets/background.png') //
                                : Image.network('$MINIO_PUBLIC/200/$background_image'),
                          ),
                          if (access_token != null)
                            IconButton(
                              onPressed: () async {
                                // upload background image
                                final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

                                if (image == null) {
                                  return;
                                }

                                await dio
                                    .post(
                                      '/credential/upload/background_image', //
                                      data: FormData.fromMap({
                                        'value': MultipartFile.fromBytes(
                                          await image.readAsBytes(), //
                                          filename: image.name,
                                        ), //
                                      }),
                                    )
                                    .then((r) {
                                      init();
                                      show_snackbar(context: context, message: 'Update Success', color: Colors.green);
                                    })
                                    .catchError((e) {
                                      show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
                                    });
                              },
                              icon: Icon(Icons.upload_outlined, color: Colors.blue),
                            ),
                        ],
                      ),

                      // profile
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: profile_image == null
                                ? Image.network('$MINIO_PUBLIC/100/assets/logo.png') //
                                : Image.network('$MINIO_PUBLIC/100/$profile_image'), //
                          ),
                          if (access_token != null)
                            IconButton(
                              onPressed: () async {
                                // upload profile image
                                final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

                                // if no image selected
                                if (image == null) return;

                                // upload image to server
                                await dio
                                    .post(
                                      '/credential/upload/profile_image', //
                                      data: FormData.fromMap({
                                        'value': MultipartFile.fromBytes(
                                          await image.readAsBytes(), //
                                          filename: image.name,
                                        ),
                                      }),
                                    )
                                    .then((r) {
                                      init();
                                      show_snackbar(context: context, message: 'Update Success', color: Colors.green);
                                    })
                                    .catchError((e) {
                                      show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
                                    });
                              },
                              icon: Icon(Icons.upload_outlined, color: Colors.blue),
                            ),
                        ],
                      ),
                    ],
                  ),

                  // sign in and sign up buttons
                  if (access_token == null) ...[
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(Routes.Sign_In()).then((value) => init());
                          },
                          child: Text('Sign In'),
                        ), //
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(Routes.Sign_Up()).then((value) {
                              if (value == true) {
                                Navigator.of(context).push(Routes.Sign_In()).then((value) => init());
                              }
                            });
                          },
                          child: Text('Sign Up'),
                        ), //
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(Routes.Reset()).then((value) {
                              if (value == true) {
                                Navigator.of(context).push(Routes.Sign_In()).then((value) => init());
                              }
                            });
                          },
                          child: Text('Reset'),
                        ), //
                      ],
                    ),
                  ],

                  // sign in and sign up buttons
                  if (access_token != null) ...[
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(onPressed: () {}, child: Text('Be Store')), //
                        OutlinedButton(onPressed: () {}, child: Text('Be Driver')), //
                      ],
                    ),
                  ],

                  SizedBox(height: 8),

                  ExpansionTile(
                    title: Text('Information: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                    initiallyExpanded: true,
                    children: [
                      //
                      Row(
                        children: [
                          Icon(Icons.person), //
                          SizedBox(width: 8, height: 40),
                          Text("Name: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(name ?? ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) => Update_Profile_Page(
                                          title: 'Name', //
                                          input: name ?? '',
                                        ),
                                      ),
                                    )
                                    .then((output) async {
                                      debug(output);
                                      if (output == null) return;
                                      await dio
                                          .post(
                                            '/credential/update/name', //
                                            data: FormData.fromMap({'value': output}),
                                          )
                                          .then((r) {
                                            init();
                                            show_snackbar(context: context, message: 'Update Success', color: Colors.green);
                                          })
                                          .catchError((e) {
                                            show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
                                          });
                                    });
                              },
                              icon: Icon(Icons.edit),
                            ),
                        ],
                      ),
                      //
                      Row(
                        children: [
                          Icon(Icons.phone), //
                          SizedBox(width: 8, height: 40),
                          Text("Phone Number: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(phone_number ?? ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) => Update_Profile_Page(
                                          title: 'Phone Number', //
                                          input: phone_number ?? '',
                                          keyboard_type: TextInputType.phone,
                                        ),
                                      ),
                                    )
                                    .then((output) async {
                                      debug(output);
                                      if (output == null) return;
                                      await dio
                                          .post(
                                            '/credential/update/phone_number', //
                                            data: FormData.fromMap({'value': output}),
                                          )
                                          .then((r) {
                                            init();
                                            show_snackbar(context: context, message: 'Update Success', color: Colors.green);
                                          })
                                          .catchError((e) {
                                            show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
                                          });
                                    });
                              },
                              icon: Icon(Icons.edit),
                            ),
                        ],
                      ),
                      //
                      Row(
                        children: [
                          Icon(Icons.place), //
                          SizedBox(width: 8, height: 40),
                          Text("Address: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(address ?? ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) => Update_Profile_Page(
                                          title: 'Address', //
                                          input: address ?? '',
                                        ),
                                      ),
                                    )
                                    .then((output) async {
                                      debug(output);
                                      if (output == null) return;
                                      await dio
                                          .post(
                                            '/credential/update/address', //
                                            data: FormData.fromMap({'value': output}),
                                          )
                                          .then((r) {
                                            init();
                                            show_snackbar(context: context, message: 'Update Success', color: Colors.green);
                                          })
                                          .catchError((e) {
                                            show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
                                          });
                                    });
                              },
                              icon: Icon(Icons.edit),
                            ),
                        ],
                      ),
                    ],
                  ),

                  // credential
                  ExpansionTile(
                    title: Text('Credential: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    tilePadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                    initiallyExpanded: true,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person), //
                          SizedBox(width: 8, height: 40),
                          Text("Username: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(username ?? ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) => Update_Profile_Page(
                                          title: 'Username', //
                                          input: username ?? '',
                                        ),
                                      ),
                                    )
                                    .then((output) async {
                                      debug(output);
                                      if (output == null) return;
                                      await dio
                                          .post(
                                            '/credential/update/username', //
                                            data: FormData.fromMap({'value': output}),
                                          )
                                          .then((r) {
                                            init();
                                            show_snackbar(context: context, message: 'Update Success', color: Colors.green);
                                          })
                                          .catchError((e) {
                                            show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
                                          });
                                    });
                              },
                              icon: Icon(Icons.edit),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.security_rounded), //
                          SizedBox(width: 8, height: 40),
                          Text("Password: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(access_token != null ? "**********" : ""),
                          Spacer(),
                          if (access_token != null)
                            IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(
                                      MaterialPageRoute(
                                        builder: (context) => Update_Profile_Page(
                                          title: 'Password', //
                                          input: '',
                                        ),
                                      ),
                                    )
                                    .then((output) async {
                                      debug(output);
                                      if (output == null) return;
                                      await dio
                                          .post(
                                            '/credential/update/password', //
                                            data: FormData.fromMap({'value': output}),
                                          )
                                          .then((r) {
                                            init();
                                            show_snackbar(context: context, message: 'Update Success', color: Colors.green);
                                          })
                                          .catchError((e) {
                                            show_snackbar(context: context, message: 'Update Fail', color: Colors.red);
                                          });
                                    });
                              },
                              icon: Icon(Icons.edit),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.telegram), //
                          SizedBox(width: 8, height: 40),
                          Text("Telegram ID: ", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(telegram_id ?? ""),
                          Spacer(),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  // sign out button
                  if (access_token != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            // debug('Sign Out Clicked');
                            secure_storage.delete(key: 'access_token');
                            init();
                          },
                          child: Text('Sign Out', style: TextStyle(color: Colors.red)),
                        ), //
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),

      drawer: const Main_Drawer(),
    );
  }
}

Future<String?> show_edit_dialog({
  required BuildContext context, //
  required String title,
  required String input,
  TextInputType? keyboard_type,
}) {
  final controller = TextEditingController(text: input);

  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 400,
        child: TextField(
          controller: controller, //
          keyboardType: keyboard_type ?? TextInputType.text,
          //   autofocus: true, //
          onSubmitted: (value) => Navigator.of(ctx).pop(controller.text),
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(controller.text), child: Text('Save'))],
    ),
  );
}

void show_snackbar({
  required BuildContext context, //
  required String message, //
  required Color color, //
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: color,
      ),
    );
}
