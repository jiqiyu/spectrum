import 'package:flutter/material.dart';
import 'package:spectrum/model/spectrum_model.dart';
import 'package:spectrum/model/worker_model.dart';
import 'package:spectrum/model/routine_model.dart';

class FirstTimeScreen extends StatelessWidget {
  const FirstTimeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 50,
        child: ElevatedButton(
          child: const Text('Add routines to my day tracker'),
          onPressed: () {}, // show add spec interface
        ),
      ),
    );
  }
}

// routine -> task -> worker -> spectrum