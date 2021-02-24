import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/main/contents_backup.dart';
import 'package:wallet_apps/src/screen/main/import_account/import_acc.dart';
import '../import_account/import_acc.dart';

class WelcomeBody extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Container(
          padding: const EdgeInsets.only(
            left: 42,
            right: 16,
            bottom: 16,
          ),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: MyText(
                    text: AppText.welcome,
                    fontSize: 22,
                    color: AppColors.whiteColorHexa,
                  )),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: MyText(
                      text: AppText.appName,
                      fontSize: 38,
                      fontWeight: FontWeight.w500,
                      color: AppColors.whiteColorHexa,
                    )),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
        ),
        SvgPicture.asset(
          'assets/undraw_wallet.svg',
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.2,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
        ),
        Column(
          children: [
            MyFlatButton(
              edgeMargin: EdgeInsets.only(left: 42, right: 42, bottom: 16),
              textButton: AppText.createAccTitle,
              action: () {
                Navigator.pushNamed(context, ContentsBackup.route);
              },
            ),
            MyFlatButton(
              edgeMargin: EdgeInsets.only(left: 42, right: 42, bottom: 16),
              textButton: AppText.importAccTitle,
              action: () {
                Navigator.pushNamed(context, ImportAcc.route);
              },
            )
          ],
        ),
      ],
    );
    // return Stack(
    //   children: [
    // Image.asset(
    //     'assets/kabob_logo.png',
    //     width: 200,
    //     height: 200,
    //   ),
    //     Positioned(
    //       bottom: 30,
    //       width: MediaQuery.of(context).size.width,
    //       child: Column(
    //         children: [
    //           MyFlatButton(
    //             // width: 100,
    //             edgeMargin: EdgeInsets.only(left: 66, right: 66, bottom: 16),
    //             textButton: 'Create Account',
    //             action: () {
    //               Navigator.pushNamed(context, ContentsBackup.route);
    //             },
    //           ),
    //           MyFlatButton(
    //             edgeMargin: EdgeInsets.only(left: 66, right: 66, bottom: 16),
    //             textButton: 'Import Account',
    //             action: () {
    //               Navigator.pushNamed(context, ImportAcc.route);
    //             },
    //           )
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
