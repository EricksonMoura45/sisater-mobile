import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:location/location.dart' as location_package;
import 'package:geocoding/geocoding.dart';
import 'package:sisater_mobile/models/unidade_de_producao/unidade_de_producao_post.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/comunidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/municipio.dart';
import 'package:sisater_mobile/models/unidade_de_producao/abastecimento_agua.dart';
import 'package:sisater_mobile/models/unidade_de_producao/dominio.dart';
import 'package:sisater_mobile/models/unidade_de_producao/energia_eletrica.dart';
import 'package:sisater_mobile/models/unidade_de_producao/transicao_agroecologica.dart';
import 'package:sisater_mobile/modules/unidade_de_producao/repository/unidade_producao_repository.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';
import 'package:sisater_mobile/shared/utils/widgets/input_widget.dart';
import 'package:esig_utils/status.dart';
import 'package:esig_utils/size_screen.dart';
import 'package:sisater_mobile/shared/utils/snackbar_service.dart';

class CadastrarUnidadeProducao extends StatefulWidget {
  const CadastrarUnidadeProducao({super.key});

  @override
  State<CadastrarUnidadeProducao> createState() => _CadastrarUnidadeProducaoState();
}

class _CadastrarUnidadeProducaoState extends State<CadastrarUnidadeProducao> {
  final _formKey = GlobalKey<FormState>();
  final _repository = Modular.get<UnidadeProducaoRepository>();
  final _locationService = location_package.Location();
  
  // Controllers para os campos de texto
  final TextEditingController _denominacaoController = TextEditingController();
  final TextEditingController _detalhamentoAcessoController = TextEditingController();
  final TextEditingController _areaDocumentalController = TextEditingController();
  final TextEditingController _areaRealController = TextEditingController();
  final TextEditingController _areaPreservacaoController = TextEditingController();
  final TextEditingController _areaCulturaPermanenteController = TextEditingController();
  final TextEditingController _areaCulturaTemporariaController = TextEditingController();
  final TextEditingController _areaPastagemController = TextEditingController();
  final TextEditingController _areaReservaLegalController = TextEditingController();
  final TextEditingController _areaOutrosController = TextEditingController();
  
  // Controllers para endereço
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  
  // Estados para dropdowns
  Municipio? _municipioSelecionado;
  Comunidade? _comunidadeSelecionada;
  TransicaoAgroecologica? _transicaoAgroecologicaSelecionada;
  Dominio? _dominioSelecionado;
  EnergiaEletrica? _energiaEletricaSelecionada;
  AbastecimentoAgua? _abastecimentoAguaSelecionado;
  
  // Listas para os dropdowns
  List<Municipio> _listaMunicipios = [];
  List<Comunidade> _listaComunidades = [];
  List<TransicaoAgroecologica> _listaTransicaoAgroecologica = [];
  List<Dominio> _listaDominio = [];
  List<EnergiaEletrica> _listaEnergiaEletrica = [];
  List<AbastecimentoAgua> _listaAbastecimentoAgua = [];
  
  // Estados de carregamento
  Status _statusCarregaDados = Status.AGUARDANDO;
  Status _statusCadastro = Status.CONCLUIDO;
  Status _statusCapturaLocalizacao = Status.CONCLUIDO;
  bool _comunidadesCarregadas = false;
  
  // Valores para campos booleanos
  bool _possuiCar = false;
  bool _possuiSeguro = false;
  
  @override
  void initState() {
    super.initState();
    _carregarDados();
  }
  
  Future<void> _carregarDados() async {
    try {
      setState(() {
        _statusCarregaDados = Status.AGUARDANDO;
      });
      
      // Carregar dados em paralelo
      await Future.wait([
        _carregarMunicipios(),
        _carregarTransicaoAgroecologica(),
        _carregarDominio(),
        _carregarEnergiaEletrica(),
        _carregarAbastecimentoAgua(),
      ]);
      
      setState(() {
        _statusCarregaDados = Status.CONCLUIDO;
      });
    } catch (e) {
      // Tratar erro silenciosamente
    }
  }
  
  Future<void> _carregarMunicipios() async {
    try {
      final municipios = await _repository.listaMunicipios(null);
      setState(() {
        _listaMunicipios = municipios;
      });
    } catch (e) {
      // Tratar erro silenciosamente
    }
  }
  
  Future<void> _carregarComunidades() async {
    if (_municipioSelecionado?.code == null) return;
    
    try {
      final cityCode = int.tryParse(_municipioSelecionado!.code!);
      if (cityCode != null) {
        final comunidades = await _repository.listaComunidade(cityCode);
        setState(() {
          _listaComunidades = comunidades;
          _comunidadesCarregadas = true;
        });
      }
    } catch (e) {
      // Tratar erro silenciosamente
    }
  }
  
