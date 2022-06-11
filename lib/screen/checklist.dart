import 'package:flutter/material.dart';

import '../model/spectrum_model.dart';
import '../service/auth.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({Key? key}) : super(key: key);

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  bool shouldDisplayGreet = false;
  Spectrum? spec;

  @override
  void initState() {
    super.initState();
    _getDefaultSpec();
    shouldDisplayGreet =
        spec == null || spec!.taskIds == null || spec!.taskIds!.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    if (shouldDisplayGreet) {
      return _greetings();
    }

    return _checklist();
  }

  // TODO:
  // - scroller control
  // - introductions for first time users
  Widget _greetings() {
    final width = MediaQuery.of(context).size.width * 0.8;
    return Center(
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          width: width,
          height: MediaQuery.of(context).size.height * 0.6,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                width: width,
                color: Colors.red,
              ),
              Container(
                width: width,
                color: Colors.blue,
              ),
              Container(
                width: width,
                color: Colors.green,
              ),
              Container(
                width: width,
                color: Colors.yellow,
              ),
              Container(
                width: width,
                color: Colors.orange,
              ),
            ],
          )),
    );
  }

  Widget _checklist() {
    return const Center(child: Text('Checklist'));
  }

  void _getDefaultSpec() async {
    final Spectrum? spec = await Spectrum.fetchDefault(AuthService.user!.uid);
    setState(() => this.spec = spec);
  }
}
