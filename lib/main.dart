import 'package:flutter/material.dart';
import './root.dart';
import './state_provider.dart';
import './global_bloc.dart';

void main() => runApp(StatefulProvider<GlobalBloc>(
      valueBuilder: (BuildContext context, GlobalBloc oldBloc) =>
          oldBloc ?? GlobalBloc(),
      onDispose: (BuildContext context, GlobalBloc bloc) => bloc.dispose(),
      child: Root(),
    ));
