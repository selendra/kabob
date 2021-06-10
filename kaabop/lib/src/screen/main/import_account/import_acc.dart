import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:wallet_apps/src/models/m_import_acc.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import 'package:wallet_apps/src/screen/main/import_account/import_acc_body.dart';
import 'package:wallet_apps/src/screen/main/import_user_info/import_user_infor.dart';

class ImportAcc extends StatefulWidget {
  final String reimport;
  const ImportAcc({this.reimport});
  @override
  State<StatefulWidget> createState() {
    return ImportAccState();
  }
}

class ImportAccState extends State<ImportAcc> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  final ImportAccModel _importAccModel = ImportAccModel();

  bool status;
  int currentVersion;

  bool enable = false;

  String tempMnemonic;

  @override
  void initState() {
    AppServices.noInternetConnection(globalKey);
    super.initState();
  }

  String onChanged(String value) {
    validateMnemonic(value).then((value) {
      setState(() {
        enable = value;
      });
    });
    return null;
  }

  Future<bool> validateMnemonic(String mnemonic) async {
    final res = await ApiProvider.sdk.api.keyring.validateMnemonic(mnemonic);
    return res;
  }

  void clearInput() {
    _importAccModel.mnemonicCon.clear();
    setState(() {
      enable = false;
    });
  }

  Future<void> onSubmit() async => submit();

  Future<void> submit() async {
    validateMnemonic(_importAccModel.mnemonicCon.text).then((value) async {
      if (value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImportUserInfo(
              _importAccModel.mnemonicCon.text,
            ),
          ),
        );
      }
    });
  }

  Future<void> onSubmitIm() async {
    if (_importAccModel.formKey.currentState.validate()) {
      reImport();
    }
  }

  Future<void> reImport() async {
    dialogLoading(context);
    final isValidSeed =
        await validateMnemonic(_importAccModel.mnemonicCon.text);
    final isValidPw = await checkPassword(_importAccModel.pwCon.text);

    if (isValidSeed == false) {
      await dialog(
          context, const Text('Invalid seed phrases'), const Text('Opps'));
    }

    if (isValidPw == false) {
      await dialog(
          context, const Text('PIN verification failed'), const Text('Opps'));
    }

    if (isValidSeed && isValidPw) {
      Navigator.pop(context);
      setState(() {
        enable = true;
      });
      final resPk =
          await ApiProvider().getPrivateKey(_importAccModel.mnemonicCon.text);
      if (resPk != null) {
        ContractProvider().extractAddress(resPk);
        final res = await ApiProvider.keyring.store
            .encryptPrivateKey(resPk, _importAccModel.pwCon.text);

        if (res != null) {
          await StorageServices().writeSecure('private', res);
        }
      }

      addBtcWallet();
      
      Provider.of<ContractProvider>(context, listen: false).getEtherAddr();
      Provider.of<ApiProvider>(context, listen: false).connectPolNon();
      Provider.of<ContractProvider>(context, listen: false).getBnbBalance();
      Provider.of<ContractProvider>(context, listen: false).getBscBalance();
      Provider.of<ContractProvider>(context, listen: false).getEtherBalance();
      

      await dialogSuccess(
        context,
        const Text("You haved imported successfully"),
        const Text('Congratulation'),
        // ignore: deprecated_member_use
        action: FlatButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
                context, Home.route, ModalRoute.withName('/'));
          },
          child: const Text('Continue'),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }


  Future<void> addBtcWallet() async{
       final seed = bip39.mnemonicToSeed(_importAccModel.mnemonicCon.text);
        final hdWallet = HDWallet.fromSeed(seed);

        await StorageServices.setData(hdWallet.address, 'btcaddress');
        final res = await ApiProvider.keyring.store
            .encryptPrivateKey(hdWallet.wif, _importAccModel.pwCon.text);

        if (res != null) {
          await StorageServices().writeSecure('btcwif', res);
        }

        Provider.of<ApiProvider>(context, listen: false)
            .getBtcBalance(hdWallet.address);
        Provider.of<ApiProvider>(context, listen: false)
            .isBtcAvailable('contain');

        Provider.of<ApiProvider>(context, listen: false)
            .setBtcAddr(hdWallet.address);
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol('BTC');
  }

  Future<void> isDotContain() async {
    // Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('DOT');
    // Provider.of<ApiProvider>(context, listen: false).isDotContain();
    Provider.of<ApiProvider>(context, listen: false).connectPolNon();
  }

  Future<void> isBnbContain() async {
    // Provider.of<WalletProvider>(context, listen: false).addTokenSymbol('BNB');
    // Provider.of<ContractProvider>(context, listen: false).getBscDecimal();
    Provider.of<ContractProvider>(context, listen: false).getBnbBalance();
  }

  Future<void> isBscContain() async {
    Provider.of<WalletProvider>(context, listen: false)
        .addTokenSymbol('SEL (BEP-20)');
    Provider.of<ContractProvider>(context, listen: false).getSymbol();
    Provider.of<ContractProvider>(context, listen: false)
        .getBscDecimal()
        .then((value) {
      Provider.of<ContractProvider>(context, listen: false).getBscBalance();
    });
  }

  Future<bool> checkPassword(String pin) async {
    final res = await ApiProvider.sdk.api.keyring
        .checkPassword(ApiProvider.keyring.current, pin);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        body: BodyScaffold(
          height: MediaQuery.of(context).size.height,
          child: ImportAccBody(
            reImport: widget.reimport,
            importAccModel: _importAccModel,
            onChanged: widget.reimport != null ? null : onChanged,
            onSubmit: widget.reimport != null ? onSubmitIm : submit,
            clearInput: clearInput,
            enable: enable,
            submit: widget.reimport != null ? onSubmitIm : submit,
          ),
        ) //welcomeBody(context, navigatePage),
        );
  }
}
