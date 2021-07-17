import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/contact_book_m.dart';
import 'package:wallet_apps/src/screen/home/contact_book/add_contact/add_contact.dart';

class ContactBookBody extends StatefulWidget {
  final ContactBookModel model;

  final Function getContact;

  final Function deleteContact;

  final Function editContact;

  const ContactBookBody({
    this.model,
    this.getContact,
    this.deleteContact,
    this.editContact,
  });

  @override
  _ContactBookBodyState createState() => _ContactBookBodyState();
}

class _ContactBookBodyState extends State<ContactBookBody> {
  // Future<void> dialog(String text1, String text2, {Widget action}) async {
  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  //         title: Align(
  //           child: Text(text1),
  //         ),
  //         content: Padding(
  //           padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
  //           child: Text(text2),
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Column(
      children: [
        MyAppBar(
          title: "Contact List",
          color: isDarkTheme
              ? hexaCodeToColor(AppColors.darkCard)
              : hexaCodeToColor(AppColors.cardColor),
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
                        ),
                      ),
                    );
                    if (response == true) await widget.getContact();
                  }
                },
                child: Icon(
                  Icons.add,
                  color: isDarkTheme ? Colors.white : Colors.black,
                  size: 25,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: widget.model.contactBookList == null
              ? Center(
                  child: SvgPicture.asset(
                    'assets/icons/no_data.svg',
                    width: 180,
                    height: 180,
                  ),
                )
              : widget.model.contactBookList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await widget.getContact();
                        },
                        child: ListView.builder(
                          itemCount: widget.model.contactBookList.length,
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
                                                  builder: (context) =>
                                                      SubmitTrx(
                                                    widget
                                                        .model
                                                        .contactBookList[index]
                                                        .address
                                                        .text,
                                                    false,
                                                    const [],
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
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        content: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15.0, bottom: 15.0),
                                          child: Text(
                                              "Do you really want to deleteContact this contact?"),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Close'),
                                          ),
                                          FlatButton(
                                            onPressed: () async {
                                              await widget.deleteContact(index);
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Yes"),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                  // await dialog(
                                  //     "Do you really want to deleteContact this contact",
                                  //     "Message",
                                  //     // ignore: deprecated_member_use
                                  //     action: FlatButton(
                                  //       onPressed: () async {
                                  //         await widget.deleteContact(index);
                                  //         Navigator.pop(context);
                                  //       },
                                  //       child: const Text("Yes"),
                                  //     ));
                                } else if (options == 'edit') {
                                  await widget.editContact(index);
                                }
                              },
                              child: Card(
                                color: isDarkTheme
                                    ? hexaCodeToColor(AppColors.darkCard)
                                    : hexaCodeToColor(AppColors.cardColor),
                                margin: const EdgeInsets.only(bottom: 16.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        margin:
                                            const EdgeInsets.only(right: 16),
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
                                            text: widget
                                                .model
                                                .contactBookList[index]
                                                .userName
                                                .text,
                                            color: isDarkTheme
                                                ? AppColors.whiteColorHexa
                                                : AppColors.textColor,
                                            fontSize: 20,
                                          ),
                                          MyText(
                                            text: widget
                                                .model
                                                .contactBookList[index]
                                                .address
                                                .text,
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
