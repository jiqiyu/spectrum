import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spectrum/model/spectrum_model.dart';
import 'package:spectrum/model/worker_model.dart';
import 'package:spectrum/model/routine_model.dart';
import 'package:spectrum/service/auth.dart';
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
  String _startAtDocId = '';
  bool _isLoading = false;
  bool _noMore = false;
  List<Spectrum> specs = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchSpecs(AuthService.user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Spectrum>>(
        stream: source.specListController,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorMessage(message: snapshot.error.toString());
          }
          if (snapshot.hasData) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.isEmpty) {
              // no data, create a system default spectrum
              var defaultSpec = Spectrum.fromMap(
                  {'name': 'My Day Tracker', 'isDefault': true});
              setState(() => specs.add(defaultSpec));
            }

            return Container(
                alignment: AlignmentDirectional.topStart,
                child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: _spectrumCards(snapshot.data ?? specs),
                    )));
          }

          return const Center(child: CircularProgressIndicator());
        });
  }

  void _fetchSpecs(String userId) async {
    if (_isLoading || _noMore) return;

    setState(() => _isLoading = true);

    try {
      var data = await Spectrum.fetchSome(
          userId, _startAtDocId, _orderBy, _orderDirection, _pageSize);
      late Spectrum defaultSpec;

      if (data.isEmpty) {
        defaultSpec = Spectrum.fromMap({
          'name': 'My Day Tracker_${AuthService.user!.uid}',
          'isDefault': true
        });
        defaultSpec.id =
            await Spectrum.createSpec(AuthService.user!.uid, defaultSpec);
      }

      setState(() {
        _isLoading = false;
        _noMore = data.length < _pageSize;
        specs.addAll(data.isEmpty ? [defaultSpec] : data);
        // TODO: fix this
        if (specs.isNotEmpty) _startAtDocId = specs[specs.length - 1].id!;
      });
      source.specListController.add(specs);
    } catch (e) {
      source.specListController.addError(e);
    }
  }

  List<Widget> _spectrumCards(List<Spectrum> specs) {
    List<Widget> cards = <Widget>[];
    List<Widget> containers = <Widget>[];
    final double viewWidth = MediaQuery.of(context).size.width;
    final double cardDimension = viewWidth * 0.45;
    const double marginX = 5;
    const double marginBottom = 10;
    // final random = Random();

    cards.add(Center(child: Wrap(children: containers)));

    for (int i = 0; i < specs.length; i++) {
      containers.add(GestureDetector(
        onTap: () {},
        child: Container(
          width: cardDimension,
          // height: (50 + random.nextInt(300 - 50)).toDouble(),
          height: cardDimension,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black38, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          margin: EdgeInsets.only(
              left: (i % 2 == 0) ? 0 : marginX,
              right: (i % 2 == 0) ? marginX : 0,
              bottom: marginBottom),
          child: Center(
              child: Text(
                  specs[i].name.replaceAll('_${AuthService.user!.uid}', ''),
                  style: const TextStyle(color: Colors.black87))),
        ),
      ));
    }

    return cards;
  }
}


// routine -> task -> worker -> spectrum