import 'package:rxdart/rxdart.dart';

import '../model/spectrum_model.dart';

final screenEmitter = BehaviorSubject<String?>.seeded('Spectrums');

final specListController = BehaviorSubject<List<Spectrum>>.seeded([]);
