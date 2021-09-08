import 'package:flutter_live/router/bb_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<BBRouter>(
    lazy: false,
    create: (context) => BBRouter(),
  )
];

