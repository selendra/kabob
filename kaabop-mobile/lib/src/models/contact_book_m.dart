import 'package:wallet_apps/index.dart';

class ContactBookModel {

  List<ContactBookModel> contactBookList = List<ContactBookModel>();
  // [
  //   // ContactBookModel.initList(contactNum: '123', address: "1", username: "Daveat", memo: "IT"),
  //   // ContactBookModel.initList(contactNum: '123', address: "2", username: "God", memo: "IT"),
  //   // ContactBookModel.initList(contactNum: '123', address: "3", username: "d", memo: "IT"),
  //   // ContactBookModel.initList(contactNum: '123', address: "4", username: "v", memo: "IT"),
  //   // ContactBookModel.initList(contactNum: '123', address: "5", username: "a", memo: "IT"),
  //   // ContactBookModel.initList(contactNum: '123', address: "6", username: "c", memo: "IT"),
  // ];

  TextEditingController contactNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController memo = TextEditingController();

  FocusNode userNameNode = FocusNode();
  FocusNode addressNode = FocusNode();
  FocusNode memoNode = FocusNode();
  FocusNode contactNumberNode = FocusNode();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool enable = false;

  String addressValidator;

  ContactBookModel();

  ContactBookModel.initList({String contactNum, String address, String username, String memo}){
    this.contactNumber.text = contactNum;
    this.address.text = address;
    this.userName.text = username;
    this.memo.text = memo;
  }
}