import 'package:flutter/material.dart';
import 'package:frontend/theme/custom_color_scheme.dart';
import 'package:frontend/theme/custom_text_style.dart';

enum AlertTypeMessage { error, success, warning, info, ask }

void onWidgetDidBuild(Function callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback();
  });
}

loadingWidget(BuildContext context, {String? info, bool barrierDismissible = false}) {
  showDialog(
    context: context,
    useRootNavigator: true,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return PopScope(
        canPop: barrierDismissible,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Color(0xFF1A5ED7),
              ),
              if (info != null) ...[
                const SizedBox(
                  height: 16,
                ),
                Text(
                  info,
                  style: CustomTextStyle.semiBold18.copyWith(
                      color: Theme.of(context).colorScheme.cuartoText),
                )
              ]
            ],
          ),
        ),
      );
    },
  );
}

showSnackBar(BuildContext context, String message, {type = AlertTypeMessage.success, duration = const Duration(seconds: 5), IconData? icon}) {
  onWidgetDidBuild(() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          duration: duration,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(right: 13.0),
                  child: Text(
                    message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyle.medium14.copyWith(
                      color: type == AlertTypeMessage.warning
                          ? const Color(0xFF664d03)
                          : Theme.of(context).colorScheme.cuartoText,
                    ),
                  ),
                ),
              ),
              Icon(
                icon ??
                    (type == AlertTypeMessage.error ? Icons.error : type == AlertTypeMessage.warning ? Icons.warning : Icons.check),
                color: type == AlertTypeMessage.warning
                    ? Theme.of(context).colorScheme.octavoIcon
                    : Theme.of(context).colorScheme.novenoIcon,
              ),
            ],
          ),
          backgroundColor: type == AlertTypeMessage.error
              ? Theme.of(context).colorScheme.error
              : type == AlertTypeMessage.warning
              ? const Color(0xFFFFF3CD)
              : Theme.of(context).colorScheme.success,
        ),
      );
  });
}

Widget get customSizeHeight => const SizedBox(
  height: 16,
);

Widget get customWidth => const SizedBox(
  width: 16,
);