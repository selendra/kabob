import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/menu/swap_des.dart';

class Swap extends StatefulWidget {
  @override
  _SwapState createState() => _SwapState();
}

class _SwapState extends State<Swap> {
  FlareControls flareController = FlareControls();
  final GlobalKey<FormState> _swapKey = GlobalKey<FormState>();

  TextEditingController _amountController;

  bool _success = false;

  Future<void> approve() async {
    final contract = Provider.of<ContractProvider>(context, listen: false);

    await dialogBox().then((value) async {
      try {
        final res = await getPrivateKey(value);

        if (res != null) {
          dialogLoading(context);
          final hash = await contract.approveSwap(res);
          if (hash != null) {
            contract.getBscBalance();
            Navigator.pop(context);
            enableAnimation('approved balance to swap.');
          }
        }
      } catch (e) {
        Navigator.pop(context);
        await customDialog('Opps', e.message.toString());
      }
    });
  }

  Future<void> swap() async {
    final contract = Provider.of<ContractProvider>(context, listen: false);
    await dialogBox().then((value) async {
      try {
        final res = await getPrivateKey(value);

        if (res != null) {
          dialogLoading(context);
          final hash = await contract.swap(_amountController.text, res);
          if (hash != null) {
            await Future.delayed(const Duration(seconds: 7));
            final res = await contract.getPending(hash);

            print(res);

            if (res != null) {
              if (res) {
                setState(() {});

                contract.getBscBalance();
                Navigator.pop(context);
                enableAnimation(
                    'swapped ${_amountController.text} of SEL v1 to SEL v2.');
                _amountController.text = '';
              } else {
                Navigator.pop(context);
                await customDialog('Opps', 'Something went wrong.');
              }
            }
          } else {
            Navigator.pop(context);
          }
        }
      } catch (e) {
        Navigator.pop(context);
        await customDialog('Opps', e.message.toString());
      }
    });
  }

  Future<String> getPrivateKey(String pin) async {
    String privateKey;
    final encrytKey = await StorageServices().readSecure('private');
    try {
      privateKey =
          await ApiProvider.keyring.store.decryptPrivateKey(encrytKey, pin);
    } catch (e) {
      await customDialog('Opps', 'PIN verification failed');
    }

    return privateKey;
  }

  void validateSwap() async {
    final contract = Provider.of<ContractProvider>(context, listen: false);

    if (double.parse(_amountController.text) >
            double.parse(contract.bscNative.balance) ||
        double.parse(contract.bscNative.balance) == 0) {
      customDialog(
          'Insufficient Balance', 'Your loaded balance is not enough to swap.');
    } else {
      final res = await ContractProvider().checkAllowance();

      if (res.toString() == '0') {
        customDialog(
            'Approval Required', 'Your haven\'t approved to swap balance.');
      } else {
        confirmDialog(_amountController.text, swap);
      }
    }
  }

  Future enableAnimation(String operationText) async {
    setState(() {
      _success = true;
    });
    flareController.play('Checkmark');

    Timer(const Duration(milliseconds: 2500), () {
      // Navigator.pop(context);
      setState(() {
        _success = false;
      });

      successDialog(operationText);
    });
  }

