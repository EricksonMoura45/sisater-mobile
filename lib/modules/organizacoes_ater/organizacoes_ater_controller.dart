// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mobx/mobx.dart';

import 'package:sisater_mobile/modules/organizacoes_ater/repository/organizacoes_ater_repository.dart';

part 'organizacoes_ater_controller.g.dart';

class OrganizacoesAterController = _OrganizacoesAterControllerBase with _$OrganizacoesAterController;

abstract class _OrganizacoesAterControllerBase with Store {

  _OrganizacoesAterControllerBase({
    required this.organizacoesAterRepository,
  });
  
   OrganizacoesAterRepository organizacoesAterRepository;
}
