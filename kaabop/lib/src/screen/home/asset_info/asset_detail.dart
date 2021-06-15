import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../index.dart';

class AssetDetail extends StatefulWidget {
  final Market marketData;
  const AssetDetail(this.marketData);

  @override
  _AssetDetailState createState() => _AssetDetailState();
}

class _AssetDetailState extends State<AssetDetail> {
  String totalSupply = '';

  String circulatingSupply = '';

  String marketCap = '';

  String marketCapChange24h = '';

  String convert(String supply) {
    var formatter = NumberFormat.decimalPattern();

    if (supply != null) {
      if (supply.contains('.')) {
        var value = supply?.replaceFirst(RegExp(r"\.[^]*"), "");
        return formatter.format(int.parse(value));
      }
    }

    return formatter.format(int.parse(supply));
  }

  @override
  void initState() {
    if (widget.marketData.totalSupply != 'null') {
      totalSupply = convert(widget.marketData.totalSupply);
    }
    if (widget.marketData.circulatingSupply != 'null') {
      circulatingSupply = convert(widget.marketData.circulatingSupply);
    }

    if (widget.marketData.marketCap != 'null') {
      marketCap = convert(widget.marketData.marketCap);
    }

    if (widget.marketData.marketCapChange24H != 'null') {
      marketCapChange24h = convert(widget.marketData.marketCapChange24H);
    }
    // totalSupply = convert(widget.marketData.totalSupply);
    // circulatingSupply = convert(widget.marketData.circulatingSupply);
    // marketCap = convert(widget.marketData.marketCap);
    // marketCapChange24h = convert(widget.marketData.marketCapChange24H);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MyText(
              text: 'Price Today',
              fontSize: 16.0,
              textAlign: TextAlign.left,
              bottom: 16.0,
            ),
            line(),
            textRow('Price', '\$${widget.marketData.currentPrice}', ''),
            line(),
            textRow(
                'Price Change 24h',
                '\$${widget.marketData.priceChange24H} ',
                ' ${widget.marketData.priceChangePercentage24H}%'),
            line(),
            textRow(
                '24h Low / 24 High',
                '\$${widget.marketData.low24H} / \$${widget.marketData.high24H}',
                ''),
            line(),
            textRow('Market Rank', '#${widget.marketData.marketCapRank}', ''),
            const SizedBox(height: 20),
            const MyText(
              text: 'Market Cap',
              fontSize: 16.0,
              textAlign: TextAlign.left,
              bottom: 16.0,
            ),
            line(),
            textRow('Market Cap', '\$$marketCap', ''),
            line(),
            textRow('Market Cap Change 24h', '\$$marketCapChange24h', ''),
            const SizedBox(height: 20),
            const MyText(
              text: 'Price History',
              fontSize: 16.0,
              textAlign: TextAlign.left,
              bottom: 16.0,
            ),
            line(),
            textRow('All Time High', '\$${widget.marketData.ath}', ''),
            line(),
            textRow('All Time Low', '\$${widget.marketData.atl}', ''),
            const SizedBox(height: 20),
            const MyText(
              text: 'Supply',
              fontSize: 16.0,
              textAlign: TextAlign.left,
              bottom: 16.0,
            ),
            line(),
            textRow(
                'Circulating Supply',
                '$circulatingSupply ${widget.marketData.symbol.toUpperCase()}',
                ''),
            line(),
            textRow('Total Supply',
                '$totalSupply ${widget.marketData.symbol.toUpperCase()}', ''),
          ],
        ),
      ),
    );
  }

  Widget line() {
    return Container(
      height: 1,
      color: hexaCodeToColor(AppColors.textColor),
    );
  }

  Widget textRow(String leadingText, String trailingText, String endingText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            text: leadingText,
            color: '#FFFFFF',
            fontSize: 16,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              MyText(
                text: trailingText,
                color: '#FFFFFF',
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
              MyText(
                text: endingText,
                color: endingText != '' && endingText.substring(1, 2) == '-'
                    ? '#FF0000'
                    : '#00FF00',
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