  Future<String> dialogBox() async {
    /* Show Pin Code For Fill Out */
    final String _result = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Material(
            color: Colors.transparent,
            child: FillPin(),
          );
        });

    return _result;
  }

  Future<void> customDialog(String text1, String text2) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Align(
            child: Text(text1),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Text(text2),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> successDialog(String operationText) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            //height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width * 0.7,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.08,
                  ),
                  SvgPicture.asset(
                    'assets/icons/tick.svg',
                    height: 100,
                    width: 100,
                  ),
                  MyText(
                    text: 'SUCCESS!',
                    fontSize: 22,
                    top: MediaQuery.of(context).size.width * 0.1,
                    fontWeight: FontWeight.bold,
                  ),
                  MyText(
                    top: 8.0,
                    fontSize: 16,
                    text: 'You have successfully ' + operationText,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // ignore: deprecated_member_use
                      SizedBox(
                        height: 50,
                        width: 140,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.grey[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            'Close',
                            style: TextStyle(
                              color: hexaCodeToColor(AppColors.secondarytext),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // ignore: deprecated_member_use
                      SizedBox(
                        height: 50,
                        width: 140,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, Home.route, ModalRoute.withName('/'));
                          },
                          color: hexaCodeToColor(AppColors.secondary),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            'Go to wallet',
                            style: TextStyle(
                              color: hexaCodeToColor('#ffffff'),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> confirmDialog(String amount, Function swap) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            // height: MediaQuery.of(context).size.height / 2.2,
            width: MediaQuery.of(context).size.width * 0.7,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  const MyText(
                    text: 'Swapping',
                    //color: '#000000',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                  SvgPicture.asset(
                    'assets/icons/arrow.svg',
                    height: 100,
                    width: 100,
                    color: hexaCodeToColor(AppColors.secondary),
                  ),
                  const MyText(
                    text: 'SEL v1 to SEL v2',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    top: 40,
                    bottom: 8.0,
                  ),
                  MyText(
                    text: '$amount of SEL v1',
                    fontSize: 16,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.15,
                  ),
                  SizedBox(
                    height: 60,
                    width: 200,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        swap();
                      },
                      color: hexaCodeToColor(AppColors.secondary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        'CONFIRM',
                        style: TextStyle(
                          color: hexaCodeToColor('#ffffff'),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _amountController = TextEditingController();
    _amountController.addListener(() {
      final text = _amountController.text.toLowerCase();
      _amountController.value = _amountController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    final contract = Provider.of<ContractProvider>(context, listen: false);
    return Scaffold(
      body: BodyScaffold(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                children: [
                  MyAppBar(
                    title: "Swap SEL v2",
                    color: isDarkTheme
                        ? hexaCodeToColor(AppColors.darkCard)
                        : hexaCodeToColor(AppColors.whiteHexaColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    tile: GestureDetector(
                      onTap: () async {
                        dialogLoading(context);
                        final res = await ContractProvider().checkAllowance();

                        if (res.toString() == '0') {
                          Navigator.pop(context);
                          approve();
                        } else {
                          Navigator.pop(context);
                          customDialog('Opps', 'You have already approved.');
                        }
                      },
                      child: MyText(
                        text: 'Approve',
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondarytext,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        right: 30,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Column(
                    children: [
                      MyText(
                        width: double.infinity,
                        text:
                            'Available Balance:  ${contract.bscNative.balance} SEL v1',
                        fontWeight: FontWeight.bold,
                        color: isDarkTheme
                            ? AppColors.darkSecondaryText
                            : AppColors.textColor,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        bottom: 20.0,
                        top: 16.0,
                        left: 16.0,
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: isDarkTheme
                              ? hexaCodeToColor(AppColors.darkCard)
                              : hexaCodeToColor(AppColors.whiteHexaColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                                8.0), //                 <--- border radius here
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: 150,
                                width: double.infinity,
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: isDarkTheme
                                      ? hexaCodeToColor(AppColors.darkBgd)
                                      : hexaCodeToColor(
                                          AppColors.whiteColorHexa),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                        8.0), //                 <--- border radius here
                                  ),
                                ),
                                child: Form(
                                  key: _swapKey,
                                  child: Column(
                                    children: [
                                      MyText(
                                        width: double.infinity,
                                        text: 'Amount',
                                        fontWeight: FontWeight.bold,
                                        color: isDarkTheme
                                            ? AppColors.darkSecondaryText
                                            : AppColors.textColor,
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        bottom: 4.0,
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.bottomLeft,
                                          child: TextFormField(
                                            controller: _amountController,
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.done,
                                            style: TextStyle(
                                                color: isDarkTheme
                                                    ? hexaCodeToColor(AppColors
                                                        .whiteColorHexa)
                                                    : hexaCodeToColor(
                                                        AppColors.textColor),
                                                fontSize: 18.0),
                                            decoration: InputDecoration(
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  fetchMax();
                                                },
                                                child: MyText(
                                                  textAlign: TextAlign.left,
                                                  text: 'Max',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColors.secondarytext,
                                                ),
                                              ),
                                              prefixIconConstraints:
                                                  BoxConstraints(
                                                minWidth: 0,
                                                minHeight: 0,
                                              ),
                                              border: InputBorder.none,
                                              hintText: '0.00',
                                              hintStyle: TextStyle(
                                                fontSize: 20.0,
                                                color: isDarkTheme
                                                    ? hexaCodeToColor(AppColors
                                                        .darkSecondaryText)
                                                    : hexaCodeToColor(
                                                            AppColors.textColor)
                                                        .withOpacity(0.3),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.all(
                                                      0), // Default padding =
                                            ),
                                            validator: (value) => value.isEmpty
                                                ? 'Please fill in amount'
                                                : null,

                                            /* Limit Length Of Text Input */
                                            onChanged: null,
                                            onFieldSubmitted: (value) {},
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              MyFlatButton(
                                edgeMargin:
                                    const EdgeInsets.only(bottom: 16, top: 42),
                                textButton: 'Swap',
                                action: () async {
                                  if (_swapKey.currentState.validate()) {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);

                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }

                                    validateSwap();

                                    // successDialog('');

                                  }
                                },
                              ),
                              SwapDescription(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (_success == false)
                Container()
              else
                BackdropFilter(
                  // Fill Blur Background
                  filter: ImageFilter.blur(
                    sigmaX: 5.0,
                    sigmaY: 5.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: CustomAnimation.flareAnimation(
                          flareController,
                          "assets/animation/check.flr",
                          "Checkmark",
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          )),
    );
  }

  void fetchMax() async {
    final contract = Provider.of<ContractProvider>(context, listen: false);
    contract.getBscBalance();

    setState(() {
      _amountController.value = TextEditingValue(
          text: contract.bscNative.balance,
          selection: TextSelection(
            baseOffset: contract.bscNative.balance.length,
            extentOffset: contract.bscNative.balance.length,
          ));
    });
  }
}
