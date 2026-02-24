import 'package:flutter/material.dart';

import 'package:app_1riel/Environment.dart';
import 'package:app_1riel/navigators/Routes.dart';
import 'package:app_1riel/utilities/Debug.dart';

class Main_Drawer extends StatefulWidget {
  const Main_Drawer({super.key});

  static void close_drawer(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  State<Main_Drawer> createState() => _Main_DrawerState();
}

class _Main_DrawerState extends State<Main_Drawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 200, //
            alignment: Alignment.center,
            child: Image.network(
              '$MINIO/public/assets/background.png',
              height: 200,
              fit: BoxFit.cover, //
            ), //
          ),

          // Option
          ExpansionTile(
            leading: Icon(Icons.list_alt_outlined),
            title: Text('Options'),
            children: [
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Option #1', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Option #2', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Option #3', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {},
              ),
            ],
          ),
          // Demo
          ExpansionTile(
            leading: Icon(Icons.list_alt_outlined),
            title: Text('Options'),
            children: [
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Option #1', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Option #2', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.school_outlined), //
                title: Text('Option #3', overflow: TextOverflow.ellipsis, maxLines: 1),
                onTap: () {},
              ),
            ],
          ),

          // about us
          ListTile(
            leading: Icon(Icons.store_outlined), //
            title: Text('Manage Store', overflow: TextOverflow.ellipsis, maxLines: 1),
            onTap: () {
              // todo:
              // Navigator.pop(context); //
              // Navigator.of(context).push(Routes.Manage_Product());
            },
          ),
          // about us
          ListTile(
            leading: Icon(Icons.drive_eta_outlined), //
            title: Text('Manage Driver', overflow: TextOverflow.ellipsis, maxLines: 1),
            onTap: () {
              // todo:
              // Navigator.pop(context); //
              // Navigator.of(context).push(Routes.Manage_Product());
            },
          ),
          // about us
          ListTile(
            leading: Icon(Icons.manage_history), //
            title: Text('Manage Product', overflow: TextOverflow.ellipsis, maxLines: 1),
            onTap: () {
              Navigator.pop(context); //
              // Navigator.of(context).push(Routes.Manage_Product());
            },
          ),
          // about us
          ListTile(
            leading: Icon(Icons.info_outline), //
            title: Text('About Us', overflow: TextOverflow.ellipsis, maxLines: 1),
            onTap: () {
              Navigator.pop(context); //
              Navigator.of(context).pushNamed('/about');
            },
          ),
        ],
      ),
    );
  }
}
