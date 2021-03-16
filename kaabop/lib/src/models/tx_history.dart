class TxHistory {
  String date;
  String symbol;
  String destination;
  String sender;
  String amount;
  String org;

  TxHistory({
    this.date,
    this.symbol,
    this.destination,
    this.sender,
    this.amount,
    this.org,
  });

  List<TxHistory> tx = [];
  List<TxHistory> txKpi = [];
  List<dynamic> txHistoryList = [];
  TxHistory.fromJson(Map<String, dynamic> json)
      : date = json['date'].toString(),
        symbol = json['symbol'].toString(),
        destination = json['destination'].toString(),
        sender = json['sender'].toString(),
        amount = json['amount'].toString(),
        org = json['fee'].toString();

  Map<String, dynamic> toJson() => {
        'date': date,
        'symbol': symbol,
        'destination': destination,
        'sender': sender,
        'amount': amount,
        'fee': org,
      };
}
