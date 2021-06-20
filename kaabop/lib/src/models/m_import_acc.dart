import 'package:wallet_apps/index.dart';

class ImportAccModel {
  
  TextEditingController mnemonicCon = TextEditingController();

  TextEditingController pwCon = TextEditingController();

  final formKey = GlobalKey<FormState>();

  FocusNode mnemonicNode = FocusNode();

  FocusNode pwNode = FocusNode();
}