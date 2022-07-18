import 'package:rxdart/rxdart.dart';

import '../model/spectrum_model.dart';

// TODO:
// - change first screen to checklist
// - design the introduction for first time users in checklist screen
final screenEmitter = BehaviorSubject<String?>.seeded('checklist');

final specListController = PublishSubject<List<Spectrum>>();
