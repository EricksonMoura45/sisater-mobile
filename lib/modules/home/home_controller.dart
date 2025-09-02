import 'package:mobx/mobx.dart';
import 'package:sisater_mobile/modules/home/repository/home_repository.dart';
part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  
  final HomeRepository homeRepository;

  _HomeControllerBase(this.homeRepository);

  

  
}