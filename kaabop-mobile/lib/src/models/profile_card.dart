import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';

class ProfileCard extends StatelessWidget {
  final CreateAccModel sdkModel;
  ProfileCard(this.sdkModel);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(right: 16),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: SvgPicture.asset(
                    'assets/male_avatar.svg',
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: sdkModel.userModel.username,
                      color: "#FFFFFF",
                      fontSize: 20,
                    ),
                    Container(
                      width: 100,
                      child: MyText(
                        text: !sdkModel.apiConnected
                            ? "Connecting to Remote Node"
                            : "Indracore",
                        color: AppColors.secondary_text,
                        fontSize: 18,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Expanded(child: Container()),
                !sdkModel.apiConnected
                    ? Container()
                    : Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: 150,
                          child: MyText(
                            text: '', //sdkModel.nativeBalance,
                            fontSize: 30,
                            color: AppColors.secondary_text,
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
                        ClipboardData(text: sdkModel.userModel.address))
                    .then((value) => {
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Copied to Clipboard')))
                        });
              },
              child: MyText(
                top: 16,
                width: 300,
                text: sdkModel.userModel.address ?? "address",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
