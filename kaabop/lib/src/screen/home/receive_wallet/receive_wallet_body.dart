import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/reuse_dropdown.dart';

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Container(
                  margin: const EdgeInsets.only(
                    bottom: 45.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  width: double.infinity,
                  child: RepaintBoundary(
                    key: keyQrShare,
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 30.0,
                        bottom: 30.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54.withOpacity(0.3),
                            blurRadius: 8.0,
                            spreadRadius: 2.0,
                            offset: const Offset(0, 3.0),
                          )
                        ],
                        color: isDarkTheme
                          ? hexaCodeToColor(AppColors.darkCard)
                          : hexaCodeToColor(AppColors.whiteHexaColor),
                      ),
                      child: Column(
                        children: [

                          Stack(
                            children: [
                              Align(
                                child: Container(
                                  padding: const EdgeInsets.only(top: 14.0),
                                  margin: const EdgeInsets.only(bottom: 36.0),
                                  child: MyText(
                                    text: 'Wallet',
                                    fontSize: 20.0,
                                    color: isDarkTheme
                                      ? AppColors.whiteColorHexa
                                      : AppColors.textColor,
                                  ),
                                ),
                              ),
                              if (assetInfo != null)
                                Container()
                              else
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.only(right: 16.0),
                                    margin:
                                        const EdgeInsets.only(bottom: 36.0),
                                    child: Consumer<WalletProvider>(
                                      builder: (context, value, child) {
                                        return ReuseDropDown(
                                          initialValue: initialValue,
                                          onChanged: onChanged,
                                          
                                          itemsList: value.listSymbol,
                                          style: TextStyle(
                                            color: isDarkTheme
                                                ? hexaCodeToColor(
                                                    AppColors.darkSecondaryText)
                                                : hexaCodeToColor(
                                                    AppColors.textColor,
                                                  ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),

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
