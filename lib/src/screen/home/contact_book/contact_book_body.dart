import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/contact_book_m.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/screen/home/contact_book/add_contact/add_contact.dart';

class ContactBookBody extends StatelessWidget {

  final ContactBookModel model;

  final Function getContact;

  ContactBookBody({this.model, this.getContact});


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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    MyText(text: 'Add', color: "#FFFFFF"),
                  ],
                ),
                onPressed: () async {
                  await FlutterContactPicker.hasPermission().then((value) async {
                    
                    if (value) {
                      var result = await FlutterContactPicker.pickPhoneContact();

                      dynamic response = await Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => AddContact(contact: result),
                        )
                      );
                        
                      print(response);
                      if (response == true) getContact();
                    }
                  });
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
              )
            ),
          )
        ),

        Expanded(
          child: model.contactBookList == null ? Center(child: MyText(text: 'No contact', color: "#FFFFFF", fontSize: 25,)) : model.contactBookList.isEmpty ? Center(child: CircularProgressIndicator())  : Padding(
            padding: EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: model.contactBookList.length,
              itemBuilder: (context, int index){
                return Card(
                  margin: EdgeInsets.only(bottom: 16.0),
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
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: SvgPicture.asset('assets/male_avatar.svg'),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              text: model.contactBookList[index].userName.text,
                              color: "#FFFFFF",
                              fontSize: 20,
                            ),
                            MyText(
                              text: 'SEL',
                              color: AppColors.secondary_text,
                              fontSize: 30,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.bold,
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
                  )
                );
              }
            )
          )
        )
      ],
    );
  }
}