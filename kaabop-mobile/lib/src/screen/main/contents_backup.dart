import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/screen/main/create_mnemoic.dart';

class ContentsBackup extends StatefulWidget {
  CreateAccModel createAccM;

  ContentsBackup(CreateAccModel createAccModel) {
    this.createAccM = createAccModel;
  }

  static const route = '/contentsBackup';

  @override
  _ContentsBackupState createState() => _ContentsBackupState();
}

class _ContentsBackupState extends State<ContentsBackup> {
  final double bpSize = 16.0;

  Future<void> _generateMnemonic(WalletSDK sdk) async {
    widget.createAccM.mnemonic = '';
    widget.createAccM.mnemonicList = [];

    widget.createAccM.mnemonic = await sdk.api.keyring.generateMnemonic();
    widget.createAccM.mnemonicList = widget.createAccM.mnemonic.split(' ');
    setState(() {});
  }

  @override
  initState() {
    _generateMnemonic(widget.createAccM.sdk);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyScaffold(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          MyAppBar(
            color: hexaCodeToColor(AppColors.cardColor),
            title: AppText.createAccTitle,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(
                      text: AppText.backup,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColorHexa,
                      bottom: bpSize,
                    )),
                MyText(
                  textAlign: TextAlign.left,
                  text: AppText.getMnemonic,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.whiteColorHexa,
                  bottom: bpSize,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(
                      text: AppText.backupMnemonic,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColorHexa,
                      bottom: bpSize,
                    )),
                MyText(
                  textAlign: TextAlign.left,
                  text: AppText.keepMnemonic,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.whiteColorHexa,
                  bottom: bpSize,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(
                      text: AppText.offlineStorage,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColorHexa,
                      bottom: bpSize,
                    )),
                MyText(
                  textAlign: TextAlign.left,
                  text: AppText.mnemonicAdvise,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.whiteColorHexa,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          MyFlatButton(
            edgeMargin: EdgeInsets.only(left: 66, right: 66, bottom: 16),
            textButton: AppText.next,
            action: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CreateMnemonic(accModel: widget.createAccM)));
            },
          )
        ],
      ),
    ));
  }
}
