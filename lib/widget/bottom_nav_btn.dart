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
    this.iconSize = 24.0,
    this.selectedColor = Colors.orange,
    this.unselectedColor = Colors.black87,
  }) : super(key: key);

  @override
  State<BottomNavBtn> createState() => _BottomNavBtnState();
}

class _BottomNavBtnState extends State<BottomNavBtn> {
  final double _iconMarginBottom = 12.5;

  @override
  void initState() {
    super.initState();
    source.screenEmitter.add('Spectrums');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
        stream: source.screenEmitter,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Color color = snapshot.data == widget.label
                ? widget.selectedColor!
                : widget.unselectedColor!;
            return Column(
              children: [
                IconButton(
                  constraints: BoxConstraints(
                    maxHeight: widget.iconSize! + _iconMarginBottom,
                    minHeight: widget.iconSize! + _iconMarginBottom,
                  ),
                  iconSize: widget.iconSize!,
                  icon: Icon(widget.icon, color: color),
                  onPressed: () =>
                      source.screenEmitter.add(widget.label ?? 'checklist'),
                ),
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: TextStyle(fontSize: 9.0, color: color),
                  ),
              ],
            );
          }
          return Container();
        });
  }
}
