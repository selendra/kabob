import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/screen/home/portfolio/portfolio_body.dart';

class Portfolio extends StatefulWidget{

  final List<dynamic> listData;
  // /final List<CircularSegmentEntry> listChart;

  Portfolio({@required this.listData});

  @override
  State<StatefulWidget> createState() {
    return PortfolioState();
  }
}

class PortfolioState extends State<Portfolio>{

  PortfolioM _portfolioM = PortfolioM();

  @override
  void initState(){
    setChartData();
    super.initState();
  }

  void setChartData(){
    // setState(() {
    //   _portfolioM.circularChart = widget.listChart;
    // });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyScaffold(
        height: MediaQuery.of(context).size.height,
        child: PortfolioBody(
          listData: widget.listData,
          portfolioM: _portfolioM,
        )
      )
    );
  }
}
