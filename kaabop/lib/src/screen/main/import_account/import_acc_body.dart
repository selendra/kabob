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
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        Expanded(
          child: BodyScaffold(
            height: MediaQuery.of(context).size.height-70,
            bottom: 0,
            child: Form(
              key: importAccModel.formKey,
              child: Column(
                children: [

                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Align(
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
                    )
                  ),

                  // TabBar
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
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
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              child: const MyText(
                                text: "Mnemonic",
                                color: AppColors.secondarytext,
                                // color: "#FFFFFF",
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                    title: Align(
                                      child: MyText(text: "Oops", fontWeight: FontWeight.w600,),
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                                      child: Text("This feature has not implemented yet!", textAlign: TextAlign.center),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
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
                              child: MyText(
                                text: "Keystore (json)",
                                color: isDarkTheme ? AppColors.whiteColorHexa : AppColors.blackColor,
                                // color: "#FFFFFF",
                              ),
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                  
                  MyInputField(
                    pTop: 30,
                    pLeft: 20,
                    pRight: 20,
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

                  if (reImport != null)
                    MyInputField(
                      pLeft: 20,
                      pRight: 20,
                      pBottom: 16.0,
                      labelText: "Pin",
                      textInputFormatter: [LengthLimitingTextInputFormatter(4)],
                      controller: importAccModel.pwCon,
                      focusNode: importAccModel.pwNode,
                      validateField: (value) => value.isEmpty ? 'Please fill in pin' : null,
                      maxLine: null,
                      onChanged: onChanged,
                      //inputAction: TextInputAction.done,
                      onSubmit: onSubmit,
                    )
                  else
                    Container(),

                  Expanded(
                    child: Container(),
                  ),
                  // MyFlatButton(
                  //   hasShadow: enable,
                  //   edgeMargin: const EdgeInsets.only(left: 66, right: 66, bottom: 16),
                  //   textButton: AppText.next,
                  //   action: enable == false
                  //     ? null
                  //     : () async {
                  //       submit();
                  //     },
                  // )
                  MyFlatButton(
                    hasShadow: enable,
                    edgeMargin: const EdgeInsets.only(left: 66, right: 66, bottom: 16),
                    textButton: AppText.next,
                    action: enable == false
                      ? null
                      : () async {
                        submit();
                      },
                  )
                ],
              ),
            ),
          )
        ),

      ],
    );
  }
}
