import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/components/effect_c.dart';

class HomeBody extends StatelessWidget {
  final Function balanceOf;
  final Function setPortfolio;
  final Function scrollRefresh;

  const HomeBody({this.balanceOf, this.setPortfolio, this.scrollRefresh});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        // Pie Chart With List Asset
        PortFolioCus(),
        
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

        // const SizedBox(
        //   height: 70,
        // ),
      ],
    );
  }
}
