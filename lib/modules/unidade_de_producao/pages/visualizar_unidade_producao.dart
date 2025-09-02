import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sisater_mobile/models/unidade_de_producao/unidade_de_producao_list.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/comunidade.dart';
import 'package:sisater_mobile/models/beneficiarios_ater/campos_selecionaveis/municipio.dart';
import 'package:sisater_mobile/models/unidade_de_producao/abastecimento_agua.dart';
import 'package:sisater_mobile/models/unidade_de_producao/dominio.dart';
import 'package:sisater_mobile/models/unidade_de_producao/energia_eletrica.dart';
import 'package:sisater_mobile/models/unidade_de_producao/transicao_agroecologica.dart';
import 'package:sisater_mobile/modules/unidade_de_producao/repository/unidade_producao_repository.dart';
import 'package:sisater_mobile/shared/utils/themes.dart';
import 'package:sisater_mobile/shared/utils/widgets/form_appbar.dart';
import 'package:esig_utils/status.dart';

class VisualizarUnidadeProducao extends StatefulWidget {
  final UnidadedeProducaoList unidade;
  
  const VisualizarUnidadeProducao({super.key, required this.unidade});

  @override
  State<VisualizarUnidadeProducao> createState() => _VisualizarUnidadeProducaoState();
}

class _VisualizarUnidadeProducaoState extends State<VisualizarUnidadeProducao> {
  final _repository = Modular.get<UnidadeProducaoRepository>();
  
  // Dados carregados para exibição
  Municipio? _municipio;
  Comunidade? _comunidade;
  TransicaoAgroecologica? _transicaoAgroecologica;
  Dominio? _dominio;
  EnergiaEletrica? _energiaEletrica;
  AbastecimentoAgua? _abastecimentoAgua;
  
  // Estados de carregamento
  Status _statusCarregaDados = Status.AGUARDANDO;
  
  @override
  void initState() {
    super.initState();
    _carregarDadosRelacionados();
  }
  
