import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/contact_book_m.dart';
import 'package:wallet_apps/src/screen/home/contact_book/contact_book_body.dart';
import 'package:wallet_apps/src/screen/home/contact_book/edit_contact/edit_contact.dart';

class ContactBook extends StatefulWidget {
  static const String route = '/contactList';

  @override
  _ContactBookState createState() => _ContactBookState();
}

class _ContactBookState extends State<ContactBook> {
  final ContactBookModel _contactBookModel = ContactBookModel();

  List<Map<String, dynamic>> contactData = [];

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

  Future<void> getContact() async {
    try {
      _contactBookModel.contactBookList = [];
      final value = await StorageServices.fetchData('contactList');

      if (value == null) {
        _contactBookModel.contactBookList = null;
      } else {
        for (final i in value) {
          _contactBookModel.contactBookList.add(
            ContactBookModel.initList(
              contactNum: i['phone'].toString(),
              username: i['username'].toString(),
              address: i['address'].toString(),
              memo: i['memo'].toString(),
            ),
          );
        }
      }
      setState(() {});
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Align(
              child: Text('Opps'),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Text('Cannot add contact'),
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
      // await dialog(
      //   "Cannot add contact",
      //   "Message",
      // );
    }
  }

  Future<void> deleteContact(int index) async {
    _contactBookModel.contactBookList.removeAt(index);
    //print("Empty ${_contactBookModel.contactBookList.isEmpty}");
    if (_contactBookModel.contactBookList.isEmpty) {
      await StorageServices.removeKey('contactList');
      _contactBookModel.contactBookList = null;

      setState(() {});
    } else {
      for (final data in _contactBookModel.contactBookList) {
        contactData.add({
          'username': data.userName.text,
          'phone': data.contactNumber.text,
          'address': data.address.text,
          'memo': data.memo.text
        });
      }
      await StorageServices.setData(contactData, 'contactList');
      await getContact();
    }
  }

  Future<void> editContact(int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditContact(
          contact: _contactBookModel.contactBookList,
          index: index,
        ),
      ),
    );

    await getContact();
  }

  @override
  void initState() {
    getContact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: ContactBookBody(
          model: _contactBookModel,
          deleteContact: deleteContact,
          editContact: editContact,
          getContact: getContact,
        ),
      ),
    );
  }
}
