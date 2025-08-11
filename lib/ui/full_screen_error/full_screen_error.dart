import 'package:bloc_base_architecture/imports/core_imports.dart';
import 'package:flutter/material.dart';

import '../../bloc/full_screen_error/full_screen_error_bloc.dart';
import '../../bloc/full_screen_error/full_screen_error_contractor.dart';

class FullScreenError extends StatefulWidget {
  final String title;
  final String message;
  final String? buttonTitle;
  final Function onRetryTap;

  const FullScreenError({
    required this.onRetryTap,
    this.message = '',
    this.title = '',
    this.buttonTitle,
    super.key,
  });

  @override
  State<FullScreenError> createState() => _FullScreenErrorState();
}

class _FullScreenErrorState
    extends BaseState<FullScreenErrorBloc, FullScreenError> {
  // _FullScreenErrorState() : super(getIt.get<FullScreenErrorBloc>());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(widget.title, textAlign: TextAlign.center),
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: widget.onRetryTap as void Function()?,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onViewEvent(ViewAction event) async {
    switch (event.runtimeType) {
      case const (NavigateScreen):
        final screen = event as NavigateScreen;
        switch (screen.target) {
          case FullScreenErrorTarget.NETWORK_RESTORED:
            widget.onRetryTap();
            break;
        }
        break;
    }
  }
}
