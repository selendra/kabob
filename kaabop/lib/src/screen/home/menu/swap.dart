import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';

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
            enableAnimation();
          }
        }
      } catch (e) {
        Navigator.pop(context);
        await customDialog('Opps', e.message.toString());
      }
    });
  }

  Future<void> swap(String amount) async {
    final contract = Provider.of<ContractProvider>(context, listen: false);

    if (double.parse(amount) > double.parse(contract.bscNative.balance) ||
        double.parse(contract.bscNative.balance) == 0) {
      await customDialog(
          'Insufficient Balance', 'Your loaded balance is not enough to swap.');
    } else {
      await dialogBox().then((value) async {
        try {
          final res = await getPrivateKey(value);

          if (res != null) {
            dialogLoading(context);
            final hash = await contract.swap(amount, res);
            if (hash != null) {
              setState(() {});
              _amountController.text = '';
              contract.getBscBalance();
              Navigator.pop(context);
              enableAnimation();
            }
          }
        } catch (e) {
          Navigator.pop(context);
          await customDialog('Opps', e.message.toString());
        }
      });
    }
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

  Future enableAnimation() async {
    setState(() {
      _success = true;
    });
    flareController.play('Checkmark');

    Timer(const Duration(milliseconds: 2500), () {
      // Navigator.pop(context);
      setState(() {
        _success = false;
      });
      // Navigator.pushNamedAndRemoveUntil(
      //     context, Home.route, ModalRoute.withName('/'));
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

    return Scaffold(
      backgroundColor: isDarkTheme
          ? hexaCodeToColor(AppColors.darkBgd)
          : hexaCodeToColor(AppColors.whiteColorHexa),
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
                        : hexaCodeToColor(AppColors.cardColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 16.0),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: isDarkTheme
                              ? hexaCodeToColor(AppColors.darkCard)
                              : hexaCodeToColor(AppColors.cardColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                                8.0), //                 <--- border radius here
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              width: double.infinity,
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: isDarkTheme
                                    ? hexaCodeToColor(AppColors.darkBgd)
                                    : hexaCodeToColor(AppColors.cardColor),
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
                                          textInputAction: TextInputAction.done,
                                          style: TextStyle(
                                              color: isDarkTheme
                                                  ? hexaCodeToColor(
                                                      AppColors.whiteColorHexa)
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
                                                color: AppColors.secondarytext,
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
                              action: () {
                                if (_swapKey.currentState.validate()) {
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);

                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  swap(_amountController.text);
                                }

                                //Navigator.pushNamed(context, AppText.importAccView);
                              },
                            ),
                            MyFlatButton(
                              edgeMargin: const EdgeInsets.only(bottom: 16),
                              textButton: 'Approve',
                              action: () {
                                approve();
                                //Navigator.pushNamed(context, AppText.importAccView);
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  MyText(
                    width: double.infinity,
                    text: 'The SEL Token v2 features:',
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme
                        ? AppColors.whiteColorHexa
                        : AppColors.textColor,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    bottom: 4.0,
                    top: 32.0,
                    left: 16.0,
                  ),
                  MyText(
                    width: double.infinity,
                    text:
                        '🚀 Token contract verification and other related informations to SEL token v2, all available on BSCscan like Whitepaper, Social Channels and other official info.',
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme
                        ? AppColors.darkSecondaryText
                        : AppColors.textColor,
                    fontSize: 14.0,
                    textAlign: TextAlign.start,
                    bottom: 4.0,
                    top: 16.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  MyText(
                    width: double.infinity,
                    text:
                        '🚀 For future cross-chains transaction; this version is designed to work with others chains like Polygon, Ethereum and other networks.',
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme
                        ? AppColors.darkSecondaryText
                        : AppColors.textColor,
                    fontSize: 14.0,
                    textAlign: TextAlign.start,
                    bottom: 4.0,
                    top: 16.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  MyText(
                    width: double.infinity,
                    text:
                        '🚀 Use the Token to purchase invitations and share the referral link to join Selendra airdrop opportunity.',
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme
                        ? AppColors.darkSecondaryText
                        : AppColors.textColor,
                    fontSize: 14.0,
                    textAlign: TextAlign.start,
                    bottom: 4.0,
                    top: 16.0,
                    left: 16.0,
                    right: 16.0,
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
