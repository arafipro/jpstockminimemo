import "package:jpstockminimemo/constants/imports.dart";

class CustomAlertDialog extends StatelessWidget {
/*　引数の詳細
title       ：ダイアログタイトル
buttonText  ：ダイアログボタンタイトル
*/
  final String title;
  final String buttonText;
  final dynamic onPressed;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              buttonColor,
            ),
          ),
          onPressed: onPressed ??
              () {
                Navigator.of(context).pop();
              },
          child: Text(buttonText),
        ),
      ],
    );
  }
}
