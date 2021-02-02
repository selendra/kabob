class TxHistory {
  String date;
  String destination;
  String sender;
  String amount;
  String fee;

  TxHistory({
    this.date,
    this.destination,
    this.sender,
    this.amount,
    this.fee,
  });

  List<TxHistory> tx = [];

  TxHistory.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        destination = json['destination'],
        sender = json['sender'],
        amount = json['amount'],
        fee = json['fee'];

  Map<String, dynamic> toJson() => {
        'date': date,
        'destination': destination,
        'sender': sender,
        'amount': amount,
        'fee': fee,
      };
}
