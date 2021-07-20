import 'package:provider/provider.dart';
import 'package:wallet_apps/index.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanner extends StatefulWidget {
  // final List portList;
  // final WalletSDK sdk;
  // final Keyring keyring;

  // QrScanner({this.portList, this.sdk, this.keyring});

  @override
  State<StatefulWidget> createState() {
    return QrScannerState();
  }
}

class QrScannerState extends State<QrScanner> {
  final GlobalKey qrKey = GlobalKey();

  String code;

  void _onQrViewCreated(QRViewController controller) {
    try {

      controller.scannedDataStream.listen((scanData) async {
        await controller.pauseCamera();
        // code = scanData.code;
        Navigator.pop(context, scanData.code);
        // await Future.delayed(Duration(seconds: 2), () async {
        //   // _backend.mapData = await Navigator.push(
        //   //     context,
        //   //     MaterialPageRoute(
        //   //         builder: (context) => SubmitTrx(scanData.code, false,
        //   //             widget.portList, widget.sdk, widget.keyring)));

        // });
      });
    } catch (e) {
      print("Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      body: BodyScaffold(
        physic: const NeverScrollableScrollPhysics(),
        height: MediaQuery.of(context).size.height,
        bottom: 0,
        child: Column(
          children: [
            MyAppBar(
              title: "Scanning",
              color: isDarkTheme
                ? hexaCodeToColor(AppColors.darkCard)
                : hexaCodeToColor(AppColors.whiteHexaColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQrViewCreated,
                overlay: QrScannerOverlayShape(
                  borderRadius: 10,
                  borderWidth: 10,
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
