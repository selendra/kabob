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
  TxHistory.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        symbol = json['symbol'],
        destination = json['destination'],
        sender = json['sender'],
        amount = json['amount'],
        org = json['fee'];

  Map<String, dynamic> toJson() => {
        'date': date,
        'symbol': symbol,
        'destination': destination,
        'sender': sender,
        'amount': amount,
        'fee': org,
      };
}
