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

  List _mnemonic;

  bool enable = false;

  List _wordsLeft = [];

  Widget _buildWordsButtons() {
    if (_wordsLeft.length > 0) {
      _wordsLeft.sort();
    }

    final List<Widget> rows = <Widget>[];

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
                  padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                  margin: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _wordsLeft.remove(i);
                        _wordsSelected.add(i.toString());
                      });
                      if (_wordsLeft.isEmpty) validationMnemonic();
                    },
                    child: MyText(
                      text: i.toString(),
                      color: AppColors.secondarytext,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ));
      }
    }
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: rows,
      ),
    );
  }

  void setMnemonic() {
    _wordsLeft.clear();
    for (final i in widget.accModel.mnemonicList) {
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
  void initState() {
    _mnemonic = [];
    _wordsLeft = [];
    _wordsSelected = [];
    for (final i in widget.accModel.mnemonicList) {
      _wordsLeft.add(i); // Use For Sort Mnemonic
      _mnemonic.add(i); // Use For Compare
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            MyAppBar(
              color: hexaCodeToColor(AppColors.cardColor),
              title: AppText.createAccTitle,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: MyText(
                        text: AppText.confirmMnemonic,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColorHexa,
                        bottom: 12,
                      )),

                  MyText(
                    textAlign: TextAlign.left,
                    text: AppText.clickMnemonic,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteColorHexa,
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
                          text: AppText.reset,
                          bottom: 16,
                          color: AppColors.secondarytext),
                    ),
                  ),

                  // Field of Mnemonic
                  Container(
                      height: 80,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      color: hexaCodeToColor(AppColors.cardColor),
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.centerLeft,
                      child: MyText(
                        color: AppColors.secondarytext,
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
              edgeMargin:
                  const EdgeInsets.only(left: 66, right: 66, bottom: 16),
              textButton: AppText.next,
              action: enable == false
                  ? null
                  : () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyUserInfo(
                            widget.accModel,
                          ),
                        ),
                      );
                    },
            )
          ],
        ),
      ),
    );
  }
}
