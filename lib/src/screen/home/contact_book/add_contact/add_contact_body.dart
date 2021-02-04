import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/contact_book_m.dart';

class AddContactBody extends StatelessWidget {

  final ContactBookModel model;
  final Function validateAddress;
  final Function submitContact;
  final Function onChanged;
  final Function onSubmit;

  AddContactBody({this.model, this.validateAddress, this.submitContact, this.onChanged, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        MyAppBar(
          title: "Add Contact",
          onPressed: () {
            print("Dae");
            Navigator.pop(context);
          },
        ),

        Container(
          margin: EdgeInsets.only(top: 16),
          child: Form(
            key: model.formKey,
            child: Column(
              children: [
                MyInputField(
                  labelText: "Contact number",
                  prefixText: null,
                  textInputFormatter: [
                    LengthLimitingTextInputFormatter(TextField.noMaxLength)
                  ],
                  inputType: TextInputType.phone,
                  controller: model.contactNumber,
                  focusNode: model.contactNumberNode,
                  enableInput: false,
                  validateField: (String fun){},
                  onChanged: onChanged,
                  pBottom: 16,
                  onSubmit: onSubmit
                ),

                MyInputField(
                  labelText: "User name",
                  prefixText: null,
                  textInputFormatter: [
                    LengthLimitingTextInputFormatter(TextField.noMaxLength)
                  ],
                  inputType: TextInputType.text,
                  controller: model.userName,
                  focusNode: model.userNameNode,
                  validateField: (String fun){},
                  onChanged: onChanged,
                  pBottom: 16,
                  onSubmit: onSubmit
                ),

                Row(
                  children: [
                    Expanded(
                      child: MyInputField(
                        labelText: "Address",
                        prefixText: null,
                        textInputFormatter: [
                          LengthLimitingTextInputFormatter(TextField.noMaxLength)
                        ],
                        inputType: TextInputType.text,
                        controller: model.address,
                        focusNode: model.addressNode,
                        validateField: validateAddress,
                        onChanged: onChanged,
                        pBottom: 16,
                        onSubmit: onSubmit
                      )
                    ),

                    IconButton(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 20, right: 36),
                      icon: SvgPicture.asset('assets/sld_qr.svg'),
                      onPressed: () async {
                        try {
                          var _response = await Navigator.push(
                            context,
                            transitionRoute(QrScanner(
                              // portList: portfolioList,
                              // sdk: sdk,
                              // keyring: keyring,
                            ))
                          );
                          
                          if (_response != null) {
                            model.address.text = _response;
                            onChanged(_response);
                          }
                        } catch (e) {
                          print("Error from QR scanner $e");
                        }
                      },
                    )
                  ],
                ),

                MyInputField(
                  labelText: "Memo",
                  prefixText: null,
                  textInputFormatter: [
                    LengthLimitingTextInputFormatter(TextField.noMaxLength)
                  ],
                  inputType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  controller: model.memo,
                  focusNode: model.memoNode,
                  validateField: (String fun){},
                  onChanged: onChanged,
                  pBottom: 16,
                  onSubmit: onSubmit,
                )
              ],
            ),
          )
        ),

        MyFlatButton(
          textButton: "Add contact",
          buttonColor: AppColors.secondary,
          fontWeight: FontWeight.bold,
          fontSize: size18,
          edgeMargin: EdgeInsets.only(top: 40, left: 66, right: 66, bottom: 16),
          hasShadow: true,
          action: model.enable ? submitContact : null
        )
      ],
    );
  }
}