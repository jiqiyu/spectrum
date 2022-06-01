import 'package:flutter/material.dart';
import 'package:spectrum/model/spectrum_model.dart';
import 'package:spectrum/model/worker_model.dart';
import 'package:spectrum/model/routine_model.dart';
import 'package:spectrum/service/stream_service.dart' as source;

import '../widget/error.dart';

class SpectrumsScreen extends StatefulWidget {
  const SpectrumsScreen({Key? key}) : super(key: key);

  @override
  State<SpectrumsScreen> createState() => _SpectrumsScreenState();
}

class _SpectrumsScreenState extends State<SpectrumsScreen> {
  final _pageSize = 10;
  final _orderBy = 'createdAt';
  final _orderDirection = 'asc';
  var _cursor = -1;
  bool _isLoading = false;
  bool _noMore = false;
  List<Spectrum> specs = [];

  final ScrollController _scrollController = ScrollController();

  void fetchSpecs() async {
    if (_isLoading || _noMore) return;

    setState(() => _isLoading = true);

    try {
      var data = await Spectrum.fetchSome(
          _cursor, _orderBy, _orderDirection, _pageSize);

      setState(() {
        _isLoading = false;
        _noMore = data.length < _pageSize;
        specs.addAll(data);
        if (specs.isNotEmpty) _cursor = specs.length;
      });

      source.specListController.add(specs);
    } catch (e) {
      source.specListController.addError(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSpecs();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Spectrum>>(
        stream: source.specListController,
        builder: (context, spanshot) {
          if (spanshot.hasError) return const ErrorMessage();
          if (spanshot.hasData) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (spanshot.data!.isEmpty) {
              // no data, create a system default spectrum
              var defaultSpec = Spectrum('My Day Tracker');
              defaultSpec.createSpec(defaultSpec, true);
            }

            return SpecListBuilder(
              specs: spanshot.data ?? [],
              noMore: _noMore && _cursor > 0,
              scrollController: _scrollController,
            );
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}

class SpecListBuilder extends StatelessWidget {
  final List<Spectrum> specs;
  final bool noMore;
  final ScrollController scrollController;

  const SpecListBuilder({
    Key? key,
    required this.specs,
    required this.noMore,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: display system default spectrum
    if (specs.isEmpty) return const Center(child: Text('No data'));

    // TODO: display spectrums
    return Center(
        child: Text(
            "There are ${specs.length} Spectrum(s)${noMore ? ' and no more.' : ' on this page.'}"));
  }
}



// routine -> task -> worker -> spectrum