import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/dimissible_background.dart';
import 'package:wallet_apps/src/components/route_animation.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/models/portfolio_cus.dart';
import 'package:wallet_apps/src/models/profile_card.dart';

import 'asset_info/asset_info.dart';

class HomeBody extends StatelessWidget {
  final HomeModel homeM;
  final PortfolioM portfolioM;
  final PortfolioRateModel portfolioRateM;
  final List<Color> pieColorList;
  final Map<String, double> dataMap;
  final CreateAccModel sdkModel;
  final Function balanceOf;
  final Function onDismiss;

  HomeBody(
      {this.homeM,
      this.portfolioM,
      this.portfolioRateM,
      this.pieColorList,
      this.dataMap,
      this.sdkModel,
      this.balanceOf,
      this.onDismiss});

  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ProfileCard(sdkModel),
              PortFolioCus(homeM, portfolioM, pieColorList, dataMap),
              Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 5,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: hexaCodeToColor(AppColors.secondary)),
                      ),
                      MyText(
                        text: 'Assets',
                        fontSize: 27,
                        color: "#FFFFFF",
                        left: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AddAsset.route);
                        },
                        child: Container(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      )),
                    ],
                  )),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  //balanceOf();
                  Navigator.push(
                    context,
                    RouteAnimation(
                      enterPage: AssetInfo(
                        sdkModel: sdkModel,
                        assetLogo: sdkModel.nativeToken,
                        balance: sdkModel.nativeBalance,
                        tokenSymbol: sdkModel.nativeSymbol,
                      ),
                    ),
                  );
                },
                child: portFolioItemRow(
                    sdkModel.nativeToken,
                    sdkModel.nativeSymbol,
                    sdkModel.nativeOrg,
                    sdkModel.nativeBalance,
                    Colors.white),
              ),
              sdkModel.contractModel.pHash != ''
                  ? Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: DismissibleBackground(),
                      onDismissed: (direct) {
                        onDismiss();
                      },
                      child: GestureDetector(
                        onTap: () {
                          // balanceOf();
                          Navigator.push(
                            context,
                            RouteAnimation(
                              enterPage: AssetInfo(
                                sdkModel: sdkModel,
                                assetLogo: sdkModel.contractModel.ptLogo,
                                balance: sdkModel.contractModel.pBalance,
                                tokenSymbol:
                                    sdkModel.contractModel.pTokenSymbol,
                              ),
                            ),
                          );
                        },
                        child: portFolioItemRow(
                            sdkModel.contractModel.ptLogo,
                            sdkModel.contractModel.pTokenSymbol,
                            sdkModel.contractModel.pOrg,
                            sdkModel.contractModel.pBalance,
                            Colors.black),
                      ),
                    )
                  : Container(),
            ],
          ),
        )
      ],
    );
  }

  //hexaCodeToColor(AppColors.secondary)

  Widget portFolioItemRow(String asset, String tokenSymbol, String org,
      String balance, Color color) {
    return rowDecorationStyle(
        child: Row(
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          padding: EdgeInsets.all(6),
          margin: EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(40)),
          child: Image.asset(asset),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: tokenSymbol,
                  color: "#FFFFFF",
                  fontSize: 18,
                ),
                MyText(text: org, fontSize: 15),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                    width: double.infinity,
                    text: balance, //portfolioData[0]["data"]['balance'],
                    color: "#FFFFFF",
                    fontSize: 18,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ],
    ));
  }

// Portfolow Row Decoration
  Widget rowDecorationStyle(
      {Widget child, double mTop: 0, double mBottom = 16}) {
    return Container(
        margin: EdgeInsets.only(top: mTop, left: 16, right: 16, bottom: 16),
        padding: EdgeInsets.fromLTRB(15, 9, 15, 9),
        height: 90,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 2.0,
                offset: Offset(1.0, 1.0))
          ],
          color: hexaCodeToColor(AppColors.cardColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child);
  }
}
