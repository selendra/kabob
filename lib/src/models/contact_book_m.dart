import 'package:wallet_apps/index.dart';

class ContactBookModel {

  TextEditingController contactNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController memo = TextEditingController();

  FocusNode userNameNode = FocusNode();
  FocusNode addressNode = FocusNode();
  FocusNode memoNode = FocusNode();
  FocusNode contactNumberNode = FocusNode();

  ContactBookModel(){}

  ContactBookModel.initList({String address, String username, String memo}){
    this.address.text = address;
    this.userName.text = username;
    this.memo.text = memo;
  }
}