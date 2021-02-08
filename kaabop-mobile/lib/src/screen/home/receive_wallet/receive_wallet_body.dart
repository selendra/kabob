import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/index.dart';

class ReceiveWalletBody extends StatelessWidget {
  final GlobalKey keyQrShare;
  final GlobalKey<ScaffoldState> globalKey;
  final HomeModel homeM;
  final GetWalletMethod method;
  final String name;
  final String wallet;

  ReceiveWalletBody({
    this.keyQrShare,
    this.globalKey,
    this.homeM,
    this.method,
    this.name,
    this.wallet,
  });

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MyAppBar(
          title: "Receive wallet",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        wallet == 'wallet address'
            ? Expanded(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/no_data.svg', height: 200),
                  MyText(text: "There are no wallet found")
                ],
              ))
            : Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          bottom: 45.0,
                          left: 16.0,
                          right: 16.0,
                          top: 16.0,
                        ),
                        width: double.infinity,
                        child: RepaintBoundary(
                          key: keyQrShare,
                          child: Container(
                              padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: hexaCodeToColor(AppColors.cardColor),
                                  ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  qrCodeGenerator(wallet,
                                      AppConfig.logoQrEmbedded, keyQrShare),
                                  MyText(
                                    text: name,
                                    bottom: 16,
                                    top: 16,
                                    // color: "#FFFFFF",
                                  ),
                                  MyText(
                                    width: 300,
                                    text: wallet,
                                    color: AppColors.secondary_text,
                                    fontSize: 16,
                                    bottom: 16,
                                  ),
                                  MyText(
                                    text:
                                        "Scan the qr code to perform transaction",
                                    fontSize: 16,
                                  ),
                                ],
                              )),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 21),
                          child: FlatButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.share,
                                    color: Colors.white, size: 30),
                                Container(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: MyText(
                                      text: "SHARE MY CODE", color: "#FFFFFF"),
                                )
                              ],
                            ),
                            onPressed: () {
                              method.qrShare(keyQrShare, wallet);
                            },
                          )),
                      FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.content_copy,
                                color: Colors.white, size: 30),
                            Container(
                                padding: EdgeInsets.only(left: 10.0),
                                child: MyText(
                                    text: "COPY ADDRESS", color: "#FFFFFF"))
                          ],
                        ),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: wallet)); /* Copy Text */
                          method.snackBar('Copied', globalKey);
                        },
                      )
                    ],
                  ),
                ),
              )
      ],
    );
  }
}
