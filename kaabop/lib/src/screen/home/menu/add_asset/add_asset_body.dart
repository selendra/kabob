import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/menu/add_asset/search_asset.dart';

class AddAssetBody extends StatelessWidget {
  final ModelAsset assetM;
  final String tokenSymbol;
  final Function validateIssuer;
  final Function popScreen;
  final String Function(String) onChanged;
  final String Function(String) validateField;
  final Function onSubmit;
  final void Function() submitAsset;
  final Function addAsset;
  final Function qrRes;

  const AddAssetBody({
    this.assetM,
    this.tokenSymbol,
    this.validateIssuer,
    this.popScreen,
    this.onChanged,
    this.validateField,
    this.onSubmit,
    this.submitAsset,
    this.addAsset,
    this.qrRes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: MyAppBar(
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
                icon: const Icon(Icons.search, color: Colors.white, size: 30),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: SearchAsset(),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Expanded(
          child: SvgPicture.asset(
            'assets/icons/contract.svg',
            width: 200,
            height: 200,
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: assetM.formStateAsset,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: portFolioItemRow(
                        ContractProvider().kmpi.logo,
                        ContractProvider().kmpi.symbol,
                        Colors.black,
                        addAsset,
                      ),
                    )
                  else if (tokenSymbol == 'SEL')
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: portFolioItemRow(
                        ContractProvider().bscNative.logo,
                        tokenSymbol,
                        Colors.black,
                        addAsset,
                      ),
                    )
                  else if (tokenSymbol != 'SEL' && tokenSymbol != '')
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: portFolioItemRow(
                        ContractProvider().bscNative.logo,
                        tokenSymbol,
                        Colors.black,
                        addAsset,
                      ),
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
                        final _response = await Navigator.push(
                            context, transitionRoute(QrScanner()));
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 40.0),
        MyFlatButton(
          textButton: "Submit",
          edgeMargin: const EdgeInsets.only(left: 66, right: 66),
          hasShadow: true,
          action: assetM.enable ? submitAsset : null,
        ),
      ],
    );
  }

  Widget portFolioItemRow(
      String logo, String tokenSymbol, Color color, Function addAsset) {
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
                    color: "#FFFFFF",
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
                offset: Offset(1.0, 1.0))
          ],
          color: hexaCodeToColor(AppColors.cardColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child);
  }
}
