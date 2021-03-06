import 'package:australti_ecommerce_app/theme/theme.dart';
import 'package:australti_ecommerce_app/widgets/circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';

showAlertError(BuildContext context, String titulo, String subtitulo) {
  bool isIos = UniversalPlatform.isIOS;
  bool isAndroid = UniversalPlatform.isAndroid;
  bool isWeb = UniversalPlatform.isWeb;
  final currentTheme =
      Provider.of<ThemeChanger>(context, listen: false).currentTheme;
  if (isAndroid) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(
                titulo,
                style: TextStyle(color: Colors.white),
              ),
              content: Text(subtitulo, style: TextStyle(color: Colors.grey)),
              actions: <Widget>[
                MaterialButton(
                    child: Text('Ok'),
                    elevation: 5,
                    textColor: currentTheme.accentColor,
                    onPressed: () => Navigator.pop(context))
              ],
            ));
  } else if (isIos || isWeb) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(titulo),
              content: Text(subtitulo, style: TextStyle(color: Colors.grey)),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    'Aceptar',
                    style: TextStyle(color: currentTheme.accentColor),
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }
}

showSnackBar(BuildContext context, String text) {
  final currentTheme =
      Provider.of<ThemeChanger>(context, listen: false).currentTheme;

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 6.0,
      backgroundColor: currentTheme.primaryColor,
      behavior: SnackBarBehavior.floating,
      content: Text(text, style: TextStyle(color: Colors.white))));
}

showModalLoading(BuildContext context) {
  bool isIos = UniversalPlatform.isIOS;
  bool isAndroid = UniversalPlatform.isAndroid;
  bool isWeb = UniversalPlatform.isWeb;
  if (isAndroid) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                content: Center(
                    child: Row(children: [
              buildLoadingWidget(context),
              Text(' Por favor, espere')
            ]))));
  } else if (isIos || isWeb) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              content: Center(
                  child: Row(children: [
                buildLoadingWidget(context),
                Text(' Por favor, espere')
              ])),
            ));
  }
}
