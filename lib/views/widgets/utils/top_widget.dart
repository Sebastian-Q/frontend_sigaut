import 'package:flutter/material.dart';
import 'package:frontend/theme/custom_color_scheme.dart';
import 'package:frontend/theme/custom_text_style.dart';
import 'package:frontend/views/widgets/top_menu_widget.dart';

class TopWidget extends StatefulWidget {
  final bool extendedBody;
  final Widget? searchWidget;
  final String titleHeader;
  final double expandedHeight;

  const TopWidget({
    super.key,
    this.extendedBody = false,
    this.searchWidget,
    required this.titleHeader,
    this.expandedHeight = 150.0,
  });

  @override
  State<TopWidget> createState() => _TopWidgetState();
}

class _TopWidgetState extends State<TopWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primaryBackground,
          expandedHeight: widget.expandedHeight,
          title: Text(
            widget.titleHeader,
            style: CustomTextStyle.semiBold26.copyWith(
                color: Theme.of(context).colorScheme.cuartoText),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              showTopMenu();
            },
            icon: Icon(
              Icons.menu,
              size: 32,
              color: Theme.of(context).colorScheme.primeroIcon,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          flexibleSpace: widget.searchWidget,
        ),
      ],
    );
  }

  void showTopMenu() {
    if (!mounted) return;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, _, __) {
        return TopMenuWidget();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeIn,
          ).drive(Tween<Offset>(
            begin: const Offset(0, -1.0),
            end: Offset.zero,
          )),
          child: child,
        );
      },
    );
  }
}