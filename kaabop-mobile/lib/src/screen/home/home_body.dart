import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/asset_item.dart';
import 'package:wallet_apps/src/components/portfolio_cus.dart';
import 'package:wallet_apps/src/components/profile_card.dart';
import 'package:wallet_apps/src/components/route_animation.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
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
                        color: AppColors.whiteColorHexa,
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
                  // Navigator.push(
                  //   context,
                  //   RouteAnimation(
                  //     enterPage: AssetInfo(
                  //       sdkModel: sdkModel,
                  //       assetLogo: sdkModel.nativeToken,
                  //       balance: sdkModel.nativeBalance,
                  //       tokenSymbol: sdkModel.nativeSymbol,
                  //     ),
                  //   ),
                  // );
                },
                child: AssetItem(sdkModel.nativeToken, sdkModel.nativeSymbol,
                    sdkModel.nativeOrg, sdkModel.nativeBalance, Colors.white),
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
                        child: AssetItem(
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

}
