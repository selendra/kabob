import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/contact_book_m.dart';

class AddContactBody extends StatelessWidget {

  final ContactBookModel model;
  final Function submitContact;

  AddContactBody({this.model, this.submitContact});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        MyAppBar(
          title: "Contact List",
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        Container(
          margin: EdgeInsets.only(top: 16),
          child: Form(
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
                  onChanged: (String value){

                  },
                  pBottom: 16,
                  onSubmit: (){}
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
                  onChanged: (String value){

                  },
                  pBottom: 16,
                  onSubmit: (){}
                ),

                // Row(
                //   children: [
                //     MyInputField(
                //       labelText: "Address",
                //       prefixText: null,
                //       textInputFormatter: [
                //         LengthLimitingTextInputFormatter(TextField.noMaxLength)
                //       ],
                //       inputType: TextInputType.text,
                //       controller: model.address,
                //       focusNode: model.addressNode,
                //       validateField: (String fun){},
                //       onChanged: (String value){

                //       },
                //       pBottom: 16,
                //       onSubmit: (){}
                //     ),

                //     // Expanded(
                //     //   child: IconButton(
                //     //     icon: Icon(Icons.ac_unit),
                //     //     onPressed: (){
                          
                //     //     },
                //     //   )
                //     // )
                //   ],
                // ),

                MyInputField(
                      labelText: "Address",
                      prefixText: null,
                      textInputFormatter: [
                        LengthLimitingTextInputFormatter(TextField.noMaxLength)
                      ],
                      inputType: TextInputType.text,
                      controller: model.address,
                      focusNode: model.addressNode,
                      validateField: (String fun){},
                      onChanged: (String value){

                      },
                      pBottom: 16,
                      onSubmit: (){}
                    ),

                MyInputField(
                  labelText: "Memo",
                  prefixText: null,
                  textInputFormatter: [
                    LengthLimitingTextInputFormatter(TextField.noMaxLength)
                  ],
                  inputType: TextInputType.text,
                  controller: model.memo,
                  focusNode: model.memoNode,
                  validateField: (String fun){},
                  onChanged: (String value){

                  },
                  pBottom: 16,
                  onSubmit: (){}
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
          action: submitContact
        )
      ],
    );
  }
}