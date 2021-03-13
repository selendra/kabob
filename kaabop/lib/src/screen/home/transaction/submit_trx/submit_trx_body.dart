import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';

class SubmitTrxBody extends StatelessWidget {
  final bool enableInput;
  final dynamic dialog;
  final ModelScanPay scanPayM;
  final String Function(String) onChanged;
  final Function onSubmit;
  final void Function() clickSend;
  final Function resetAssetsDropDown;
  final CreateAccModel sdkModel;
  final List<Map<String,String>> list;
  final PopupMenuItem Function(Map<String, dynamic>) item;

  const SubmitTrxBody(
      {this.enableInput,
      this.dialog,
      this.scanPayM,
      this.onChanged,
      this.onSubmit,
      this.clickSend,
      this.resetAssetsDropDown,
      this.sdkModel,
      this.item,
      this.list});

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
          onSubmit: onSubmit),
      MyInputField(
          pBottom: 16,
          labelText: "Amount",
          textInputFormatter: [
            LengthLimitingTextInputFormatter(TextField.noMaxLength)
          ],
          inputType: TextInputType.number,
          controller: scanPayM.controlAmount,
          focusNode: scanPayM.nodeAmount,
          validateField: (value) => value == null ||
                  double.parse(value.toString()) < 0 ||
                  value == '-0'
              ? 'Please fill in positive amount'
              : null,
          onChanged: onChanged,
          onSubmit: onSubmit),
      MyInputField(
          pBottom: 16,
          labelText: "Memo",
          textInputFormatter: [
            LengthLimitingTextInputFormatter(TextField.noMaxLength)
          ],
          controller: scanPayM.controlMemo,
          focusNode: scanPayM.nodeMemo,
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
                  margin: const EdgeInsets.only(
                    bottom: 16.0,
                    left: 16,
                    right: 16,
                  ),
                  child: customDropDown(
                    scanPayM.asset ?? "Asset name",
                    list,
                    scanPayM,
                    resetAssetsDropDown,
                    item,
                  ),
                ),
                listInput[1],
                listInput[2],
                MyFlatButton(
                  textButton: "Request code",
                  edgeMargin: const EdgeInsets.only(
                    top: 40,
                    left: 66,
                    right: 66,
                  ),
                  hasShadow: true,
                  action: clickSend,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
