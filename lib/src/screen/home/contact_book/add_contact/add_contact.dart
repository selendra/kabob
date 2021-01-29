import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/contact_book_m.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/screen/home/contact_book/add_contact/add_contact_body.dart';
import 'package:wallet_apps/src/screen/home/contact_book/contact_book_body.dart';

class AddContact extends StatefulWidget {
  final PhoneContact contact;

  AddContact({this.contact});

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  ContactBookModel _addContactModel = ContactBookModel();

  void submitContact() async {
    try {
      // Show Loading
      dialogLoading(context);

      await Future.delayed(Duration(seconds: 1), () {});
      Map<String, dynamic> contactData = {
        'username': _addContactModel.userName.text,
        'phone': _addContactModel.contactNumber.text,
        'address': _addContactModel.address.text,
        'memo': _addContactModel.memo.text
      };

      await StorageServices.addMoreData(contactData, 'contactList');

      await StorageServices.fetchData('contactList');

      // Close Dialog Loading
      Navigator.pop(context);

      await dialog(
          context,
          Text(
              "Successfully add new contact!\n Please check your contact book"),
          Text("Congratualtion"));
      // Close Screen
      Navigator.pop(context, true);
    } catch (e) {
      // Close Dialog Loading
      Navigator.pop(context);
      print("My error $e");
    }
  }

  @override
  initState() {
    _addContactModel.contactNumber.text = widget.contact.phoneNumber.number;
    _addContactModel.userName.text = widget.contact.fullName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyScaffold(
            height: MediaQuery.of(context).size.height,
            child: AddContactBody(
                model: _addContactModel, submitContact: submitContact)));
  }
}
