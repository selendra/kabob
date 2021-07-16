import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/components/component.dart';
import 'package:wallet_apps/src/screen/home/menu/account_c.dart';
import '../../../../index.dart';

class Account extends StatefulWidget {
  //static const route = '/account';
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  KeyPairData _currentAcc;
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _oldPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();

  final GlobalKey<FormState> _changePinKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _backupKey = GlobalKey<FormState>();

  final FocusNode _pinNode = FocusNode();
  final FocusNode _oldNode = FocusNode();
  final FocusNode _newNode = FocusNode();
  bool _loading = false;

  String onChanged(String value) {
    _backupKey.currentState.validate();
    return value;
  }

  String onChangedChangePin(String value) {
    _changePinKey.currentState.validate();
    return value;
  }

  String onChangedBackup(String value) {
    _backupKey.currentState.validate();
    return value;
  }

  Future<void> onSubmit() async {
    if (_backupKey.currentState.validate()) {
      await getBackupKey(_pinController.text);
    }
  }

  void onSubmitChangePin() {
    submitChangePin();
  }

  void submitBackUpKey() {
    if (_pinController.text != null) {
      getBackupKey(_pinController.text);
    }
  }

  void submitChangePin() {
    if (_oldPinController.text != null && _newPinController.text != null) {
      _changePin(_oldPinController.text, _newPinController.text);
    }
  }

  // Future<void> dialog(BuildContext context, String text1, String text2,
  //     {Widget action}) async {
  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  //         title: Align(
  //           child: Text(text1),
  //         ),
  //         content: Padding(
  //           padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
  //           child: Text(text2),
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('Close'),
  //           ),
  //           action
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> deleteAccout() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          // title: const Align(
          //   child: Text('Are you sure to delete your account'),
          // ),
          content: const Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Text('Are you sure to delete your account'),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            FlatButton(
              onPressed: _deleteAccount,
              child: const Text('Delete'),
            ),
            // action
          ],
        );
      },
    );

    // await dialog(
    //   context,
    //   'Are you sure to delete your account?',
    //   'Delete Account',
    //   // ignore: deprecated_member_use
    //   action: FlatButton(
    //     onPressed: _deleteAccount,
    //     child: const Text('Delete'),
    //   ),
    // );
  }

  Future<void> _deleteAccount() async {
    try {
      await ApiProvider.sdk.api.keyring.deleteAccount(
        ApiProvider.keyring,
        _currentAcc,
      );
      Navigator.pop(context);
      AppServices.clearStorage();
      StorageServices().clearSecure();
      //Provider.of<WalletProvider>(context, listen: false).resetDatamap();
      Provider.of<WalletProvider>(context, listen: false).clearPortfolio();
      Provider.of<ContractProvider>(context, listen: false).resetConObject();
      Navigator.pushAndRemoveUntil(context,
          RouteAnimation(enterPage: Welcome()), ModalRoute.withName('/'));
    } catch (e) {
      // await dialog(context, e.toString(), 'Opps');
    }
  }

  Future<void> getBackupKey(String pass) async {
    Navigator.pop(context);
    try {
      final pairs = await KeyringPrivateStore()
          .getDecryptedSeed(ApiProvider.keyring.keyPairs[0].pubKey, pass);

      if (pairs['seed'] != null) {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Align(
                child: Text('Backup Key'),
              ),
              content: Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Text(pairs['seed'].toString()),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
                // action
              ],
            );
          },
        );

        // await dialog(
        //   context,
        //   pairs['seed'].toString(),
        //   'Backup Key',
        // );
      } else {
        //await dialog(context, 'Incorrect Pin', 'Backup Key');
      }
    } catch (e) {
      //await dialog(context, e.toString(), 'Opps');
    }
    _pinController.text = '';
  }

  Future<void> _changePin(String oldPass, String newPass) async {
    Navigator.pop(context);
    setState(() {
      _loading = true;
    });
    final res = await ApiProvider.sdk.api.keyring
        .changePassword(ApiProvider.keyring, oldPass, newPass);
    if (res != null) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: const Align(
              child: Text('Change Pin'),
            ),
            content: const Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text('You pin has changed!!'),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              // action
            ],
          );
        },
      );

      // await dialog(
      //   context,
      //   'You pin has changed!!',
      //   'Change Pin',
      // );
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: const Align(
              child: Text('Opps'),
            ),
            content: const Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text('Change Failed!!'),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              // action
            ],
          );
        },
      );

      // await dialog(
      //   context,
      //   'Change Failed',
      //   'Opps',
      // );

      setState(() {
        _loading = false;
      });
    }
    setState(() {
      _loading = false;
    });
    _oldPinController.text = '';
    _newPinController.text = '';
  }

  void copyToClipBoard(String text, BuildContext context) {
    Clipboard.setData(
      ClipboardData(
        text: text,
      ),
    ).then(
      (value) => {
        // ignore: deprecated_member_use
        Scaffold.of(context).showSnackBar(
          const SnackBar(
            content: Text('Copied to Clipboard'),
            duration: Duration(seconds: 3),
          ),
        ),
      },
    );
  }

  @override
  void initState() {
    _currentAcc = ApiProvider.keyring.keyPairs[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Column(
                    children: [
                      MyAppBar(
                        title: "Account",
                        color: isDarkTheme
                            ? hexaCodeToColor(AppColors.darkCard)
                            : hexaCodeToColor(AppColors.cardColor),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: isDarkTheme
                                ? hexaCodeToColor(AppColors.darkCard)
                                : hexaCodeToColor(AppColors.cardColor),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 25,
                                  bottom: 25,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: isDarkTheme
                                      ? hexaCodeToColor(AppColors.darkCard)
                                      : hexaCodeToColor(AppColors.cardColor),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Consumer<ApiProvider>(
                                          builder: (context, value, child) {
                                            return Container(
                                              alignment: Alignment.centerLeft,
                                              margin: const EdgeInsets.only(
                                                right: 16,
                                              ),
                                              width: 70,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: SvgPicture.string(
                                                value.accountM.addressIcon,
                                              ),
                                            );
                                          },
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: _currentAcc.name,
                                              color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
                                              fontSize: 20,
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  AccountC().showBackup(
                                    context,
                                    _backupKey,
                                    _pinController,
                                    _pinNode,
                                    onChangedBackup,
                                    onSubmit,
                                    submitBackUpKey,
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 70,
                                  child:  MyText(
                                    text: 'Backup Key',
                                   color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  AccountC().showChangePin(
                                    context,
                                    _changePinKey,
                                    _oldPinController,
                                    _newPinController,
                                    _oldNode,
                                    _newNode,
                                    onChangedChangePin,
                                    onSubmitChangePin,
                                    submitChangePin,
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 70,
                                  child: MyText(
                                    text: 'Change Pin',
                                    color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: deleteAccout,
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 70,
                                  child: const MyText(
                                    text: 'Delete Account',
                                    color: "#FF0000",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
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
