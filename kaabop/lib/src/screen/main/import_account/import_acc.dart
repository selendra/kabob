import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/m_import_acc.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import 'package:wallet_apps/src/screen/main/import_account/import_acc_body.dart';
import 'package:wallet_apps/src/screen/main/import_user_info/import_user_infor.dart';

class ImportAcc extends StatefulWidget {

  static const route = '/import';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        body: BodyScaffold(
          height: MediaQuery.of(context).size.height,
          child: ImportAccBody(
            importAccModel: _importAccModel,
            onChanged: onChanged,
            onSubmit: submit,
            clearInput: clearInput,
            enable: enable,
            submit: submit,
          ),
        ) //welcomeBody(context, navigatePage),
        );
  }
}
