import 'package:wallet_apps/index.dart';

class FillPin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FillPinState();
  }
}

class FillPinState extends State<FillPin> {
  final TextEditingController _pinPutController = TextEditingController();

  TextEditingController pinController = TextEditingController();

  final FocusNode _pinNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
        // border: Border.all(color: Colors.deepPurpleAccent),
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey.withOpacity(0.5));
  }

  BoxConstraints get boxConstraint {
    return const BoxConstraints(minWidth: 60, minHeight: 80);
  }

  @override
  void initState() {
    _pinPutController.clear();
    _pinNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _pinPutController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: const MyText(
        top: 16,
        bottom: 16,
        text: "Fill your pin ",
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 13, bottom: 20),
            child: PinPut(
              obscureText: '⚪',
              focusNode: _pinNode,
              controller: _pinPutController,
              fieldsCount: 4,
              eachFieldMargin: const EdgeInsets.only(left: 13),
              selectedFieldDecoration: _pinPutDecoration.copyWith(
                color: Colors.grey.withOpacity(0.5),
                border: Border.all(color: Colors.grey),
              ),
              submittedFieldDecoration: _pinPutDecoration,
              followingFieldDecoration: _pinPutDecoration,
              eachFieldConstraints: boxConstraint,
              textStyle: const TextStyle(fontSize: 18, color: Colors.white),
              onSubmit: (value) {
                Navigator.pop(context, value);
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const MyText(text: "Close"),
            ),
          )
        ],
      ),

      // content: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Container(
      //       padding: const EdgeInsets.only(right: 16, bottom: 20),
      //       child: TextField(
      //         decoration: InputDecoration(hintText: 'Pin'),
      //         controller: pinController,
      //         onSubmitted: (value) {
      //           Navigator.pop(context, value);
      //         },
      //       ),
      //     ),

      // Align(
      //   alignment: Alignment.centerRight,
      //   child: GestureDetector(
      //     child: MyText(text: "Close"),
      //     onTap: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // )
      //     ],
      //   ),
    );
  }
}
