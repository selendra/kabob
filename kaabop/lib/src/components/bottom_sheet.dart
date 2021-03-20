import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';

class MyBottomSheet {
  dynamic response;

  Future<dynamic> trxOptions({
    BuildContext context,
    List portfolioList,
    WalletSDK sdk,
    Keyring keyring,
    CreateAccModel sdkModel,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: hexaCodeToColor(AppColors.bgdColor),
          ),
          height: 153,
          child: Column(
            children: [
              const Align(
                child: MyText(
                  color: "#FFFFFF",
                  top: 20,
                  bottom: 33,
                  text: "Transaction options",
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyBottomSheetItem(
                      subTitle: "Scan wallet",
                      icon: "icons/qr_code.svg",
                      action: () async {
                        try {
                          await TrxOptionMethod.scanQR(
                            context,
                            portfolioList,
                          );
                        } catch (e) {
                          //  print(e.message);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: MyBottomSheetItem(
                      icon: "icons/form.svg",
                      subTitle: "Fill wallet",
                      action: () {
                        TrxOptionMethod.navigateFillAddress(
                          context,
                          portfolioList,
                          sdk,
                          keyring,
                          sdkModel,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: MyBottomSheetItem(
                      icon: "icons/contact.svg",
                      subTitle: "Invite friend",
                      action: () async {
                        // TrxOptionMethod.selectContact(
                        //     context, portfolioList);
                        await dialog(
                          context,
                          const Text('Coming Soon !'),
                          const Text('Invite friend'),
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> notification({BuildContext context}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(color: hexaCodeToColor(AppColors.bgdColor)),
          height: MediaQuery.of(context).size.height - 107,
          child: Column(
            children: [
              const Align(
                child: MyText(
                  color: "#FFFFFF",
                  top: 20,
                  bottom: 33,
                  text: "Notification",
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/no_data.svg', height: 200),
                    const MyText(text: "There are no notification found")
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
