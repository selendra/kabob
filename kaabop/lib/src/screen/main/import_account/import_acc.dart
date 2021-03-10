import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/models/m_import_acc.dart';
import 'package:wallet_apps/src/screen/main/import_account/import_acc_body.dart';
import 'package:wallet_apps/src/screen/main/import_user_info/import_user_infor.dart';

class ImportAcc extends StatefulWidget {
  final CreateAccModel importAccModel;

  ImportAcc(this.importAccModel);
  static const route = '/import';

  @override
  State<StatefulWidget> createState() {
    return ImportAccState();
  }
}

class ImportAccState extends State<ImportAcc> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  ImportAccModel _importAccModel = ImportAccModel();



  bool status;
  int currentVersion;

  bool enable = false;

  String tempMnemonic;

  var snackBar;

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
  }

  Future<bool> validateMnemonic(String mnemonic) async {
    final res =
        await widget.importAccModel.sdk.api.keyring.validateMnemonic(mnemonic);
    //print(res);
    return res;
  }

  void clearInput() {
    _importAccModel.mnemonicCon.clear();
    setState(() {
      enable = false;
    });
  }

  void onSubmit() async => await submit();

  Future<void> submit() async {
    validateMnemonic(_importAccModel.mnemonicCon.text).then((value) async {
      if (value) {
        setState(() {
          widget.importAccModel.mnemonic = _importAccModel.mnemonicCon.text;
        });
        await Navigator.pushNamed(context, ImportUserInfo.route);
        clearInput();
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        body: BodyScaffold(
          height: MediaQuery.of(context).size.height,
          child: ImportAccBody(
            importAccModel: _importAccModel,
            onChanged: onChanged,
            onSubmit: onSubmit,
            clearInput: clearInput,
            enable: enable,
            submit: submit,
          ),
        ) //welcomeBody(context, navigatePage),
        );
  }
}
