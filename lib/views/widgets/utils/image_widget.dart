import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:frontend/theme/custom_color_scheme.dart';
import 'package:frontend/theme/custom_text_style.dart';

class ImageWidget extends StatefulWidget {
  final Color? colorBorder;
  final String? urlImage;
  final String? title;
  const ImageWidget({super.key, this.colorBorder, this.urlImage, this.title});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(20),
          dashPattern: const [6, 6],
          color: widget.colorBorder ?? Theme.of(context).colorScheme.cuartoBorder,
          strokeWidth: 2,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Theme.of(context).colorScheme.cuartoBackground,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.urlImage != null) ...{
                    Expanded(
                      child: Image.network(
                        widget.urlImage!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  } else ...{
                    Icon(Icons.camera_alt_outlined, size: 50, color: Theme.of(context).colorScheme.septimoIcon,),
                    Text(
                      widget.title ?? "Subir imagen",
                      style: CustomTextStyle.medium14.copyWith(color: Theme.of(context).colorScheme.primeroText),
                    ),
                  }
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
}
