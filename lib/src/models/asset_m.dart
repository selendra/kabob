import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ModelAsset {
  bool enable = false;

  String assetBalance = '0';
  static const String assetSymbol = 'KPI';
  static const String assetOrganization = 'Koompi';

  String responseAssetCode;
  String responseIssuer;

  GlobalKey<FormState> formStateAsset = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> globalKey = new GlobalKey<ScaffoldState>();
  Map<String, dynamic> result;

  TextEditingController controllerAssetCode = TextEditingController();
  TextEditingController controllerIssuer = TextEditingController();

  FocusNode nodeAssetCode = FocusNode();
  FocusNode nodeIssuer = FocusNode();
}
