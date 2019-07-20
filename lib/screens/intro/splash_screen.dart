import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:mpesa_ledger_flutter/blocs/firebase/firebase_auth_bloc.dart';
import 'package:mpesa_ledger_flutter/blocs/query_sms/query_sms_bloc.dart';
import 'package:mpesa_ledger_flutter/blocs/runtime_permissions/runtime_permission_bloc.dart';
import 'package:mpesa_ledger_flutter/screens/intro/intro_walk_through_screen.dart';
import 'package:mpesa_ledger_flutter/services/firebase/firebase_auth.dart';
import 'package:mpesa_ledger_flutter/widgets/dialogs/alertDialog.dart';

class SplashScreen extends StatefulWidget {
  RuntimePermissionsBloc runtimePermissionBloc = RuntimePermissionsBloc();
  FirebaseAuthBloc firebaseAuthBloc = FirebaseAuthBloc();
  FirebaseAuthProvider onAuthStateChanged = FirebaseAuthProvider();
  QuerySMSBloc querySMSBloc = QuerySMSBloc();
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.runtimePermissionBloc.dispose();
    widget.firebaseAuthBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.runtimePermissionBloc.permissionDenialStream.listen((data) {
      if (data) {
        return AlertDialogWidget(
          context,
          title: "SMS Permission",
          content: Text("To use MPESA LEDGER, allow SMS permissions"),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                SystemChannels.platform
                    .invokeMethod<void>('SystemNavigator.pop');
              },
            ),
            FlatButton(
              child: Text("ALLOW PERMISSIONS"),
              onPressed: () {
                widget.runtimePermissionBloc.checkAndRequestPermissionSink
                    .add(null);
                Navigator.pop(context);
              },
            )
          ],
        ).show();
      }
    });

    widget.runtimePermissionBloc.openAppSettingsStream.listen((data) {
      if (data) {
        return AlertDialogWidget(
          context,
          title: "SMS Permission",
          content: Text(
              "To use MPESA LEDGER, allow SMS permissions are needed, please go to settings > Permissions and turn or SMS"),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                SystemChannels.platform
                    .invokeMethod<void>('SystemNavigator.pop');
              },
            ),
            FlatButton(
              child: Text("TURN ON"),
              onPressed: () {
                SystemChannels.platform
                    .invokeMethod<void>('SystemNavigator.pop');
                AppSettings.openAppSettings();
              },
            )
          ],
        ).show();
      }
    });

    widget.runtimePermissionBloc.continueToAppStream.listen((void v) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (route) => IntroWalkThrough()),
      );
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "TEST",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 45.0),
            ),
            Text(
              "TEST",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 45.0),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: widget.onAuthStateChanged.onAuthStateChanged,
              builder:
                  (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
                if (snapshot.data == null) {
                  return Column(
                    children: <Widget>[
                      GoogleSignInButton(
                        onPressed: () {
                          widget.firebaseAuthBloc.signInSink.add(null);
                        },
                      ),
                    ],
                  );
                } else {
                  widget.runtimePermissionBloc.checkAndRequestPermissionSink
                      .add(null);
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
