import 'package:flutter/material.dart';
import '../../../../index.dart';

class AttActivity extends StatelessWidget {
  final List<Map> _checkAll;
  final CreateAccModel sdkModel;
  final Function _onRefresh;
  AttActivity(this._checkAll, this.sdkModel, this._onRefresh);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: _checkAll.isEmpty
              ? Center(
                  child: SvgPicture.asset(
                    'assets/no_data.svg',
                    width: 250,
                    height: 250,
                  ),
                )
              : ListView.builder(
                  itemCount: _checkAll.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: 0, left: 16, right: 16, bottom: 16),
                      padding: EdgeInsets.fromLTRB(15, 9, 15, 9),
                      height: 90,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2.0,
                              offset: Offset(1.0, 1.0))
                        ],
                        color: hexaCodeToColor(AppColors.cardColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            padding: EdgeInsets.all(6),
                            margin: EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(40)),
                            child: Image.asset(
                                sdkModel.contractModel.attendantM.attLogo),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    text: sdkModel
                                        .contractModel.attendantM.aSymbol,
                                    color: "#FFFFFF",
                                    fontSize: 18,
                                  ),
                                  MyText(
                                      textAlign: TextAlign.start,
                                      text: _checkAll[index]['location'],
                                      fontSize: 14),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 16, top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyText(
                                    width: double.infinity,
                                    text: _checkAll[index]['time'] ?? "",
                                    color: "#FFFFFF",
                                    fontSize: 12,
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _checkAll[index]['status']
                                              ? hexaCodeToColor(
                                                  AppColors.secondary)
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
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
      ),
    );
  }
}
