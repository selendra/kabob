import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallet_apps/src/components/dimissible_background.dart';
import 'package:wallet_apps/src/models/tx_history.dart';
import '../../../../index.dart';
import 'package:flare_flutter/flare_controls.dart';

class AssetHistory extends StatelessWidget {
  final List<TxHistory> _txHistoryModel;
  final FlareControls _flareController;
  final bool isPay;
  final Function _deleteHistory;
  final Function showDetailDialog;
  AssetHistory(this._txHistoryModel, this._flareController, this.isPay,
      this._deleteHistory, this.showDetailDialog);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          _txHistoryModel.isEmpty
              ? SvgPicture.asset(
                  'assets/no_data.svg',
                  width: 250,
                  height: 250,
                )
              : Expanded(
                  child: _txHistoryModel.isEmpty
                      ? Container()
                      : ListView.builder(
                          itemCount: _txHistoryModel.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              background: DismissibleBackground(),
                              onDismissed: (direction) {
                                _deleteHistory(
                                    index, _txHistoryModel[index].symbol);
                              },
                              child: GestureDetector(
                                onTap: () {
                                  showDetailDialog(_txHistoryModel[index]);
                                },
                                child: rowDecorationStyle(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 50,
                                        height: 50,
                                        padding: EdgeInsets.all(6),
                                        margin: EdgeInsets.only(right: 20),
                                        decoration: BoxDecoration(
                                            color: hexaCodeToColor(
                                                AppColors.secondary),
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: Image.asset(
                                            'assets/koompi_white_logo.png'),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 16),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText(
                                                text: _txHistoryModel[index]
                                                    .symbol,
                                                color: "#FFFFFF",
                                                fontSize: 18,
                                              ),
                                              MyText(
                                                  text: _txHistoryModel[index]
                                                      .org,
                                                  fontSize: 15),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(right: 16),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText(
                                                width: double.infinity,
                                                text: _txHistoryModel[index]
                                                    .amount,
                                                color: "#FFFFFF",
                                                fontSize: 18,
                                                textAlign: TextAlign.right,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                ),
          isPay == false
              ? Container()
              : BackdropFilter(
                  // Fill Blur Background
                  filter: ImageFilter.blur(
                    sigmaX: 5.0,
                    sigmaY: 5.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: CustomAnimation.flareAnimation(
                              _flareController,
                              "assets/animation/check.flr",
                              "Checkmark"))
                    ],
                  )),
        ],
      ),
    );
  }
}
