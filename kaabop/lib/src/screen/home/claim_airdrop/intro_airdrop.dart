import 'package:flutter/material.dart';

import '../../../../index.dart';

class IntroAirdrop extends StatefulWidget {
  @override
  _IntroAirdropState createState() => _IntroAirdropState();
}

class _IntroAirdropState extends State<IntroAirdrop> {
  int _radioValue1 = 0;
  String _stageUrl = 'assets/airdrop-1.png';

  void onChanged(int value) {
    if (value == 0) {
      _stageUrl = 'assets/airdrop-1.png';
    }

    if (value == 1) {
      _stageUrl = 'assets/airdrop-2.png';
    }

    if (value == 2) {
      _stageUrl = 'assets/airdrop-3.png';
    }
    _radioValue1 = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            MyAppBar(
              title: 'Introduction',
              color: hexaCodeToColor(AppColors.bgdColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        focusColor: Colors.white,
                        value: 0,
                        groupValue: _radioValue1,
                        onChanged: onChanged,
                      ),
                      const Text(
                        'Stage 1',
                        style: TextStyle(fontSize: 18.0),
                        // style:TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Radio(
                        value: 1,
                        groupValue: _radioValue1,
                        onChanged: onChanged,
                      ),
                      const Text(
                        'Stage 2',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Radio(
                        value: 2,
                        groupValue: _radioValue1,
                        onChanged: onChanged,
                      ),
                      const Text(
                        'Stage 3',
                        style: TextStyle(fontSize: 18.0),
                        //style: new TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 450,
                    child:  Image.asset(_stageUrl)
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: MyText(
                      text:
                          'Selendra will conduct 3 airdrops. Each drop will have 6 sessions with a total of 31,415,927 SEL tokens. Each session will last as long as 3 months to distribute to as many people as possible. The first airdrop will take place in April 2021, during Khmer New Year. Enjoy the airdrop, everyone.',
                      textAlign: TextAlign.justify,
                      right: 24,
                      left: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  MyFlatButton(
                    textButton: "Next",
                    edgeMargin: const EdgeInsets.only(
                      top: 29,
                      left: 66,
                      right: 66,
                    ),
                    hasShadow: true,
                    action: () {
                      Navigator.pushNamed(context, AppText.claimAirdropView);
                    },
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
