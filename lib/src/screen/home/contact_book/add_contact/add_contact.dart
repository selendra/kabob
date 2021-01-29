import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/contact_book_m.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/screen/home/contact_book/add_contact/add_contact_body.dart';
import 'package:wallet_apps/src/screen/home/contact_book/contact_book_body.dart';

class AddContact extends StatefulWidget {

  final CreateAccModel accModel;
  final PhoneContact contact;

  AddContact({this.accModel, this.contact});
  
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  ContactBookModel _addContactModel = ContactBookModel();

  void submitContact() async {
    
    try {
      // Show Loading
      dialogLoading(context);
      // final pass = await StorageServices.fetchData('pass');
      // print(widget.accModel.sdk.api.keyring.addContact(keyring, acc))
      final acc = await widget.accModel.sdk.api.keyring.importAccount(
        widget.accModel.keyring,
        keyType: KeyType.mnemonic,
        name: "Daveat",
        password: '123456',
      );

      await widget.accModel.sdk.api.keyring.addContact(widget.accModel.keyring, acc).then((value) {

        // Close Dialog Loading
        Navigator.pop(context);
        print("Add contact  response $value");
      });
    } catch (e) {
      print("My error $e");
    }
    // Close Dialog Loading
    Navigator.pop(context);
  }

  @override
  initState(){
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
          model: _addContactModel,
          submitContact: submitContact
        )
      )
    );
  }
}