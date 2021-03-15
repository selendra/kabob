import 'package:flutter/material.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';

import '../../../../index.dart';

class AssetInfoC {
  bool transferFrom = false;


  void showRecieved(
    BuildContext context,
    CreateAccModel sdkModel,
    GetWalletMethod _method,

  ) {
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
              padding: const EdgeInsets.only(top: 16.0),
              color: Color(AppUtils.convertHexaColor(AppColors.bgdColor)),
              child: ReceiveWalletBody(
                name: sdkModel.userModel.username,
                wallet: sdkModel.userModel.address,
                method: _method,
                globalKey: _globalKey,
                keyQrShare: _keyQrShare,
              ),
            ),
          ),
        );
      },
    );
  }





}
