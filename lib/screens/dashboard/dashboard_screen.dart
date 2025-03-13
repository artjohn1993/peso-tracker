import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:peso_tracker/modal/transaction_modal.dart';
import 'package:peso_tracker/model/transaction_model.dart';

import 'package:peso_tracker/provider/transaction_notifier.dart';
import 'package:peso_tracker/screens/dashboard/component/bottom_navigation.dart';
import 'package:peso_tracker/screens/dashboard/component/dashboard_container.dart';
import 'package:peso_tracker/screens/dashboard/component/sidebar_menu.dart';
import 'package:peso_tracker/screens/transaction/transaction_screen.dart';
import 'package:peso_tracker/services/database_service.dart';
import 'package:local_auth/local_auth.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  DatabaseService database = DatabaseService.instance;
  var navigationIndex = 0;
  late Widget layout = _selectLayout(0);
  late List<TransactionModel> transactionList;

  @override
  void initState() {
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Peso Tracker"),
        centerTitle: true,
      ),
      body: layout,
      bottomNavigationBar: BottomNavigation(
        onNavigationBarEvent: onNavigationBarEvent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapFloatButton,
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: SidebarMenu(),
      ),
    );
  }

  void initialization() async {
    //initialize transactionList
    transactionList = await database.getTransaction();
    ref
        .read(transactionProvider.notifier)
        .updateTransaction(transactionList, null);

    layout = _selectLayout(0);

    await checkAuthentication();
    //delay the display of splash screen
    //await Future.delayed(Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  Future<void> checkAuthentication() async {
    final LocalAuthentication auth = LocalAuthentication();
    var isAuthEnable = await database.getSettings();
    if (isAuthEnable) {
      try {
        final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Please authenticate to show account',
            options: const AuthenticationOptions(
              biometricOnly: false,
              stickyAuth: true,
            ));
        print(didAuthenticate);

        if (!didAuthenticate) return;
      } on PlatformException {}
    }
  }

  //change layout according to navigation bar event
  void onNavigationBarEvent(int index) {
    setState(() {
      layout = _selectLayout(index);
    });
  }

  //change layout according to navigation bar event
  Widget _selectLayout(int index) {
    switch (index) {
      case 0:
        return DashboardContainer();
      case 1:
        return TransactionScreen();
      default:
        return DashboardContainer();
    }
  }

  void _onTapFloatButton() {
    showModalBottomSheet(
      useSafeArea: true,
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      builder: (buildContext) => TransactionModal(),
    );
  }
}
