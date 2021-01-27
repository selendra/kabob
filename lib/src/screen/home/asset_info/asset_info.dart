import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/src/components/component.dart';

import '../../../../index.dart';

class AssetInfo extends StatefulWidget {
  final String accBalance;
  final WalletSDK sdk;
  final Keyring keyring;
  AssetInfo({@required this.accBalance, this.sdk, this.keyring});
  @override
  _AssetInfoState createState() => _AssetInfoState();
}

class _AssetInfoState extends State<AssetInfo> {
  TextEditingController _callerController = TextEditingController();
  TextEditingController _accountController = TextEditingController();
  FocusNode _callerNode = FocusNode();
  FocusNode _accountNode = FocusNode();

  String onChanged(String value) {
    return value;
  }

  String onSubmit(String value) {
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            MyAppBar(
              title: "Asset",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.15,
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: hexaCodeToColor(AppColors.cardColor),
                ),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(right: 16),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Image.asset('assets/koompi_white_logo.png'),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Balance",
                            color: "#FFFFFF",
                            fontSize: 20,
                          ),
                          SizedBox(height: 5),
                          MyText(
                            text: widget.accBalance + " KPI",
                            color: AppColors.secondary_text,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      try {
                        await GetRequest()
                            .totalSupply(widget.keyring.keyPairs[0].address)
                            .then((value) async {
                          if (value != null) {
                            await dialog(
                                context,
                                MyText(
                                  text: value,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.center,
                                ),
                                Text('Total Supply of KPI'));
                          }
                        });
                      } catch (e) {
                        print(e.toString());
                      }

                      // MyBottomSheet().trxOptions(
                      //   context: context,
                      //   //portfolioList: homeM.portfolioList,
                      //   // resetHomeData: resetDbdState,
                      //   sdk: widget.sdk,
                      //   keyring: widget.keyring,
                      // );
                    },
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width * 0.15,
                          width: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: hexaCodeToColor(AppColors.cardColor),
                          ),
                          child: Icon(
                            Icons.receipt,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        MyText(
                          text:
                              "Total Supply", //portfolioData[0]["data"]['balance'],
                          color: "#FFFFFF",
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width * 0.15,
                          width: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: hexaCodeToColor(AppColors.cardColor),
                          ),
                          child: Icon(
                            Icons.swap_vert,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        MyText(
                          text:
                              "Balance Of", //portfolioData[0]["data"]['balance'],
                          color: "#FFFFFF",
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width * 0.15,
                        width: MediaQuery.of(context).size.width * 0.15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: hexaCodeToColor(AppColors.cardColor),
                        ),
                        child: Icon(
                          Icons.check_box,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      MyText(
                        text: "Approve", //portfolioData[0]["data"]['balance'],
                        color: "#FFFFFF",
                        fontSize: 14,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width * 0.15,
                        width: MediaQuery.of(context).size.width * 0.15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: hexaCodeToColor(AppColors.cardColor),
                        ),
                        child: Icon(
                          Icons.receipt,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      MyText(
                        text:
                            "Allowance", //portfolioData[0]["data"]['balance'],
                        color: "#FFFFFF",
                        fontSize: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 5,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: hexaCodeToColor(AppColors.secondary)),
                  ),
                  MyText(
                    text: 'Activity',
                    fontSize: 27,
                    color: "#FFFFFF",
                    left: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.only(left: 16, bottom: 8),
              alignment: Alignment.centerLeft,
              child: MyText(
                text: 'Yesterday',
                fontSize: 15,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) => rowDecorationStyle(
                  child: Row(
                    children: <Widget>[
                      MyCircularImage(
                        padding: EdgeInsets.all(6),
                        margin: EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                            color: hexaCodeToColor(AppColors.secondary),
                            borderRadius: BorderRadius.circular(40)),
                        imagePath: 'assets/sld_logo.svg',
                        width: 50,
                        height: 50,
                        colorImage: Colors.white,
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: "KPI",
                                color: "#FFFFFF",
                                fontSize: 18,
                              ),
                              MyText(text: "Koompi", fontSize: 15),
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
                                  text:
                                      "0", //portfolioData[0]["data"]['balance'],
                                  color: "#FFFFFF",
                                  fontSize: 18,
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis),
                              // MyText(
                              //   width: double.infinity,
                              //   text: "+",//"${!rate.isNegative ? '+' : ''}$rate",
                              //   textAlign: TextAlign.right,
                              //   color: AppColors.secondary_text,//!rate.isNegative ? AppColors.secondary_text : "#ff1900",
                              //   fontSize: 15
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
