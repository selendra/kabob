import 'package:wallet_apps/index.dart';

class PortfolioM{

  List<Map<String, dynamic>> list = [];

  GlobalKey<AnimatedCircularChartState> chartKey = GlobalKey<AnimatedCircularChartState>();

  List<CircularSegmentEntry> circularChart;

  double total = 0;

  double remainDataChart = 100;

}