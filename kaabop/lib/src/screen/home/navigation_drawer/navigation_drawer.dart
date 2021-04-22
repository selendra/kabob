import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/components/component.dart';
import '../../../../index.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            MyAppBar(
              title: '',
              color: hexaCodeToColor(AppColors.bgdColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 100,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.only(
                        left: 25,
                        top: 25,
                        bottom: 25,
                      ),
                      decoration: BoxDecoration(
                        color: hexaCodeToColor(AppColors.cardColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Consumer<ApiProvider>(
                            builder: (context, value, child) {
                              return Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(
                                  right: 16,
                                ),
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: SvgPicture.string(
                                  value.accountM.addressIcon,
                                ),
                              );
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: ApiProvider.keyring.current.name ?? '',
                                color: "#FFFFFF",
                                fontSize: 20,
                              ),
                              const SizedBox(
                                width: 100,
                                child: MyText(
                                  text: "Indracore",
                                  color: AppColors.secondarytext,
                                  textAlign: TextAlign.start,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
