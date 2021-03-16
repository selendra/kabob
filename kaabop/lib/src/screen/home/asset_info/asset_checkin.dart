import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../index.dart';

class AssetCheckIn extends StatelessWidget {
  final List<Map> _txCheckIn;
  const AssetCheckIn(this._txCheckIn);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          if (_txCheckIn.isEmpty)
            SvgPicture.asset(
              'assets/no_data.svg',
              width: 250,
              height: 250,
            )
          else
            Expanded(
              child: _txCheckIn.isEmpty
                  ? Container()
                  : ListView.builder(
                      itemCount: _txCheckIn.length,
                      itemBuilder: (context, index) {
                        return rowDecorationStyle(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 50,
                                height: 50,
                                padding: const EdgeInsets.all(6),
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: hexaCodeToColor(AppColors.secondary),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child:
                                    Image.asset('assets/koompi_white_logo.png'),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      MyText(
                                        text: '',
                                        color: "#FFFFFF",
                                      ),
                                      MyText(text: '', fontSize: 15),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      MyText(
                                        width: double.infinity,
                                        text: '',
                                        color: "#FFFFFF",
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
        ],
      ),
    );
  }
}
