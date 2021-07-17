import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/effect_c.dart';

class HomeBody extends StatelessWidget {
  final Function balanceOf;
  final Function setPortfolio;

  const HomeBody({this.balanceOf, this.setPortfolio});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return RefreshIndicator(
      onRefresh: () async {
        final contract = Provider.of<ContractProvider>(context, listen: false);
        final api = Provider.of<ApiProvider>(context, listen: false);
        final market = Provider.of<MarketProvider>(context, listen: false);
        await Future.delayed(const Duration(milliseconds: 300))
            .then((value) async {
          setPortfolio();
          market.fetchTokenMarketPrice(context);
          if (contract.bnbNative.isContain) {
            contract.getBnbBalance();
          }
          if (contract.bscNative.isContain) {
            contract.getBscBalance();
          }

          if (contract.bscNativeV2.isContain) {
            contract.getBscV2Balance();
          }

          if (contract.etherNative.isContain) {
            contract.getEtherBalance();
          }

          if (contract.kgoNative.isContain) {
            contract.getKgoBalance();
          }

          if (api.btc.isContain) {
            api.getBtcBalance(api.btcAdd);
          }

          if (contract.token.isNotEmpty) {
            contract.fetchNonBalance();
            contract.fetchEtherNonBalance();
          }
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          homeAppBar(context),

          Container(
            child: PortFolioCus(),
          ),
          
          Consumer<ContractProvider>(builder: (context, value, child) {
            return value.isReady
            // Asset List As Row
            ? AnimatedOpacity(
              opacity: value.isReady ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: AssetList(),
            )
            // Loading Data Effect Shimmer
            : MyShimmer(isDarkTheme: isDarkTheme,);
            
          }),

          const SizedBox(
            height: 70,
          ),
        ],
      )
    );
  }
}
