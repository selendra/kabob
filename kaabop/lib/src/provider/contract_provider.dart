import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/src/models/atd.dart';
import 'package:wallet_apps/src/models/kmpi.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import 'package:wallet_apps/src/provider/wallet_provider.dart';

import '../../index.dart';

class ContractProvider with ChangeNotifier {
  ContractProvider({this.sdk1, this.keyring1});

  final WalletSDK sdk1;
  final Keyring keyring1;

  final WalletSDK sdk = ApiProvider.sdk;

  final Keyring keyring = ApiProvider.keyring;

  Atd atd = Atd();
  Kmpi kmpi = Kmpi();

  Future<void> initKmpi() async {
    kmpi.isContain = true;
    kmpi.logo = 'assets/koompi_white_logo.png';
    kmpi.symbol = 'KMPI';
    kmpi.org = 'KOOMPI';
    kmpi.balanceReady = false;

    await sdk.api.callContract();
    await fetchKmpiHash();
    fetchKmpiBalance();
    notifyListeners();
  }

  Future<void> fetchKmpiHash() async {
    final res =
        await sdk.api.getHashBySymbol(keyring.current.address, kmpi.symbol);
    kmpi.hash = res.toString();
  }

  Future<void> fetchKmpiBalance() async {
    final res = await sdk.api.balanceOfByPartition(
        keyring.current.address, keyring.current.address, kmpi.hash);
    kmpi.balance = BigInt.parse(res['output'].toString()).toString();
    kmpi.balanceReady = true;

    notifyListeners();
  }

  Future<void> initAtd() async {
    atd.isContain = true;
    atd.logo = 'assets/FingerPrint1.png';
    atd.symbol = 'ATD';
    atd.org = 'KOOMPI';
    atd.balanceReady = false;

    await sdk.api.initAttendant();
    notifyListeners();
  }

  Future<void> fetchAtdBalance() async {
    final res = await sdk.api.getAToken(keyring.current.address);
    atd.balance = BigInt.parse(res).toString();
    atd.balanceReady = true;

    notifyListeners();
  }

  Future<void> addToken(
    String symbol,
    BuildContext context,
  ) async {
    if (symbol == 'KMPI') {
      initKmpi().then((value) async {
        await StorageServices.saveBool(kmpi.symbol, true);
      });
    } else {
      initAtd().then((value) async {
        await StorageServices.saveBool(atd.symbol, true);
      });
    }
    Navigator.pushNamedAndRemoveUntil(
        context, Home.route, ModalRoute.withName('/'));
  }

  Future<void> removeToken(String symbol) async {
    if (symbol == 'KMPI') {
      kmpi.isContain = false;
      await StorageServices.removeKey('KMPI');
    } else {
      atd.isContain = false;
      await StorageServices.removeKey('ATD');
    }
    notifyListeners();
  }

  Future<void> getAStatus() async {
    final res = await sdk.api.getAStatus(keyring.keyPairs[0].address);
    atd.status = res;
    notifyListeners();
  }
  //  Future<void> getCheckInList() async {
  //   final res = await ApiProvider.sdk.api
  //       .getCheckInList(ApiProvider.keyring.keyPairs[0].address);

  //   setState(() {
  //     _checkInList.clear();
  //   });
  //   for (final i in res) {
  //     final String latlong = i['location'].toString();

  //     await addressName(LatLng(double.parse(latlong.split(',')[0]),
  //             double.parse(latlong.split(',')[1])))
  //         .then((value) async {
  //       if (value != null) {
  //         await dateConvert(int.parse(i['time'].toString())).then((time) {
  //           setState(() {
  //             _checkInList
  //                 .add({'time': time, 'location': value, 'status': true});
  //           });
  //         });
  //       }
  //     });
  //   }
  //   if (!mounted) return;
  //   return res;
  // }

  // Future<void> getCheckOutList() async {
  //   final res = await ApiProvider.sdk.api
  //       .getCheckOutList(widget.sdkModel.keyring.keyPairs[0].address);

  //   setState(() {
  //     _checkOutList.clear();
  //   });

  //   for (final i in res) {
  //     final String latlong = i['location'].toString();

  //     await addressName(LatLng(double.parse(latlong.split(',')[0]),
  //             double.parse(latlong.split(',')[1])))
  //         .then((value) async {
  //       if (value != null) {
  //         await dateConvert(int.parse(i['time'].toString())).then((time) {
  //           setState(() {
  //             _checkOutList
  //                 .add({'time': time, 'location': value, 'status': false});
  //           });
  //         });
  //       }
  //     });
  //   }
  //   if (!mounted) return;
  //   return res;
  // }

  // Future<String> addressName(LatLng place) async {
  //   final List<Placemark> placemark = await Geolocator()
  //       .placemarkFromCoordinates(place.latitude, place.longitude);

  //   return placemark[0].thoroughfare ??
  //       '' + ", " + placemark[0].subLocality ??
  //       '' + ", " + placemark[0].administrativeArea ??
  //       '';
  // }

  // Future<String> dateConvert(int millisecond) async {
  //   final df = DateFormat('dd-MM-yyyy hh:mm a');
  //   final DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecond);

  //   return df.format(date);
  // }

  // Future<void> sortList() async {
  //   _checkAll = List.from(_checkInList)..addAll(_checkOutList);
  //   _checkAll.sort((a, b) => int.parse(a['time'].toString())
  //       .compareTo(int.parse(b['time'].toString())));
  //   setState(() {});
  //   if (!mounted) return;
  // }
}
