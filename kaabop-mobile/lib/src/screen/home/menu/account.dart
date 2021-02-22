import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/storage/types/keyPairData.dart';
import 'package:wallet_apps/src/components/component.dart';
import 'package:wallet_apps/src/components/route_animation.dart';
import 'package:wallet_apps/src/models/contract.m.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/screen/home/menu/account_c.dart';
import '../../../../index.dart';

class Account extends StatefulWidget {
  final WalletSDK sdk;
  final keyring;
  final CreateAccModel sdkModel;

  Account(this.sdk, this.keyring, this.sdkModel);
  static const route = '/account';
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  KeyPairData _currentAcc;
  TextEditingController _pinController = TextEditingController();
  TextEditingController _oldPinController = TextEditingController();
  TextEditingController _newPinController = TextEditingController();

  GlobalKey<FormState> _changePinKey = GlobalKey<FormState>();
  GlobalKey<FormState> _backupKey = GlobalKey<FormState>();

  FocusNode _pinNode = FocusNode();
  FocusNode _oldNode = FocusNode();
  FocusNode _newNode = FocusNode();
  bool _loading = false;

  String onChanged(String value) {
    _changePinKey.currentState.validate();
    _backupKey.currentState.validate();
    return value;
  }

  String onChangedBackup(String value) {
    _backupKey.currentState.validate();
    return value;
  }

  String onSubmit(String value) {
    return value;
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

  void deleteAccout() async {
    await dialog(context, Text('Are you sure to delete your account?'),
        Text('Delete Account'),
        action: FlatButton(onPressed: _deleteAccount, child: Text('Delete')));
  }

  Future<void> _deleteAccount() async {
    try {
      await widget.sdk.api.keyring.deleteAccount(
        widget.keyring,
        _currentAcc,
      );
      Navigator.pop(context);
      AppServices.clearStorage();
      widget.sdkModel.contractModel = ContractModel();
      Navigator.pushAndRemoveUntil(context,
          RouteAnimation(enterPage: Welcome()), ModalRoute.withName('/'));
    } catch (e) {
      await dialog(context, Text(e.toString()), Text('Opps'));
    }
  }

  Future<void> getBackupKey(String pass) async {
    Navigator.pop(context);
    try {
      final pairs = await KeyringPrivateStore()
          .getDecryptedSeed('${widget.keyring.keyPairs[0].pubKey}', pass);
      print(pairs);

      if (pairs['seed'] != null) {
        await dialog(
            context,
            GestureDetector(
                onTap: () {
                  copyToClipBoard(pairs['seed'], context);
                },
                child: Text(pairs['seed'])),
            Text('Backup Key'));
      } else {
        await dialog(context, Text('Incorrect Pin'), Text('Backup Key'));
      }
    } catch (e) {
      await dialog(context, Text(e.toString()), Text('Opps'));
    }
    _pinController.text = '';
  }

  Future<void> _changePin(String oldPass, String newPass) async {
    Navigator.pop(context);
    setState(() {
      _loading = true;
    });
    final res = await widget.sdk.api.keyring
        .changePassword(widget.keyring, oldPass, newPass);
    print(res);
    if (res != null) {
      await dialog(
          context, Text('You pin has changed!!'), Text('Change Pin'));
    } else {
      await dialog(context, Text('Change Failed'), Text('Opps'));
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
    ).then((value) => {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Copied to Clipboard'),
              duration: Duration(seconds: 3),
            ),
          ),
        });
  }

  @override
  void initState() {
    _currentAcc = widget.keyring.keyPairs[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Column(
                    children: [
                      MyAppBar(
                        title: "Account",
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
                            color: hexaCodeToColor(AppColors.cardColor),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 25, bottom: 25),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: hexaCodeToColor(AppColors.cardColor),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(right: 16),
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: SvgPicture.asset(
                                              'assets/male_avatar.svg'),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: '${_currentAcc.name}',
                                              color: "#FFFFFF",
                                              fontSize: 20,
                                            ),
                                            Container(
                                              width: 100,
                                              child: MyText(
                                                text: "Indracore",
                                                color: AppColors.secondary_text,
                                                fontSize: 18,
                                                textAlign: TextAlign.start,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(child: Container()),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(
                                    right: 16, left: 16, bottom: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Builder(
                                      builder: (context) => GestureDetector(
                                        onTap: () {
                                          copyToClipBoard(
                                              _currentAcc.pubKey, context);
                                        },
                                        child: Row(
                                          children: [
                                            MyText(
                                              text: 'Public Key:  ',
                                              color: "#FFFFFF",
                                              fontSize: 18,
                                            ),
                                            SizedBox(height: 50),
                                            Expanded(
                                              child: MyText(
                                                text: '${_currentAcc.pubKey}',
                                                color: "#FFFFFF",
                                                fontSize: 18,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Builder(
                                      builder: (context) => GestureDetector(
                                        onTap: () {
                                          copyToClipBoard(
                                              _currentAcc.address, context);
                                        },
                                        child: Row(
                                          children: [
                                            MyText(
                                              text: 'Address:  ',
                                              color: "#FFFFFF",
                                              fontSize: 18,
                                            ),
                                            Expanded(
                                              child: MyText(
                                                text: '${_currentAcc.address}',
                                                color: "#FFFFFF",
                                                fontSize: 18,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //child: SvgPicture.asset('assets/male_avatar.svg'),
                              ),
                              SizedBox(height: 40),
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
                                  margin: EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 70,
                                  child: MyText(
                                    text: 'Backup Key',
                                    color: "#FFFFFF",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  //child: SvgPicture.asset('assets/male_avatar.svg'),
                                ),
                              ),
                              SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  AccountC().showChangePin(
                                    context,
                                    _changePinKey,
                                    _oldPinController,
                                    _newPinController,
                                    _oldNode,
                                    _newNode,
                                    onChanged,
                                    onSubmit,
                                    submitChangePin,
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 70,
                                  child: MyText(
                                    text: 'Change Pin',
                                    color: "#FFFFFF",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  //child: SvgPicture.asset('assets/male_avatar.svg'),
                                ),
                              ),
                              SizedBox(height: 20),
                              GestureDetector(
                                onTap: deleteAccout,
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 70,
                                  child: MyText(
                                    text: 'Delete Account',
                                    color: "#FF0000",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  //child: SvgPicture.asset('assets/male_avatar.svg'),
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
