import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:wallet_apps/src/provider/api_provider.dart';

import '../../../../index.dart';

class AssetInfoC {
  bool transferFrom = false;

  Widget appBar(BuildContext context, Color color, String trailingText,
      Widget title, void Function() leadingFunction) {
    return Container(
      height: 65.0,
      width: MediaQuery.of(context).size.width,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                padding: const EdgeInsets.only(left: 30),
                iconSize: 40.0,
                icon: const Icon(
                  LineAwesomeIcons.arrow_left,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: leadingFunction,
              ),
              title
            ],
          ),
          MyText(
            text: trailingText,
            right: 30,
          ),
        ],
      ),
    );
  }

  void showRecieved(BuildContext context, GetWalletMethod _method,
      {String symbol, org}) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final _keyQrShare = GlobalKey();
        final _globalKey = GlobalKey<ScaffoldState>();

        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Scaffold(
            key: _globalKey,
            body: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(top: 27.0),
                color: Color(AppUtils.convertHexaColor(AppColors.bgdColor)),
                child: symbol != null
                    ? Consumer<ContractProvider>(
                        builder: (context, value, child) {
                          return ReceiveWalletBody(
                            method: _method,
                            globalKey: _globalKey,
                            keyQrShare: _keyQrShare,
                            name: ApiProvider.keyring.current.name,
                            assetInfo: 'assetInfo',
                            wallet: symbol == 'BNB' || org == 'BEP-20'
                                ? value.ethAdd
                                : ApiProvider.keyring.current.address,
                          );
                        },
                      )
                    : Consumer<ApiProvider>(
                        builder: (context, value, child) {
                          return ReceiveWalletBody(
                            method: _method,
                            globalKey: _globalKey,
                            keyQrShare: _keyQrShare,
                            name: value.accountM.name,
                            wallet: value.accountM.address,
                            assetInfo: 'assetInfo',
                          );
                        },
                      )),
          ),
        );
      },
    );
  }
}
