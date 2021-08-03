import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/reuse_dropdown.dart';
import 'package:wallet_apps/src/screen/home/receive_wallet/appbar_wallet.dart';

class ReceiveWalletBody extends StatelessWidget {
  final GlobalKey keyQrShare;
  final GlobalKey<ScaffoldState> globalKey;
  final HomeModel homeM;
  final GetWalletMethod method;
  final Function(String) onChanged;
  final String name;
  final String wallet;
  final String initialValue;
  final String assetInfo;

  const ReceiveWalletBody({
    this.keyQrShare,
    this.globalKey,
    this.homeM,
    this.method,
    this.onChanged,
    this.name,
    this.wallet,
    this.initialValue,
    this.assetInfo,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Column(
      children: <Widget>[

        MyAppBar(
          title: "Receive wallet",
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        Expanded(
          child: BodyScaffold(
            isSafeArea: false,
            child: 
            (wallet == 'wallet address') ? Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/no_data.svg', height: 200),
                  const MyText(text: "There are no wallet found")
                ],
              ),
            )
            : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                RepaintBoundary(
                  key: keyQrShare,
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 45.0,
                      left: 16.0,
                      right: 16.0,
                      top: 16.0
                    ),
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        shadow()
                      ],
                      color: isDarkTheme
                        ? hexaCodeToColor(AppColors.darkCard)
                        : hexaCodeToColor(AppColors.whiteHexaColor),
                    ),
                    child: Column(
                      children: [

                        QrViewTitle(
                          assetInfo: assetInfo,
                          initialValue: initialValue,
                          onChanged: onChanged,
                        ),

                        // Qr View
                        qrCodeGenerator(
                          wallet,
                          AppConfig.logoQrEmbedded,
                          keyQrShare,
                        ),

                        MyText(
                          text: name,
                          bottom: 16,
                          top: 16,
                          color: isDarkTheme
                            ? AppColors.whiteColorHexa
                            : AppColors.textColor,
                        ),
                        MyText(
                          width: 300,
                          text: wallet,
                          color: AppColors.secondarytext,
                          fontSize: 16,
                          bottom: 16,
                        ),
                        MyText(
                          text: "Scan the qr code to perform transaction",
                          fontSize: 16,
                          color: isDarkTheme
                            ? AppColors.whiteColorHexa
                            : AppColors.textColor,
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(bottom: 21),
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () {
                      method.qrShare(keyQrShare, wallet);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.share,
                          color: hexaCodeToColor(AppColors.secondary),
                          size: 30,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: const MyText(
                            text: "SHARE MY CODE",
                            color: AppColors.secondary,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: wallet),
                    );
                    /* Copy Text */
                    method.snackBar('Copied', globalKey);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.content_copy,
                        color: hexaCodeToColor(AppColors.secondary),
                        size: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: const MyText(
                          text: "COPY ADDRESS",
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          )
        ),

      ],
    );
  }
}
