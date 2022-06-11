import 'package:flutter/material.dart';
import 'package:spectrum/service/stream_service.dart' as source;

class BottomNavBtn extends StatefulWidget {
  final IconData icon;
  final String? label;
  final double? iconSize;
  final Color? unselectedColor;
  final Color? selectedColor;

  const BottomNavBtn({
    Key? key,
    required this.icon,
    required this.label,
    this.iconSize = 28.0,
    this.selectedColor = Colors.orange,
    this.unselectedColor = Colors.black87,
  }) : super(key: key);

  @override
  State<BottomNavBtn> createState() => _BottomNavBtnState();
}

class _BottomNavBtnState extends State<BottomNavBtn> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
        stream: source.screenEmitter,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Color color = snapshot.data == widget.label
                ? widget.selectedColor!
                : widget.unselectedColor!;
            return InkWell(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(
                  widget.icon,
                  size: widget.iconSize!,
                  color: color,
                ),
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: TextStyle(fontSize: 9.0, color: color),
                  ),
              ]),
              onTap: () =>
                  source.screenEmitter.add(widget.label ?? 'checklist'),
            );
          }
          return Container();
        });
  }
}
