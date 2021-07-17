import 'package:bitcoin_flutter/bitcoin_flutter.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:provider/provider.dart';

import '../../../index.dart';

class AssetList extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final passphraseController = TextEditingController();
  final pinController = TextEditingController();
  final focus = FocusNode();
  final pinFocus = FocusNode();

  Future<bool> validateMnemonic(String mnemonic) async {
    final res = await ApiProvider.sdk.api.keyring.validateMnemonic(mnemonic);
    return res;
  }

  String validate(String value) {
    return null;
  }

  Future<bool> checkPassword(String pin) async {
    final res = await ApiProvider.sdk.api.keyring
        .checkPassword(ApiProvider.keyring.current, pin);
    return res;
  }

  Future<void> onSubmit(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      dialogLoading(context);
      final isValidSeed = await validateMnemonic(passphraseController.text);
      final isValidPw = await checkPassword(pinController.text);

      if (isValidSeed == false) {
        Navigator.pop(context);
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: const Align(
                child: Text('Opps'),
              ),
              content: const Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Text('Invalid Seed phrase'),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
      // await dialog(
      if (isValidPw == false) {
        Navigator.pop(context);
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: const Align(
                child: Text('Opps'),
              ),
              content: const Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Text('PIN verification failed'),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }

      if (isValidSeed && isValidPw) {
        final seed = bip39.mnemonicToSeed(passphraseController.text);
        final hdWallet = HDWallet.fromSeed(seed);
        final keyPair = ECPair.fromWIF(hdWallet.wif);
        final bech32Address = new P2WPKH(
                data: new PaymentData(pubkey: keyPair.publicKey),
                network: bitcoin)
            .data
            .address;

        await StorageServices.setData(bech32Address, 'bech32');
        final res = await ApiProvider.keyring.store
            .encryptPrivateKey(hdWallet.wif, pinController.text);

        if (res != null) {
          await StorageServices().writeSecure('btcwif', res);
        }

        Provider.of<ApiProvider>(context, listen: false)
            .getBtcBalance(hdWallet.address);
        Provider.of<ApiProvider>(context, listen: false)
            .isBtcAvailable('contain');

        Provider.of<ApiProvider>(context, listen: false)
            .setBtcAddr(bech32Address);
        Provider.of<WalletProvider>(context, listen: false)
            .addTokenSymbol('BTC');
        Navigator.pop(context);
        Navigator.pop(context);
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: const Align(
                child: Text('Success'),
              ),
              content: const Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Text('You have created bitcoin wallet.'),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<ContractProvider>(
          builder: (context, value, child) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  RouteAnimation(
                    enterPage: AssetInfo(
                      id: value.bscNative.id,
                      assetLogo: value.bscNative.logo,
                      balance:
                          value.bscNative.balance ?? AppText.loadingPattern,
                      tokenSymbol: value.bscNative.symbol ?? '',
                      org: value.bscNative.org,
                      marketPrice: value.bscNative.marketPrice,
                      priceChange24h: value.bscNative.change24h,
                    ),
                  ),
                );
              },
              child: AssetItem(
                value.bscNative.logo,
                value.bscNative.symbol ?? '',
                'BEP-20',
                value.bscNative.balance ?? AppText.loadingPattern,
                Colors.transparent,
                marketPrice: value.bscNative.marketPrice,
                priceChange24h: value.bscNative.change24h,
              ),
            );
          },
        ),
        Consumer<ContractProvider>(
          builder: (context, value, child) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  RouteAnimation(
                    enterPage: AssetInfo(
                      id: value.bscNativeV2.id,
                      assetLogo: value.bscNativeV2.logo,
                      balance:
                          value.bscNativeV2.balance ?? AppText.loadingPattern,
                      tokenSymbol: value.bscNativeV2.symbol ?? '',
                      org: value.bscNativeV2.org,
                      marketPrice: value.bscNativeV2.marketPrice,
                      priceChange24h: value.bscNativeV2.change24h,
                    ),
                  ),
                );
              },
              child: AssetItem(
                value.bscNativeV2.logo,
                value.bscNativeV2.symbol ?? '',
                'BEP-20',
                value.bscNativeV2.balance ?? AppText.loadingPattern,
                Colors.transparent,
                marketPrice: value.bscNativeV2.marketPrice,
                priceChange24h: value.bscNativeV2.change24h,
              ),
            );
          },
        ),
        Consumer<ContractProvider>(
          builder: (context, value, child) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  RouteAnimation(
                    enterPage: AssetInfo(
                      id: value.kgoNative.id,
                      assetLogo: value.kgoNative.logo,
                      balance:
                          value.kgoNative.balance ?? AppText.loadingPattern,
                      tokenSymbol: value.kgoNative.symbol ?? '',
                      org: value.kgoNative.org,
                      marketData: value.kgoNative.marketData,
                      marketPrice: value.kgoNative.marketPrice,
                      priceChange24h: value.kgoNative.change24h,
                    ),
                  ),
                );
              },
              child: AssetItem(
                value.kgoNative.logo,
                value.kgoNative.symbol ?? '',
                'BEP-20',
                value.kgoNative.balance ?? AppText.loadingPattern,
                Colors.transparent,
                marketPrice: value.kgoNative.marketPrice,
                priceChange24h: value.kgoNative.change24h,
                lineChartData: value.kgoNative.lineChartData,
              ),
            );
          },
        ),
        Consumer<ContractProvider>(
          builder: (context, value, child) {
            return value.kmpi.isContain
                ? Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: DismissibleBackground(),
                    onDismissed: (direct) {
                      value.removeToken(value.kmpi.symbol, context);
                      // setPortfolio();
                    },
                    child: Consumer<ContractProvider>(
                      builder: (context, value, child) {
                        return GestureDetector(
                          onTap: () {
                            Provider.of<ContractProvider>(context,
                                    listen: false)
                                .fetchKmpiBalance();
                            Navigator.push(
                              context,
                              RouteAnimation(
                                enterPage: AssetInfo(
                                  id: value.kmpi.id,
                                  assetLogo: value.kmpi.logo,
                                  balance: value.kmpi.balance ??
                                      AppText.loadingPattern,
                                  tokenSymbol: value.kmpi.symbol,
                                  org: value.kmpi.org,
                                ),
                              ),
                            );
                          },
                          child: AssetItem(
                            value.kmpi.logo,
                            value.kmpi.symbol,
                            value.kmpi.org,
                            value.kmpi.balance,
                            Colors.black,
                          ),
                        );
                      },
                    ),
                  )
                : Container();
          },
        ),
        Consumer<ContractProvider>(
          builder: (coontext, value, child) {
            return value.atd.isContain
                ? Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: DismissibleBackground(),
                    onDismissed: (direct) {
                      value.removeToken(value.atd.symbol, context);
                      //setPortfolio();
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          RouteAnimation(
                            enterPage: AssetInfo(
                              id: value.atd.id,
                              assetLogo: value.atd.logo,
                              balance:
                                  value.atd.balance ?? AppText.loadingPattern,
                              tokenSymbol: value.atd.symbol,
                              org: value.atd.org,
                            ),
                          ),
                        );
                      },
                      child: AssetItem(
                        value.atd.logo,
                        value.atd.symbol,
                        value.atd.org,
                        value.atd.balance,
                        Colors.black,
                      ),
                    ),
                  )
                : Container();
          },
        ),
        Consumer<ContractProvider>(
          builder: (context, value, child) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  RouteAnimation(
                    enterPage: AssetInfo(
                      id: value.bnbNative.id,
                      assetLogo: value.bnbNative.logo,
                      balance:
                          value.bnbNative.balance ?? AppText.loadingPattern,
                      tokenSymbol: value.bnbNative.symbol ?? '',
                      marketData: value.bnbNative.marketData,
                      marketPrice: value.bnbNative.marketPrice,
                      priceChange24h: value.bnbNative.change24h,
                    ),
                  ),
                );
              },
              child: AssetItem(
                value.bnbNative.logo,
                value.bnbNative.symbol ?? '',
                'Smart Chain',
                value.bnbNative.balance ?? AppText.loadingPattern,
                Colors.transparent,
                marketPrice: value.bnbNative.marketPrice,
                priceChange24h: value.bnbNative.change24h,
                size: 60,
                lineChartData: value.bnbNative.lineChartData,
              ),
            );
          },
        ),
        Consumer<ApiProvider>(
          builder: (context, value, child) {
            final isDarkTheme = Provider.of<ThemeProvider>(context).isDark;
            return GestureDetector(
              onTap: () async {
                if (!value.btc.isContain) {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    enableDrag: true,
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(25.0),
                        height: MediaQuery.of(context).size.height / 1.2,
                        color: isDarkTheme
                            ? Color(
                                AppUtils.convertHexaColor(AppColors.darkBgd),
                              )
                            : Color(
                                AppUtils.convertHexaColor(AppColors.bgdColor),
                              ),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                MyText(
                                  top: 16.0,
                                  bottom: 16.0,
                                  fontSize: 22,
                                  text: 'Create Bitcoin Wallet',
                                  color: isDarkTheme
                                      ? AppColors.whiteColorHexa
                                      : AppColors.textColor,
                                ),
                                const SizedBox(height: 16.0),
                                MyInputField(
                                  focusNode: focus,
                                  controller: passphraseController,
                                  labelText: 'Seed phrase',
                                  validateField: (value) => value.isEmpty
                                      ? 'Please fill in passphrase'
                                      : null,
                                  onSubmit: () {},
                                ),
                                const SizedBox(height: 16.0),
                                MyInputField(
                                  focusNode: pinFocus,
                                  controller: pinController,
                                  labelText: 'Pin',
                                  obcureText: true,
                                  validateField: (value) =>
                                      value.isEmpty || value.length < 4
                                          ? 'Please fill in old 4 digits pin'
                                          : null,
                                  textInputFormatter: [
                                    LengthLimitingTextInputFormatter(4)
                                  ],
                                  onSubmit: () {},
                                ),
                                const SizedBox(height: 25),
                                MyFlatButton(
                                  textButton: "Submit",
                                  edgeMargin: const EdgeInsets.only(
                                    top: 40,
                                    left: 66,
                                    right: 66,
                                  ),
                                  hasShadow: true,
                                  action: () async {
                                    onSubmit(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                  // await
                } else {
                  Navigator.push(
                    context,
                    RouteAnimation(
                      enterPage: AssetInfo(
                        id: value.btc.id,
                        assetLogo: value.btc.logo,
                        balance: value.btc.balance ?? AppText.loadingPattern,
                        tokenSymbol: value.btc.symbol,
                        org: value.btc.org ?? '',
                        marketData: value.btc.marketData,
                        marketPrice: value.btc.marketPrice,
                        priceChange24h: value.btc.change24h,
                      ),
                    ),
                  );
                }
              },
              child: AssetItem(
                value.btc.logo,
                value.btc.symbol,
                '',
                value.btc.balance ?? AppText.loadingPattern,
                Colors.transparent,
                size: 60,
                marketPrice: value.btc.marketPrice,
                priceChange24h: value.btc.change24h,
                lineChartData: value.btc.lineChartData,
              ),
            );
          },
        ),
        Consumer<ContractProvider>(builder: (context, value, child) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                RouteAnimation(
                  enterPage: AssetInfo(
                    id: value.etherNative.id,
                    assetLogo: value.etherNative.logo,
                    balance:
                        value.etherNative.balance ?? AppText.loadingPattern,
                    tokenSymbol: value.etherNative.symbol ?? '',
                    org: value.etherNative.org ?? '',
                    marketData: value.etherNative.marketData,
                    marketPrice: value.etherNative.marketPrice,
                    priceChange24h: value.etherNative.change24h,
                  ),
                ),
              );
            },
            child: AssetItem(
              value.etherNative.logo,
              value.etherNative.symbol,
              value.etherNative.org,
              value.etherNative.balance ?? AppText.loadingPattern,
              Colors.transparent,
              marketPrice: value.etherNative.marketPrice,
              priceChange24h: value.etherNative.change24h,
              lineChartData: value.etherNative.lineChartData,
            ),
          );
        }),
        Consumer<ApiProvider>(
          builder: (context, value, child) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  RouteAnimation(
                    enterPage: AssetInfo(
                      id: value.dot.id,
                      assetLogo: value.dot.logo,
                      balance: value.dot.balance ?? AppText.loadingPattern,
                      tokenSymbol: value.dot.symbol,
                      org: value.dot.org,
                      marketData: value.dot.marketData,
                      marketPrice: value.dot.marketPrice,
                      priceChange24h: value.dot.change24h,
                    ),
                  ),
                );
              },
              child: AssetItem(
                value.dot.logo,
                value.dot.symbol,
                '',
                value.dot.balance ?? AppText.loadingPattern,
                Colors.transparent,
                size: 60,
                marketPrice: value.dot.marketPrice,
                priceChange24h: value.dot.change24h,
                lineChartData: value.dot.lineChartData,
              ),
            );
          },
        ),
        Consumer<ApiProvider>(builder: (context, value, child) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                RouteAnimation(
                  enterPage: AssetInfo(
                    id: value.nativeM.id,
                    assetLogo: value.nativeM.logo,
                    balance: value.nativeM.balance ?? AppText.loadingPattern,
                    tokenSymbol: value.nativeM.symbol,
                    org: value.nativeM.org,
                  ),
                ),
              );
            },
            child: AssetItem(
              value.nativeM.logo,
              value.nativeM.symbol,
              value.nativeM.org,
              value.nativeM.balance ?? AppText.loadingPattern,
              Colors.transparent,
            ),
          );
        }),
        Consumer<ContractProvider>(builder: (context, value, child) {
          return value.token.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  addAutomaticKeepAlives: false,
                  primary: false,
                  itemCount: value.token.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      background: DismissibleBackground(),
                      onDismissed: (direct) {
                        if (value.token[index].org == 'ERC-20') {
                          value.removeEtherToken(
                              value.token[index].symbol, context);
                        } else {
                          value.removeToken(value.token[index].symbol, context);
                        }

                        //setPortfolio();
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            RouteAnimation(
                              enterPage: AssetInfo(
                                assetLogo: 'assets/circle.png',
                                balance: value.token[index].balance ??
                                    AppText.loadingPattern,
                                tokenSymbol: value.token[index].symbol ?? '',
                                org: value.token[index].org,
                              ),
                            ),
                          );
                        },
                        child: AssetItem(
                          'assets/circle.png',
                          value.token[index].symbol ?? '',
                          value.token[index].org ?? '',
                          value.token[index].balance ?? AppText.loadingPattern,
                          Colors.transparent,
                        ),
                      ),
                    );
                  })
              : Container();
        }),
      ],
    );
  }
}
