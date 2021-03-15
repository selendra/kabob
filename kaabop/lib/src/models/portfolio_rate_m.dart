import 'package:wallet_apps/index.dart';

class PortfolioRateModel {

  double currentData = 0;
  double comingData = 0;
  int totalRate = 0;

  Future<int> valueRate(Map<String, dynamic> data, double current) async{
    comingData = double.parse(data['balance'].toString());
    // print("Current data $current");
    // print("Coming Data $comingData");
    // print(current != comingData);
    // Current Token Different Up Coming Token
    if (current != comingData){
      if (current != 0) {
        totalRate = comingData.round()-current.round();
        await StorageServices.setData(totalRate, 'total_rate');
      }
      await StorageServices.setData(comingData, 'current_amount');
    }
    // No Transaction That Make Value Change And Display Previous Rate
    else {
      totalRate = await getCurrentTotalRate();
     // print("Get current total rate $totalRate");
    }
    return totalRate;
  }

  Future<double> getCurrentData() async {
    await StorageServices.fetchData('current_amount').then((value) {
      currentData = double.parse(value.toString());
    });
    return currentData ?? 0;
  }
  
  Future<int> getCurrentTotalRate() async {
    await StorageServices.fetchData('total_rate').then((value) {
      ///print("My value $value");
      totalRate = int.parse(value.toString());
    });
    return totalRate ?? 0;
  }
}