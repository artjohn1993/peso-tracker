import 'package:flutter/material.dart';
import 'package:peso_tracker/main.dart';
import 'package:local_auth/local_auth.dart';
import 'package:peso_tracker/services/database_service.dart';

class SidebarMenu extends StatefulWidget {
  const SidebarMenu({super.key});

  @override
  State<SidebarMenu> createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  final DatabaseService _database = DatabaseService.instance;
  late final LocalAuthentication auth;
  bool isAuthAvailable = false;
  bool authValue = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    initializeSetting();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: kColorScheme.primary),
          child: Center(child: Image.asset('assets/logo-no-background.png')),
        ),
        ListTile(
          leading: Switch(
            value: authValue,
            onChanged: (value) {
              setState(() {
                authValue = value;
                _database.updateSetting(authValue ? 0 : 1);
              });
            },
          ),
          title: const Text('Finger Auhentication',style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle: FittedBox(
            fit: BoxFit.fitWidth,
            child: FutureBuilder(
              future: checkAvailability,
              builder: (ctx, snapshot) {
                if (snapshot.data != null) {
                  isAuthAvailable = snapshot.data!;
                  return Text(snapshot.data!
                      ? 'Authentication is available'
                      : 'No available authentication');
                } else {
                  return Text('No available authentication');
                }
              },
            ),
          ),
        )
      ],
    );
  }

  Future<bool> get checkAvailability async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    return canAuthenticateWithBiometrics || await auth.isDeviceSupported();
  }

  void initializeSetting() async {
     var temp = await _database.getSettings();
     setState(() {
       authValue = temp;
     });
  }
}
