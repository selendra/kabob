import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/contact_book_m.dart';
import 'package:wallet_apps/src/screen/home/contact_book/edit_contact/edit_contact_body.dart';

class EditContact extends StatefulWidget {
  final List<ContactBookModel> contact;
  final int index;

  EditContact({this.contact, this.index});

  @override
  _EditContactState createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {

  ContactBookModel _addContactModel = ContactBookModel();

  List<Map<String, dynamic>> contactData = List<Map<String, dynamic>>();

  Future<void> submitContact() async {

    try {
      // Show Loading
      dialogLoading(context);

      await Future.delayed(Duration(seconds: 1), (){});

      var result = await dialog(
        context,
        Text("Are you sure to edit this contact?"),
        Text("Message"),
        action: FlatButton(
          child: Text("Yes"),
          onPressed: () async {
            widget.contact[widget.index] = _addContactModel;

            for (var data in widget.contact){
              contactData.add(
                {
                  'username': data.userName.text,
                  'phone': data.contactNumber.text,
                  'address': data.address.text,
                  'memo': data.memo.text
                }
              );
            }
            await StorageServices.setData(contactData, 'contactList');

            Navigator.pop(context, true);
          },
        )
      );

      // Close Dialog Loading
      Navigator.pop(context);
      //print("Close Dialog");

      if (result) {
        await dialog(context, Text("Successfully edit contact!\n Please check your contact book"), Text("Congratualtion"));
        // Close Screen
        Navigator.pop(context, true);
      } else {
        Navigator.pop(context);
      }

    } catch (e) {
      // Close Dialog Loading
      Navigator.pop(context);
      //print("My error $e");
    }
  }

  void onChanged(String value){
    _addContactModel.formKey.currentState.validate();
    allValidator();
  }

  void onSubmit() async {
    if (_addContactModel.contactNumberNode.hasFocus){
      FocusScope.of(context).requestFocus(_addContactModel.userNameNode);
    } else if (_addContactModel.userNameNode.hasFocus){
      FocusScope.of(context).requestFocus(_addContactModel.addressNode);
    } else if (_addContactModel.addressNode.hasFocus){
      FocusScope.of(context).requestFocus(_addContactModel.memoNode);
    } else {
      if (_addContactModel.enable) await submitContact();
    }
  }

  void allValidator(){
    //print("1"+_addContactModel.contactNumber.text.isNotEmpty.toString());
    //print("2"+_addContactModel.userName.text.isNotEmpty.toString());
    //print("3"+_addContactModel.address.text.isNotEmpty.toString());
    if (
      _addContactModel.contactNumber.text.isNotEmpty &&
      _addContactModel.userName.text.isNotEmpty &&
      _addContactModel.address.text.isNotEmpty
    ){
      setState((){_addContactModel.enable = true;});
    } else if(_addContactModel.enable) setState((){_addContactModel.enable = false;});
  }

  String validateAddress(String value){
    if(_addContactModel.addressNode.hasFocus){
      if (value.isEmpty) {
        return 'Please fill in address';
      }
    }
    return null;
  }

  @override
  initState(){
    _addContactModel = widget.contact[widget.index];
    allValidator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: EditContactBody(
          model: _addContactModel,
          validateAddress: validateAddress,
          onChanged: onChanged,
          onSubmit: onSubmit,
          submitContact: submitContact
        )
      )
    );
  }
}
