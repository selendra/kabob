import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../index.dart';

class AssetList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<ContractProvider>(
          builder: (context, value, child) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  RouteAnimation(
                    enterPage: AssetInfo(
                      id: value.bscNative.id,
                      assetLogo: value.bscNative.logo,
                      balance:
                          value.bscNative.balance ?? AppText.loadingPattern,
                      tokenSymbol: value.bscNative.symbol ?? '',
                      org: value.bscNative.org,
                      
                      marketPrice: value.bscNative.marketPrice,
                      priceChange24h: value.bscNative.change24h,
                    ),
                  ),
                );
              },
              child: AssetItem(
                value.bscNative.logo,
                value.bscNative.symbol ?? '',
                'BEP-20',
                value.bscNative.balance ?? AppText.loadingPattern,
                Colors.transparent,
                marketPrice: value.bscNative.marketPrice,
                priceChange24h: value.bscNative.change24h,
              ),
            );
          },
        ),
        Consumer<ContractProvider>(
          builder: (context, value, child) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  RouteAnimation(
                    enterPage: AssetInfo(
                      id: value.kgoNative.id,
                      assetLogo: value.kgoNative.logo,
                      balance:
                          value.kgoNative.balance ?? AppText.loadingPattern,
                      tokenSymbol: value.kgoNative.symbol ?? '',
                      org: value.kgoNative.org,
                    
                      marketData: value.kgoNative.marketData,
                      marketPrice: value.kgoNative.marketPrice,
                      priceChange24h: value.kgoNative.change24h,
                    ),
                  ),
                );
              },
              child: AssetItem(
                value.kgoNative.logo,
                value.kgoNative.symbol ?? '',
                'BEP-20',
                value.kgoNative.balance ?? AppText.loadingPattern,
                Colors.transparent,
                
                marketPrice: value.kgoNative.marketPrice,
                priceChange24h: value.kgoNative.change24h,
              ),
            );
          },
        ),
        Consumer<ContractProvider>(
          builder: (context, value, child) {
            return value.kmpi.isContain
                ? Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: DismissibleBackground(),
                    onDismissed: (direct) {
                      value.removeToken(value.kmpi.symbol, context);
                      // setPortfolio();
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
                                  id: value.kmpi.id,
                                  assetLogo: value.kmpi.logo,
                                  balance: value.kmpi.balance ??
                                      AppText.loadingPattern,
                                  tokenSymbol: value.kmpi.symbol,
                                  org: value.kmpi.org,
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
                      //setPortfolio();
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          RouteAnimation(
                            enterPage: AssetInfo(
                              id: value.atd.id,
                              assetLogo: value.atd.logo,
                              balance:
                                  value.atd.balance ?? AppText.loadingPattern,
                              tokenSymbol: value.atd.symbol,
                              org: value.atd.org,
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
        Consumer<ContractProvider>(
          builder: (context, value, child) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  RouteAnimation(
                    enterPage: AssetInfo(
                      id: value.bnbNative.id,
                      assetLogo: value.bnbNative.logo,
                      balance:
                          value.bnbNative.balance ?? AppText.loadingPattern,
                      tokenSymbol: value.bnbNative.symbol ?? '',
                      marketData: value.bnbNative.marketData,
                      marketPrice: value.bnbNative.marketPrice,
                      priceChange24h: value.bnbNative.change24h,
                    ),
                  ),
                );
              },
              child: AssetItem(
                value.bnbNative.logo,
                value.bnbNative.symbol ?? '',
                'Smart Chain',
                value.bnbNative.balance ?? AppText.loadingPattern,
                Colors.transparent,
                marketPrice: value.bnbNative.marketPrice,
                priceChange24h: value.bnbNative.change24h,
                size: 60,
              ),
            );
          },
        ),
        Consumer<ContractProvider>(builder: (context, value, child) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                RouteAnimation(
                  enterPage: AssetInfo(
                    id: value.etherNative.id,
                    assetLogo: value.etherNative.logo,
                    balance: value.etherNative.balance,
                    tokenSymbol: value.etherNative.symbol,
                    org: value.etherNative.org,
                    marketData: value.etherNative.marketData,
                    marketPrice: value.etherNative.marketPrice,
                    priceChange24h: value.etherNative.change24h,
                  ),
                ),
              );
            },
            child: AssetItem(
              value.etherNative.logo,
              value.etherNative.symbol,
              value.etherNative.org,
              value.etherNative.balance ?? AppText.loadingPattern,
              Colors.transparent,
              marketPrice: value.etherNative.marketPrice,
              priceChange24h: value.etherNative.change24h,
            ),
          );
        }),
        Consumer<ApiProvider>(
          builder: (context, value, child) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  RouteAnimation(
                    enterPage: AssetInfo(
                      id: value.dot.id,
                      assetLogo: value.dot.logo,
                      balance: value.dot.balance ?? AppText.loadingPattern,
                      tokenSymbol: value.dot.symbol,
                      org: value.dot.org,
                      marketData: value.dot.marketData,
                      marketPrice: value.dot.marketPrice,
                      priceChange24h: value.dot.change24h,
                    ),
                  ),
                );
              },
              child: AssetItem(
                value.dot.logo,
                value.dot.symbol,
                '',
                value.dot.balance ?? AppText.loadingPattern,
                Colors.transparent,
                size: 60,
                marketPrice: value.dot.marketPrice,
                priceChange24h: value.dot.change24h,
              ),
            );
          },
        ),
        Consumer<ApiProvider>(builder: (context, value, child) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                RouteAnimation(
                  enterPage: AssetInfo(
                    id: value.nativeM.id,
                    assetLogo: value.nativeM.logo,
                    balance: value.nativeM.balance ?? AppText.loadingPattern,
                    tokenSymbol: value.nativeM.symbol,
                    org: value.nativeM.org,
                  ),
                ),
              );
            },
            child: AssetItem(
              value.nativeM.logo,
              value.nativeM.symbol,
              value.nativeM.org,
              value.nativeM.balance ?? AppText.loadingPattern,
              Colors.transparent,
            ),
          );
        }),
        Consumer<ContractProvider>(builder: (context, value, child) {
          return value.token.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  addAutomaticKeepAlives: false,
                  primary: false,
                  itemCount: value.token.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: DismissibleBackground(),
                      onDismissed: (direct) {
                        value.removeToken(value.token[index].symbol, context);
                        //setPortfolio();
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            RouteAnimation(
                              enterPage: AssetInfo(
                                assetLogo: 'assets/circle.png',
                                balance: value.token[index].balance ??
                                    AppText.loadingPattern,
                                tokenSymbol: value.token[index].symbol ?? '',
                                org: value.token[index].org,
                              ),
                            ),
                          );
                        },
                        child: AssetItem(
                          'assets/circle.png',
                          value.token[index].symbol ?? '',
                          'BEP-20',
                          value.token[index].balance ?? AppText.loadingPattern,
                          Colors.transparent,
                        ),
                      ),
                    );
                  })
              : Container();
        }),
      ],
    );
  }
}
