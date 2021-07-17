import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';

class ImportAccBody extends StatelessWidget {
  final bool enable;
  final String reImport;
  final ImportAccModel importAccModel;
  final String Function(String) onChanged;
  final Function onSubmit;
  final Function clearInput;
  final Function submit;

  const ImportAccBody({
    this.importAccModel,
    this.onChanged,
    this.onSubmit,
    this.clearInput,
    this.enable,
    this.reImport,
    this.submit,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Column(
      children: [
        MyAppBar(
          title: 'Import Account',
          color: isDarkTheme
              ? hexaCodeToColor(AppColors.darkCard)
              : hexaCodeToColor(AppColors.cardColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: importAccModel.formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: MyText(
                    text: 'Source Type',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme
                        ? AppColors.whiteColorHexa
                        : AppColors.textColor,
                    bottom: 16,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: hexaCodeToColor(AppColors.secondary),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                title: Align(
                                  child: Text("Oops"),
                                ),
                                content: Padding(
                                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                                  child: Text("This feature has not implemented yet!", textAlign: TextAlign.center),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          child: const MyText(
                            text: "Keystore (json)",
                            // color: "#FFFFFF",
                          ),
                        ),
                      )
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: MyInputField(
                    pLeft: 0,
                    pRight: 0,
                    pBottom: 16.0,
                    labelText: "Seed Phrase",
                    textInputFormatter: [
                      LengthLimitingTextInputFormatter(
                        TextField.noMaxLength,
                      )
                    ],
                    controller: importAccModel.mnemonicCon,
                    focusNode: importAccModel.mnemonicNode,
                    maxLine: null,
                    onChanged: onChanged,
                    //inputAction: TextInputAction.done,
                    onSubmit: reImport != null ? () {} : onSubmit,
                  ),
                ),
                if (reImport != null)
                  MyInputField(
                    pLeft: 0,
                    pRight: 0,
                    pBottom: 16.0,
                    labelText: "Pin",
                    textInputFormatter: [LengthLimitingTextInputFormatter(4)],
                    controller: importAccModel.pwCon,
                    focusNode: importAccModel.pwNode,
                    validateField: (value) =>
                        value.isEmpty ? 'Please fill in pin' : null,
                    maxLine: null,
                    onChanged: onChanged,
                    //inputAction: TextInputAction.done,
                    onSubmit: onSubmit,
                  )
                else
                  Container(),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(),
        ),
        MyFlatButton(
          edgeMargin: const EdgeInsets.only(left: 66, right: 66, bottom: 16),
          textButton: AppText.next,
          action: enable == false
              ? null
              : () async {
                  submit();
                },
        )
      ],
    );
  }
}
