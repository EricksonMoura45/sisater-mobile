import 'package:esig_utils/size_screen.dart';
import 'package:flutter/material.dart';
import 'package:sisater_mobile/shared/utils/widgets/toast_avisos_sucesso.dart';

Widget NaoAptoButton(BuildContext context, String titulo){
  return MaterialButton(
      padding: const EdgeInsets.all(17),
      minWidth: SizeScreen.perWidth(context, 90),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      colorBrightness: Brightness.dark,
      color: Colors.grey.withOpacity(.7),
      onPressed: () async {
        ToastAvisosSucesso('Preencha todos os campos obrigatórios *');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
}