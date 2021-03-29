import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallet_apps/index.dart';
import 'package:vibration/vibration.dart';

class Passcode extends StatelessWidget {
  static const route = '/passcode';

  //final OutlineInputBorder outlineInputBorder = OutlineInputBorder();
  final TextEditingController pinOneController = TextEditingController();
  final TextEditingController pinTwoController = TextEditingController();
  final TextEditingController pinThreeController = TextEditingController();
  final TextEditingController pinFourController = TextEditingController();
  final TextEditingController pinFiveController = TextEditingController();
  final TextEditingController pinSixController = TextEditingController();

  final storage = new FlutterSecureStorage();

  int pinIndex = 0;
  String firstPin;
  List<String> currentPin = ["", "", "", "", "", ""];

  final outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(80),
    borderSide: const BorderSide(
      color: Colors.transparent,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyScaffold(
          child: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                const Text(
                  'Enter 6-Digits Code',
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(height: 60),
                _buildPinRow(),
                ReuseNumPad(pinIndexSetup, clearPin),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildPinRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ReusePinNum(outlineInputBorder, pinOneController),
        ReusePinNum(outlineInputBorder, pinTwoController),
        ReusePinNum(outlineInputBorder, pinThreeController),
        ReusePinNum(outlineInputBorder, pinFourController),
        ReusePinNum(outlineInputBorder, pinFiveController),
        ReusePinNum(outlineInputBorder, pinSixController),
      ],
    );
  }

  void clearPin() {
    if (pinIndex == 0) {
      pinIndex = 0;
    } else if (pinIndex == 6) {
      setPin(pinIndex, "");
      pinIndex--;
    } else {
      setPin(pinIndex, "");
      currentPin[pinIndex - 1] = "";
      pinIndex--;
    }
  }

  void pinIndexSetup(String text) {
    if (pinIndex == 0) {
      pinIndex = 1;
    } else if (pinIndex < 6) {
      pinIndex++;
    }
    setPin(pinIndex, text);
    currentPin[pinIndex - 1] = text;
    String strPin = "";
    // ignore: avoid_function_literals_in_foreach_calls
    currentPin.forEach((element) {
      strPin += element;
    });
    if (pinIndex == 6) {
      //print(strPin);
      verifyPin(strPin);
      //checkVerify(strPin);

    }
  }

  Future<void> setVerifyPin(String pin) async {
    if (firstPin == null) {
      firstPin = pin;
      clearAll();
    } else {
      if (firstPin == pin) {
        await storage.write(key: 'passcode', value: pin);
      }
    }
  }

  void clearAll() {
    for (int i = 0; i < 6; i++) {
      clearPin();
    }
  }

  Future<void> verifyPin(String pin) async {
    String value = await storage.read(key: 'passcode');

    if (value == null) {
      //setVerif    yPin(pin);
    } else {
      if (value == pin) {
        print('verify');
      }
    }
    // final res = await ApiProvider.sdk.api.keyring
    //     .checkPassword(ApiProvider.keyring.current, pin);

    // if (res) {
    //   //correct pasword
    // } else {
    //   for (int i = 0; i < 6; i++) {
    //     clearPin();
    //   }
    //   Vibration.vibrate(amplitude: 500);
    // }
  }

  void setPin(int n, String text) {
    switch (n) {
      case 1:
        pinOneController.text = text;
        break;
      case 2:
        pinTwoController.text = text;
        break;
      case 3:
        pinThreeController.text = text;
        break;
      case 4:
        pinFourController.text = text;
        break;
      case 5:
        pinFiveController.text = text;
        break;
      case 6:
        pinSixController.text = text;
        break;
    }
  }
}

class ReusePinNum extends StatelessWidget {
  final OutlineInputBorder outlineInputBorder;
  final TextEditingController textEditingController;

  const ReusePinNum(this.outlineInputBorder, this.textEditingController);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.0,
      height: 40.0,
      child: TextField(
        controller: textEditingController,
        enabled: false,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 1.0),
          border: outlineInputBorder,
          filled: true,
          fillColor: Colors.grey[300],
        ),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 42,
          color: hexaCodeToColor(AppColors.secondary),
        ),
      ),
    );
  }
}

class ReuseNumPad extends StatelessWidget {
  final Function pinIndexSetup;
  final Function clearPin;

  const ReuseNumPad(this.pinIndexSetup, this.clearPin);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildNumberPad(),
    );
  }

  Widget _buildNumberPad() {
    return Expanded(
      child: Container(
        //padding: const EdgeInsets.only(left: 32, right: 32, top: 20),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ReuseKeyBoardNum(1, () {
                  pinIndexSetup('1');
                }),
                ReuseKeyBoardNum(2, () {
                  pinIndexSetup('2');
                }),
                ReuseKeyBoardNum(3, () {
                  pinIndexSetup('3');
                }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ReuseKeyBoardNum(4, () {
                  pinIndexSetup('4');
                }),
                ReuseKeyBoardNum(5, () {
                  pinIndexSetup('5');
                }),
                ReuseKeyBoardNum(6, () {
                  pinIndexSetup('6');
                }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ReuseKeyBoardNum(7, () {
                  pinIndexSetup('7');
                }),
                ReuseKeyBoardNum(8, () {
                  pinIndexSetup('8');
                }),
                ReuseKeyBoardNum(9, () {
                  pinIndexSetup('9');
                }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const SizedBox(
                  width: 60.0,
                  child: MaterialButton(
                    onPressed: null,
                    child: SizedBox(),
                  ),
                ),
                ReuseKeyBoardNum(0, () {
                  pinIndexSetup('0');
                }),
                SizedBox(
                  width: 60,
                  child: MaterialButton(
                    height: 60,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                    onPressed: () {
                      clearPin();
                    },
                    child: const Icon(
                      Icons.backspace,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ReuseKeyBoardNum extends StatelessWidget {
  final int n;
  final Function() onPressed;

  const ReuseKeyBoardNum(this.n, this.onPressed);
  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 70.0,
      //width: M,
      width: 100,
      height: 70.0,
      alignment: Alignment.center,
      child: MaterialButton(
        padding: const EdgeInsets.all(8.0),
        onPressed: onPressed,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(60.0),
        // ),
        height: 90,
        child: Text(
          '$n',
          style: TextStyle(
              fontSize: 24 * MediaQuery.of(context).textScaleFactor,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
