import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import 'package:wallet_apps/src/screen/main/create_mnemoic.dart';

class ContentsBackup extends StatefulWidget {
  final CreateAccModel createAccM;

  // ContentsBackup(CreateAccModel createAccModel) {
  //   this.createAccM = createAccModel;
  // }
  const ContentsBackup(this.createAccM);

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
  void initState() {
    _generateMnemonic(ApiProvider.sdk);
    super.initState();
  }

  @override
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
              padding: const EdgeInsets.all(16.0),
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
              edgeMargin:
                  const EdgeInsets.only(left: 66, right: 66, bottom: 16),
              textButton: AppText.next,
              action: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateMnemonic(
                      accModel: widget.createAccM,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
