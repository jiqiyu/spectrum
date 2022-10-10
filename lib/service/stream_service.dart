import 'package:rxdart/rxdart.dart';

import '../model/spectrum_model.dart';

final screenEmitter = BehaviorSubject<String?>.seeded('checklist');

final specListController = PublishSubject<List<Spectrum>>();