  Future<void> _carregarTransicaoAgroecologica() async {
    try {
      final transicoes = await _repository.listaTransicaoAgroecologica();
      setState(() {
        _listaTransicaoAgroecologica = transicoes;
      });
    } catch (e) {
      // Tratar erro silenciosamente
    }
  }
  
  Future<void> _carregarDominio() async {
    try {
      final dominios = await _repository.listaDominio();
      setState(() {
        _listaDominio = dominios;
      });
    } catch (e) {
      // Tratar erro silenciosamente
    }
  }
  
  Future<void> _carregarEnergiaEletrica() async {
    try {
      final energias = await _repository.listaEnergiaEletrica();
      setState(() {
        _listaEnergiaEletrica = energias;
      });
    } catch (e) {
      // Tratar erro silenciosamente
    }
  }
  
  Future<void> _carregarAbastecimentoAgua() async {
    try {
      final abastecimentos = await _repository.listaAbastecimentoAgua();
      setState(() {
        _listaAbastecimentoAgua = abastecimentos;
      });
    } catch (e) {
      // Tratar erro silenciosamente
    }
  }
  
  void _onMunicipioChanged(Municipio? municipio) {
    setState(() {
      _municipioSelecionado = municipio;
      _comunidadeSelecionada = null;
      _comunidadesCarregadas = false;
    });
    
    if (municipio != null) {
      _carregarComunidades();
    }
  }
  
  Future<void> _capturarLocalizacao() async {
    try {
      setState(() {
        _statusCapturaLocalizacao = Status.AGUARDANDO;
      });
      // Verificar permissões
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) {
          _mostrarMensagem('Serviço de localização não disponível');
          setState(() {
            _statusCapturaLocalizacao = Status.CONCLUIDO;
          });
          return;
        }
      }
      
      location_package.PermissionStatus permissionGranted = await _locationService.hasPermission();
      if (permissionGranted == location_package.PermissionStatus.denied) {
        permissionGranted = await _locationService.requestPermission();
        if (permissionGranted != location_package.PermissionStatus.granted) {
          _mostrarMensagem('Permissão de localização negada');
          setState(() {
            _statusCapturaLocalizacao = Status.CONCLUIDO;
          });
          return;
        }
      }
      
      // Obter posição atual
      location_package.LocationData locationData = await _locationService.getLocation();
      
      // Converter coordenadas para endereço
      List<Placemark> placemarks = await placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        
        setState(() {
          _latitudeController.text = locationData.latitude!.toString();
          _longitudeController.text = locationData.longitude!.toString();
          _logradouroController.text = place.street ?? '';
          _numeroController.text = place.subThoroughfare ?? '';
          _complementoController.text = place.thoroughfare ?? '';
          _bairroController.text = place.subLocality ?? '';
          _cepController.text = place.postalCode ?? '';
        });
        
