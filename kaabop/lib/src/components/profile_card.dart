import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';

class ProfileCard extends StatelessWidget {
  final CreateAccModel sdkModel;
  const ProfileCard(this.sdkModel);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Account.route);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 25,
          bottom: 25,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: hexaCodeToColor(AppColors.cardColor),
        ),
        child: Consumer<ApiProvider>(
          builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(right: 16),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: value.accountM.addressIcon == null
                          ? Container()
                          : SvgPicture.string(
                              value.accountM.addressIcon,
                            ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: value.accountM.name ?? '',
                          color: "#FFFFFF",
                          fontSize: 20,
                        ),
                        SizedBox(
                          width: 100,
                          child: MyText(
                            text: !value.isConnected ? "" : "Indracore",
                            color: AppColors.secondarytext,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    if (!value.isConnected)
                      Container()
                    else
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          width: 150,
                          child: MyText(
                            text: '', //sdkModel.nativeBalance,
                            fontSize: 30,
                            color: AppColors.secondarytext,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: value.accountM.address),
                    ).then(
                      (value) => {
                        // ignore: deprecated_member_use
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Copied to Clipboard'),
                          ),
                        )
                      },
                    );
                  },
                  child: MyText(
                    top: 16,
                    width: 300,
                    text: value.accountM.address ?? "",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
