import 'package:flutter/material.dart';
import 'package:spectrum/model/spectrum_model.dart';
import 'package:spectrum/model/worker_model.dart';
import 'package:spectrum/model/routine_model.dart';

import '../widget/error.dart';

class SpectrumsScreen extends StatefulWidget {
  const SpectrumsScreen({Key? key}) : super(key: key);

  @override
  State<SpectrumsScreen> createState() => _SpectrumsScreenState();
}

class _SpectrumsScreenState extends State<SpectrumsScreen> {
  final Future<List<Spectrum>> _spectrums = Spectrum.fetchAll();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Spectrum>>(
        future: _spectrums,
        builder: (context, spanshot) {
          if (spanshot.hasError) return const ErrorMessage();
          if (spanshot.hasData && spanshot.data?.isEmpty == true) {
            var defaultSpec = Spectrum('My Day Tracker');
            defaultSpec.createSpec(defaultSpec, true);
          }

          return SpecListBuilder(specs: spanshot.data ?? []);
        });
  }
}

class SpecListBuilder extends StatelessWidget {
  final List<Spectrum> specs;

  const SpecListBuilder({Key? key, required this.specs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: display system default spectrum
    if (specs.isEmpty) return const Center(child: Text('No spectrums'));

    // TODO: display spectrums
    return Center(child: Text('There are ${specs.length} Spectrum(s)'));
  }
}



// routine -> task -> worker -> spectrum