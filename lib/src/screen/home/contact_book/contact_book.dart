import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/contact_book_m.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/screen/home/contact_book/contact_book_body.dart';

class ContactBook extends StatefulWidget {

  final CreateAccModel accModel;

  ContactBook(this.accModel);

  static const String route = '/contactList';

  @override
  _ContactBookState createState() => _ContactBookState();
}

class _ContactBookState extends State<ContactBook> {

  ContactBookModel _contactBookModel = ContactBookModel();

  List<ContactBookModel> contactBookList = [
    ContactBookModel.initList(address: "1", username: "Daveat", memo: "IT"),
    ContactBookModel.initList(address: "2", username: "God", memo: "IT"),
    ContactBookModel.initList(address: "3", username: "d", memo: "IT"),
    ContactBookModel.initList(address: "4", username: "v", memo: "IT"),
    ContactBookModel.initList(address: "5", username: "a", memo: "IT"),
    ContactBookModel.initList(address: "6", username: "c", memo: "IT"),
  ];

  @override
  initState(){
    // print(widget.sdkModel.keyring.contacts)
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: ContactBookBody(
          model: _contactBookModel,
          contactList: contactBookList,
          accModel: widget.accModel 
        )
      )
    );
  }
}