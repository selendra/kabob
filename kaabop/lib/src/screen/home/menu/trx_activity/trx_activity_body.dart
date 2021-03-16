import 'package:wallet_apps/index.dart';

class TrxActivityBody extends StatelessWidget{

  final List<dynamic> activityList;
  final void Function() popScreen;

  const TrxActivityBody({
    this.activityList,
    this.popScreen
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MyAppBar(
          title: "My activity",
          onPressed: popScreen,
        ),
        Expanded(
          child: buildListBody(activityList),
        )
      ],
    );
  }

}