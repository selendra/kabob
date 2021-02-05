import 'package:flutter_screenshot_switcher/flutter_screenshot_switcher.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/createAccountM.dart';
import 'package:wallet_apps/src/screen/main/create_user_info/user_infor.dart';

class ConfirmMnemonic extends StatefulWidget {
  final CreateAccModel accModel;

  ConfirmMnemonic(this.accModel);

  static const route = '/confirmMnemonic';

  @override
  _ConfirmMnemonicState createState() => _ConfirmMnemonicState();
}

class _ConfirmMnemonicState extends State<ConfirmMnemonic> {
  List<String> _wordsSelected = [];

  List _mnemonic = [];

  bool enable = false;

  List _wordsLeft = [
    // 'child',
    // 'capital',
    // 'fashion',
    // 'three',
    // 'mushroom',
    // 'aim',
    // 'cash',
    // 'expire',
    // 'quantum',
    // 'steel',
    // 'recycle',
    // 'shrug'
  ];

  Widget _buildWordsButtons() {
    if (_wordsLeft.length > 0) {
      _wordsLeft.sort();
    }

    List<Widget> rows = <Widget>[];

    for (var r = 0; r * 3 < _wordsLeft.length; r++) {
      if (_wordsLeft.length > r * 3) {
        rows.add(Row(
          children: _wordsLeft
              .getRange(
                  r * 3,
                  _wordsLeft.length > (r + 1) * 3
                      ? (r + 1) * 3
                      : _wordsLeft.length)
              .map(
                (i) => Container(
                  alignment: Alignment.center,
                  color: hexaCodeToColor(AppColors.cardColor),
                  padding: EdgeInsets.only(left: 4, right: 4, bottom: 4),
                  margin: EdgeInsets.only(left: 4, right: 4, bottom: 4),
                  child: FlatButton(
                    child: MyText(
                      text: i,
                      fontSize: 18,
                      color: AppColors.secondary_text,
                      fontWeight: FontWeight.bold,
                    ),
                    onPressed: () {
                      setState(() {
                        _wordsLeft.remove(i);
                        _wordsSelected.add(i);
                      });
                      if (_wordsLeft.isEmpty) validationMnemonic();
                    },
                  ),
                ),
              )
              .toList(),
        ));
      }
    }
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: rows,
      ),
    );
  }

  void setMnemonic() {
    _wordsLeft.clear();
    for (var i in widget.accModel.mnemonicList) {
      _wordsLeft.add(i); // Use For Sort Mnemonic
    }
    _wordsLeft.sort();
    setState(() {
      enable = false;
    });
  }

  void validationMnemonic() {
    int i = 0;
    while (i < _mnemonic.length) {
      if (_mnemonic[i] != _wordsSelected[i]) break;
      i++;
    }
    if (i == _mnemonic.length) {
      setState(() {
        enable = true;
      });
    } else if (enable) {
      setState(() {
        enable = false;
      });
    }
  }

  @override
  initState() {
    for (var i in widget.accModel.mnemonicList) {
      _wordsLeft.add(i); // Use For Sort Mnemonic
      _mnemonic.add(i); // Use For Compare
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: BodyScaffold(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          MyAppBar(
            color: hexaCodeToColor(AppColors.cardColor),
            title: 'Create Account',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: MyText(
                      text: 'Confirm the mnemonic',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: "#FFFFFF",
                      bottom: 12,
                    )),

                MyText(
                  textAlign: TextAlign.left,
                  text:
                      'Please click on the mnemonic in the correct order to confirm',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: "#FFFFFF",
                  bottom: 12,
                ),

                InkWell(
                    onTap: () {
                      _wordsSelected = [];
                      setMnemonic();
                    },
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: MyText(
                            text: 'Reset',
                            bottom: 16,
                            color: AppColors.secondary_text))),

                // Field of Mnemonic
                Container(
                    height: 80,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 16),
                    color: hexaCodeToColor(AppColors.cardColor),
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.centerLeft,
                    child: MyText(
                      color: AppColors.secondary_text,
                      fontSize: 18,
                      textAlign: TextAlign.left,
                      text: _wordsSelected.join(' '),
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          _buildWordsButtons(),
          Expanded(
            child: Container(),
          ),
          MyFlatButton(
            edgeMargin: EdgeInsets.only(left: 66, right: 66, bottom: 16),
            textButton: 'Next',
            action: enable == false
                ? null
                : () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyUserInfo(widget.accModel)));
                  },
          )
        ],
      ),
    ));
  }
}
