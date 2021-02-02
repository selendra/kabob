import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/contact_book_m.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/screen/home/contact_book/contact_book_body.dart';

class ContactBook extends StatefulWidget {

  final CreateAccModel sdkModel;

  ContactBook(this.sdkModel);

  static const String route = '/contactList';

  @override
  _ContactBookState createState() => _ContactBookState();
}

class _ContactBookState extends State<ContactBook> {

  ContactBookModel _contactBookModel = ContactBookModel();

  Future<void> getContact() async {
    try {
      _contactBookModel.contactBookList = [];
      var value = await StorageServices.fetchData('contactList');

      print("Get from storage $value");
      if(value == null) {
        _contactBookModel.contactBookList = null;
        print("My contact");
      }
      else {
        print("Ke contact");
        for(var i in value){
          _contactBookModel.contactBookList.add(
            ContactBookModel.initList(
              contactNum: i['phone'], 
              username: i['username'], 
              address: i['address'], 
              memo: i['memo'],
            ),
          );

        } 
      }
      setState(() {});
    } catch (e) {
      await dialog(context, Text("Cannot add contact"), Text("Message"));
    }
  }

  @override
  initState(){
    getContact();
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
          sdkModel: widget.sdkModel,
          getContact: getContact
        )
      )
    );
  }
}