        _mostrarMensagem('Localização capturada com sucesso!');
      }
      setState(() {
        _statusCapturaLocalizacao = Status.CONCLUIDO;
      });
    } catch (e) {
      _mostrarMensagem('Erro ao capturar localização: $e');
      setState(() {
        _statusCapturaLocalizacao = Status.CONCLUIDO;
      });
    }
  }
  
  void _mostrarMensagem(String mensagem) {
    if (mensagem.contains('sucesso')) {
      SnackbarService.showSuccess(context, mensagem);
    } else if (mensagem.contains('Erro')) {
      SnackbarService.showError(context, mensagem);
    } else {
      SnackbarService.showInfo(context, mensagem);
    }
  }
  
  Future<void> _cadastrarUnidadeProducao() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    try {
      setState(() {
        _statusCadastro = Status.AGUARDANDO;
      });
      
      // Criar objeto para envio
      final unidadeProducao = UnidadeDeProducaoPost(
        isFisherman: false,
        productionUnitNormal: ProductionUnitNormal(
          name: _denominacaoController.text,
          accessDetails: _detalhamentoAcessoController.text,
          communityId: _comunidadeSelecionada?.id,
          agroecologicalTransitionId: _transicaoAgroecologicaSelecionada?.id,
          domainId: _dominioSelecionado?.id,
          legalArea: double.tryParse(_areaDocumentalController.text.replaceAll(',', '.')),
          realArea: double.tryParse(_areaRealController.text.replaceAll(',', '.')),
          hasCar: _possuiCar ? 1 : 0,
          hasSafe: _possuiSeguro ? 1 : 0,
          electricPowerId: _energiaEletricaSelecionada?.id,
          waterSupplyId: _abastecimentoAguaSelecionado?.id,
          preservationArea: double.tryParse(_areaPreservacaoController.text.replaceAll(',', '.')),
          temporaryCultivationArea: double.tryParse(_areaCulturaTemporariaController.text.replaceAll(',', '.')),
          permanentCultivationArea: double.tryParse(_areaCulturaPermanenteController.text.replaceAll(',', '.')),
          pastureArea: double.tryParse(_areaPastagemController.text.replaceAll(',', '.')),
          legalReserveArea: double.tryParse(_areaReservaLegalController.text.replaceAll(',', '.')),
          otherArea: double.tryParse(_areaOutrosController.text.replaceAll(',', '.')),
          street: _logradouroController.text,
          number: _numeroController.text,
          complement: _complementoController.text,
          neighborhood: _bairroController.text,
          cityCode: _municipioSelecionado?.code,
          postalCode: _cepController.text,
        ),
      );
      
      // Enviar para API
      await _repository.postUnidadeDeProducao(unidadeProducao);
      
      setState(() {
        _statusCadastro = Status.CONCLUIDO;
      });
      
      _mostrarMensagem('Unidade de produção cadastrada com sucesso!');
      
      // Voltar para página anterior
      Navigator.of(context).pop();
      
    } catch (e) {
      setState(() {
        _statusCadastro = Status.ERRO;
      });
      _mostrarMensagem('Erro ao cadastrar: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: formAppBar(context, 'Cadastrar Unidade de Produção', false, ''),
      body: Observer(
        builder: (_) {
          if (_statusCarregaDados == Status.AGUARDANDO) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (_statusCarregaDados == Status.ERRO) {
            return const Center(
              child: Text('Erro ao carregar dados. Tente novamente.'),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informações Gerais
                  _buildSectionTitle('Informações Gerais'),
                  const SizedBox(height: 20),
                  
                  // Denominação da Unidade de Produção
                  _buildInputField(
                    label: 'Denominação da Unidade de Produção *',
                    controller: _denominacaoController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  
                  // Detalhamento do acesso
                  _buildInputField(
                    label: 'Detalhamento do acesso',
                    controller: _detalhamentoAcessoController,
                  ),
                  
                  // Município da Comunidade
                  _buildDropdownField<Municipio>(
                    label: 'Município da Comunidade',
                    value: _municipioSelecionado,
                    items: _listaMunicipios,
                    onChanged: _onMunicipioChanged,
                    itemBuilder: (municipio) => municipio.name ?? '',
                  ),
                  
                  // Comunidade
                  if (_comunidadesCarregadas)
                    _buildDropdownField<Comunidade>(
                      label: 'Comunidade',
                      value: _comunidadeSelecionada,
                      items: _listaComunidades,
                      onChanged: (comunidade) {
                        setState(() {
                          _comunidadeSelecionada = comunidade;
                        });
                      },
                      itemBuilder: (comunidade) => comunidade.name ?? '',
                    ),
                  
                  // Transição agroecológica
                  _buildDropdownField<TransicaoAgroecologica>(
                    label: 'Transição agroecológica',
                    value: _transicaoAgroecologicaSelecionada,
                    items: _listaTransicaoAgroecologica,
                    onChanged: (transicao) {
                      setState(() {
                        _transicaoAgroecologicaSelecionada = transicao;
                      });
                    },
                    itemBuilder: (transicao) => transicao.name ?? '',
                  ),
                  
                  // Caracterização de domínio
                  _buildDropdownField<Dominio>(
                    label: 'Caracterização de domínio *',
                    value: _dominioSelecionado,
                    items: _listaDominio,
                    onChanged: (dominio) {
                      setState(() {
                        _dominioSelecionado = dominio;
                      });
                    },
                    itemBuilder: (dominio) => dominio.name ?? '',
                    validator: (value) {
                      if (value == null) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  
                  // Área documental
                  _buildInputField(
                    label: 'Área documental (ha)',
                    controller: _areaDocumentalController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    ],
                  ),
                  
                  // Área real
                  _buildInputField(
                    label: 'Área real (ha)',
                    controller: _areaRealController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    ],
                  ),
                  
                  // Possui CAR
                  _buildCheckboxField(
                    label: 'Possui CAR? *',
                    value: _possuiCar,
                    onChanged: (value) {
                      setState(() {
                        _possuiCar = value ?? false;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  
                  // Possui seguro
                  _buildCheckboxField(
                    label: 'Possui seguro? *',
                    value: _possuiSeguro,
                    onChanged: (value) {
                      setState(() {
                        _possuiSeguro = value ?? false;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  
                  // Energia elétrica
                  _buildDropdownField<EnergiaEletrica>(
                    label: 'Energia elétrica',
                    value: _energiaEletricaSelecionada,
                    items: _listaEnergiaEletrica,
                    onChanged: (energia) {
                      setState(() {
                        _energiaEletricaSelecionada = energia;
                      });
                    },
                    itemBuilder: (energia) => energia.name ?? '',
                  ),
                  
                  // Abastecimento de Água
                  _buildDropdownField<AbastecimentoAgua>(
                    label: 'Abastecimento de Água',
                    value: _abastecimentoAguaSelecionado,
                    items: _listaAbastecimentoAgua,
                    onChanged: (abastecimento) {
                      setState(() {
                        _abastecimentoAguaSelecionado = abastecimento;
                      });
                    },
                    itemBuilder: (abastecimento) => abastecimento.name ?? '',
                  ),
                  
                  // Área de Preservação Permanente - APP
                  _buildInputField(
                    label: 'Área de Preservação Permanente - APP (ha)',
                    controller: _areaPreservacaoController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    ],
                  ),
                  
                  // Área de Cultura Permanente
                  _buildInputField(
                    label: 'Área de Cultura Permanente (ha)',
                    controller: _areaCulturaPermanenteController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    ],
                  ),
                  
                  // Área de Cultura Temporária
                  _buildInputField(
                    label: 'Área de Cultura Temporária (ha)',
                    controller: _areaCulturaTemporariaController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    ],
                  ),
                  
                  // Área de Pastagem
                  _buildInputField(
                    label: 'Área de Pastagem (ha)',
                    controller: _areaPastagemController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    ],
                  ),
                  
                  // Área de Reserva Legal
                  _buildInputField(
                    label: 'Área de Reserva Legal (ha)',
                    controller: _areaReservaLegalController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    ],
                  ),
                  
                  // Outros
                  _buildInputField(
                    label: 'Outros (ha)',
                    controller: _areaOutrosController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Informações de Endereço
                  _buildSectionTitle('Informações de Endereço'),
                  const SizedBox(height: 20),
                  
                  // Botão Capturar Localização
                  Observer(builder: (_) {
                    if (_statusCapturaLocalizacao == Status.AGUARDANDO) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.blue,
                        onPressed: _capturarLocalizacao,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Capturar Localização',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  
                  // Logradouro
                  _buildInputField(
                    label: 'Logradouro *',
                    controller: _logradouroController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  
                  // Número e Complemento
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          label: 'N° *',
                          controller: _numeroController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInputField(
                          label: 'Complemento',
                          controller: _complementoController,
                        ),
                      ),
                    ],
                  ),
                  
                  // Bairro
                  _buildInputField(
                    label: 'Bairro',
                    controller: _bairroController,
                  ),
                  
                  // Município
                  _buildInputField(
                    label: 'Município *',
                    controller: TextEditingController(
                      text: _municipioSelecionado?.name ?? '',
                    ),
                    enabled: false,
                    validator: (value) {
                      if (_municipioSelecionado == null) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  
                  // CEP
                  _buildInputField(
                    label: 'CEP',
                    controller: _cepController,
                    keyboardType: TextInputType.number,
                    formatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  
                  // Latitude e Longitude
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          label: 'Latitude',
                          controller: _latitudeController,
                          enabled: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInputField(
                          label: 'Longitude',
                          controller: _longitudeController,
                          enabled: false,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Observer(builder: (_) {
          if (_statusCarregaDados == Status.CONCLUIDO) {
            return botaoCadastrar(context);
          } else {
            return SizedBox();
          }
        }),
      ),
    );
  }
  
  Widget botaoCadastrar(BuildContext context) {
    return Observer(builder: (_) {
      if (_statusCadastro == Status.AGUARDANDO) {
        return ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Themes.verdeBotao,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        );
      } else {
        return ElevatedButton(
          onPressed: () async {
            _cadastrarUnidadeProducao();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Themes.verdeBotao,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Cadastrar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }
    });
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 0, 2),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
  
  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatters,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          InputWidget(
            controller: controller,
            formatters: formatters,
            validator: validator,
          ),
        ],
      ),
    );
  }
  
  Widget _buildDropdownField<T>({
    required String label,
    required T? value,
    required List<T> items,
    required Function(T?) onChanged,
    required String Function(T) itemBuilder,
    String? Function(T?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          DropdownButtonFormField<T>(
            hint: const Text('Selecione entre as opções'),
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
            ),
            borderRadius: BorderRadius.circular(10),
            isExpanded: true,
            value: value,
            items: items.map((item) => DropdownMenuItem<T>(
              value: item,
              child: Text(itemBuilder(item)),
            )).toList(),
            onChanged: onChanged,
            validator: validator,
          ),
        ],
      ),
    );
  }
  
  Widget _buildCheckboxField({
    required String label,
    required bool value,
    required Function(bool?) onChanged,
    String? Function(bool?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          CheckboxListTile(
            title: const Text('Sim'),
            value: value,
            onChanged: onChanged,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          if (validator != null)
            Builder(
              builder: (context) {
                final error = validator(value);
                if (error != null) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      error,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
        ],
      ),
    );
  }
}