// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:sisater_mobile/shared/utils/themes.dart';

class BotaoMenu extends StatelessWidget {
  final String tituloBotao;
  final void Function()? function;

  const BotaoMenu({
    super.key,
    required this.tituloBotao,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return  MaterialButton(
      padding:  EdgeInsets.all(30),
      //minWidth: SizeScreen.perWidth(context, 90),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      colorBrightness: Brightness.dark,
      color: Themes.verdeBotao.withOpacity(.7),
      onPressed: function,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              tituloBotao,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.navigate_next))
        ],
      ),
    );
  }
}
