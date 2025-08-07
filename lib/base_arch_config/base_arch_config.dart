import 'package:bloc_base_architecture/base_arch_controller/base_arch_controller.dart';
import 'package:injectable/injectable.dart';
import '../core/constants.dart';

@singleton
class BaseArchConfig {
  final BaseArchController _baseArchController;

  BaseArchConfig(this._baseArchController);

  init() {
    _setLocalization();
  }

  _setLocalization() {
    _baseArchController.setLocalization(
      localizationList: AppConstant.localizationList,
    );
  }
}
