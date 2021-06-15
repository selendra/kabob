import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:wallet_apps/index.dart';


class MySplashScreen extends StatefulWidget {
  //static const route = '/';
  @override
  State<StatefulWidget> createState() {
    return MySplashScreenState();
  }
}

class MySplashScreenState extends State<MySplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  Future<void> getCurrentAccount() async {
    await Future.delayed(const Duration(milliseconds: 700), () async {
      final List<KeyPairData> ls = ApiProvider.keyring.keyPairs.toList();

      if (ls.isEmpty) {
        Navigator.pushReplacement(
            context, RouteAnimation(enterPage: Welcome()));
      } else {
        final ethAddr = await StorageServices().readSecure('etherAdd');

        if (ethAddr == null) {
          await dialogSuccess(
            context,
            const Text(
                'Please reimport your seed phrases to add support to new update.'),
            const Text('New Update!'),
            action: FlatButton(
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
              child: const Text('Continue'),
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
    // dialogLoading(context);
    getCurrentAccount();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(),
    );
  }
}
