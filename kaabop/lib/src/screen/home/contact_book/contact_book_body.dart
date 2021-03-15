import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/contact_book_m.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/screen/home/contact_book/add_contact/add_contact.dart';

class ContactBookBody extends StatelessWidget {
  final CreateAccModel sdkModel;

  final ContactBookModel model;

  final Function getContact;

  final Function deleteContact;

  final Function editContact;

  const ContactBookBody(
      {this.model,
      this.getContact,
      this.sdkModel,
      this.deleteContact,
      this.editContact});

  @override
  Widget build(BuildContext context) {
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
              // ignore: deprecated_member_use
              child: FlatButton(
                padding: const EdgeInsets.only(right: 16),
                onPressed: () async {
                  dynamic response;
                  PhoneContact result;
                  final bool value =
                      await FlutterContactPicker.requestPermission();

                  if (value) {
                    result = await FlutterContactPicker.pickPhoneContact();

                    response = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddContact(
                          contact: result,
                          sdkModel: sdkModel,
                        ),
                      ),
                    );
                    if (response == true) await getContact();
                  }
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: model.contactBookList == null
              ? const Center(
                  child: MyText(
                    text: 'No contact',
                    color: "#FFFFFF",
                    fontSize: 25,
                  ),
                )
              : model.contactBookList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView.builder(
                        itemCount: model.contactBookList.length,
                        itemBuilder: (context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              final options = await showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return SimpleDialog(
                                      title: const Text('Options'),
                                      children: [
                                        SimpleDialogItem(
                                          icon: Icons.near_me,
                                          text: 'Send',
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => SubmitTrx(
                                                  model.contactBookList[index]
                                                      .address.text,
                                                  false,
                                                  const [],
                                                  sdkModel,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        SimpleDialogItem(
                                          icon: Icons.edit,
                                          text: 'Edit',
                                          onPressed: () {
                                            Navigator.pop(context, 'edit');
                                          },
                                        ),
                                        SimpleDialogItem(
                                          icon: Icons.delete,
                                          text: 'Delete',
                                          onPressed: () {
                                            Navigator.pop(context, 'delete');
                                          },
                                        ),
                                      ],
                                    );
                                  });
                              if (options == 'delete') {
                                await dialog(
                                    context,
                                    const Text(
                                      "Do you really want to deleteContact this contact",
                                    ),
                                    const Text("Message"),
                                    // ignore: deprecated_member_use
                                    action: FlatButton(
                                      onPressed: () async {
                                        await deleteContact(index);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Yes"),
                                    ));
                              } else if (options == 'edit') {
                                await editContact(index);
                              }
                            },
                            child: Card(
                              color: hexaCodeToColor(AppColors.cardColor),
                              margin: const EdgeInsets.only(bottom: 16.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.only(right: 16),
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
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
                                          text: model.contactBookList[index]
                                              .address.text,
                                          color: AppColors.secondarytext,
                                          textAlign: TextAlign.start,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                          width: 300,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }
}

class SimpleDialogItem extends StatelessWidget {
  const SimpleDialogItem(
      {Key key, this.icon, this.color, this.text, this.onPressed})
      : super(key: key);

  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Icon(icon, size: 28.0, color: color),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 16.0),
              child: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
