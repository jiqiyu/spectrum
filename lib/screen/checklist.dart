import 'package:flutter/material.dart';

import '../model/spectrum_model.dart';
import '../service/auth.dart';
import 'package:spectrum/model/worker_model.dart';
import 'package:spectrum/model/routine_model.dart';

class Checklist extends StatefulWidget {
  const Checklist({Key? key}) : super(key: key);

  @override
  State<Checklist> createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  bool shouldDisplayGreet = false;
  Spectrum? spec;

  @override
  void initState() {
    super.initState();
    _getDefaultSpec();
  }

  @override
  Widget build(BuildContext context) {
    // TODO:
    // if (shouldDisplayGreet) {
    //   return _greetings();
    // }

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
    return Center(
      child: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.add),
      ),
    );
    // return const Center(child: Text('Checklist'));
  }

  void _addDailyRoutineItem() async {}

  void _getDefaultSpec() async {
    final Spectrum? spec = await Spectrum.fetchDefault(AuthService.user!.uid);
    if (mounted) {
      setState(() {
        this.spec = spec;
        shouldDisplayGreet =
            spec == null || spec.taskIds == null || spec.taskIds!.isEmpty;
      });
    }
  }
}
