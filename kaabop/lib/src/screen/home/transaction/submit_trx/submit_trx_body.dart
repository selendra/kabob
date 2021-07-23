import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/reuse_dropdown.dart';

class SubmitTrxBody extends StatelessWidget {
  final bool enableInput;
  final dynamic dialog;
  final ModelScanPay scanPayM;
  final String Function(String) onChanged;
  final String Function(String) validateField;
  final Function onSubmit;
  final void Function() clickSend;
  final Function(String) resetAssetsDropDown;

  final List<String> list;
  final PopupMenuItem Function(Map<String, dynamic>) item;

  const SubmitTrxBody({
    this.enableInput,
    this.dialog,
    this.scanPayM,
    this.onChanged,
    this.validateField,
    this.onSubmit,
    this.clickSend,
    this.resetAssetsDropDown,
    this.item,
    this.list,
  });

  @override
  Widget build(BuildContext context) {

    final List<MyInputField> listInput = [

      MyInputField(
        pBottom: 16,
        labelText: "Receiver address",
        textInputFormatter: [
          LengthLimitingTextInputFormatter(TextField.noMaxLength),
        ],
        controller: scanPayM.controlReceiverAddress,
        focusNode: scanPayM.nodeReceiverAddress,
        validateField: (value) =>
            value == null ? 'Please fill in receiver address' : null,
        onChanged: onChanged,
        onSubmit: () {}
      ),
      MyInputField(
        pBottom: 16,
        labelText: "Amount",
        textInputFormatter: [
          LengthLimitingTextInputFormatter(TextField.noMaxLength)
        ],
        inputType: Platform.isAndroid ? TextInputType.number : TextInputType.text,
        controller: scanPayM.controlAmount,
        focusNode: scanPayM.nodeAmount,
        validateField: validateField,
        onChanged: onChanged,
        onSubmit: () {}
      ),
    ];

    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;

    return Column(
      children: [

        MyAppBar(
          title: "Send wallet",
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        Expanded(
          child: Center(
            child: BodyScaffold(
              child: Form(
                key: scanPayM.formStateKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    listInput[0],
                    Container(
                      /* Type of payment */
                      margin: const EdgeInsets.only(
                        bottom: 16.0,
                        left: 16,
                        right: 16,
                      ),

                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 11.0,
                          bottom: 11.0,
                          left: 26.0,
                          right: 14.0,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkTheme
                            ? hexaCodeToColor(AppColors.darkCard)
                            : hexaCodeToColor(AppColors.whiteHexaColor),
                          borderRadius: BorderRadius.circular(size5),
                          border: Border.all(width: scanPayM.asset != null ? 1 : 0, color: scanPayM.asset != null ? hexaCodeToColor(AppColors.secondary) : Colors.transparent)
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: MyText(
                                text: 'Asset',
                                textAlign: TextAlign.left,
                                color: isDarkTheme
                                  ? AppColors.darkSecondaryText
                                  : AppColors.textColor,
                              ),
                            ),
                            ReuseDropDown(
                              initialValue: scanPayM.asset ?? "Asset name",
                              onChanged: resetAssetsDropDown,
                              itemsList: list,
                              style: TextStyle(
                                color: isDarkTheme ? Colors.white : hexaCodeToColor(AppColors.blackColor),
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ],
                        ),
                      ),

                      // child: customDropDown(
                      //   scanPayM.asset ?? "Asset name",
                      //   list,
                      //   scanPayM,
                      //   resetAssetsDropDown,
                      //   item,
                      // ),
                    ),
                    listInput[1],
                    //listInput[2],
                    MyFlatButton(
                      textButton: "Request code",
                      edgeMargin: const EdgeInsets.only(
                        top: 40,
                        left: 66,
                        right: 66,
                      ),
                      hasShadow: scanPayM.enable,
                      action: scanPayM.enable ? clickSend : null,
                    ),
                  ],
                ),
              )
            )
          ),
        )
      ],
    );
  }
}
