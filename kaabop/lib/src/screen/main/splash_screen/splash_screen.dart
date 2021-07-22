import 'package:flutter/scheduler.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';

class MySplashScreen extends StatefulWidget {
  //static const route = '/';
  @override
  State<StatefulWidget> createState() {
    return MySplashScreenState();
  }
}

class MySplashScreenState extends State<MySplashScreen> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation<double> animation;

  Future<void> getCurrentAccount() async {

    // Navigator.push(context, MaterialPageRoute(builder: (context) => ImportAcc(reimport: "hello") ));

    await Future.delayed(const Duration(milliseconds: 1000), () async {

      final List<KeyPairData> ls = ApiProvider.keyring.keyPairs.toList();

      if (ls.isEmpty) {
        Navigator.pushReplacement(context, RouteAnimation(enterPage: Welcome()));
      } else {
        final ethAddr = await StorageServices().readSecure('etherAdd');

        if (ethAddr == null) {
          await dialogSuccess(
            context,
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text('Please reimport your seed phrases to add support to new update.', textAlign: TextAlign.center,)
            ),
            const Text('New Update!'),
            action: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  RouteAnimation(
                    enterPage: const ImportAcc(
                      reimport: 'reimport',
                    ),
                  ),
                );
              },
              child: const MyText(text: 'Continue', color: AppColors.secondarytext),
            ),
          );
        } else {
          checkBio();
        }
      }
    });
  }

  Future<void> checkBio() async {

    final bio = await StorageServices.readSaveBio();

    final passCode = await StorageServices().readSecure('passcode');

    await StorageServices().readSecure('private').then((value) {
      print("My private key: $value");
    });

    if (bio && passCode != null) {
      Navigator.pushReplacement(
        context,
        RouteAnimation(
          enterPage: const Passcode(isHome: 'home'),
        ),
      );
    } else {
      
      if (bio) {
        Navigator.pushReplacement(
          context,
          RouteAnimation(
            enterPage: FingerPrint(),
          ),
        );
      } else if (passCode != null) {
        Navigator.pushReplacement(
          context,
          RouteAnimation(
            enterPage: const Passcode(isHome: 'home'),
          ),
        );
      } else {
        Navigator.pushReplacementNamed(context, Home.route);
      }
    }
  }

  Future<void> checkBiometric() async {
    await StorageServices.readSaveBio().then((value) {
      if (value) {
        Navigator.pushReplacement(
          context,
          RouteAnimation(
            enterPage: FingerPrint(),
          ),
        );
      } else {
        Navigator.pushReplacementNamed(context, Home.route);
      }
    });
  }

  @override
  void initState() {
    // readTheme();
    getCurrentAccount();

    // final window = WidgetsBinding.instance.window;
    // window.onPlatformBrightnessChanged = () {
    //   readTheme();
    // };

    super.initState();
  }

  void readTheme() async {
    final res = await StorageServices.fetchData('dark');
    final sysTheme = _checkIfDarkModeEnabled();

    if (res != null) {
      Provider.of<ThemeProvider>(context, listen: false).changeMode();
    } else {
      if (sysTheme) {
        Provider.of<ThemeProvider>(context, listen: false).changeMode();
      } else {
        Provider.of<ThemeProvider>(context, listen: false).changeMode();
      }
    }
  }

  void systemThemeChange() async {
    final res = await StorageServices.fetchData('dark');
    final sysTheme = _checkIfDarkModeEnabled();

    if (res == null) {
      if (sysTheme) {
        Provider.of<ThemeProvider>(context, listen: false).changeMode();
      } else {
        Provider.of<ThemeProvider>(context, listen: false).changeMode();
      }
    }
  }

  bool _checkIfDarkModeEnabled() {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    return darkModeOn;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      body: Container(),
    );
  }
}
