import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/reuse_dropdown.dart';

import 'package:wallet_apps/src/screen/home/menu/add_asset/search_asset.dart';

class AddAssetBody extends StatelessWidget {
  
  final ModelAsset assetM;
  final String tokenSymbol;
  final String initialValue;
  final Function validateIssuer;
  final Function popScreen;
  final String Function(String) onChanged;
  final String Function(String) validateField;
  final Function onSubmit;
  final void Function() submitAsset;
  final Function addAsset;
  final Function qrRes;
  final Function onChangeDropDown;

  const AddAssetBody({
    this.assetM,
    this.tokenSymbol,
    this.initialValue,
    this.validateIssuer,
    this.popScreen,
    this.onChanged,
    this.validateField,
    this.onSubmit,
    this.submitAsset,
    this.addAsset,
    this.qrRes,
    this.onChangeDropDown,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Column(
      children: [
        
        MyAppBar(

          title: "Add asset",
          onPressed: () {
            Navigator.pop(context);
          },

          tile: Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: IconButton(
              /* Menu Icon */
              // padding: edgePadding,
              padding: const EdgeInsets.only(left: 30),
              iconSize: 40.0,
              icon: Icon(
                Icons.search,
                color: isDarkTheme ? Colors.white : Colors.black,
                size: 30,
              ),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchAsset(),
                );
              },
            ),
          ),
        ),

        Expanded(
          child: BodyScaffold(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [

                const SizedBox(
                  height: 20.0,
                ),
                SvgPicture.asset(
                  'assets/icons/contract.svg',
                  width: 200,
                  height: 200,
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Form(
                    key: assetM.formStateAsset,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Container(
                        //   /* Type of payment */
                        //   margin: const EdgeInsets.only(
                        //     bottom: 16.0,
                        //     left: 16,
                        //     right: 16,
                        //   ),
                        //   child: Container(
                        //     padding: const EdgeInsets.only(
                        //       top: 11.0,
                        //       bottom: 11.0,
                        //       left: 26.0,
                        //       right: 14.0,
                        //     ),
                        //     decoration: BoxDecoration(
                        //       color: hexaCodeToColor(AppColors.cardColor),
                        //       borderRadius: BorderRadius.circular(size5),
                        //     ),
                        //     child: Row(
                        //       children: <Widget>[
                        //         const Expanded(
                        //           child: MyText(
                        //             text: 'Asset',
                        //             textAlign: TextAlign.left,
                        //           ),
                        //         ),
                        //         ReuseDropDown(
                        //           initialValue: "Asset name",
                        //           onChanged: (value) {},
                        //           itemsList: [],
                        //           style: TextStyle(
                        //             color: hexaCodeToColor(AppColors.textColor),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // MyInputField(
                        //   pBottom: 16.0,
                        //   labelText: "Token Contract Address",
                        //   textInputFormatter: [
                        //     LengthLimitingTextInputFormatter(TextField.noMaxLength)
                        //   ],
                        //   controller: assetM.controllerAssetCode,
                        //   focusNode: assetM.nodeAssetCode,
                        //   validateField: (value) => value.isEmpty
                        //       ? 'Please fill in token contract address'
                        //       : null,
                        //   onChanged: onChanged,
                        //   onSubmit: onSubmit,
                        // ),

                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          height: 65,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: hexaCodeToColor(isDarkTheme ? AppColors.darkCard : AppColors.whiteHexaColor),
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(width: initialValue != null ? 1 : 0, color: initialValue != null ? hexaCodeToColor(AppColors.secondary) : Colors.transparent)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                left: 16.0,
                                text: 'Select Network',
                                color: isDarkTheme ? AppColors.whiteHexaColor : AppColors.darkCard,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ReuseDropDown(
                                  style: TextStyle(color: hexaCodeToColor(isDarkTheme ? AppColors.whiteHexaColor : AppColors.darkCard)),
                                  initialValue: initialValue,
                                  itemsList: const [
                                    'Ethereum',
                                    'Binance Smart Chain'
                                  ],
                                  onChanged: (value) {
                                    onChangeDropDown(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        MyInputField(
                          pBottom: 16.0,
                          labelText: "Token Contract Address",
                          textInputFormatter: [
                            LengthLimitingTextInputFormatter(TextField.noMaxLength)
                          ],
                          controller: assetM.controllerAssetCode,
                          focusNode: assetM.nodeAssetCode,
                          validateField: (value) => value.isEmpty
                            ? 'Please fill in token contract address'
                            : null,
                          onChanged: onChanged,
                          onSubmit: onSubmit,
                        ),

                        if (assetM.match)
                          portFolioItemRow(
                            isDarkTheme,
                            ContractProvider().kmpi.logo,
                            ContractProvider().kmpi.symbol,
                            Colors.black,
                            addAsset,
                          )
                        else if (tokenSymbol == 'SEL')
                          portFolioItemRow(
                            isDarkTheme,
                            ContractProvider().bscNative.logo,
                            tokenSymbol,
                            Colors.black,
                            addAsset,
                          )
                        else if (tokenSymbol == 'KGO')
                          portFolioItemRow(
                            isDarkTheme,
                            ContractProvider().kgoNative.logo,
                            tokenSymbol,
                            Colors.black,
                            addAsset,
                          )
                        else if (tokenSymbol != 'SEL' && tokenSymbol != '')
                          portFolioItemRow(
                            isDarkTheme,
                            'assets/circle.png',
                            tokenSymbol,
                            Colors.black,
                            addAsset,
                          )
                        else
                          Container(),
                        if (assetM.loading)
                          const CircularProgressIndicator()
                        else
                          Container(),
                          
                        Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () async {
                              final _response = await Navigator.push(context, MaterialPageRoute(builder: (context) =>QrScanner()));
                                  // transitionRoute(QrScanner()));
                              if (_response != null) {
                                qrRes(_response.toString());
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: SvgPicture.asset(
                                'assets/icons/qr_code.svg',
                                width: 40,
                                height: 40,
                                color: isDarkTheme ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                MyFlatButton(
                  textButton: "Submit",
                  edgeMargin: const EdgeInsets.only(left: 66, right: 66),
                  hasShadow: assetM.enable,
                  action: assetM.enable ? submitAsset : null,
                )   

              ]
            ),
          )
        ),
      ],
    );
  }

  Widget portFolioItemRow(bool isDark, String logo, String tokenSymbol, Color color, Function addAsset) {

    return rowDecorationStyle(
      isDark,
      child: Row(
        children: <Widget>[
          Container(
            height: 50, width: 50,
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: color, 
              borderRadius: BorderRadius.circular(40)
            ),
            child: Image.asset(logo),
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
                    color: isDark ? "#FFFFFF" : AppColors.darkText,
                  ),
                  //MyText(text: org, fontSize: 15),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                addAsset();
              },
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    MyText(
                      width: double.infinity,
                      text: 'Add', //portfolioData[0]["data"]['balance'],
                      color: AppColors.secondary,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowDecorationStyle(bool isDark, {Widget child, double mTop = 0, double mBottom = 16}) {
    return Container(
        margin: EdgeInsets.only(top: mTop, left: 16, right: 16, bottom: 16),
        padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
        decoration: BoxDecoration(
          boxShadow:[
            shadow(
              hexaCode: isDark ? Colors.black.withOpacity(0.3) : null 
            )
            // BoxShadow(
            //   color: Colors.black12,
            //   blurRadius: 2.0,
            //   offset: Offset(1.0, 1.0)
            // )
          ],
          color: hexaCodeToColor(isDark ? AppColors.darkCard : AppColors.whiteHexaColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child);
  }
}
