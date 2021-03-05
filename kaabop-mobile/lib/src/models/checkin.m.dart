import 'package:flutter/material.dart';

class CheckInModel {

  GlobalKey<FormState> checkInKey = GlobalKey();
  bool isEnable = false;
  bool isSuccess = false;

  TextEditingController hashController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  FocusNode hashNode = FocusNode();
  FocusNode locationNode = FocusNode();
  String status = 'Asset Name';

  
}