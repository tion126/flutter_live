import 'package:flutter/material.dart';
import 'package:flutter_live/state/view_state_widget.dart';
import 'package:flutter_live/utils/base_response.dart';

enum ViewState {
  idle,
  loading, 
  empty,
  error
}

mixin BaseStateMixin<T extends StatefulWidget> on State<T> {
  ViewState _viewState = ViewState.loading;
  ViewState get viewState => _viewState;

  set viewState(ViewState viewState) {
    this.error = "";
    _viewState = viewState;
    viewRefresh();
  }

  String error = "";

  /// get
  bool get isLoading => viewState == ViewState.loading;
  bool get isIdle => viewState == ViewState.idle;
  bool get isEmpty => viewState == ViewState.empty;
  bool get isError => viewState == ViewState.error;

  /// set
  void setIdle() => viewState = ViewState.idle;
  void setBusy() => viewState = ViewState.loading;
  void setEmpty() => viewState = ViewState.empty;

  void setError(e, {String? message}) {
    if (e is BaseResponse) {
      message = e.msg ?? message ?? "";
    } else {
      message = message ?? "$e";
    }
    viewState = ViewState.error;
    this.error = e.msg;
  }

  // ignore: non_constant_identifier_names
  ThemeData get TD {
    return Theme.of(context);
  }

  @override
  void initState() {
    super.initState();
    this.initialization();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      this.frameCallback();
    });
  }

  void initialization() {}

  void frameCallback() {}

  void loadData() {}

  Widget body();

  Widget wraper(Widget child) {
    return child;
  }

  void viewRefresh() {
    if (mounted) {
      this.setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var child;
    switch (this.viewState) {
      case ViewState.loading:
        child = ViewStateBusyWidget();
        break;
      case ViewState.error:
        child = ViewStateErrorWidget(
            title: this.error,
            onPressed: () {
              this.setBusy();
              this.loadData();
            });
        break;
      case ViewState.empty:
        child = ViewStateEmptyWidget(onPressed: () {
          this.setBusy();
          this.loadData();
        });
        break;
      case ViewState.idle:
        child = body();
        break;
      default:
        child = body();
    }
    return this.wraper(child);
  }
}
