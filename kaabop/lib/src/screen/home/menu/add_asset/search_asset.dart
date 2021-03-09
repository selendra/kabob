import 'package:flutter/material.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/reuse_widget.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/models/token.m.dart';
import 'package:wallet_apps/theme/color.dart';

class SearchAsset extends SearchDelegate {
  final CreateAccModel sdkModel;
  final Function added;
  final List<TokenModel> token;
  SearchAsset({this.sdkModel, this.added, this.token});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      primaryColor: hexaCodeToColor(AppColors.cardColor),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white),
      ),
      textTheme: TextTheme(
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
        icon: Icon(
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
      icon: Icon(
        Icons.arrow_back,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<TokenModel> searchProducts = query.isEmpty
        ? []
        : token
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
                onTap: () {
                  added(searchProducts[index].symbol);
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
        // ? Container(
        //     padding: const EdgeInsets.all(8.0),
        //     child: portFolioItemRow(
        //         sdkModel.contractModel.ptLogo,
        //         sdkModel.contractModel.pTokenSymbol,
        //         sdkModel.contractModel.pOrg,
        //         sdkModel.contractModel.pBalance,
        //         Colors.black,
        //         added),
        //   )
        : Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<TokenModel> searchProducts = query.isEmpty
        ? []
        : token
            .where(
              (element) => element.symbol.toLowerCase().startsWith(
                    query.toLowerCase(),
                  ),
            )
            .toList();
    //print(token.length);
    return searchProducts.isNotEmpty
        ? ListView.builder(
            itemCount: searchProducts.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  added(searchProducts[index].symbol);
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
        // ? Container(
        //     padding: const EdgeInsets.all(8.0),
        //     child: portFolioItemRow(
        //         sdkModel.contractModel.ptLogo,
        //         sdkModel.contractModel.pTokenSymbol,
        //         sdkModel.contractModel.pOrg,
        //         sdkModel.contractModel.pBalance,
        //         Colors.black,
        //         added),
        //   )
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
        // Expanded(
        //   child: GestureDetector(
        //     onTap: added,
        //     child: Container(
        //       margin: EdgeInsets.only(right: 16),
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           MyText(
        //               width: double.infinity,
        //               text: 'Add', //portfolioData[0]["data"]['balance'],
        //               color: AppColors.secondary,
        //               fontSize: 18,
        //               textAlign: TextAlign.right,
        //               overflow: TextOverflow.ellipsis),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    ));
  }

  Widget rowDecorationStyle(
      {Widget child, double mTop: 0, double mBottom = 16}) {
    return Container(
      margin: EdgeInsets.only(top: mTop, left: 16, right: 16, bottom: 16),
      padding: EdgeInsets.fromLTRB(15, 9, 15, 9),
      height: 90,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 2.0, offset: Offset(1.0, 1.0))
        ],
        color: hexaCodeToColor(AppColors.cardColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
