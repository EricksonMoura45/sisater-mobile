import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';

Future<bool?> ToastAvisosErro(String mensagem){
  return 
  Fluttertoast.showToast(
            msg: mensagem,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Themes.cinzaTexto,
            textColor: Colors.black,
            fontSize: 16.0);
}