import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'asset_info/asset_info.dart';

class HomeBody extends StatelessWidget {
  final Function balanceOf;
  final Function setPortfolio;

  const HomeBody({this.balanceOf, this.setPortfolio});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 300)).then((value) {
          setPortfolio();
          Provider.of<ContractProvider>(context, listen: false).getBscDecimal();
        });
      },
      child: ListView(
        children: [
          homeAppBar(context),
          Container(
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
                            Navigator.push(
                              context,
                              RouteAnimation(
                                enterPage: AddAsset(),
                              ),
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
                        value.removeToken(value.kmpi.symbol, context);
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
                        value.removeToken(value.atd.symbol, context);
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
          Consumer<ApiProvider>(
            builder: (context, value, child) {
              return value.dot.isContain
                  ? Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: DismissibleBackground(),
                      onDismissed: (direct) {
                        setPortfolio();

                        Provider.of<ContractProvider>(context, listen: false)
                            .removeToken(value.dot.symbol, context);
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            RouteAnimation(
                              enterPage: AssetInfo(
                                assetLogo: value.dot.logo,
                                balance: value.dot.balance,
                                tokenSymbol: value.dot.symbol,
                              ),
                            ),
                          );
                        },
                        child: AssetItem(
                          value.dot.logo,
                          value.dot.symbol,
                          'testnet',
                          value.dot.balance,
                          Colors.black,
                        ),
                      ),
                    )
                  : Container();
            },
          ),
          Consumer<ContractProvider>(
            builder: (context, value, child) {
              return value.bnbNative.isContain
                  ? Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: DismissibleBackground(),
                      onDismissed: (direct) {
                        setPortfolio();
                        value.removeToken(value.bnbNative.symbol, context);
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            RouteAnimation(
                              enterPage: AssetInfo(
                                assetLogo: value.bnbNative.logo,
                                balance: value.bnbNative.balance ?? '0',
                                tokenSymbol: value.bnbNative.symbol ?? '',
                              ),
                            ),
                          );
                        },
                        child: AssetItem(
                          value.bnbNative.logo,
                          value.bnbNative.symbol ?? '',
                          'Smart Chain',
                          value.bnbNative.balance ?? '0',
                          Colors.black,
                        ),
                      ),
                    )
                  : Container();
            },
          ),
          Consumer<ContractProvider>(
            builder: (context, value, child) {
              return value.bscNative.isContain
                  ? Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: DismissibleBackground(),
                      onDismissed: (direct) {
                        setPortfolio();
                        value.removeToken(value.bscNative.symbol, context);
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            RouteAnimation(
                              enterPage: AssetInfo(
                                assetLogo: value.bscNative.logo,
                                balance: value.bscNative.balance ?? '0',
                                tokenSymbol: value.bscNative.symbol ?? '',
                              ),
                            ),
                          );
                        },
                        child: AssetItem(
                          value.bscNative.logo,
                          value.bscNative.symbol ?? '',
                          'BEP-20',
                          value.bscNative.balance ?? '0',
                          Colors.black,
                        ),
                      ),
                    )
                  : Container();
            },
          ),
          Consumer<ContractProvider>(builder: (context, value, child) {
            return value.token.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    addAutomaticKeepAlives: false,
                    itemCount: value.token.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: DismissibleBackground(),
                        onDismissed: (direct) {
                          setPortfolio();
                          value.removeToken(value.token[index].symbol, context);
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              RouteAnimation(
                                enterPage: AssetInfo(
                                  assetLogo: value.bscNative.logo,
                                  balance: value.token[index].balance ?? '0',
                                  tokenSymbol: value.token[index].symbol ?? '',
                                ),
                              ),
                            );
                          },
                          child: AssetItem(
                            value.bscNative.logo,
                            value.token[index].symbol ?? '',
                            'testnet',
                            value.token[index].balance ?? '0',
                            Colors.black,
                          ),
                        ),
                      );
                    })
                : Container();
          }),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
