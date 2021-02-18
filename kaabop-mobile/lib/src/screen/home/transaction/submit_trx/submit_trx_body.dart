import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';

class SubmitTrxBody extends StatelessWidget {
  final bool enableInput;
  final dynamic dialog;
  final ModelScanPay scanPayM;
  final Function validateWallet;
  final Function validateAmount;
  final Function validateMemo;
  final Function onChanged;
  final Function onSubmit;
  final Function validateInput;
  final Function clickSend;
  final Function resetAssetsDropDown;
  final CreateAccModel sdkModel;
  final List list;
  final PopupMenuItem Function(Map<String, dynamic>) item;

  SubmitTrxBody(
      {this.enableInput,
      this.dialog,
      this.scanPayM,
      this.validateWallet,
      this.validateAmount,
      this.validateMemo,
      this.onChanged,
      this.onSubmit,
      this.validateInput,
      this.clickSend,
      this.resetAssetsDropDown,
      this.sdkModel,
      this.item,
      this.list});

  Widget build(BuildContext context) {
    List<MyInputField> listInput = [
      MyInputField(
          pBottom: 16,
          labelText: "Receiver address",
          prefixText: null,
          textInputFormatter: [
            LengthLimitingTextInputFormatter(TextField.noMaxLength),
          ],
          inputType: TextInputType.text,
          controller: scanPayM.controlReceiverAddress,
          focusNode: scanPayM.nodeReceiverAddress,
          validateField: (value) =>
              value.isEmpty ? 'Please fill in receiver address' : null,
          onChanged: onChanged,
          onSubmit: onSubmit),
      MyInputField(
          pBottom: 16,
          labelText: "Amount",
          prefixText: null,
          textInputFormatter: [
            LengthLimitingTextInputFormatter(TextField.noMaxLength)
          ],
          inputType: TextInputType.number,
          controller: scanPayM.controlAmount,
          focusNode: scanPayM.nodeAmount,
          validateField: (value) =>
              value.isEmpty || int.parse(value) < 0 || value == '-0'
                  ? 'Please fill in positive amount '
                  : null,
          onChanged: onChanged,
          onSubmit: onSubmit),
      MyInputField(
          pBottom: 16,
          labelText: "Memo",
          prefixText: null,
          textInputFormatter: [
            LengthLimitingTextInputFormatter(TextField.noMaxLength)
          ],
          inputType: TextInputType.text,
          controller: scanPayM.controlMemo,
          focusNode: scanPayM.nodeMemo,
          validateField: validateMemo,
          onChanged: onChanged,
          onSubmit: onSubmit)
    ];

    return Column(
      children: [
        MyAppBar(
          title: "Send wallet",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Expanded(
          child: Form(
            key: scanPayM.formStateKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                listInput[0],
                Container(
                  /* Type of payment */
                  margin: EdgeInsets.only(bottom: 16.0, left: 16, right: 16),
                  child: customDropDown(
                      scanPayM.asset != null ? scanPayM.asset : "Asset name",
                      list,
                      scanPayM,
                      resetAssetsDropDown,
                      item),

                  // child: customDropDown(label, list, _model, changeValue, item),
                ),
                listInput[1],
                listInput[2],
                MyFlatButton(
                    textButton: "Request code",
                    buttonColor: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: size18,
                    edgeMargin: EdgeInsets.only(top: 40, left: 66, right: 66),
                    hasShadow: true,
                    action:
                        clickSend //scanPayM.enable == false ? null : clickSend
                    ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
