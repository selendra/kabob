import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/reuse_widget.dart';

import 'package:wallet_apps/src/models/token.m.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import 'package:wallet_apps/src/provider/contract_provider.dart';
import 'package:wallet_apps/theme/color.dart';

class SearchAsset extends SearchDelegate {

  final Function added;
  final List<TokenModel> token;
  SearchAsset({ this.added, this.token});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      primaryColor: hexaCodeToColor(AppColors.cardColor),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white),
      ),
      textTheme: const TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
        ),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<TokenModel> searchProducts = query.isEmpty
        ? []
        : ApiProvider.listToken
            .where(
              (element) => element.symbol.toLowerCase().startsWith(
                    query.toLowerCase(),
                  ),
            )
            .toList();
    return searchProducts.isNotEmpty
        ? ListView.builder(
            itemCount: searchProducts.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  await StorageServices.readBool(searchProducts[index].symbol)
                      .then((value) async {
                    if (!value) {
                      Provider.of<ContractProvider>(context, listen: false)
                          .addToken(searchProducts[index].symbol, context);
                    } else {
                      await dialog(
                        context,
                        const Text('This asset is already added!'),
                        const Text('Asset Added'),
                      );
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: portFolioItemRow(
                      searchProducts[index].logo,
                      searchProducts[index].symbol,
                      searchProducts[index].org,
                      searchProducts[index].balance,
                      searchProducts[index].color,
                      added),
                ),
              );
            })
        : Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<TokenModel> searchProducts = query.isEmpty
        ? []
        : ApiProvider.listToken
            .where(
              (element) => element.symbol.toLowerCase().startsWith(
                    query.toLowerCase(),
                  ),
            )
            .toList();
    return searchProducts.isNotEmpty
        ? ListView.builder(
            itemCount: searchProducts.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  await StorageServices.readBool(searchProducts[index].symbol)
                      .then((value) async {
                    if (!value) {
                      Provider.of<ContractProvider>(context, listen: false)
                          .addToken(searchProducts[index].symbol, context);
                    } else {
                      await dialog(
                        context,
                        const Text('This asset is already added!'),
                        const Text('Asset Added'),
                      );
                    }
                  });
                },
                child: Container(
                 // padding: const EdgeInsets.all(8.0),
                  child: portFolioItemRow(
                      searchProducts[index].logo,
                      searchProducts[index].symbol,
                      searchProducts[index].org,
                      searchProducts[index].balance,
                      searchProducts[index].color,
                      added),
                ),
              );
            })
        : Container();
  }

  Widget portFolioItemRow(String asset, String tokenSymbol, String org,
      String balance, Color color, Function added) {
    return rowDecorationStyle(
      child: Row(
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.only(right: 20),
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
                  ),
                  MyText(text: org, fontSize: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowDecorationStyle(
      {Widget child, double mTop = 0, double mBottom = 16}) {
    return Container(
      margin: EdgeInsets.only(top: mTop, left: 16, right: 16, bottom: 16),
      padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
      height: 90,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2.0,
            offset: Offset(1.0, 1.0),
          )
        ],
        color: hexaCodeToColor(AppColors.cardColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
