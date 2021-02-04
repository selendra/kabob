import 'package:wallet_apps/index.dart';

class ProviderBloc extends InheritedWidget {
  // final bloc = Bloc();

  @override
  bool updateShouldNotify(_) => true;

  ProviderBloc({Widget child}) : super(child: child);

  static ProviderBloc of(BuildContext context) {
    // return (context.inheritFromWidgetOfExactType(Provider) as Provider).bloc;
    return context.dependOnInheritedWidgetOfExactType<ProviderBloc>();
  }

  static Future fetchStatusNWallet() async {
    var userStatusNWallet =
        await StorageServices.fetchData('userStatusAndWallet');
    return userStatusNWallet;
  }

  static String idsUser;

  static fetchUserIds() async {
    var userIds = await StorageServices.fetchData('user_token');
    if (userIds != null) {
      idsUser = await userIds['id'];
    }
  }

  /* Fetch Token */
  static fetchToken() async {
    var token = await StorageServices.fetchData('user_token');
    return token;
  }
}
