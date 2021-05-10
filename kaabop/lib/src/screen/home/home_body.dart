import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/asset_list.dart';

class HomeBody extends StatelessWidget {
  final Function balanceOf;
  final Function setPortfolio;

  const HomeBody({this.balanceOf, this.setPortfolio});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final contract = Provider.of<ContractProvider>(context, listen: false);
        await Future.delayed(const Duration(milliseconds: 300))
            .then((value) async {
          setPortfolio();
          MarketProvider().fetchTokenMarketPrice(context);
          if (contract.bnbNative.isContain) {
            contract.getBnbBalance();
          }
          if (contract.bscNative.isContain) {
            contract.getBscBalance();
          }

          if (contract.etherNative.isContain) {
            contract.getEtherBalance();
          }

          if (contract.kgoNative.isContain) {
            contract.getKgoBalance();
          }

          if (contract.token.isNotEmpty) {
            contract.fetchNonBalance();
          }
        });
      },
      child: ListView(
        children: [
          homeAppBar(context),
          // const SizedBox(height: 200,),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: PortFolioCus(),
          ),

          Consumer<ContractProvider>(builder: (context, value, child) {
            return value.isReady
                ? AnimatedOpacity(
                    opacity: value.isReady ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: AssetList(),
                  )
                : Shimmer.fromColors(
                    period: const Duration(seconds: 2),
                    baseColor: hexaCodeToColor(AppColors.cardColor),
                    highlightColor:hexaCodeToColor(AppColors.bgdColor), //Colors.grey[50],
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
                          height: 100,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 65, //size ?? 65,
                                height: 65, //size ?? 65,
                                padding: const EdgeInsets.all(6),
                                margin: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Container(
                                      width: 40.0,
                                      height: 8.0,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      itemCount: 6,
                    ),
                  );
          }),

          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
