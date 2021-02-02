import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/contact_book_m.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/screen/home/contact_book/add_contact/add_contact.dart';

class ContactBookBody extends StatelessWidget {

  final CreateAccModel sdkModel;

  final ContactBookModel model;

  final Function getContact;

  ContactBookBody({this.model, this.getContact, this.sdkModel});

  @override
  Widget build(BuildContext context) {
    print(model.contactBookList);
    return Column(
      children: [
        MyAppBar(
            title: "Contact List",
            onPressed: () {
              Navigator.pop(context);
            },
            tile: Expanded(
              child: Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(Icons.add, color: Colors.white, size: 25,),
                    onPressed: () async {
                      print("Hello world");
                      dynamic response;
                      await FlutterContactPicker.requestPermission()
                          .then((value) async {
                        if (value) {
                          var result = await FlutterContactPicker.pickPhoneContact();

                          response = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddContact(contact: result),
                            )
                          );

                          print("Close screen $response");
                        }
                      });
                      if (response == true) await getContact();

                      // try{

                      //   final PhoneContact _contact = await FlutterContactPicker.pickPhoneContact().then((value) );
                      //   print("My contact ${_contact}");
                      // } catch (e) {
                      //   print("error contact $e");
                      // }
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => AddContact()
                      //   )
                      // );
                    },
                  )),
            )),
        Expanded(
            child: model.contactBookList == null
                ? Center(
                    child: MyText(
                    text: 'No contact',
                    color: "#FFFFFF",
                    fontSize: 25,
                  ))
                : model.contactBookList.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: EdgeInsets.all(16),
                        child: ListView.builder(
                            itemCount: model.contactBookList.length,
                            itemBuilder: (context, int index) {
                              return Card(
                                margin: EdgeInsets.only(bottom: 16.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(builder: (context) => SubmitTrx(model.contactBookList[index].address.text, false, [], sdkModel.sdk, sdkModel.keyring)));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(right: 16),
                                            width: 70,
                                            height: 70,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: SvgPicture.asset(
                                                'assets/male_avatar.svg'),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText(
                                                text: model.contactBookList[index]
                                                    .userName.text,
                                                color: "#FFFFFF",
                                                fontSize: 20,
                                              ),
                                              MyText(
                                                text: model.contactBookList[index].address.text,
                                                color: AppColors.secondary_text,
                                                textAlign: TextAlign.start,
                                                fontWeight: FontWeight.bold,
                                                overflow: TextOverflow.ellipsis,
                                                width: 300
                                              ),
                                            ],
                                          ),
                                          // Expanded(child: Container()),
                                          // Align(
                                          //   alignment: Alignment.bottomRight,
                                          //   child: Container(
                                          //     width: 150,
                                          //     child: MyText(
                                          //       text: accBalance,
                                          //       fontSize: 30,
                                          //       color: AppColors.secondary_text,
                                          //       fontWeight: FontWeight.bold,
                                          //       overflow: TextOverflow.ellipsis,
                                          //     ),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    ),
                                )
                              );
                            })))
      ],
    );
  }
}
