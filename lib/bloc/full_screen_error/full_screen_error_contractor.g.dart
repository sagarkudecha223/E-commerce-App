// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_screen_error_contractor.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FullScreenErrorData extends FullScreenErrorData {
  @override
  final ScreenState state;
  @override
  final String? errorMessage;

  factory _$FullScreenErrorData([
    void Function(FullScreenErrorDataBuilder)? updates,
  ]) => (FullScreenErrorDataBuilder()..update(updates))._build();

  _$FullScreenErrorData._({required this.state, this.errorMessage}) : super._();
  @override
  FullScreenErrorData rebuild(
    void Function(FullScreenErrorDataBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  FullScreenErrorDataBuilder toBuilder() =>
      FullScreenErrorDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FullScreenErrorData &&
        state == other.state &&
        errorMessage == other.errorMessage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FullScreenErrorData')
          ..add('state', state)
          ..add('errorMessage', errorMessage))
        .toString();
  }
}

class FullScreenErrorDataBuilder
    implements Builder<FullScreenErrorData, FullScreenErrorDataBuilder> {
  _$FullScreenErrorData? _$v;

  ScreenState? _state;
  ScreenState? get state => _$this._state;
  set state(ScreenState? state) => _$this._state = state;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  FullScreenErrorDataBuilder();

  FullScreenErrorDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _errorMessage = $v.errorMessage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FullScreenErrorData other) {
    _$v = other as _$FullScreenErrorData;
  }

  @override
  void update(void Function(FullScreenErrorDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FullScreenErrorData build() => _build();

  _$FullScreenErrorData _build() {
    final _$result =
        _$v ??
        _$FullScreenErrorData._(
          state: BuiltValueNullFieldError.checkNotNull(
            state,
            r'FullScreenErrorData',
            'state',
          ),
          errorMessage: errorMessage,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