  Future<void> _carregarDadosRelacionados() async {
    try {
      setState(() {
        _statusCarregaDados = Status.AGUARDANDO;
      });
      
      // Carregar dados relacionados em paralelo
      await Future.wait([
        _carregarMunicipio(),
        _carregarComunidade(),
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
  
  Future<void> _carregarMunicipio() async {
    try {
      final municipios = await _repository.listaMunicipios(null);
      final municipio = municipios.firstWhere(
        (m) => m.code == widget.unidade.productionUnitNormal?.cityCode,
        orElse: () => Municipio(),
      );
      setState(() {
        _municipio = municipio;
      });
    } catch (e) {
      // Tratar erro silenciosamente
    }
  }
  
  Future<void> _carregarComunidade() async {
    try {
      if (widget.unidade.productionUnitNormal?.communityId != null) {
        final cityCode = int.tryParse(_municipio?.code ?? '');
        if (cityCode != null) {
          final comunidades = await _repository.listaComunidade(cityCode);
          final comunidade = comunidades.firstWhere(
            (c) => c.id == widget.unidade.productionUnitNormal?.communityId,
            orElse: () => Comunidade(),
          );
          setState(() {
            _comunidade = comunidade;
          });
        }
      }
    } catch (e) {
      // Tratar erro silenciosamente
    }
  }
  
  Future<void> _carregarTransicaoAgroecologica() async {
    try {
      if (widget.unidade.productionUnitNormal?.agroecologicalTransitionId != null) {
        final transicoes = await _repository.listaTransicaoAgroecologica();
        final transicao = transicoes.firstWhere(
          (t) => t.id == widget.unidade.productionUnitNormal?.agroecologicalTransitionId,
          orElse: () => TransicaoAgroecologica(),
        );
        setState(() {
          _transicaoAgroecologica = transicao;
        });
      }
    } catch (e) {
      // Tratar erro silenciosamente
    }
  }
  
  Future<void> _carregarDominio() async {
    try {
      if (widget.unidade.productionUnitNormal?.domainId != null) {
        final dominios = await _repository.listaDominio();
        final dominio = dominios.firstWhere(
          (d) => d.id == widget.unidade.productionUnitNormal?.domainId,
          orElse: () => Dominio(),
        );
        setState(() {
          _dominio = dominio;
        });
      }
    } catch (e) {
      // Tratar erro silenciosamente
    }
  }
  
  Future<void> _carregarEnergiaEletrica() async {
    try {
      if (widget.unidade.productionUnitNormal?.electricPowerId != null) {
        final energias = await _repository.listaEnergiaEletrica();
        final energia = energias.firstWhere(
          (e) => e.id == widget.unidade.productionUnitNormal?.electricPowerId,
          orElse: () => EnergiaEletrica(),
        );
        setState(() {
          _energiaEletrica = energia;
        });
      }
    } catch (e) {
      // Tratar erro silenciosamente
    }
  }
  
  Future<void> _carregarAbastecimentoAgua() async {
    try {
      if (widget.unidade.productionUnitNormal?.waterSupplyId != null) {
        final abastecimentos = await _repository.listaAbastecimentoAgua();
        final abastecimento = abastecimentos.firstWhere(
          (a) => a.id == widget.unidade.productionUnitNormal?.waterSupplyId,
          orElse: () => AbastecimentoAgua(),
        );
        setState(() {
          _abastecimentoAgua = abastecimento;
        });
      }
    } catch (e) {
      // Tratar erro silenciosamente
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: formAppBar(context, 'Visualizar Unidade de Produção', false, ''),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informações Gerais
                _buildSectionTitle('Informações Gerais'),
                const SizedBox(height: 20),
                
                // Denominação da Unidade de Produção
                _buildInfoField(
                  label: 'Denominação da Unidade de Produção',
                  value: widget.unidade.productionUnitNormal?.name ?? 'Não informado',
                ),
                
                // Detalhamento do acesso
                _buildInfoField(
                  label: 'Detalhamento do acesso',
                  value: widget.unidade.productionUnitNormal?.accessDetails ?? 'Não informado',
                ),
                
                // Município da Comunidade
                _buildInfoField(
                  label: 'Município da Comunidade',
                  value: _municipio?.name ?? 'Não informado',
                ),
                
                // Comunidade
                _buildInfoField(
                  label: 'Comunidade',
                  value: _comunidade?.name ?? 'Não informado',
                ),
                
                // Transição agroecológica
                _buildInfoField(
                  label: 'Transição agroecológica',
                  value: _transicaoAgroecologica?.name ?? 'Não informado',
                ),
                
                // Caracterização de domínio
                _buildInfoField(
                  label: 'Caracterização de domínio',
                  value: _dominio?.name ?? 'Não informado',
                ),
                
                // Área documental
                _buildInfoField(
                  label: 'Área documental (ha)',
                  value: widget.unidade.productionUnitNormal?.legalArea?.toString() ?? 'Não informado',
                ),
                
                // Área real
                _buildInfoField(
                  label: 'Área real (ha)',
                  value: widget.unidade.productionUnitNormal?.realArea?.toString() ?? 'Não informado',
                ),
                
                // Possui CAR
                _buildInfoField(
                  label: 'Possui CAR?',
                  value: widget.unidade.productionUnitNormal?.hasCar == 1 ? 'Sim' : 'Não',
                ),
                
                // Possui seguro
                _buildInfoField(
                  label: 'Possui seguro?',
                  value: widget.unidade.productionUnitNormal?.hasSafe == 1 ? 'Sim' : 'Não',
                ),
                
                // Energia elétrica
                _buildInfoField(
                  label: 'Energia elétrica',
                  value: _energiaEletrica?.name ?? 'Não informado',
                ),
                
                // Abastecimento de Água
                _buildInfoField(
                  label: 'Abastecimento de Água',
                  value: _abastecimentoAgua?.name ?? 'Não informado',
                ),
                
                // Área de Preservação Permanente - APP
                _buildInfoField(
                  label: 'Área de Preservação Permanente - APP (ha)',
                  value: widget.unidade.productionUnitNormal?.preservationArea?.toString() ?? 'Não informado',
                ),
                
                // Área de Cultura Permanente
                _buildInfoField(
                  label: 'Área de Cultura Permanente (ha)',
                  value: widget.unidade.productionUnitNormal?.permanentCultivationArea?.toString() ?? 'Não informado',
                ),
                
                // Área de Cultura Temporária
                _buildInfoField(
                  label: 'Área de Cultura Temporária (ha)',
                  value: widget.unidade.productionUnitNormal?.temporaryCultivationArea?.toString() ?? 'Não informado',
                ),
                
                // Área de Pastagem
                _buildInfoField(
                  label: 'Área de Pastagem (ha)',
                  value: widget.unidade.productionUnitNormal?.pastureArea?.toString() ?? 'Não informado',
                ),
                
                // Área de Reserva Legal
                _buildInfoField(
                  label: 'Área de Reserva Legal (ha)',
                  value: widget.unidade.productionUnitNormal?.legalReserveArea?.toString() ?? 'Não informado',
                ),
                
                // Outros
                _buildInfoField(
                  label: 'Outros (ha)',
                  value: widget.unidade.productionUnitNormal?.otherArea?.toString() ?? 'Não informado',
                ),
                
                const SizedBox(height: 30),
                
                // Informações de Endereço
                _buildSectionTitle('Informações de Endereço'),
                const SizedBox(height: 20),
                
                // Logradouro
                _buildInfoField(
                  label: 'Logradouro',
                  value: widget.unidade.productionUnitNormal?.street ?? 'Não informado',
                ),
                
                // Número e Complemento
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoField(
                        label: 'N°',
                        value: widget.unidade.productionUnitNormal?.number ?? 'Não informado',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoField(
                        label: 'Complemento',
                        value: widget.unidade.productionUnitNormal?.complement ?? 'Não informado',
                      ),
                    ),
                  ],
                ),
                
                // Bairro
                _buildInfoField(
                  label: 'Bairro',
                  value: widget.unidade.productionUnitNormal?.neighborhood ?? 'Não informado',
                ),
                
                // Município
                _buildInfoField(
                  label: 'Município',
                  value: _municipio?.name ?? 'Não informado',
                ),
                
                // CEP
                _buildInfoField(
                  label: 'CEP',
                  value: widget.unidade.productionUnitNormal?.postalCode ?? 'Não informado',
                ),
                
                // Latitude e Longitude
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoField(
                        label: 'Latitude',
                        value: 'Não informado',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoField(
                        label: 'Longitude',
                        value: 'Não informado',
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
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
  
  Widget _buildInfoField({
    required String label,
    required String value,
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
