// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_app_contract.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MainAppData extends MainAppData {
  @override
  final ScreenState state;
  @override
  final bool isLoggedIn;
  @override
  final bool isLightTheme;
  @override
  final String? errorMessage;

  factory _$MainAppData([void Function(MainAppDataBuilder)? updates]) =>
      (MainAppDataBuilder()..update(updates))._build();

  _$MainAppData._({
    required this.state,
    required this.isLoggedIn,
    required this.isLightTheme,
    this.errorMessage,
  }) : super._();
  @override
  MainAppData rebuild(void Function(MainAppDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MainAppDataBuilder toBuilder() => MainAppDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MainAppData &&
        state == other.state &&
        isLoggedIn == other.isLoggedIn &&
        isLightTheme == other.isLightTheme &&
        errorMessage == other.errorMessage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, isLoggedIn.hashCode);
    _$hash = $jc(_$hash, isLightTheme.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MainAppData')
          ..add('state', state)
          ..add('isLoggedIn', isLoggedIn)
          ..add('isLightTheme', isLightTheme)
          ..add('errorMessage', errorMessage))
        .toString();
  }
}

class MainAppDataBuilder implements Builder<MainAppData, MainAppDataBuilder> {
  _$MainAppData? _$v;

  ScreenState? _state;
  ScreenState? get state => _$this._state;
  set state(ScreenState? state) => _$this._state = state;

  bool? _isLoggedIn;
  bool? get isLoggedIn => _$this._isLoggedIn;
  set isLoggedIn(bool? isLoggedIn) => _$this._isLoggedIn = isLoggedIn;

  bool? _isLightTheme;
  bool? get isLightTheme => _$this._isLightTheme;
  set isLightTheme(bool? isLightTheme) => _$this._isLightTheme = isLightTheme;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  MainAppDataBuilder();

  MainAppDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _state = $v.state;
      _isLoggedIn = $v.isLoggedIn;
      _isLightTheme = $v.isLightTheme;
      _errorMessage = $v.errorMessage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MainAppData other) {
    _$v = other as _$MainAppData;
  }

  @override
  void update(void Function(MainAppDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MainAppData build() => _build();

  _$MainAppData _build() {
    final _$result =
        _$v ??
        _$MainAppData._(
          state: BuiltValueNullFieldError.checkNotNull(
            state,
            r'MainAppData',
            'state',
          ),
          isLoggedIn: BuiltValueNullFieldError.checkNotNull(
            isLoggedIn,
            r'MainAppData',
            'isLoggedIn',
          ),
          isLightTheme: BuiltValueNullFieldError.checkNotNull(
            isLightTheme,
            r'MainAppData',
            'isLightTheme',
          ),
          errorMessage: errorMessage,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
