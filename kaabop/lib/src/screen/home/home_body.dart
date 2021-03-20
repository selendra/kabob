import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/asset_item.dart';
import 'package:wallet_apps/src/components/portfolio_cus.dart';
import 'package:wallet_apps/src/components/route_animation.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import 'package:wallet_apps/src/provider/contract_provider.dart';
import 'asset_info/asset_info.dart';
import 'menu/add_asset/search_asset.dart';

class HomeBody extends StatelessWidget {
  final Function balanceOf;
  final Function setPortfolio;

  const HomeBody({this.balanceOf, this.setPortfolio});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        homeAppBar(context),
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                PortFolioCus(),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: hexaCodeToColor(AppColors.secondary),
                        ),
                      ),
                      const MyText(
                        text: 'Assets',
                        fontSize: 27,
                        color: AppColors.whiteColorHexa,
                        left: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showSearch(
                              context: context,
                              delegate: SearchAsset(),
                            );
                          },
                          child: const Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                Consumer<ApiProvider>(builder: (context, value, child) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        RouteAnimation(
                          enterPage: AssetInfo(
                       
                            assetLogo: value.nativeM.logo,
                            balance: value.nativeM.balance,
                            tokenSymbol: value.nativeM.symbol,
                          ),
                        ),
                      );
                    },
                    child: AssetItem(
                      value.nativeM.logo,
                      value.nativeM.symbol,
                      value.nativeM.org,
                      value.nativeM.balance,
                      Colors.white,
                    ),
                  );
                }),
                Consumer<ContractProvider>(
                  builder: (context, value, child) {
                    return value.kmpi.isContain
                        ? Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            background: DismissibleBackground(),
                            onDismissed: (direct) {
                              value.removeToken(value.kmpi.symbol);
                              setPortfolio();
                            },
                            child: Consumer<ContractProvider>(
                              builder: (context, value, child) {
                                return GestureDetector(
                                  onTap: () {
                                    Provider.of<ContractProvider>(context,
                                            listen: false)
                                        .fetchKmpiBalance();
                                    Navigator.push(
                                      context,
                                      RouteAnimation(
                                        enterPage: AssetInfo(
                                        
                                          assetLogo: value.kmpi.logo,
                                          balance: value.kmpi.balance ?? '0',
                                          tokenSymbol: value.kmpi.symbol,
                                        ),
                                      ),
                                    );
                                  },
                                  child: AssetItem(
                                    value.kmpi.logo,
                                    value.kmpi.symbol,
                                    value.kmpi.org,
                                    value.kmpi.balance,
                                    Colors.black,
                                  ),
                                );
                              },
                            ),
                          )
                        : Container();
                  },
                ),
                Consumer<ContractProvider>(
                  builder: (coontext, value, child) {
                    return value.atd.isContain
                        ? Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            background: DismissibleBackground(),
                            onDismissed: (direct) {
                              value.removeToken(value.atd.symbol);
                              setPortfolio();
                            },
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  RouteAnimation(
                                    enterPage: AssetInfo(
                            
                                      assetLogo: value.atd.logo,
                                      balance: value.atd.balance ?? '0',
                                      tokenSymbol: value.atd.symbol,
                                    ),
                                  ),
                                );
                              },
                              child: AssetItem(
                                value.atd.logo,
                                value.atd.symbol,
                                value.atd.org,
                                value.atd.balance,
                                Colors.black,
                              ),
                            ),
                          )
                        : Container();
                  },
                ),
                Consumer<ApiProvider>(builder: (context, value, child) {
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: DismissibleBackground(),
                    onDismissed: (direct) {
                      setPortfolio();
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          RouteAnimation(
                            enterPage: AssetInfo(
                       
                              assetLogo: 'assets/icons/polkadot.png',
                              balance: value.dot.balance ?? '0',
                              tokenSymbol: 'DOT',
                            ),
                          ),
                        );
                      },
                      child: AssetItem(
                        'assets/icons/polkadot.png',
                        'DOT',
                        'testnet',
                        value.dot.balance ?? '0',
                        Colors.black,
                      ),
                    ),
                  );
                })

                // Dismissible(
                //   key: UniqueKey(),
                //   direction: DismissDirection.endToStart,
                //   background: DismissibleBackground(),
                //   onDismissed: (direct) {
                //     setPortfolio();
                //   },
                //   child: GestureDetector(
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         RouteAnimation(
                //           enterPage: AssetInfo(
                //             sdkModel: sdkModel,
                //             assetLogo: 'assets/icons/kusama.png',
                //             balance: '0',
                //             tokenSymbol: 'KSM',
                //           ),
                //         ),
                //       );
                //     },
                //     child: const AssetItem(
                //       'assets/icons/kusama.png',
                //       'KSM',
                //       '',
                //       '0',
                //       Colors.black,
                //     ),
                //   ),

                // )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
