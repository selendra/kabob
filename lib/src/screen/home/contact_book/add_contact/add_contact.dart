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

  Future<void> submitContact() async {
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

      // Close Dialog Loading
      Navigator.pop(context);
      print("Close Dialog");

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

  void onChanged(String value) {
    _addContactModel.formKey.currentState.validate();
    allValidator();
  }

  void onSubmit() async {
    if (_addContactModel.contactNumberNode.hasFocus) {
      FocusScope.of(context).requestFocus(_addContactModel.userNameNode);
    } else if (_addContactModel.userNameNode.hasFocus) {
      FocusScope.of(context).requestFocus(_addContactModel.addressNode);
    } else if (_addContactModel.addressNode.hasFocus) {
      FocusScope.of(context).requestFocus(_addContactModel.memoNode);
    } else {
      if (_addContactModel.enable) await submitContact();
    }
  }

  void allValidator() {
    if (_addContactModel.contactNumber.text.isNotEmpty &&
        _addContactModel.userName.text.isNotEmpty &&
        _addContactModel.address.text.isNotEmpty) {
      setState(() {
        _addContactModel.enable = true;
      });
    } else if (_addContactModel.enable)
      setState(() {
        _addContactModel.enable = false;
      });
  }

  String validateAddress(String value) {
    _addContactModel.addressValidator = instanceValidate.validateAsset(value);
    if (_addContactModel.addressValidator != null)
      return _addContactModel.addressValidator + ' address';
    return _addContactModel.addressValidator;
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
                model: _addContactModel,
                validateAddress: validateAddress,
                onChanged: onChanged,
                onSubmit: onSubmit,
                submitContact: submitContact)));
  }
}
