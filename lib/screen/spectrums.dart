import 'dart:developer';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
  final _pageSize = 1;
  final _orderBy = 'createdAt';
  final _orderDirection = 'asc';
  int _cursor = -1; // fetch startAt _cursor + 1
  bool _isLoading = false;
  bool _hasMore = true;
  List<Spectrum> specs = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // TODO:
    // fetch once and cache data for saving network traffic
    _fetchSpecs(AuthService.user!.uid);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // TODO:
  // - use staggered grid view
  // - add scroll to fetch more
  // - add sort by
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Spectrum>?>(
        stream: source.specListController,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorMessage(message: snapshot.error.toString());
          }
          if (snapshot.hasData) {
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            List<Widget> cards = _spectrumCards(snapshot.data ?? specs);
            if (_hasMore) {
              cards.add(Center(
                child: TextButton(
                    onPressed: () => _fetchSpecs(AuthService.user!.uid),
                    child: const Text('Load More')),
              ));
            }

            return MasonryGridView.count(
                controller: _scrollController,
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemCount: cards.length,
                itemBuilder: (context, index) => cards[index]);

            // return Container(
            //     alignment: AlignmentDirectional.topStart,
            //     child: SingleChildScrollView(
            //         controller: _scrollController,
            //         padding: const EdgeInsets.all(10),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           mainAxisSize: MainAxisSize.max,
            //           children:
            //               _spectrumCards(snapshot.data ?? specs, _hasMore),
            //         )
            //         ));
          }

          return const Center(child: CircularProgressIndicator());
        });
  }

  void _fetchSpecs(String userId) async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      final data = await Spectrum.fetchSome(
          userId, _cursor, _orderBy, _orderDirection, _pageSize);
      late Spectrum defaultSpec;

      if (data['specs'].isEmpty) {
        defaultSpec = await Spectrum.createSpec(
            AuthService.user!.uid,
            Spectrum.fromMap({
              'userId': AuthService.user!.uid,
              'name': 'My Day Tracker_${AuthService.user!.uid}',
              'isDefault': true
            }),
            isDefault: true);
      }

      setState(() {
        _isLoading = false;
        _hasMore = data['hasMore'];
        specs.addAll(data['specs'].isEmpty ? [defaultSpec] : data['specs']);
        if (specs.isNotEmpty) _cursor = specs.length - 1;
      });
      source.specListController.add(specs);
    } catch (e) {
      source.specListController.addError(e);
    }
  }

  List<Widget> _spectrumCards(List<Spectrum> specs) {
    List<Widget> containers = <Widget>[];
    final double viewWidth = MediaQuery.of(context).size.width;
    final double cardDimension = viewWidth * 0.45;

    for (int i = 0; i < specs.length; i++) {
      DateTime createdAt = DateTime.fromMicrosecondsSinceEpoch(
          specs[i].createdAt!.microsecondsSinceEpoch,
          isUtc: true);
      String datetime = DateFormat('EEE, dd/MM/yyyy').format(createdAt);

      containers.add(GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.only(left: 15, top: 8, bottom: 5),
            margin: EdgeInsets.only(
                left: (i % 2 == 0) ? 8 : 0,
                right: (i % 2 == 0) ? 0 : 8,
                top: 8),
            // height: (50 + random.nextInt(300 - 50)).toDouble(),
            height: cardDimension,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 1.0,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            // child:
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  child: Text(
                      specs[i].name.replaceAll('_${AuthService.user!.uid}', ''),
                      style: const TextStyle(color: Colors.black87))),

              // TODO:
              // - display summary of the spectrum here
              // - add a button to add/edit the spectrum

              Text(
                  '${specs[i].taskIds != null ? specs[i].taskIds!.length.toString() : '0'} metric(s) added',
                  style: const TextStyle(color: Colors.black54, fontSize: 12)),
              Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 3),
                  child: Text('Created at $datetime',
                      style: const TextStyle(
                          color: Colors.black54, fontSize: 12))),
            ]),
          )));
    }

    return containers;
  }
}

// routine -> task -> worker -> spectrum
